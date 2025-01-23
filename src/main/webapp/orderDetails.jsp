<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Заказ #${order.order_id}</title>
    <jsp:include page="header.jsp"/>
    <style>
        .order-details {
            max-width: 800px;
            margin: 100px auto 20px;
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
    </style>
</head>
<body>
    <div class="order-details">
        <div class="order-info">
            <h1>Заказ #${order.order_id}</h1>
            <p><strong>Дата:</strong>
                <fmt:formatDate value="${order.order_date}" pattern="dd.MM.yyyy HH:mm"/>
            </p>
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

        <a href="${pageContext.request.contextPath}/profile/bonuses" class="back-link">
            ← Назад к списку премий
        </a>
    </div>
</body>
</html>