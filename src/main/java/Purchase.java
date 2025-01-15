import javax.persistence.*;
import java.sql.Date;

@Entity
@Table(name = "purchases")
public class Purchase {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long purchase_id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "game_id", nullable = false)
    private Game game;

    @Column(nullable = false)
    private Date purchase_date;

    @Column(nullable = false)
    private Double cost;

    // Конструкторы
    public Purchase() {}

    public Purchase(User user, Game game, Date purchase_date, Double cost) {
        this.user = user;
        this.game = game;
        this.purchase_date = purchase_date;
        this.cost = cost;
    }

    // Геттеры и сеттеры
    public Long getPurchase_id() {
        return purchase_id;
    }

    public void setPurchase_id(Long purchase_id) {
        this.purchase_id = purchase_id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Game getGame() {
        return game;
    }

    public void setGame(Game game) {
        this.game = game;
    }

    public Date getPurchase_date() {
        return purchase_date;
    }

    public void setPurchase_date(Date purchase_date) {
        this.purchase_date = purchase_date;
    }

    public Double getCost() {
        return cost;
    }

    public void setCost(Double cost) {
        this.cost = cost;
    }
}