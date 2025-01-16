<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Заказы пользователя</title>
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
        .error-message {
            color: red;
            margin-top: 20px;
            text-align: center;
        }
        .order-table {
            margin-top: 20px;
        }
        .order-header {
            margin-bottom: 20px;
        }

        .tabs {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            border-bottom: 1px solid #ccc;
        }
        .tab-link {
            padding: 10px 20px;
            cursor: pointer;
            background-color: #f1f1f1;
            border: 1px solid #ccc;
            border-bottom: none;
        }
        .tab-link.current {
            background-color: white;
            border-top: 2px solid #007BFF;
        }
        .tab-content {
            display: none;
            padding: 20px;
            border: 1px solid #ccc;
            border-top: none;
        }
        .tab-content.current {
            display: block;
        }
    </style>
</head>
<body>
<jsp:include page="header.jsp" />
<div class="main-content">
    <ul class="tabs">
        <li class="tab-link current" data-tab="#tab-1">Мои заказы</li>
        <c:if test="${userRole eq 'employee' or userRole eq 'director'}">
            <li class="tab-link" data-tab="#tab-2">Остальные заказы</li>
        </c:if>
    </ul>

    <!-- Вкладка "Мои заказы" -->
    <div id="tab-1" class="tab-content current">
        <c:if test="${not empty userOrders}">
            <c:forEach var="order" items="${userOrders}">
                <!-- Отображение заказов текущего пользователя -->
                <table class="order-table">
                    <thead>
                        <tr>
                            <th colspan="7">Заказ <c:out value="${order.order_id}" /> от <c:out value="${order.order_date}" /></th>
                        </tr>
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
                        <!-- Переменная для общей стоимости заказа -->
                        <c:set var="totalCost" value="0" />
                        <c:forEach var="orderItem" items="${order.orderItems}">
                            <c:set var="game" value="${orderItem.game}" />
                            <c:set var="quantity" value="${orderItem.quantity}" />
                            <c:set var="itemCost" value="${orderItem.price * quantity}" />
                            <c:set var="totalCost" value="${totalCost + itemCost}" />
                            <tr>
                                <td><c:out value="${game.name}" /></td>
                                <td><c:out value="${game.genre}" /></td>
                                <td><c:out value="${game.developer}" /></td>
                                <td><c:out value="${game.release_date}" /></td>
                                <td><c:out value="${orderItem.price}" /></td>
                                <td><c:out value="${quantity}" /></td>
                                <td><c:out value="${itemCost}" /></td>
                            </tr>
                        </c:forEach>
                        <!-- Отображение общей стоимости заказа после всех товаров -->
                        <tr>
                            <td colspan="6" align="right"><strong>Общая стоимость:</strong></td>
                            <td><strong><c:out value="${totalCost}" /></strong></td>
                        </tr>
                        <!-- Код для получения заказа -->
                        <tr>
                            <td colspan="7" align="right"><strong>Код для получения заказа:</strong> <c:out value="${decryptedOrderCodes[order.order_id]}" /></td>
                        </tr>
                        <!-- Отображение статуса заказа -->
                        <tr>
                            <td colspan="7" align="right"><strong>Статус заказа:</strong> <c:out value="${order.status.status}" /></td>
                        </tr>
                        <!-- Форма для изменения статуса заказа -->
                        <c:if test="${not empty availableStatuses}">
                            <form action="${pageContext.request.contextPath}/updateOrderStatus" method="GET">
                                <input type="hidden" name="orderId" value="${order.order_id}" />
                                <td colspan="7" align="right">
                                    <select name="newStatus">
                                        <c:forEach var="status" items="${availableStatuses}">
                                            <option value="${status}">${status.status}</option>
                                        </c:forEach>
                                    </select>
                                    <button type="submit">Обновить статус</button>
                                </td>
                            </form>
                        </c:if>
                    </tbody>
                </table>
            </c:forEach>
        </c:if>
        <c:if test="${empty userOrders}">
            <p>У вас нет заказов.</p>
        </c:if>
    </div>

    <!-- Вкладка "Остальные заказы" -->
    <c:if test="${userRole eq 'employee' or userRole eq 'director'}">
        <div id="tab-2" class="tab-content">
            <c:if test="${not empty otherOrders}">
                <c:forEach var="order" items="${otherOrders}">
                    <!-- Отображение заказов других пользователей -->
                    <table class="order-table">
                        <thead>
                            <tr>
                                <th colspan="7">Заказ <c:out value="${order.order_id}" /> от <c:out value="${order.order_date}" /></th>
                            </tr>
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
                            <!-- Переменная для общей стоимости заказа -->
                            <c:set var="totalCost" value="0" />
                            <c:forEach var="orderItem" items="${order.orderItems}">
                                <c:set var="game" value="${orderItem.game}" />
                                <c:set var="quantity" value="${orderItem.quantity}" />
                                <c:set var="itemCost" value="${orderItem.price * quantity}" />
                                <c:set var="totalCost" value="${totalCost + itemCost}" />
                                <tr>
                                    <td><c:out value="${game.name}" /></td>
                                    <td><c:out value="${game.genre}" /></td>
                                    <td><c:out value="${game.developer}" /></td>
                                    <td><c:out value="${game.release_date}" /></td>
                                    <td><c:out value="${orderItem.price}" /></td>
                                    <td><c:out value="${quantity}" /></td>
                                    <td><c:out value="${itemCost}" /></td>
                                </tr>
                            </c:forEach>
                            <!-- Отображение общей стоимости заказа после всех товаров -->
                            <tr>
                                <td colspan="6" align="right"><strong>Общая стоимость:</strong></td>
                                <td><strong><c:out value="${totalCost}" /></strong></td>
                            </tr>
                            <!-- Отображение статуса заказа -->
                            <tr>
                                <td colspan="7" align="right"><strong>Статус заказа:</strong> <c:out value="${order.status.status}" /></td>
                            </tr>
                            <!-- Форма для изменения статуса заказа -->
                            <c:if test="${not empty availableStatuses}">
                                <form action="${pageContext.request.contextPath}/updateOrderStatus" method="GET">
                                    <input type="hidden" name="orderId" value="${order.order_id}" />
                                    <td colspan="7" align="right">
                                        <select name="newStatus">
                                            <c:forEach var="status" items="${availableStatuses}">
                                                <option value="${status}">${status.status}</option>
                                            </c:forEach>
                                        </select>
                                        <button type="submit">Обновить статус</button>
                                    </td>
                                </form>
                            </c:if>
                        </tbody>
                    </table>
                </c:forEach>
            </c:if>
            <c:if test="${empty otherOrders}">
                <p>Нет заказов других пользователей.</p>
            </c:if>
        </div>
    </c:if>

    <!-- JavaScript для переключения вкладок -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var tabLinks = document.querySelectorAll(".tab-link");
            var tabContents = document.querySelectorAll(".tab-content");

            tabLinks.forEach(function (tabLink) {
                tabLink.addEventListener("click", function (event) {
                    event.preventDefault();

                    // Удаляем класс "current" у всех вкладок и содержимого
                    tabLinks.forEach(function (link) {
                        link.classList.remove("current");
                    });

                    tabContents.forEach(function (content) {
                        content.classList.remove("current");
                    });

                    // Добавляем класс "current" для активной вкладки и её содержимого
                    this.classList.add("current");
                    document.querySelector(this.getAttribute("data-tab")).classList.add("current");
                });
            });
        });
    </script>
</div>
</body>
</html>