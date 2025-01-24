import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/games")
public class GamesTableServlet extends HttpServlet {

    @Inject
    TestServiceBean testServiceBean;

    @PersistenceContext(unitName = "Kursach")
    private EntityManager em;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
//            List<Game> games = em.createQuery("SELECT g FROM Game g", Game.class).getResultList();
            List<Game> games = testServiceBean.getAllGames();
            System.out.println("Список игр size: " + games.size());
            // Получаем данные для фильтров
            List<String> genres = testServiceBean.getUniqueGenres();
            List<String> developers = testServiceBean.getUniqueDevelopers();
            int minYear = testServiceBean.getMinReleaseYear();
            int maxYear = testServiceBean.getMaxReleaseYear();
            double minPrice = testServiceBean.getMinPrice();
            double maxPrice = testServiceBean.getMaxPrice();

            request.setAttribute("games", games);
            request.setAttribute("genres", genres);
            request.setAttribute("developers", developers);
            request.setAttribute("minYear", minYear);
            request.setAttribute("maxYear", maxYear);
            request.setAttribute("minPrice", minPrice);
            request.setAttribute("maxPrice", maxPrice);
            request.getRequestDispatcher("/games_table.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(true); // Создаем сессию, если она не существует
        Long gameId = Long.parseLong(request.getParameter("gameId"));

        System.out.println("Добавление игры в корзину с ID: " + gameId); // Добавлено для отладки

        try {
            Principal principal = request.getUserPrincipal();
            if (principal != null) {
                // Получаем пользователя из базы данных
                User user = testServiceBean.getAllUsers().stream()
                        .filter(u -> u.getUser_name().equals(principal.getName()))
                        .findFirst()
                        .orElse(null);

                if (user != null) {
                    // Добавляем игру в корзину пользователя
                    testServiceBean.addToCart(gameId, user.getUser_id());
                }
            } else {
                // Если пользователь не авторизован, используем корзину из сессии
                Map<Long, Integer> cart = (Map<Long, Integer>) session.getAttribute("cart");
                if (cart == null) {
                    cart = new HashMap<>();
                }

                cart.put(gameId, cart.getOrDefault(gameId, 0) + 1);
                session.setAttribute("cart", cart);
            }

            response.sendRedirect(request.getContextPath() + "/games");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/games");
        }
    }
}