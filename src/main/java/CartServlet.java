import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    @PersistenceContext(name = "Kursach")
    private EntityManager em;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Map<Long, Integer> cart = new HashMap<>();
        if (session != null) {
            cart = (Map<Long, Integer>) session.getAttribute("cart");
            System.out.println("111Список игр cart: " + cart);
            if (cart == null) {
                cart = new HashMap<>();
            }
        }

        try {
            Map<Game, Integer> cartItems = new HashMap<>();
            if (!cart.isEmpty()) {
                // Используем JOIN FETCH для загрузки всех необходимых данных сразу
                List<Game> games = em.createQuery("SELECT g FROM Game g WHERE g.id IN :gameIds", Game.class)
                        .setParameter("gameIds", cart.keySet()) // Создаём именованный параметр
                        .getResultList();

                for (Game game : games) {
                    Integer quantity = cart.get(game.getId());
                    if (quantity != null) {
                        cartItems.put(game, quantity);
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