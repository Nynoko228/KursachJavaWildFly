<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Профиль</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
        }
        .header {
            position: fixed;
            top: 0;
            width: 100%;
            background-color: #333;
            color: white;
            padding: 10px 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            z-index: 1000;
        }
        .header a {
            color: white;
            text-decoration: none;
            margin-right: 20px;
            font-size: 16px;
        }
        .header a:hover {
            color: #0056b3; /* Цвет при наведении */
        }
        .content {
            padding-top: 60px; /* Высота шапки */
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
    <jsp:include page="header.jsp" />
    <div class="content">
        <div class="container">
            <h1>Добро пожаловать, <%= request.getUserPrincipal().getName() %>!</h1>
            <p>Вы успешно авторизованы на странице профиля.</p>

            <!-- Кнопки для перехода на другие страницы -->
            <a href="${pageContext.request.contextPath}/games" class="button">Каталог игр</a>
            <a href="${pageContext.request.contextPath}/cart" class="button">Корзина</a>
            <a href="${pageContext.request.contextPath}/profile/orders" class="button">Заказы</a>
            <!-- Форма для выхода из системы -->
            <form action="${pageContext.request.contextPath}/logout" method="POST">
                <button type="submit" class="button">Выйти</button>
            </form>
        </div>
    </div>
</body>
</html>