import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.Principal;
import java.util.*;
import java.util.stream.Collectors;

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

                // Получаем заказы текущего пользователя
                List<Order> userOrders = testServiceBean.getOrdersByUserId(user.getUser_id());
                System.out.println("User Orders: " + userOrders);
                request.setAttribute("userOrders", userOrders);

                // Получаем расшифрованные коды подтверждения для заказов текущего пользователя
                Map<Long, String> decryptedOrderCodes = testServiceBean.getDecryptedOrderCodes(userOrders);
                request.setAttribute("decryptedOrderCodes", decryptedOrderCodes);

                // Получаем все заказы, если пользователь - Работник или Директор
                List<Order> allOrders = new ArrayList<>();
                if ("employee".equals(role.getRole_name()) || "director".equals(role.getRole_name())) {
                    allOrders = testServiceBean.getAllOrders();
                    // Фильтрация заказов для получения только тех, которые не принадлежат текущему пользователю
                    List<Order> filteredAllOrders = allOrders.stream()
                            .filter(order -> userOrders.stream()
                                    .noneMatch(userOrder -> userOrder.getOrder_id().equals(order.getOrder_id())))
                            .collect(Collectors.toList());

                    System.out.println("Filtered All Orders: " + filteredAllOrders);

                    request.setAttribute("otherOrders", filteredAllOrders);
                }

                // Получаем доступные статусы для изменения
                List<OrderStatus> availableStatuses = getAvailableStatusesForRole(role.getRole_name());
                request.setAttribute("availableStatuses", availableStatuses);
            } else {
                request.setAttribute("errorMessage", "Пользователь не найден.");
            }
        } else {
            request.setAttribute("errorMessage", "Для просмотра заказов необходимо авторизоваться.");
        }

        List<OrderStatus> allStatuses = Arrays.asList(OrderStatus.values());
        request.setAttribute("allStatuses", allStatuses);
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