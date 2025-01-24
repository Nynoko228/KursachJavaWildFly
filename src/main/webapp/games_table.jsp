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
            overflow-x: hidden;
        }
        .table-container {
            margin-left: auto;
            margin-right: auto;
            margin-top: 20px;
            border-radius: 10px;
            background: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            max-height: 70vh;
            max-width: 70vw;
            overflow: auto;
            padding: 20px;
            box-sizing: border-box;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            font-family: Arial, sans-serif;
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
        .search-input {
            font-family: Arial, sans-serif;
            border: 2px solid #ddd;
            border-radius: 20px;
            padding: 10px 20px;
            width: 40%;
            margin: 0;
            box-sizing: border-box;
            display: block;
            outline: none;
            transition: all 0.3s ease;
            flex: 1; /* Занимает доступное пространство */
            max-width: 100%;
            height: 40px;
        }
        .search-input:focus {
            border-color: #007bff;
            box-shadow: 0 0 8px rgba(0,123,255,0.3);
        }
        .search-container {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin: 20px 0;
            width: 70vw;
            margin-left: auto;
            margin-right: auto;
            align-items: center;
        }
        .filter-button {
            flex-shrink: 0;
            box-sizing: border-box;
            height: 40px;
            background: #007bff;
            border: none;
            color: white;
            padding: 10px 20px;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .filter-button:hover {
            background: #0056b3;
        }
        .sidebar {
            position: fixed;
            top: 0;
            right: -300px;
            width: 300px;
            height: 100%;
            background: white;
            box-shadow: -2px 0 8px rgba(0, 0, 0, 0.1);
            transition: right 0.3s ease;
            padding: 20px;
            z-index: 1001;
            overflow-y: auto;
            box-sizing: border-box;
        }

        .sidebar.active {
            right: 0;
        }

        .sidebar-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            display: none;
        }

        .sidebar-overlay.active {
            display: block;
        }
        }
    </style>
</head>
<body>
    <div class="main-content">
        <h1>Список игр</h1>
        <div class="search-container">
            <input
                type="text"
                class="search-input"
                placeholder="Поиск по названию..."
                onkeyup="filterGames()"
                id="searchInput"
            >
            <button class="filter-button" onclick="toggleSidebar()">Фильтры</button>
        </div>
        <div class="table-container">
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
        </div>
        <div class="sidebar" id="sidebar">
            <h2>Привет</h2>
        </div>
        <div class="sidebar-overlay" id="sidebarOverlay"></div>
        <script>
            let sortDirection = 'asc';
            function sorted(index) {
                const table = document.getElementById('gamesTable');
                const tbody = document.getElementById('gamesTableBody');
                const rows = Array.from(tbody.querySelectorAll('tr'));

                rows.sort((rowA, rowB) => {
                    const aValue = parseFloat(rowA.cells[index].textContent);
                    const bValue = parseFloat(rowB.cells[index].textContent);
                    return sortDirection === 'asc' ? aValue - bValue : bValue - aValue;
                });

                tbody.innerHTML = '';
                rows.forEach(row => tbody.appendChild(row));

                sortDirection = sortDirection === 'asc' ? 'desc' : 'asc';
            }

            function filterGames() {
                const input = document.getElementById('searchInput');
                const filter = input.value.toLowerCase();
                const rows = document.querySelectorAll('#gamesTableBody tr');

                rows.forEach(row => {
                    const name = row.cells[0].textContent.toLowerCase();
                    row.style.display = name.includes(filter) ? '' : 'none';
                });
            }

            function toggleSidebar() {
                const sidebar = document.getElementById('sidebar');
                const overlay = document.querySelector('.sidebar-overlay');

                sidebar.classList.toggle('active');
                overlay.classList.toggle('active');
            }

            // Закрытие сайдбара при нажатии на область затемнения
            document.getElementById('sidebarOverlay').addEventListener('click', () => {
                const sidebar = document.getElementById('sidebar');
                const overlay = document.getElementById('sidebarOverlay');

                sidebar.classList.remove('active');
                overlay.classList.remove('active');
            })
        </script>
    </div>
</body>
</html>