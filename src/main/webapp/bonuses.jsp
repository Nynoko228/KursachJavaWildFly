<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Премии сотрудников</title>
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
        .main-content {
            max-width: 80%px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center; /* Вертикальное центрирование содержимого */
        }
        h1 {
            text-align: center;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .back-button {
            display: block;
            margin-top: 20px;
            text-align: center;
        }
        .back-button a {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 4px;
        }
        .back-button a:hover {
            background-color: #0056b3;
        }
        .error-message {
            color: red;
            text-align: center;
            margin-top: 20px;
        }
        .success-message {
            color: green;
            text-align: center;
            margin-top: 20px;
        }
        .main-content {
            padding: 20px !important;
            min-width: 80vw;
            max-width: 80vw;
            display: flex;
            flex: 1;
            flex-direction: column;
            background-color: #fff;
            justify-content: center;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px; /* Добавляем закругление основному контейнеру */
        }
        .container {
            width: 100%;
            max-width: 80%; /* Фиксированная максимальная ширина */
            margin: 0 auto; /* Центрирование */
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden; /* Скрываем overflow для контейнера */
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background-color: white;
            border-radius: 8px;
            overflow: hidden; /* Для скругления углов таблицы */
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .scrollable-table {
            overflow-y: auto; /* Добавляем скролл при необходимости */
            max-height: 60vh; /* Максимальная высота таблицы */
            margin-top: 20px;
            border-radius: 8px;
            flex-grow: 1;
        }
        .main-content-wrapper {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px 0; /* Вертикальные отступы */
        }
        .clickable-row {
            cursor: pointer;
            transition: background-color 0.2s ease;
        }
        .clickable-row:hover {
            background-color: #f5f5f5;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    <div class="main-content-wrapper">
        <div class="main-content">
            <div class="container">
                <h1>Премии сотрудников</h1>
                <c:if test="${not empty bonuses}">
                    <div class="scrollable-table">
                        <table>
                            <thead>
                                <tr>
                                    <th>Сотрудник</th>
                                    <th>Номер заказа</th>
                                    <th>Величина премии</th>
                                    <th>Дата получения</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="bonus" items="${bonuses}">
                                    <tr class="clickable-row"
                                    data-href="<c:url value="/profile/orderDetails">
                                                     <c:param name="orderId" value="${bonus.order.order_id}"/>
                                                     <c:param name="bonusDate" value="${bonus.bonus_date.time}"/>
                                                     <c:param name="empl" value="${bonus.employee.user_name}"/>
                                                   </c:url>">
                                            <td><c:out value="${bonus.employee.user_name}" /></td>
                                            <td><c:out value="${bonus.order.order_id}" /></td>
                                            <td><c:out value="${bonus.amount}" /></td>
                                            <td><fmt:formatDate value="${bonus.bonus_date}" pattern="dd.MM.yyyy HH:mm" /></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
                <c:if test="${empty bonuses}">
                    <p>Премий нет.</p>
                </c:if>
                <div class="back-button">
                    <a href="${pageContext.request.contextPath}/profile/orders">Назад к заказам</a>
                </div>
                <c:if test="${not empty errorMessage}">
                    <div class="error-message">
                        <p>${errorMessage}</p>
                    </div>
                </c:if>
                <c:if test="${not empty successMessage}">
                    <div class="success-message">
                        <p>${successMessage}</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('.clickable-row').forEach(row => {
            // Обработчик клика
            row.addEventListener('click', function(e) {
                if (e.ctrlKey || e.metaKey) {
                    window.open(this.dataset.href, '_blank');
                } else {
                    window.location.href = this.dataset.href;
                }
            });
        });
    });
</script>
</body>
</html>