import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;


@WebServlet("/deliverOrder")
public class DeliverOrderServlet extends HttpServlet {
    @Inject
    private TestServiceBean testServiceBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long orderId = Long.parseLong(request.getParameter("orderId"));
        String providedCode = request.getParameter("code");

        // Получаем заказ по ID
        Optional<Order> orderOptional = testServiceBean.findOrderById(orderId);
        if (orderOptional.isPresent()) {
            Order order = orderOptional.get();

            // Проверяем, что статус заказа "Готов к выдаче"
            if (order.getStatus() != OrderStatus.READY_FOR_PICKUP) {
                request.setAttribute("errorMessage", "Заказ не готов к выдаче.");
                request.getRequestDispatcher("/profile/orders").forward(request, response);
                return;
            }

            // Получаем зашифрованный код из базы данных
            String encryptedOrderCode = order.getOrder_code();

            // Расшифровываем код из базы данных
            String decryptedOrderCode = testServiceBean.decrypt(encryptedOrderCode);

            // Проверяем введенный код с расшифрованным кодом из базы данных
            if (decryptedOrderCode.equals(providedCode)) {
                // Обновляем статус заказа на "Выдан"
                testServiceBean.updateOrderStatus(orderId, OrderStatus.DELIVERED);
                request.setAttribute("successMessage", "Заказ успешно выдан.");
            } else {
                request.setAttribute("errorMessage", "Неверный код подтверждения.");
            }
        } else {
            request.setAttribute("errorMessage", "Заказ не найден.");
        }

        // Перенаправляем обратно на страницу с заказами
        request.getRequestDispatcher("/profile/orders").forward(request, response);
    }
}