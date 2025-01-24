import javax.persistence.*;
import java.util.Set;

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



    @Column(name = "bonus_percentage")
    private Integer bonusPercentage;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "role_id", referencedColumnName = "role_id", nullable = false)
    private Role role;

//    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
//    private Set<Purchase> purchases;

    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY, orphanRemoval = true)
    private Cart cart;

    public User() {}

    public User(String user_name, String password, Role role, Integer bonusPercentage) {
        this.user_name = user_name;
        this.password = password;
        this.role = role;
        this.bonusPercentage = bonusPercentage;
    }

    // Геттеры и сеттеры
    public Long getUser_id() {
        return user_id;
    }

    public void setUser_id(Long user_id) {
        this.user_id = user_id;
    }

    public String getUser_name() {
        return user_name;
    }

    public void setUser_name(String user_name) {
        this.user_name = user_name;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public void setBonusPercentage(Integer bonusPercentage) {
        this.bonusPercentage = bonusPercentage;
    }

    public Integer getBonusPercentage() {
        return bonusPercentage;
    }

//    public Set<Purchase> getPurchases() {
//        return purchases;
//    }
//
//    public void setPurchases(Set<Purchase> purchases) {
//        this.purchases = purchases;
//    }

    public Cart getCart() {
        return cart;
    }

    public void setCart(Cart cart) {
        this.cart = cart;
    }
}