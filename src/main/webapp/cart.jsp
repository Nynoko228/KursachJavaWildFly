<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Корзина</title>
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
            padding-left: 20px;
            padding-right: 20px;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            font-family: Arial, sans-serif;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
            cursor: pointer;
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
            margin: 4px 2px;
            cursor: pointer;
            border-radius: 4px;
        }
        .button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    <div class="content">
        <h1>Корзина</h1>
        <c:if test="${not empty cartItems}">
            <table>
                <thead>
                    <tr>
                        <th>Название</th>
                        <th>Жанр</th>
                        <th>Разработчик</th>
                        <th>Дата релиза</th>
                        <th>Цена</th>
                        <th>Количество</th>
                        <th>Стоимость</th>
                    </tr>
                </thead>
                <tbody>
                    <c:set var="totalCost" value="0" />
                    <c:forEach var="entry" items="${cartItems}">
                        <c:set var="game" value="${entry.key}" />
                        <c:set var="quantity" value="${entry.value}" />
                        <c:set var="itemCost" value="${game.cost * quantity}" />
                        <c:set var="totalCost" value="${totalCost + itemCost}" />
                        <tr>
                            <td><c:out value="${game.name}" /></td>
                            <td><c:out value="${game.genre}" /></td>
                            <td><c:out value="${game.developer}" /></td>
                            <td><c:out value="${game.release_date}" /></td>
                            <td><c:out value="${game.cost}" /></td>
                            <td><c:out value="${quantity}" /></td>
                            <td><c:out value="${itemCost}" /></td>
                        </tr>
                    </c:forEach>
                    <tr>
                        <td colspan="6" align="right"><strong>Общая стоимость:</strong></td>
                        <td><strong><c:out value="${totalCost}" /></strong></td>
                    </tr>
                </tbody>
            </table>
        </c:if>
        <c:if test="${empty cartItems}">
            <p>Корзина пуста.</p>
        </c:if>
        <a href="${pageContext.request.contextPath}/games" class="button">Продолжить покупки</a>
    </div>
</body>
</html>