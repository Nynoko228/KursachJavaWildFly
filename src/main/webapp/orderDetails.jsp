<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Заказ #${order.order_id}</title>
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
            justify-content: center; /* Выровнять начало страницы */
            align-items: center;
            align-items: flex-start;
        }
        .order-details {
            margin: 130px auto 20px;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .order-info { margin-bottom: 30px; }
        .back-link {
            display: block;
            margin-top: 20px;
            text-align: center;
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
        th, td {
            padding: 10px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }
    </style>
</head>
<body>
    <div class="order-details">
        <div class="order-info">
            <h1>Заказ #${order.order_id}</h1>
            <p><strong>Дата оформления:</strong>
                <fmt:formatDate value="${order.order_date}" pattern="dd.MM.yyyy"/>
            </p>
            <c:if test="${order.status.status eq 'Выдан'}">
                <p><strong>Дата выдачи:</strong>
                    <fmt:formatDate value="${bonusDate}" pattern="dd.MM.yyyy HH:mm"/>
                </p>
                <p><strong>Выдан работником:</strong> ${empl}</p>
            </c:if>
            <p><strong>Статус:</strong> ${order.status.status}</p>
            <p><strong>Клиент:</strong> ${order.user.user_name}</p>
        </div>

        <h2>Состав заказа:</h2>
        <table class="items-table">
            <thead>
                <tr>
                    <th>Игра</th>
                    <th>Количество</th>
                    <th>Цена за шт.</th>
                    <th>Сумма</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${order.orderItems}" var="item">
                    <tr>
                        <td>${item.game.name}</td>
                        <td>${item.quantity}</td>
                        <td><fmt:formatNumber value="${item.price}" type="currency"/></td>
                        <td><fmt:formatNumber value="${item.price * item.quantity}" type="currency"/></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="total">
            <h3>Итого:
                <fmt:formatNumber
                    value="${order.orderItems.stream().map(i -> i.price * i.quantity).sum()}"
                    type="currency"/>
            </h3>
        </div>

        <a href="${pageContext.request.contextPath}/profile/bonuses" class="button">
            ← Назад к списку премий
        </a>
    </div>
</body>
</html>