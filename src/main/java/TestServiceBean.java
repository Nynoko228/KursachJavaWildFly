import org.hibernate.Hibernate;

import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.ejb.Stateless;
import javax.ejb.TransactionManagement;
import javax.ejb.TransactionManagementType;
import javax.persistence.*;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.*;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import javax.transaction.Transactional;

@Stateless
@TransactionManagement(TransactionManagementType.CONTAINER)
public class TestServiceBean {

    @PersistenceContext(name = "Kursach") // Подключаемся к DB
    private EntityManager entityManager;

    private static final String AES_KEY = "ThisIsAVerySecretKey1234567890ab"; // Ключ для AES (должен быть 16, 24 или 32 байта)

    public String addUserWithRole(String username, String password, String roleName) {
        try {
            // Проверяем, существует ли пользователь с таким именем
            TypedQuery<User> userQuery = entityManager.createQuery(
                    "SELECT u FROM User u WHERE u.user_name = :username", User.class);
            userQuery.setParameter("username", username);

            List<User> existingUsers = userQuery.getResultList();

            if (!existingUsers.isEmpty()) {
                return "Имя пользователя уже занято"; // Возвращаем сообщение вместо исключения
            }

            // Создаем нового пользователя
            User user = new User();
            user.setUser_name(username);
            user.setPassword(hashPassword(password));  // Хешируем пароль
            System.out.println("Password hash: " + hashPassword(password));

            // Создаем роль
            // Получаем роль или создаем новую
            Role role = entityManager.createQuery("SELECT r FROM Role r WHERE r.role_name = :roleName", Role.class)
                    .setParameter("roleName", roleName)
                    .getResultStream()
                    .findFirst()
                    .orElseGet(() -> {
                        Role newRole = new Role();
                        newRole.setRole_name(roleName);
                        entityManager.persist(newRole);
                        return newRole;
                    });
//            role.setRole_name(roleName);

            // Добавляем роль в список ролей пользователя
            user.setRole(role);

            // Сохраняем роль в базе данных
            entityManager.persist(role);  // Сначала сохраняем роль, если она еще не существует

            // Сохраняем пользователя в базе данных
            entityManager.persist(user);  // Затем сохраняем пользователя

            return "Пользователь успешно зарегистрирован";
        } catch (Exception e) {
            e.printStackTrace();
            return "Ошибка при регистрации пользователя: " + e.getMessage();
        }
    }

    public void delUser(long student_id){
        User user = entityManager.find(User.class, student_id);
        entityManager.remove(user);
    }

    public List<User> getAllUsers() {
        Query nativeQuery = entityManager.createNativeQuery(
                "SELECT * FROM users", User.class);
//        nativeQuery.setParameter("id", id);
        return nativeQuery.getResultList();
    }
    public List<Game> getAllGames() {
        Query nativeQuery = entityManager.createNativeQuery(
                "SELECT * FROM games", Game.class);
//        nativeQuery.setParameter("id", id);
        return nativeQuery.getResultList();
    }

//    public Optional<Order> findOrderById(Long orderId) {
//        try {
//            Order order = entityManager.createQuery(
//                            "SELECT o FROM Order o " +
//                                    "LEFT JOIN FETCH o.user " + // Загрузка пользователя
//                                    "LEFT JOIN FETCH o.orderItems oi " + // Загрузка элементов заказа
//                                    "LEFT JOIN FETCH oi.game " + // Загрузка игр из OrderItem
//                                    "WHERE o.order_id = :orderId", Order.class)
//                    .setParameter("orderId", orderId)
//                    .getSingleResult();
//            return Optional.of(order);
//        } catch (NoResultException e) {
//            return Optional.empty();
//        }
//    }
    // Просто решил использовать Hibernate.initialize() для того, чтобы показать как с ней работать
    public Optional<Order> findOrderById(Long orderId) {
        Order order = entityManager.find(Order.class, orderId);
        if (order != null) {
            Hibernate.initialize(order.getUser()); // Инициализация пользователя
            Hibernate.initialize(order.getOrderItems()); // Инициализация элементов заказа
            order.getOrderItems().forEach(item -> Hibernate.initialize(item.getGame())); // Инициализация игр
        }
        return Optional.ofNullable(order);
    }

    // Метод для получения роли пользователя по ID
    public Role getUserRole(Long userId) {
        User user = entityManager.find(User.class, userId);
        if (user != null) {
            return user.getRole();
        }
        return null;
    }

    // Метод для получения всех заказов
    public List<Order> getAllOrders() {
        TypedQuery<Order> query = entityManager.createQuery(
                "SELECT DISTINCT o FROM Order o JOIN FETCH o.orderItems oi JOIN FETCH oi.game", Order.class);
        return query.getResultList();
    }

    public String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            return bytesToHex(hash);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    private String bytesToHex(byte[] bytes) {
        StringBuilder hexString = new StringBuilder();
        for (byte b : bytes) {
            hexString.append(String.format("%02x", b));
        }
        return hexString.toString();
    }

    // Метод для добавления игры в корзину пользователя
    public void addToCart(Long gameId, Long userId) {
        try {
            // Получаем пользователя по ID
            User user = entityManager.find(User.class, userId);
            if (user == null) {
                throw new IllegalArgumentException("Пользователь не найден");
            }

            // Получаем корзину пользователя
            Cart cart = user.getCart();
            if (cart == null) {
                cart = new Cart(user);
                user.setCart(cart);
                entityManager.persist(cart);
            }

            // Получаем игру по ID
            Game game = entityManager.find(Game.class, gameId);
            if (game == null) {
                throw new IllegalArgumentException("Игра не найдена");
            }

            // Проверяем, существует ли уже такой товар в корзине
            TypedQuery<CartItem> cartItemQuery = entityManager.createQuery(
                    "SELECT ci FROM CartItem ci WHERE ci.cart = :cart AND ci.game = :game", CartItem.class);
            cartItemQuery.setParameter("cart", cart);
            cartItemQuery.setParameter("game", game);
            CartItem cartItem = cartItemQuery.getResultStream().findFirst().orElse(null);

            if (cartItem != null) {
                // Если товар уже в корзине, увеличиваем количество
                cartItem.setQuantity(cartItem.getQuantity() + 1);
            } else {
                // Если товара нет в корзине, добавляем новый элемент
                cartItem = new CartItem(cart, game, 1);
                cart.getCartItems().add(cartItem);
                entityManager.persist(cartItem);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Ошибка при добавлении игры в корзину", e);
        }
    }

    // Метод для получения корзины пользователя с JOIN FETCH
    public Map<Game, Integer> getCartItems(Long userId) {
        try {
            // Получаем пользователя с корзиной и элементами корзины
            TypedQuery<Cart> cartQuery = entityManager.createQuery(
                    "SELECT c FROM Cart c JOIN FETCH c.cartItems ci JOIN FETCH ci.game g WHERE c.user.user_id = :userId", Cart.class);
            cartQuery.setParameter("userId", userId);
            Cart cart = cartQuery.getSingleResult();

            // Получаем элементы корзины
            List<CartItem> cartItems = new ArrayList<>(cart.getCartItems());

            // Преобразуем элементы корзины в карту
            Map<Game, Integer> cartMap = new HashMap<>();
            for (CartItem item : cartItems) {
                cartMap.put(item.getGame(), item.getQuantity());
            }
            return cartMap;
        } catch (Exception e) {
            e.printStackTrace();
            return new HashMap<>();
        }
    }

    public void clearCart(Long userId) {
        try {
            // Получаем пользователя по ID
            User user = entityManager.find(User.class, userId);
            if (user == null) {
                throw new IllegalArgumentException("Пользователь не найден");
            }

            // Получаем корзину пользователя
            Cart cart = user.getCart();
            if (cart == null || cart.getCartItems().isEmpty()) {
                return;
            }

            // Удаляем все элементы корзины
            for (CartItem item : new ArrayList<>(cart.getCartItems())) {
                cart.getCartItems().remove(item);
                entityManager.remove(item);
            }

            // Обновляем корзину
            entityManager.merge(cart);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Ошибка при очистке корзины", e);
        }
    }

    public void removeFromCart(Long gameId, Long userId) {
        try {
            // Получаем пользователя по ID
            User user = entityManager.find(User.class, userId);
            if (user == null) {
                throw new IllegalArgumentException("Пользователь не найден");
            }

            // Получаем корзину пользователя
            Cart cart = user.getCart();
            if (cart == null || cart.getCartItems().isEmpty()) {
                return;
            }

            // Находим элемент корзины по gameId
            CartItem cartItemToRemove = cart.getCartItems().stream()
                    .filter(ci -> ci.getGame().getId().equals(gameId))
                    .findFirst()
                    .orElse(null);

            if (cartItemToRemove != null) {
                // Удаляем элемент корзины
                cart.getCartItems().remove(cartItemToRemove);
                entityManager.remove(cartItemToRemove);
            }

            // Обновляем корзину
            entityManager.merge(cart);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Ошибка при удалении игры из корзины", e);
        }
    }

    // Метод для создания заказа
    public String createOrder(Long userId) {
        try {
            // Получаем пользователя по ID
            User user = entityManager.find(User.class, userId);
            if (user == null) {
                return "Пользователь не найден.";
            }

            // Получаем корзину пользователя
            Cart cart = user.getCart();
            if (cart == null || cart.getCartItems().isEmpty()) {
                return "Корзина пуста. Оформить заказ невозможно.";
            }

            // Генерируем четырёхзначный код
            String orderCode = generateRandomOrderCode();

            // Шифруем четырёхзначный код
            String encryptedOrderCode = encrypt(orderCode);

            // Создаем новый заказ
            Order order = new Order();
            order.setUser(user);
            order.setOrder_code(encryptedOrderCode);
            order.setOrder_date(new java.sql.Date(System.currentTimeMillis()));
            order.setStatus(OrderStatus.IN_PROGRESS);

            // Сохраняем заказ в базе данных
            entityManager.persist(order);

            // Создаем элементы заказа
            for (CartItem cartItem : cart.getCartItems()) {
                OrderItem orderItem = new OrderItem(order, cartItem.getGame(), cartItem.getQuantity(), cartItem.getGame().getCost());
                order.getOrderItems().add(orderItem);
                entityManager.persist(orderItem);
            }

            // Очищаем корзину пользователя
            clearCart(userId);

            return "Заказ успешно оформлен. Ваш код подтверждения: " + orderCode;
        } catch (Exception e) {
            e.printStackTrace();
            return "Ошибка при оформлении заказа: " + e.getMessage();
        }
    }

    // Метод для генерации четырёхзначного кода
    private String generateRandomOrderCode() {
        Random random = new Random();
        int code = 1000 + random.nextInt(9000); // Генерируем число от 1000 до 9999
        return String.valueOf(code);
    }

    public List<Order> getOrdersByUserId(Long userId) {
        try {
            // Получаем пользователя по ID
            User user = entityManager.find(User.class, userId);
            if (user == null) {
                throw new IllegalArgumentException("Пользователь не найден");
            }

            // Получаем все заказы пользователя
            TypedQuery<Order> query = entityManager.createQuery(
                    "SELECT DISTINCT o FROM Order o JOIN FETCH o.orderItems oi JOIN FETCH oi.game WHERE o.user.user_id = :userId", Order.class);
            query.setParameter("userId", userId);

            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public String encrypt(String strToEncrypt) {
        try {
            SecretKeySpec secretKey = new SecretKeySpec(AES_KEY.getBytes(StandardCharsets.UTF_8), "AES");
            Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, secretKey);
            return Base64.getEncoder().encodeToString(cipher.doFinal(strToEncrypt.getBytes(StandardCharsets.UTF_8)));
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Ошибка при шифровании", e);
        }
    }

    public String decrypt(String strToDecrypt) {
        try {
            SecretKeySpec secretKey = new SecretKeySpec(AES_KEY.getBytes(StandardCharsets.UTF_8), "AES");
            Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            cipher.init(Cipher.DECRYPT_MODE, secretKey);
            return new String(cipher.doFinal(Base64.getDecoder().decode(strToDecrypt)));
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Ошибка при расшифровке", e);
        }
    }

    public Map<Long, String> getDecryptedOrderCodes(List<Order> orders) {
        Map<Long, String> decryptedCodes = new HashMap<>();
        for (Order order : orders) {
            String decryptedCode = decrypt(order.getOrder_code());
            decryptedCodes.put(order.getOrder_id(), decryptedCode);
        }
        return decryptedCodes;
    }

    // Метод для обновления статуса заказа
    public void updateOrderStatus(Long orderId, OrderStatus newStatus) {
        Optional<Order> orderOptional = findOrderById(orderId);
        if (orderOptional.isPresent()) {
            Order order = orderOptional.get();
            order.setStatus(newStatus);
            entityManager.merge(order);
        } else {
            throw new IllegalArgumentException("Order with ID " + orderId + " not found");
        }
    }

    // Метод для получения статуса заказа по ID
    public Optional<OrderStatus> getOrderStatusById(Long orderId) {
        Optional<Order> orderOptional = findOrderById(orderId);
        return orderOptional.map(Order::getStatus);
    }

    // Метод для расчета и сохранения премии
    public void saveBonus(User employee, Long orderId) {
        Order order = entityManager.createQuery(
                        "SELECT o FROM Order o " +
                                "JOIN FETCH o.orderItems " +
                                "WHERE o.id = :orderId", Order.class)
                .setParameter("orderId", orderId)
                .getSingleResult();
        // Рассчитываем общую стоимость заказа
        BigDecimal totalCost = order.getOrderItems().stream()
                .map(orderItem -> BigDecimal.valueOf(orderItem.getPrice())  // Преобразуем цену в BigDecimal
                        .multiply(BigDecimal.valueOf(orderItem.getQuantity()))) // Умножаем на количество
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Рассчитываем премию (5% от стоимости заказа)
        BigDecimal bonusAmount = totalCost.multiply(new BigDecimal("0.05"));

        // Создаем новую премию
        Bonus bonus = new Bonus(employee, order, bonusAmount, new Date());
        entityManager.persist(bonus);
    }

    // Метод для получения всех премий
//    public List<Bonus> getAllBonuses() {
//        TypedQuery<Bonus> query = entityManager.createQuery(
//                "SELECT b FROM Bonus b JOIN FETCH b.employee JOIN FETCH b.order", Bonus.class);
//        return query.getResultList();
//    }
    @Transactional
    public List<Bonus> getAllBonuses() {
        return entityManager.createQuery(
                        "SELECT b FROM Bonus b " +
                                "JOIN FETCH b.order o " +
                                "JOIN FETCH b.employee e", Bonus.class)
                .getResultList();
    }

    public Order getFullOrderDetails(Long orderId) {
        return entityManager.createQuery(
                        "SELECT o FROM Order o " +
                                "LEFT JOIN FETCH o.orderItems i " +
                                "LEFT JOIN FETCH i.game " +
                                "LEFT JOIN FETCH o.user u " + // Загружаем пользователя, связанного с заказом
                                "WHERE o.order_id = :id", Order.class)
                .setParameter("id", orderId)
                .getSingleResult();
    }

    public boolean canViewOrder(Order order, User user) {
        return user.getRole().getRole_name().equals("director")
                || order.getUser().getUser_id().equals(user.getUser_id());
    }

    public void addGame(Game newGame) {
        try {
            entityManager.persist(newGame); // Сохраняем игру в базе данных
            entityManager.flush();       // Принудительно синхронизируем с БД
        } catch (PersistenceException e) {
            // Обработка ошибок сохранения
            throw new RuntimeException("Ошибка при добавлении игры", e);
        }
    }

    // Получение уникальных жанров
    public List<String> getUniqueGenres() {
        return entityManager.createQuery(
                "SELECT DISTINCT g.genre FROM Game g ORDER BY g.genre",
                String.class
        ).getResultList();
    }

    // Получение уникальных разработчиков
    public List<String> getUniqueDevelopers() {
        return entityManager.createQuery(
                "SELECT DISTINCT g.developer FROM Game g ORDER BY g.developer",
                String.class
        ).getResultList();
    }

    // Получение минимального года релиза
    public int getMinReleaseYear() {
        return entityManager.createQuery(
                "SELECT MIN(YEAR(g.release_date)) FROM Game g",
                Integer.class
        ).getSingleResult();
    }

    // Получение максимального года релиза
    public int getMaxReleaseYear() {
        return entityManager.createQuery(
                "SELECT MAX(YEAR(g.release_date)) FROM Game g",
                Integer.class
        ).getSingleResult();
    }

    // Получение минимальной цены
    public double getMinPrice() {
        Double result = entityManager.createQuery(
                "SELECT MIN(CAST(g.cost AS double)) FROM Game g",
                Double.class
        ).getSingleResult();
        return result != null ? result : 0.0;
    }

    // Получение максимальной цены
    public double getMaxPrice() {
        Double result = entityManager.createQuery(
                "SELECT MAX(CAST(g.cost AS double)) FROM Game g",
                Double.class
        ).getSingleResult();
        return result != null ? result : 0.0;
    }
}