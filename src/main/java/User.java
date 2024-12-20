import javax.persistence.*;
import java.util.List;

@Entity
@Table(name = "users", uniqueConstraints = @UniqueConstraint(columnNames = "user_name"))
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long user_id;

    @Column(name = "user_name", nullable = false, unique = true)
    private String user_name;

    @Column(nullable = false)
    private String password;

    @ManyToOne(fetch = FetchType.EAGER) // Изменено на ManyToOne, чтобы у пользователя была только одна роль
    @JoinColumn(name = "role_id", referencedColumnName = "role_id", nullable = false) // Колонка для внешнего ключа
    private Role role;

    public User() {
        // Конструктор по умолчанию необходим для JPA
    }

    public User(String user_name) {
        this.user_name = user_name;
    }

    public User(String user_name, String password, Role role) {
        this.user_name = user_name;
        this.password = password;
        this.role = role;
    }

    public Long getUser_id() {
        return user_id;
    }

    public String getUser_name() {
        return user_name;
    }

    public void setUser_id(Long user_id) {
        this.user_id = user_id;
    }

    public void setUser_name(String user_name) {
        this.user_name = user_name;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public Long getId() {
        return user_id;
    }

    public String getPassword() {
        return password;
    }

    public Role getRole() {
        return role;
    }
}
