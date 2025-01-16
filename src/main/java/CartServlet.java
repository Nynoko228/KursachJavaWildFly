import javax.inject.Inject;
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

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    @Inject
    private TestServiceBean testServiceBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Map<Long, Integer> cart = new HashMap<>();
        Map<Game, Integer> cartItems = new HashMap<>();

        try {
            Principal principal = request.getUserPrincipal();
            if (principal != null) {
                // Получаем пользователя из базы данных
                User user = testServiceBean.getAllUsers().stream()
                        .filter(u -> u.getUser_name().equals(principal.getName()))
                        .findFirst()
                        .orElse(null);

                if (user != null) {
                    // Получаем корзину пользователя
                    cartItems = testServiceBean.getCartItems(user.getUser_id());
                }
            } else {
                // Если пользователь не авторизован, используем корзину из сессии
                if (session != null) {
                    cart = (Map<Long, Integer>) session.getAttribute("cart");
                    if (cart == null) {
                        cart = new HashMap<>();
                    }

                    if (!cart.isEmpty()) {
                        // Используем JOIN FETCH для загрузки всех необходимых данных сразу
                        for (Map.Entry<Long, Integer> entry : cart.entrySet()) {
                            Long gameId = entry.getKey();
                            Integer quantity = entry.getValue();
                            Game game = testServiceBean.getAllGames().stream()
                                    .filter(g -> g.getId().equals(gameId))
                                    .findFirst()
                                    .orElse(null);

                            if (game != null) {
                                cartItems.put(game, quantity);
                            }
                        }
                    }
                }
            }

            request.setAttribute("cartItems", cartItems);
            System.out.println("cartItems: " + cartItems);

            request.getRequestDispatcher("/cart.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Exce: " + e);
            request.setAttribute("errorMessage", "Произошла ошибка при загрузке корзины.");
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
        }
    }
}