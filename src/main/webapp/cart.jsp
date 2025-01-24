<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
        .cart-actions {
                display: flex;
                justify-content: center;
                margin-top: 1%;
        }
        .order-message {
            color: green;
            margin-top: 20px;
            text-align: center;
        }
        .error-message {
            color: red;
            margin-top: 20px;
            text-align: center;
        }
        .main-content h1 {
            text-align: center;
            margin: 20px 0;
        }

    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    <jsp:include page="modal.jsp" />
    <div class="main-content">
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
                        <th>Действия</th>
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
                            <td class="cart-item-actions">
                                <form action="${pageContext.request.contextPath}/cart" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="gameId" value="${game.id}">
                                    <button type="submit" class="button">Удалить</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <tr>
                        <td colspan="6" align="right"><strong>Общая стоимость:</strong></td>
                        <td><strong><c:out value="${totalCost}" /></strong></td>
                        <td class="cart-item-actions">
                            <form action="${pageContext.request.contextPath}/cart" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="clear">
                                <button type="submit" class="button">Очистить корзину</button>
                            </form>
                        </td>
                    </tr>
                </tbody>
            </table>
            <div class="cart-actions">
                <a href="${pageContext.request.contextPath}/games" class="button">Продолжить покупки</a>
                <form action="${pageContext.request.contextPath}/cart/order" method="post" style="display:inline;">
                    <button type="submit" class="button">Оформить заказ</button>
                </form>
            </div>
            <c:if test="${not empty orderMessage}">
                <script>
                    window.onload = function() {
                        openModal('${orderMessage}');
                    };
                </script>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <script>
                    window.onload = function() {
                        openModal('${errorMessage}');
                    };
                </script>
            </c:if>
        </c:if>
        <c:if test="${empty cartItems}">
            <h1>Корзина пуста.</h1>
            <div class="cart-actions">
                <a href="${pageContext.request.contextPath}/games" class="button">Продолжить покупки</a>
            </div>
        </c:if>
    </div>
    <c:if test="${not empty cartSuccessful}">
        <script>
            window.onload = function() {
                openModal('${cartSuccessful}');
            };
        </script>
        <!-- Удаляем атрибут после использования -->
        <c:remove var="cartSuccessful" scope="session"/>
    </c:if>
</body>
</html>