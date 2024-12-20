import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.PersistenceContext;
import javax.security.auth.Subject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/games")
public class GamesTableServlet extends HttpServlet {
    @PersistenceContext(name = "Kursach")
    private EntityManager em;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            List<Game> games = em.createQuery("SELECT g FROM Game g", Game.class).getResultList();
            System.out.println("Список игр size: " + games.size());
            games.forEach(game -> System.out.println(game.getName()));
            request.setAttribute("games", games);
            request.getRequestDispatcher("/games_table.jsp").forward(request, response);
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Здесь можно будет обработать post-запросы (например, на добавление или удаление записи)
        response.sendRedirect(request.getContextPath() + "/base");
    }
}
