import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


@WebServlet("/updateOrderStatus")
public class UpdateOrderStatusServlet extends HttpServlet {
    @Inject
    private TestServiceBean testServiceBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long orderId = Long.parseLong(request.getParameter("orderId"));
        String newStatusStr = request.getParameter("newStatus");
        OrderStatus newStatus = OrderStatus.valueOf(newStatusStr);

        try {
            testServiceBean.updateOrderStatus(orderId, newStatus);
            request.setAttribute("successMessage", "Статус заказа успешно обновлен.");
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
        }

        // Перенаправляем обратно на страницу с заказами
        request.getRequestDispatcher("/profile/orders").forward(request, response);
    }
}