import javax.inject.Inject;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.Optional;

@WebServlet("/profile/orderDetails")
public class OrderDetailsServlet extends HttpServlet {

    @Inject
    private TestServiceBean testServiceBean;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            Long orderId = Long.parseLong(req.getParameter("orderId"));
//            Order order = orderService.getFullOrderDetails(orderId);
            Optional<Order> orderOptional = testServiceBean.findOrderById(orderId);
            if (orderOptional.isPresent()) {
                Order order = orderOptional.get();
                String employeeUsername = req.getParameter("empl");

                // Получаем бонусный процент сотрудника
                Integer bonusPercentage = 5; // значение по умолчанию
                try {
                    User employee = testServiceBean.getUserByUsername(employeeUsername);
                    bonusPercentage = employee.getBonusPercentage() != null
                            ? employee.getBonusPercentage()
                            : 5;
                } catch (Exception e) {
                    req.setAttribute("errorMessage", "Ошибка");
                }

                // Проверка прав доступа
                User currentUser = (User) req.getSession().getAttribute("user");
                if (!testServiceBean.canViewOrder(order, currentUser)) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }

                req.setAttribute("order", order);
                Long bonusId = Long.parseLong(req.getParameter("bonusId"));
                Optional<Bonus> bonus = testServiceBean.findBonusById(bonusId);
                if (bonus.isPresent()) {
                    req.setAttribute("bonus", bonus.get());
                } else {
                    req.setAttribute("errorMessage", "Премия не найдена");
                }
                req.getRequestDispatcher("/orderDetails.jsp").forward(req, resp);
            }

        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}