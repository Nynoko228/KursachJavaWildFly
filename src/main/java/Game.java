import javax.persistence.*;

@Entity
@Table(name = "games") // Название таблицы в БД
public class Game {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false) // Название не может быть пустым
    private String name;

    @Column(nullable = false) // Год выпуска не может быть пустым
    private int releaseYear;

    @Column(nullable = false) // Создатель не может быть пустым
    private String developer;

    @Column(nullable = false) // Жанр не может быть пустым
    private String genre;

    @Column(nullable = false) // Жанр не может быть пустым
    private String cost;


    public Game() {
        // Пустой конструктор необходим для JPA
    }

    public Game(String name, int releaseYear, String developer, String genre) {
        this.name = name;
        this.releaseYear = releaseYear;
        this.developer = developer;
        this.genre = genre;
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

    public int getReleaseYear() {
        return releaseYear;
    }

    public void setReleaseYear(int releaseYear) {
        this.releaseYear = releaseYear;
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

    public String getCost() {
        return cost;
    }

    public void setCost(String cost) {
        this.cost = cost;
    }
}