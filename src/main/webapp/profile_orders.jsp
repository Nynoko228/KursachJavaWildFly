<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Заказы пользователя</title>
    <jsp:include page="header.jsp" />
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

        }
        .tab-content.current {
            display: block;
        }
        .main-content {
            margin-top: 20px;
            padding-left: 20px;
            padding-right: 20px;
        }
        .modal {
            display: none; /* Скрываем модальное окно по умолчанию */
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.4);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 10% auto;
            border: 1px solid #888;
            width: 30%;
            border-radius: 8px; /* Закругленные края */
            position: relative;
            text-align: center; /* Центрирование текста */
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
        .modal-button {
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
        .modal-button:hover {
            background-color: #0056b3;
        }
        .modal-message {
            margin-bottom: 20px;
        }
        .orders-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .order-wrapper {
            transition: all 0.3s ease;
        }

        .filter-section {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin: 20px 0;
            width: 70vw;
            margin-left: auto;
            margin-right: auto;
            align-items: center;
        }

        .filter-select {
            padding: 8px 12px;
            border-radius: 4px;
            border: 1px solid #ddd;
            height: 40px;
        }
        .order-wrapper {
            display: block; /* Важно! */
            transition: opacity 0.3s ease;
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
    </style>
</head>
<body>

    <div class="main-content">
        <ul class="tabs">
            <li class="tab-link current" data-tab="#tab-1">Мои заказы</li>
            <c:if test="${userRole eq 'employee' or userRole eq 'director'}">
                <li class="tab-link" data-tab="#tab-2">Остальные заказы</li>
            </c:if>
        </ul>

        <!-- Вкладка "Мои заказы" -->
        <div id="tab-1" class="tab-content current">
            <div class="filter-section">
                <input
                    type="text"
                    class="search-input"
                    placeholder="Поиск по названию..."
                    onkeyup="filterGames()"
                    id="searchInput"
                >
                <select id="statusFilter" class="filter-select">
                    <option value="">Все статусы</option>
                    <c:forEach var="status" items="${allStatuses}">
                        <option value="${status.name()}">${status.status}</option>
                    </c:forEach>
                </select>
            </div>
            <c:if test="${not empty userOrders}">
                <div class="orders-container">
                    <c:forEach var="order" items="${userOrders}">
                        <div class="order-wrapper" data-status="${order.status.name()}">
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
                        </div>
                    </c:forEach>
                </div>
            </c:if>
            <c:if test="${empty userOrders}">
                <p>У вас нет заказов.</p>
            </c:if>
        </div>

        <!-- Вкладка "Остальные заказы" -->
        <c:if test="${userRole eq 'employee' or userRole eq 'director'}">
            <div id="tab-2" class="tab-content">
                <div class="filter-section">
                    <input
                        type="text"
                        class="search-input"
                        placeholder="Поиск по названию..."
                        onkeyup="filterGames()"
                        id="searchInput"
                    >
                    <select id="otherStatusFilter" class="filter-select">
                        <option value="">Все статусы</option>
                        <c:forEach var="status" items="${allStatuses}">
                            <option value="${status.name()}">${status.status}</option>
                        </c:forEach>
                    </select>
                </div>
                <c:if test="${not empty otherOrders}">
                    <div class="orders-container">
                        <c:forEach var="order" items="${otherOrders}">
                            <div class="order-wrapper" data-status="${order.status.name()}">
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
                                        <!-- Кнопка "Отдать заказ" -->
                                        <c:if test="${order.status eq 'READY_FOR_PICKUP'}">
                                            <tr>
                                                <td colspan="7" align="center">
                                                    <button class="deliver-order-button" data-order-id="${order.order_id}" onclick="showModal('${order.order_id}')">Отдать заказ</button>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
                <c:if test="${empty otherOrders}">
                    <p>Нет заказов других пользователей.</p>
                </c:if>
            </div>
        </c:if>

        <!-- Модальное окно -->
        <div id="modal" class="modal" style="display: none;">
            <div class="modal-content">
                <span class="close" onclick="closeModal()">&times;</span>
                <h3>Отдать заказ</h3>
                <!-- Форма для отправки данных на сервер -->
                <form id="deliveryForm" action="${pageContext.request.contextPath}/deliverOrder" method="get">
                    <label for="orderCode">Введите код заказа:</label><br>
                    <input type="text" id="orderCode" name="code" placeholder="Введите код" required>
                    <!-- Скрытое поле для передачи ID заказа -->
                    <input type="hidden" id="hiddenOrderId" name="orderId">
                    <br><br>
                    <button class="modal-button" type="submit">Ввод</button>
                    <button class="modal-button" type="button" onclick="closeModal()">Назад</button>
                </form>
            </div>
        </div>

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
            // Функция для открытия модального окна
            function showModal(orderId) {
                document.getElementById('modal').style.display = 'flex';
                document.getElementById('hiddenOrderId').value = orderId;
            }

            // Функция для закрытия модального окна
            function closeModal() {
                document.getElementById('modal').style.display = 'none';
            }
        </script>
    </div>
<script>
document.addEventListener("DOMContentLoaded", function () {
    // Функция фильтрации заказов по статусу и номеру
    function filterOrders(containerSelector, status, searchQuery) {
        const orders = document.querySelectorAll(`${containerSelector} .order-wrapper`);
        orders.forEach(order => {
            const orderStatus = order.dataset.status; // Получаем статус из data-status
            const headerText = order.querySelector('.order-table thead tr th').textContent; // Текст заголовка таблицы
            const orderIdMatch = headerText.match(/Заказ\s(\d+)\sот/); // Извлекаем только номер заказа
            const orderId = orderIdMatch ? orderIdMatch[1] : ""; // Берем номер заказа, если найден
            const matchesStatus = !status || orderStatus === status; // Проверка фильтра по статусу
            const matchesSearch = !searchQuery || orderId.includes(searchQuery); // Проверка фильтра по номеру заказа
            const shouldShow = matchesStatus && matchesSearch; // Условие отображения
            order.style.display = shouldShow ? 'block' : 'none'; // Показываем или скрываем заказ
        });
    }

    // Обработчики для фильтров по статусу
    document.querySelectorAll('.filter-select').forEach(select => {
        select.addEventListener('change', function () {
            const tabContent = this.closest('.tab-content'); // Находим текущую вкладку
            const containerSelector = `#${tabContent.id} .orders-container`; // Контейнер заказов в текущей вкладке
            const selectedStatus = this.value; // Выбранный статус
            const searchQuery = tabContent.querySelector('.search-input')?.value.trim(); // Строка поиска
            filterOrders(containerSelector, selectedStatus, searchQuery); // Фильтруем
        });
    });

    // Обработчики для поиска по номеру заказа
    document.querySelectorAll('.search-input').forEach(input => {
        input.addEventListener('keyup', function () {
            const tabContent = this.closest('.tab-content'); // Текущая вкладка
            const containerSelector = `#${tabContent.id} .orders-container`; // Контейнер заказов
            const searchQuery = this.value.trim(); // Строка поиска
            const selectedStatus = tabContent.querySelector('.filter-select')?.value; // Выбранный статус
            filterOrders(containerSelector, selectedStatus, searchQuery); // Фильтруем
        });
    });

    // Инициализация фильтров при загрузке страницы
    document.querySelectorAll('.filter-select, .search-input').forEach(element => {
        element.dispatchEvent(new Event('change'));
    });
});
</script>


</body>
</html>