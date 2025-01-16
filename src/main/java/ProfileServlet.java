import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.Principal;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    @PersistenceContext(unitName = "Kursach")
    private EntityManager em;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Principal principal = request.getUserPrincipal();
        if (principal == null) {
            response.sendRedirect("/base");  // Перенаправление на страницу авторизации
        } else {
            try {
                // Получаем пользователя из базы данных
                User user = em.createQuery("SELECT u FROM User u WHERE u.user_name = :userName", User.class)
                        .setParameter("userName", principal.getName())
                        .getSingleResult();

                // Передаем имя пользователя на профильную страницу
                System.out.println("User Name: " + principal.getName());
                request.setAttribute("username", principal.getName());

                // Передаем пользователя в сессию
                request.getSession().setAttribute("user", user);

                request.getRequestDispatcher("profile.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("/base");  // Перенаправление на страницу авторизации в случае ошибки
            }
        }
    }
}