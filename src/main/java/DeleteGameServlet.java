import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.Principal;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/profile/deleteGame")
public class DeleteGameServlet extends HttpServlet {

    @Inject
    private TestServiceBean testService;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!request.isUserInRole("director")) {
            response.sendError(403, "Доступ запрещен");
            return;
        }

        try {
            Long gameId = Long.parseLong(request.getParameter("gameId"));
            System.out.println("DELETE GAME" + gameId);
            testService.safeDeleteGame(gameId);

            // Возвращаем успешный ответ в формате JSON
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"success\"}");
        } catch (IllegalStateException e) {
            System.out.println("OSHIBKA!!:" + e.getMessage());
            // Возвращаем ошибку с кодом состояния и сообщением
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.getWriter().write("{\"" + e.getMessage() + "\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
        }
    }
}