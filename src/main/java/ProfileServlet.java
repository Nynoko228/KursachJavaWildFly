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
import java.util.Map;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    @PersistenceContext(unitName = "Kursach")
    private EntityManager em;

    @Inject
    private TestServiceBean testServiceBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Principal principal = request.getUserPrincipal();
        if (principal == null) {
            response.sendRedirect("/home");  // Перенаправление на страницу авторизации
        } else {
            try {
                // Получаем пользователя из базы данных
                User user = testServiceBean.getAllUsers().stream()
                        .filter(u -> u.getUser_name().equals(principal.getName()))
                        .findFirst()
                        .orElse(null);

                if (user == null) {
                    throw new ServletException("Пользователь не найден");
                }

                // Получаем корзину из сессии
                HttpSession session = request.getSession(false);
                Map<Long, Integer> sessionCart = new HashMap<>();
                if (session != null) {
                    sessionCart = (Map<Long, Integer>) session.getAttribute("cart");
                    if (sessionCart == null) {
                        sessionCart = new HashMap<>();
                    }
                }

                // Получаем корзину пользователя из базы данных
                Map<Game, Integer> userCartItems = testServiceBean.getCartItems(user.getUser_id());

                // Объединяем корзины
                if (!sessionCart.isEmpty()) {
                    for (Map.Entry<Long, Integer> entry : sessionCart.entrySet()) {
                        Long gameId = entry.getKey();
                        Integer quantity = entry.getValue();

                        // Добавляем или обновляем количество игры в корзине пользователя
                        testServiceBean.addToCart(gameId, user.getUser_id());
                    }

                    // Очищаем корзину из сессии
                    session.removeAttribute("cart");
                }

                // Передаем имя пользователя на профильную страницу
                System.out.println("User Name: " + principal.getName());
                request.setAttribute("username", principal.getName());

                // Передаем пользователя в сессию
                request.getSession().setAttribute("user", user);

                request.getRequestDispatcher("profile.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("/home");  // Перенаправление на страницу авторизации в случае ошибки
            }
        }
    }
}