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
import java.util.List;

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

}