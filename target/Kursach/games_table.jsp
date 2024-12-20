<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Список игр</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
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
    </style>
</head>
<body>
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
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
    <c:if test="${empty games}">
        <p>Нет доступных игр.</p>
    </c:if>

    <script>
        let sortDirection = 'asc'; // По умолчанию сортировка по возрастанию для цены
        let sortDateDirection = 'asc'; // По умолчанию сортировка по возрастанию для даты

        function sorted(index) {
            const table = document.getElementById('gamesTable');
            const tbody = document.getElementById('gamesTableBody');
            const rows = Array.from(tbody.querySelectorAll('tr'));


            rows.sort((rowA, rowB) => {
                const aValue = parseFloat(rowA.cells[index].textContent);
                const bValue = parseFloat(rowB.cells[index].textContent);
                return sortDirection === 'asc' ? aValue - bValue : bValue - aValue;
            });

            //Clear table
            tbody.innerHTML = '';
            //append sorted data
            rows.forEach(row => tbody.appendChild(row));


            sortDirection = sortDirection === 'asc' ? 'desc' : 'asc'; // Переключаем направление сортировки
        }
    </script>
</body>
</html>