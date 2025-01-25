import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.security.Principal;

@WebServlet("/cart/order")
public class OrderServlet extends HttpServlet {

    @Inject
    private TestServiceBean testServiceBean;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Principal principal = request.getUserPrincipal();

        if (principal != null) {
            // Получаем пользователя по имени
            User user = testServiceBean.getAllUsers().stream()
                    .filter(u -> u.getUser_name().equals(principal.getName()))
                    .findFirst()
                    .orElse(null);

            if (user != null) {
                // Создаем заказ
                String orderMessage = testServiceBean.createOrder(user.getUser_id());
                request.setAttribute("orderMessage", orderMessage);
                System.out.println("Order Created Succsesfull");
                request.setAttribute("cartSuccessful", "Заказ успешно оформлен");
            } else {
                request.setAttribute("errorMessage", "Пользователь не найден.");
            }
        } else {
            request.setAttribute("errorMessage", "Для оформления заказа необходимо авторизоваться.");
        }

        // Перенаправляем обратно на страницу корзины
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}