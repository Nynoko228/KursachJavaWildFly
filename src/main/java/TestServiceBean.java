import javax.ejb.Stateless;
import javax.ejb.TransactionManagement;
import javax.ejb.TransactionManagementType;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.TypedQuery;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Stateless
@TransactionManagement(TransactionManagementType.CONTAINER)
public class TestServiceBean {

    @PersistenceContext(name = "Kursach") // Подключаемся к DB
    private EntityManager entityManager;

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

}