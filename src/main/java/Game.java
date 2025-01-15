import javax.persistence.*;
import java.sql.Date;
import java.util.Set;

@Entity
@Table(name = "games") // Название таблицы в БД
public class Game {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false) // Название не может быть пустым
    private String name;

    @Column(nullable = false) // Год выпуска не может быть пустым
    private Date release_date;

    @Column(nullable = false) // Создатель не может быть пустым
    private String developer;

    @Column(nullable = false) // Жанр не может быть пустым
    private String genre;

    @Column(nullable = false) // Цена не может быть пустой
    private Double cost; // Изменили тип на Double

    @OneToMany(mappedBy = "game", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<Purchase> purchases;

    public Game() {
        // Пустой конструктор необходим для JPA
    }

    public Game(String name, Date release_date, String developer, String genre, Double cost) {
        this.name = name;
        this.release_date = release_date;
        this.developer = developer;
        this.genre = genre;
        this.cost = cost;
    }

    // Геттеры и сеттеры для всех полей
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getRelease_date() {
        return release_date;
    }

    public void setRelease_date(Date release_date) {
        this.release_date = release_date;
    }

    public String getDeveloper() {
        return developer;
    }

    public void setDeveloper(String developer) {
        this.developer = developer;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public Double getCost() {
        return cost;
    }

    public void setCost(Double cost) {
        this.cost = cost;
    }

    public Set<Purchase> getPurchases() {
        return purchases;
    }

    public void setPurchases(Set<Purchase> purchases) {
        this.purchases = purchases;
    }
}