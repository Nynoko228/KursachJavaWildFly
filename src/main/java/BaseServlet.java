import javax.inject.Inject;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

// Для запуска PostgreSQL ищием pgAdmin4

@WebServlet("/base")
public class BaseServlet extends HttpServlet {
    @Inject
    TestServiceBean bean;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
//        List<User> users = bean.getAllUsers();
//        req.setAttribute("students", users);
        req.getRequestDispatcher("Simple Form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String name = req.getParameter("name");
        String password = req.getParameter("pswd");
        String action = req.getParameter("submitAction");
        String message = null;

        if ("reg".equals(action)) {
            String role = req.getParameter("role");
            message = bean.addUserWithRole(name, password, role);

            if (message != null && !message.isEmpty()) {
                // Сохраняем сообщение в сессии перед редиректом
                req.getSession().setAttribute("resultMessage", message);
                resp.sendRedirect(req.getContextPath() + "/base");
                return;
            }

            // Передаем сообщение на JSP
            req.setAttribute("resultMessage", message);
            RequestDispatcher dispatcher = req.getRequestDispatcher("register.jsp");
            dispatcher.forward(req, resp);
        } else if ("auth".equals(action)) {
            resp.sendRedirect(req.getContextPath() + "/profile");
        } else if ("catalog".equals(action)) {
            resp.sendRedirect(req.getContextPath() + "/games");
        } else {
            resp.sendRedirect(req.getContextPath() + "/base");
        }
    }

    protected void process(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
            req.getRequestDispatcher("Simple Form.jsp").forward(req, resp);
    }
}
