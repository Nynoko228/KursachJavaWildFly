import javax.inject.Inject;
import javax.persistence.EntityNotFoundException;
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
import java.util.List;

@WebServlet("/profile/allprofiles")
public class AllUsersServlet extends HttpServlet {
    @Inject
    private TestServiceBean testServiceBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Проверка роли пользователя
        if (!request.isUserInRole("director")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        List<User> allUsers = testServiceBean.getAllUsers();
        List<Role> allRoles = testServiceBean.getAllRoles();

        request.setAttribute("users", allUsers);
        request.setAttribute("roles", allRoles);
        request.getRequestDispatcher("/allUsers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Определяем тип операции
        String roleId = request.getParameter("roleId");
        String bonusPercentage = request.getParameter("bonusPercentage");

        try {
            if (roleId != null) {
                // Обработка изменения роли
                handleRoleChange(request);
            } else if (bonusPercentage != null) {
                // Обработка изменения премии
                handleBonusChange(request);
            } else {
                throw new IllegalArgumentException("Некорректный запрос");
            }

            response.sendRedirect(request.getContextPath() + "/profile/allprofiles");

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Ошибка формата числового значения");
            doGet(request, response);
        } catch (EntityNotFoundException e) {
            request.setAttribute("errorMessage", "Объект не найден в базе данных");
            doGet(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            doGet(request, response);
        } catch (SecurityException e) {
            request.setAttribute("errorMessage", e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Неизвестная ошибка: " + e.getMessage());
            doGet(request, response);
        }
    }

    private void handleRoleChange(HttpServletRequest request) {
        String userId = request.getParameter("userId");
        String roleId = request.getParameter("roleId");

        User user = testServiceBean.getUserById(Long.parseLong(userId));

        // Проверка что не изменяем директора
        if ("director".equals(user.getRole().getRole_name())) {
            throw new SecurityException("Нельзя изменять роль директора");
        }

        testServiceBean.updateUserRole(user.getUser_id(), Long.parseLong(roleId));
    }

    private void handleBonusChange(HttpServletRequest request) {
        String userId = request.getParameter("userId");
        String bonusParam = request.getParameter("bonusPercentage").trim();

        // Парсим значение премии (допускаем null)
        Integer bonusValue = bonusParam.isEmpty() ? null : Integer.parseInt(bonusParam);

        // Валидация значения
        if (bonusValue != null && (bonusValue < 1 || bonusValue > 10)) {
            throw new IllegalArgumentException("Премия должна быть между 1% и 10%");
        }

        User user = testServiceBean.getUserById(Long.parseLong(userId));

        // Проверка что пользователь сотрудник или директор
        String role = user.getRole().getRole_name();
        if (!"employee".equals(role) && !"director".equals(role)) {
            throw new SecurityException("Премия доступна только сотрудникам");
        }

        testServiceBean.updateUserBonus(user.getUser_id(), bonusValue);
    }
}
