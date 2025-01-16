import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.Principal;
import java.util.Arrays;
import java.util.Collections;
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
                // Получаем роль пользователя
                Role role = testServiceBean.getUserRole(user.getUser_id());
                request.setAttribute("userRole", role.getRole_name());

                // Получаем заказы в зависимости от роли
                List<Order> orders;
                if ("employee".equals(role.getRole_name()) || "director".equals(role.getRole_name())) {
                    orders = testServiceBean.getAllOrders(); // Получаем все заказы
                } else {
                    orders = testServiceBean.getOrdersByUserId(user.getUser_id()); // Получаем заказы пользователя
                }
                System.out.println("All Orders: " + orders);
                request.setAttribute("orders", orders);

                // Получаем расшифрованные коды подтверждения для заказов
                Map<Long, String> decryptedOrderCodes = testServiceBean.getDecryptedOrderCodes(orders);
                request.setAttribute("decryptedOrderCodes", decryptedOrderCodes);

                // Получаем доступные статусы для изменения
                List<OrderStatus> availableStatuses = getAvailableStatusesForRole(role.getRole_name());
                request.setAttribute("availableStatuses", availableStatuses);
            } else {
                request.setAttribute("errorMessage", "Пользователь не найден.");
            }
        } else {
            request.setAttribute("errorMessage", "Для просмотра заказов необходимо авторизоваться.");
        }

        // Перенаправляем на страницу с заказами
        request.getRequestDispatcher("/profile_orders.jsp").forward(request, response);
    }

    private List<OrderStatus> getAvailableStatusesForRole(String roleName) {
        switch (roleName) {
            case "employee":
                return Arrays.asList(OrderStatus.IN_PROGRESS, OrderStatus.READY_FOR_PICKUP);
            case "director":
                return Arrays.asList(OrderStatus.IN_PROGRESS, OrderStatus.READY_FOR_PICKUP, OrderStatus.DELIVERED);
            default:
                return Collections.emptyList();
        }
    }
}