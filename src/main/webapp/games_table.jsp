<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        .filter-section {
            margin-bottom: 20px;
        }

        .filter-select {
            width: 100%;
            padding: 8px;
            border-radius: 4px;
            border: 1px solid #ddd;
            margin-top: 5px;
        }

        .range-container {
            position: relative;
            height: 30px;
        }

        .range-slider {
            width: 100%;
            position: absolute;
            pointer-events: none;
        }

        .range-slider::-webkit-slider-thumb {
            pointer-events: all;
        }

        .range-labels {
            display: flex;
            justify-content: space-between;
            margin: 5px 0;
        }

        .filter-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .apply-button, .reset-button {
            flex: 1;
            padding: 10px;
            border-radius: 4px;
            cursor: pointer;
            border: none;
        }

        .apply-button {
            background: #28a745;
            color: white;
        }

        .reset-button {
            background: #dc3545;
            color: white;
        }
        .range-inputs {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
        }

        .range-input {
            width: 100px;
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
            text-align: center;
        }

        .range-input:focus {
            outline: none;
            border-color: #007bff;
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
                                    <button class="buy-button" onclick="addToCart(${game.id})">В корзину</button>
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
            <h2>Фильтры</h2>
            <div class="filter-section">
                <label>Жанр:</label>
                <select class="filter-select" id="genreFilter">
                    <option value="">Все</option>
                    <c:forEach items="${genres}" var="genre">
                        <option value="${genre}">${genre}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="filter-section">
                <label>Разработчик:</label>
                <select class="filter-select" id="developerFilter">
                    <option value="">Все</option>
                    <c:forEach items="${developers}" var="dev">
                        <option value="${dev}">${dev}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="filter-section">
                <label>Год выпуска:</label>
                <div class="range-inputs">
                    <input type="number" id="yearMinInput" min="${minYear}" max="${maxYear}"
                           value="${minYear}" class="range-input">
                    <span>-</span>
                    <input type="number" id="yearMaxInput" min="${minYear}" max="${maxYear}"
                           value="${maxYear}" class="range-input">
                </div>
                <div class="range-container">
                    <input type="range" id="yearMin" min="${minYear}" max="${maxYear}"
                           value="${minYear}" class="range-slider">
                    <input type="range" id="yearMax" min="${minYear}" max="${maxYear}"
                           value="${maxYear}" class="range-slider">
                </div>
            </div>

            <div class="filter-section">
                <label>Цена:</label>
                <div class="range-inputs">
                    <input type="number" step="0.01" id="priceMinInput" min="${minPrice}"
                           max="${maxPrice}" value="${minPrice}" class="range-input">
                    <span>-</span>
                    <input type="number" step="0.01" id="priceMaxInput" min="${minPrice}"
                           max="${maxPrice}" value="${maxPrice}" class="range-input">
                </div>
                <div class="range-container">
                    <input type="range" id="priceMin" min="${minPrice}" max="${maxPrice}"
                           value="${minPrice}" step="0.01" class="range-slider">
                    <input type="range" id="priceMax" min="${minPrice}" max="${maxPrice}"
                           value="${maxPrice}" step="0.01" class="range-slider">
                </div>
            </div>

            <div class="filter-buttons">
                <button class="apply-button" onclick="applyFilters()">Применить</button>
                <button class="reset-button" onclick="resetFilters()">Сбросить</button>
            </div>
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
            // Фильтры
            function applyFilters() {
                const genre = document.getElementById('genreFilter').value;
                const developer = document.getElementById('developerFilter').value;
                const yearMin = parseInt(document.getElementById('yearMin').value);
                const yearMax = parseInt(document.getElementById('yearMax').value);
                const priceMin = parseFloat(document.getElementById('priceMin').value);
                const priceMax = parseFloat(document.getElementById('priceMax').value);

                const rows = document.querySelectorAll('#gamesTableBody tr');

                rows.forEach(row => {
                    const gameYear = new Date(row.cells[3].textContent).getFullYear();
                    const gamePrice = parseFloat(row.cells[4].textContent);

                    const matchGenre = !genre || row.cells[1].textContent === genre;
                    const matchDeveloper = !developer || row.cells[2].textContent === developer;
                    const matchYear = gameYear >= yearMin && gameYear <= yearMax;
                    const matchPrice = gamePrice >= priceMin && gamePrice <= priceMax;

                    row.style.display = (matchGenre && matchDeveloper && matchYear && matchPrice) ? '' : 'none';
                });
            }

            // Сброс фильтров
            function resetFilters() {
                document.getElementById('genreFilter').value = '';
                document.getElementById('developerFilter').value = '';
                document.getElementById('yearMin').value = ${minYear};
                document.getElementById('yearMax').value = ${maxYear};
                document.getElementById('priceMin').value = ${minPrice};
                document.getElementById('priceMax').value = ${maxPrice};
                updateRangeLabels();
                applyFilters();
            }

            // Обновление значений диапазонов
            function updateRangeLabels() {
                // Для года
                const yearMin = document.getElementById('yearMin').value;
                const yearMax = document.getElementById('yearMax').value;
                document.getElementById('yearMinInput').value = yearMin;
                document.getElementById('yearMaxInput').value = yearMax;
                document.getElementById('minYearValue').textContent = yearMin;
                document.getElementById('maxYearValue').textContent = yearMax;

                // Для цены
                const priceMin = parseFloat(document.getElementById('priceMin').value).toFixed(2);
                const priceMax = parseFloat(document.getElementById('priceMax').value).toFixed(2);

                // Обновляем текстовые поля
                document.getElementById('priceMinInput').value = priceMin;
                document.getElementById('priceMaxInput').value = priceMax;

                // Обновляем отображаемые значения в сайдбаре
                document.getElementById('minPriceValue').textContent = priceMin;
                document.getElementById('maxPriceValue').textContent = priceMax;
            }

            function validateNumberInput(input, min, max, isMin, pairedInput, slider) {
                let value = parseFloat(input.value);

                // Если не число, устанавливаем минимальное/максимальное значение
                if (isNaN(value)) {
                    value = isMin ? min : max;
                }

                // Ограничение значений
                value = Math.min(Math.max(value, min), max);

                // Синхронизация с парным полем
                if (isMin && value > parseFloat(pairedInput.value)) {
                    pairedInput.value = value;
                    pairedInput.dispatchEvent(new Event('change'));
                } else if (!isMin && value < parseFloat(pairedInput.value)) {
                    pairedInput.value = value;
                    pairedInput.dispatchEvent(new Event('change'));
                }

                // Обновление значения
                input.value = isMin ? Math.floor(value) : Math.ceil(value);
                slider.value = value;
            }

            // Специфичные валидации
            function validateYear(input, isMin) {
                const minYear = ${minYear};
                const maxYear = ${maxYear};
                const pairedInput = isMin ? document.getElementById('yearMaxInput') : document.getElementById('yearMinInput');
                const slider = isMin ? document.getElementById('yearMin') : document.getElementById('yearMax');
                validateNumberInput(input, minYear, maxYear, isMin, pairedInput, slider);
            }

            function validatePrice(input, isMin) {
                const minPrice = ${minPrice};
                const maxPrice = ${maxPrice};
                const pairedInput = isMin ? document.getElementById('priceMaxInput') : document.getElementById('priceMinInput');
                const slider = isMin ? document.getElementById('priceMin') : document.getElementById('priceMax');
                const value = parseFloat(input.value);

                if (!isNaN(value)) {
                    input.value = value.toFixed(2);
                    slider.value = value;
                }
                validateNumberInput(input, minPrice, maxPrice, isMin, pairedInput, slider);
            }

            // Обработчики для полей года
            document.getElementById('yearMinInput').addEventListener('change', function() {
                validateYear(this, true);
                updateRangeLabels();
                applyFilters();
            });

            document.getElementById('yearMaxInput').addEventListener('change', function() {
                validateYear(this, false);
                updateRangeLabels();
                applyFilters();
            });

            // Обработчики для полей цены
            document.getElementById('priceMinInput').addEventListener('change', function() {
                validatePrice(this, true);
                updateRangeLabels();
                applyFilters();
            });

            document.getElementById('priceMaxInput').addEventListener('change', function() {
                validatePrice(this, false);
                updateRangeLabels();
                applyFilters();
            });

            // Обработчики для ползунков
            document.querySelectorAll('.range-slider').forEach(slider => {
                slider.addEventListener('input', function() {
                    const isYear = this.id.includes('year');
                    const isMin = this.id.includes('Min');

                    if (isYear) {
                        const input = isMin ? document.getElementById('yearMinInput') : document.getElementById('yearMaxInput');
                        input.value = this.value;
                        validateYear(input, isMin);
                    } else {
                        const input = isMin ? document.getElementById('priceMinInput') : document.getElementById('priceMaxInput');
                        input.value = parseFloat(this.value).toFixed(2);
                        validatePrice(input, isMin);
                    }

                    updateRangeLabels();
                    applyFilters();
                });
            });

            // Запрет ввода нечисловых значений
            document.querySelectorAll('.range-input').forEach(input => {
                input.addEventListener('keypress', function(e) {
                    const allowedChars = /[0-9\.]/;
                    const isPrice = this.id.includes('price');

                    if (isPrice && this.value.includes('.') && e.key === '.') {
                        e.preventDefault();
                    }

                    if (!allowedChars.test(e.key) ||
                        (isPrice && this.value.split('.')[1]?.length >= 2)) {
                        e.preventDefault();
                    }
                });
            });

            // Инициализация обработчиков для селектов
            document.querySelectorAll('.filter-select').forEach(select => {
                select.addEventListener('change', applyFilters);
            });

        </script>
    </div>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script>
    function addToCart(gameId) {
        $.ajax({
            url: "${pageContext.request.contextPath}/games",
            type: "POST",
            data: { gameId: gameId },
            success: function(response) {
                // Здесь можно добавить действия после успешного добавления в корзину
                alert("Товар добавлен в корзину!");
            },
            error: function(xhr, status, error) {
                // Здесь можно добавить действия при ошибке
                alert("Произошла ошибка при добавлении товара в корзину.");
            }
        });
    }
    </script>
</body>
</html>