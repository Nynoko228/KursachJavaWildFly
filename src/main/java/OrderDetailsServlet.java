import javax.inject.Inject;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;

@WebServlet("/profile/orderDetails")
public class OrderDetailsServlet extends HttpServlet {

    @Inject
    private TestServiceBean orderService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            Long orderId = Long.parseLong(req.getParameter("orderId"));
            Order order = orderService.getFullOrderDetails(orderId);

            Long bonusTimestamp = Long.parseLong(req.getParameter("bonusDate"));
            Date bonusDate = new Date(bonusTimestamp);

            // Проверка прав доступа
            User currentUser = (User) req.getSession().getAttribute("user");
            if (!orderService.canViewOrder(order, currentUser)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            req.setAttribute("order", order);
            req.setAttribute("empl", req.getParameter("empl"));
            req.setAttribute("bonusDate", bonusDate);
            req.getRequestDispatcher("/orderDetails.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}