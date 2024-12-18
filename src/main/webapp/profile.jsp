<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Приветственная страница</title>
</head>
<body>
<% HttpServletRequest httpRequest = (HttpServletRequest) session.getAttribute("javax.servlet.http.HttpServletRequest"); %>
<% if (request.getUserPrincipal() != null) { %>
        <h1>Добро пожаловать, <%= request.getUserPrincipal().getName() %>!</h1>
        <p>Вы успешно авторизованы на странице профиля.</p>
        <!-- Форма для выхода из системы -->
        <form action="/Kursach/logout" method="POST">
            <button type="submit">Выйти</button>
        </form>
<% } else {
    response.sendRedirect("/base"); // Перенаправление на страницу авторизации
} %>
</body>
</html>
