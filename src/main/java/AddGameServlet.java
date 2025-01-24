import javax.inject.Inject;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

// Для запуска PostgreSQL ищием pgAdmin4

@WebServlet("/addGame")
public class AddGameServlet extends HttpServlet {

    @Inject
    private TestServiceBean gameService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Проверка прав доступа
        if (user == null || !user.getRole().getRole_name().equals("director")) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            // Парсинг данных из формы
            String name = req.getParameter("name");
            System.out.println("NEWGAME name: " + name);
            Date releaseDate = new SimpleDateFormat("yyyy-MM-dd").parse(req.getParameter("releaseDate"));
            String developer = req.getParameter("developer");
            String genre = req.getParameter("genre");
            Double cost = Double.parseDouble(req.getParameter("cost"));

            // Создание объекта игры
            Game newGame = new Game(name, new java.sql.Date(releaseDate.getTime()), developer, genre, cost);

            System.out.println("NEWGAME: " + newGame);

            // Сохранение в БД
            gameService.addGame(newGame);

            // Перенаправление с сообщением об успехе
            session.setAttribute("successAddGame", "Игра успешно добавлена");
            resp.sendRedirect(req.getContextPath() + "/profile");

        } catch (NumberFormatException e) {
            session.setAttribute("erroraddMessage", "Ошибка формата данных");
            resp.sendRedirect(req.getContextPath() + "/profile");
        } catch (Exception e) {
            session.setAttribute("erroraddMessage", "Ошибка при добавлении игры");
            resp.sendRedirect(req.getContextPath() + "/profile");
        }
    }
}
