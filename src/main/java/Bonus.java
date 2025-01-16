import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "bonuses")
public class Bonus {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long bonus_id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "employee_id", nullable = false)
    private User employee;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "order_id", nullable = false)
    private Order order;

    @Column(nullable = false)
    private BigDecimal amount;

    @Column(nullable = false)
    private Date bonus_date;

    public Bonus() {}

    public Bonus(User employee, Order order, BigDecimal amount, Date bonus_date) {
        this.employee = employee;
        this.order = order;
        this.amount = amount;
        this.bonus_date = bonus_date;
    }

    // Геттеры и сеттеры

    public Long getBonus_id() {
        return bonus_id;
    }

    public void setBonus_id(Long bonus_id) {
        this.bonus_id = bonus_id;
    }

    public User getEmployee() {
        return employee;
    }

    public void setEmployee(User employee) {
        this.employee = employee;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public Date getBonus_date() {
        return bonus_date;
    }

    public void setBonus_date(Date bonus_date) {
        this.bonus_date = bonus_date;
    }
}