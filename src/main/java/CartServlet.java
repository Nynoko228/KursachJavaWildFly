import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Principal principal = request.getUserPrincipal();

        if ("clear".equals(request.getParameter("action"))) {
            if (principal != null) {
                // Очистка корзины пользователя из базы данных
                User user = testServiceBean.getAllUsers().stream()
                        .filter(u -> u.getUser_name().equals(principal.getName()))
                        .findFirst()
                        .orElse(null);

                if (user != null) {
                    testServiceBean.clearCart(user.getUser_id());
                }
            } else {
                // Очистка корзины из сессии
                if (session != null) {
                    session.removeAttribute("cart");
                }
            }

            // Перезагружаем страницу корзины
            doGet(request, response);
        } else if ("remove".equals(request.getParameter("action"))) {
            Long gameId = Long.parseLong(request.getParameter("gameId"));

            if (principal != null) {
                // Удаление игры из корзины пользователя из базы данных
                User user = testServiceBean.getAllUsers().stream()
                        .filter(u -> u.getUser_name().equals(principal.getName()))
                        .findFirst()
                        .orElse(null);

                if (user != null) {
                    testServiceBean.removeFromCart(gameId, user.getUser_id());
                }
            } else {
                // Удаление игры из корзины в сессии
                if (session != null) {
                    Map<Long, Integer> cart = (Map<Long, Integer>) session.getAttribute("cart");
                    if (cart != null) {
                        cart.remove(gameId);
                        session.setAttribute("cart", cart);
                    }
                }
            }

            // Перезагружаем страницу корзины
            doGet(request, response);
        } else {
            Long gameId = Long.parseLong(request.getParameter("gameId"));
            if (principal != null) {
                // Добавление игры в корзину пользователя в базе данных
                User user = testServiceBean.getAllUsers().stream()
                        .filter(u -> u.getUser_name().equals(principal.getName()))
                        .findFirst()
                        .orElse(null);
                if (user != null) {
                    testServiceBean.addToCart(gameId, user.getUser_id());
                }
            } else {
                // Добавление игры в корзину в сессии
                if (session != null) {
                    Map<Long, Integer> cart = (Map<Long, Integer>) session.getAttribute("cart");
                    if (cart == null) {
                        cart = new HashMap<>();
                    }
                    cart.put(gameId, cart.getOrDefault(gameId, 0) + 1);
                    session.setAttribute("cart", cart);
                }
            }

            // Отправляем ответ клиенту
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": true}");
            out.flush();
        }
    }
}