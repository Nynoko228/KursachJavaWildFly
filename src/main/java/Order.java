import javax.persistence.*;
import java.sql.Date;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "orders")
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long order_id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private Set<OrderItem> orderItems = new HashSet<>();

    @Column(nullable = false)
    private String order_code_hash;

    @Column(nullable = false)
    private Date order_date;

    public Order() {}

    public Order(User user, Set<OrderItem> orderItems, String orderCodeHash, Date orderDate) {
        this.user = user;
        this.orderItems = orderItems;
        this.order_code_hash = orderCodeHash;
        this.order_date = orderDate;
    }

    // Геттеры и сеттеры
    public Long getOrder_id() {
        return order_id;
    }

    public void setOrder_id(Long order_id) {
        this.order_id = order_id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Set<OrderItem> getOrderItems() {
        return orderItems;
    }

    public void setOrderItems(Set<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }

    public String getOrder_code_hash() {
        return order_code_hash;
    }

    public void setOrder_code_hash(String order_code_hash) {
        this.order_code_hash = order_code_hash;
    }

    public Date getOrder_date() {
        return order_date;
    }

    public void setOrder_date(Date order_date) {
        this.order_date = order_date;
    }
}