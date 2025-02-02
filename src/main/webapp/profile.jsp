<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Профиль</title>
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
    </style>
</head>
<body>
    <div class="main-content">
        <div class="content">
            <div class="container">
                <h1>Добро пожаловать, <%= request.getUserPrincipal().getName() %>!</h1>
                <p>Вы успешно авторизованы на странице профиля.</p>
                <!-- Кнопки для перехода на другие страницы -->
                <a href="${pageContext.request.contextPath}/games" class="button">Каталог игр</a>
                <a href="${pageContext.request.contextPath}/cart" class="button">Корзина</a>
                <a href="${pageContext.request.contextPath}/profile/orders" class="button">Заказы</a>
                <c:if test="${userRole eq 'director'}">
                    <div>
                        <a href="${pageContext.request.contextPath}/profile/bonuses" class="button">Премии сотрудников</a>
                        <a href="${pageContext.request.contextPath}/profile/allprofiles" class="button">Список пользователей</a>
                        <button class="button" onclick="openAddGameModal()">Добавить игру</button>
                    </div>
                </c:if>
                <!-- Форма для выхода из системы -->
                <form action="${pageContext.request.contextPath}/logout" method="POST">
                    <button type="submit" class="button">Выйти</button>
                </form>
            </div>
        </div>
    </div>
    <jsp:include page="addGameModal.jsp"/>
</body>
</html>