<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Список игр</title>
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
        .buy-button {
            background-color: #007bff;
            border: none;
            color: white;
            padding: 6px 12px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            margin: 4px 2px;
            cursor: pointer;
            border-radius: 4px;
        }
        .buy-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="main-content">
        <h1>Список игр</h1>
        <c:if test="${not empty games}">
            <table id="gamesTable">
                <thead>
                    <tr>
                        <th>Название</th>
                        <th>Жанр</th>
                        <th>Разработчик</th>
                        <th onclick="sorted(3)">Дата релиза</th>
                        <th onclick="sorted(4)">Цена</th>
                        <th>Действие</th>
                    </tr>
                </thead>
                <tbody id="gamesTableBody">
                    <c:forEach var="game" items="${games}">
                        <tr>
                            <td><c:out value="${game.name}" /></td>
                            <td><c:out value="${game.genre}" /></td>
                            <td><c:out value="${game.developer}" /></td>
                            <td><c:out value="${game.release_date}" /></td>
                            <td><c:out value="${game.cost}" /></td>
                            <td>
                                <form action="${pageContext.request.contextPath}/games" method="post" style="display:inline;">
                                    <input type="hidden" name="gameId" value="${game.id}">
                                    <button class="buy-button" type="submit">Купить</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
        <c:if test="${empty games}">
            <p>Нет доступных игр.</p>
        </c:if>
        <script>
            let sortDirection = 'asc'; // По умолчанию сортировка по возрастанию
            function sorted(index) {
                const table = document.getElementById('gamesTable');
                const tbody = document.getElementById('gamesTableBody');
                const rows = Array.from(tbody.querySelectorAll('tr'));

                rows.sort((rowA, rowB) => {
                    const aValue = parseFloat(rowA.cells[index].textContent);
                    const bValue = parseFloat(rowB.cells[index].textContent);
                    return sortDirection === 'asc' ? aValue - bValue : bValue - aValue;
                });
                // Clear table
                tbody.innerHTML = '';
                // Append sorted data
                rows.forEach(row => tbody.appendChild(row));

                sortDirection = sortDirection === 'asc' ? 'desc' : 'asc'; // Переключаем направление сортировки
            }
        </script>
    </div>
</body>
</html>