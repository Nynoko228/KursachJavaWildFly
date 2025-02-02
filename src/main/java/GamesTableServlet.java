import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.servlet.AsyncContext;
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

@WebServlet(value = "/games", asyncSupported = true)
public class GamesTableServlet extends HttpServlet {

    @Inject
    TestServiceBean testServiceBean;

    @PersistenceContext(unitName = "Kursach")
    private EntityManager em;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Включение асинхронной обработки
        AsyncContext asyncContext = request.startAsync();

        asyncContext.start(() -> {
            try {
                handleGetRequest(asyncContext);
            } catch (Exception e) {
                e.printStackTrace();
                asyncContext.complete(); // Завершаем контекст при ошибке
            }
        });
    }

    private void handleGetRequest(AsyncContext asyncContext) throws ServletException, IOException {
        HttpServletRequest request = (HttpServletRequest) asyncContext.getRequest();
        HttpServletResponse response = (HttpServletResponse) asyncContext.getResponse();

        try {
            // Получаем список игр
            List<Game> games = testServiceBean.getAllActiveGames();
            System.out.println("Список игр size: " + games.size());

            // Получаем данные для фильтров
            List<String> genres = testServiceBean.getUniqueGenres();
            List<String> developers = testServiceBean.getUniqueDevelopers();
            int minYear = testServiceBean.getMinReleaseYear();
            int maxYear = testServiceBean.getMaxReleaseYear();
            double minPrice = testServiceBean.getMinPrice();
            double maxPrice = testServiceBean.getMaxPrice();

            // Устанавливаем атрибуты запроса
            request.setAttribute("games", games);
            request.setAttribute("genres", genres);
            request.setAttribute("developers", developers);
            request.setAttribute("minYear", minYear);
            request.setAttribute("maxYear", maxYear);
            request.setAttribute("minPrice", minPrice);
            request.setAttribute("maxPrice", maxPrice);

            // Перенаправляем на JSP
            asyncContext.dispatch("/games_table.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Ошибка обработки запроса.");
        } finally {
            asyncContext.complete(); // Завершаем асинхронную обработку
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Включение асинхронной обработки
        AsyncContext asyncContext = request.startAsync();

        asyncContext.start(() -> {
            try {
                handlePostRequest(asyncContext);
            } catch (Exception e) {
                e.printStackTrace();
                asyncContext.complete();
            }
        });
    }

    private void handlePostRequest(AsyncContext asyncContext) throws IOException {
        HttpServletRequest request = (HttpServletRequest) asyncContext.getRequest();
        HttpServletResponse response = (HttpServletResponse) asyncContext.getResponse();

        HttpSession session = request.getSession(true); // Создаем сессию, если она не существует
        Long gameId = Long.parseLong(request.getParameter("gameId"));

        System.out.println("Добавление игры в корзину с ID: " + gameId); // Логирование для отладки

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
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Ошибка добавления в корзину.");
        } finally {
            asyncContext.complete(); // Завершаем асинхронную обработку
        }
    }
}
