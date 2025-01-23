import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.Principal;
import java.util.List;

@WebServlet("/profile/bonuses")
public class BonusesServlet extends HttpServlet {
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
                if ("director".equals(role.getRole_name())) {
                    // Получаем все премии
                    List<Bonus> bonuses = testServiceBean.getAllBonuses();
                    request.setAttribute("bonuses", bonuses);
                    // Перенаправляем на страницу с премиями
                    request.getRequestDispatcher("/bonuses.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "У вас нет доступа к этой странице.");
                    request.getRequestDispatcher("/profile/orders").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Пользователь не найден.");
                request.getRequestDispatcher("/profile/orders").forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Для просмотра премий необходимо авторизоваться.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}