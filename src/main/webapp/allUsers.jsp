<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Список пользователей</title>
    <jsp:include page="header.jsp"/>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            background-color: #f4f4f9;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
        }
        .content {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            text-align: center;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            margin-bottom: 20px;
        }
        p {
            margin-bottom: 20px;
        }
        .button {
            background-color: #007bff;
            border: none;
            color: white;
            padding: 10px 20px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 5px;
            cursor: pointer;
            border-radius: 4px;
        }
        .button:hover {
            background-color: #0056b3;
        }
        form {
            margin-top: 20px;
        }
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            padding: 8px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .error {
            color: red;
        }
        .center-button {
            display: flex;
            justify-content: center;
            padding-top: 20px;
        }
    </style>
</head>
<body>
    <div class="main-content">
        <h1>Список пользователей</h1>
        <c:if test="${not empty errorMessage}">
            <p class="error">${errorMessage}</p>
        </c:if>

        <table>
            <tr>
                <th>ID</th>
                <th>Логин</th>
                <th>Роль</th>
                <th>Премия (%)</th>
                <th>Изменить роль</th>
            </tr>
            <c:forEach items="${users}" var="user">
                <tr>
                    <td>${user.user_id}</td>
                    <td>${user.user_name}</td>
                    <td>${user.role.role_name}</td>
                    <td>
                        <c:if test="${user.role.role_name eq 'employee' or user.role.role_name eq 'director'}">
                            <form method="post" style="display: flex; gap: 5px;">
                                <input type="hidden" name="userId" value="${user.user_id}">
                                <input type="number" name="bonusPercentage"
                                       min="1" max="10"
                                       value="${user.bonusPercentage}"
                                       style="width: 60px;">
                                <button type="submit">Сохранить</button>
                            </form>
                        </c:if>
                    </td>
                    <td>
                        <c:if test="${user.role.role_name ne 'director'}">
                            <form method="post">
                                <input type="hidden" name="userId" value="${user.user_id}">
                                <select name="roleId">
                                    <c:forEach items="${roles}" var="role">
                                        <c:if test="${role.role_name ne 'director'}">
                                            <option value="${role.role_id}"
                                                ${user.role.role_id == role.role_id ? 'selected' : ''}>
                                                ${role.role_name}
                                            </option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                                <button type="submit">Сохранить</button>
                            </form>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </table>
        <div class="center-button">
            <a href="${pageContext.request.contextPath}/profile" class="button">Назад в профиль</a>
        </div>
</div>
</body>
</html>