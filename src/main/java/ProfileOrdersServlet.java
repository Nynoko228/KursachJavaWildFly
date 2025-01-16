import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.Principal;
import java.util.List;
import java.util.Map;

@WebServlet("/profile/orders")
public class ProfileOrdersServlet extends HttpServlet {

    @Inject
    private TestServiceBean testServiceBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Principal principal = request.getUserPrincipal();

        if (principal != null) {
            // Получаем пользователя по имени
            User user = testServiceBean.getAllUsers().stream()
                    .filter(u -> u.getUser_name().equals(principal.getName()))
                    .findFirst()
                    .orElse(null);

            if (user != null) {
                // Получаем все заказы пользователя
                List<Order> orders = testServiceBean.getOrdersByUserId(user.getUser_id());
                System.out.println("All ORders: " + orders);
                request.setAttribute("orders", orders);

                // Получаем расшифрованные коды подтверждения для заказов
                Map<Long, String> decryptedOrderCodes = testServiceBean.getDecryptedOrderCodes(orders);
                request.setAttribute("decryptedOrderCodes", decryptedOrderCodes);
            } else {
                request.setAttribute("errorMessage", "Пользователь не найден.");
            }
        } else {
            request.setAttribute("errorMessage", "Для просмотра заказов необходимо авторизоваться.");
        }

        // Перенаправляем на страницу с заказами
        request.getRequestDispatcher("/profile_orders.jsp").forward(request, response);
    }
}