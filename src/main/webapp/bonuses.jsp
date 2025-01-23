<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
            background-color: #f4f4f9;
        }
        .main-content {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
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
            text-align: left;
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
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    <div class="main-content">
        <h1>Премии сотрудников</h1>
        <c:if test="${not empty bonuses}">
            <table>
                <thead>
                    <tr>
                        <th>ID премии</th>
                        <th>Сотрудник</th>
                        <th>Заказ</th>
                        <th>Сумма премии</th>
                        <th>Дата премии</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="bonus" items="${bonuses}">
                        <tr>
                            <td><c:out value="${bonus.bonus_id}" /></td>
                            <td><c:out value="${bonus.employee.user_name}" /></td>
                            <td><c:out value="${bonus.order.order_id}" /></td>
                            <td><c:out value="${bonus.amount}" /></td>
                            <td><c:out value="${bonus.bonus_date}" /></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
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
</body>
</html>