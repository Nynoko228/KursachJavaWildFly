import javax.security.auth.Subject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;


@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Завершаем сессию пользователя
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Очистка контекста безопасности
        request.logout();

        // Удаляем куки JSESSIONID
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("JSESSIONID".equals(cookie.getName())) {
                    cookie.setMaxAge(0); // Устанавливаем срок действия куки на 0, что означает удаление
                    cookie.setPath("/"); // Убедитесь, что путь установлен корректно
                    response.addCookie(cookie); // Отправляем обновленный куки обратно
                }
            }
        }

        // Отключение кэширования, чтобы браузер не сохранял авторизацию
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // Отправляем ответ с кодом состояния 401 (Unauthorized)
        response.setHeader("WWW-Authenticate", "Basic realm=\"Test\"");
//        response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
        // Перенаправление на страницу авторизации
//        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        // Прерываем процесс перенаправления, если уже произошел редирект
        // Перенаправление на страницу авторизации
        response.sendRedirect(request.getContextPath() + "/home");

    }
}