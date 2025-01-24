<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Всплывающее окно</title>
    <style>
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
            padding: 20px;
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
        .form-group {
            margin-bottom: 20px; /* Увеличиваем расстояние между полями */
        }
    </style>
</head>
<body>
    <div id="addGameModal" class="modal" style="display: none;">
        <div class="modal-content">
            <span class="close" onclick="closeAddGameModal()">&times;</span>
            <h2>Добавить новую игру</h2>
            <form action="${pageContext.request.contextPath}/addGame" method="POST">
                <div class="form-group">
                    <label>Название:</label>
                    <input type="text" name="name" required class="form-input">
                </div>
                <div class="form-group">
                    <label>Дата релиза:</label>
                    <input type="date" name="releaseDate" required class="form-input">
                </div>
                <div class="form-group">
                    <label>Разработчик:</label>
                    <input type="text" name="developer" required class="form-input">
                </div>
                <div class="form-group">
                    <label>Жанр:</label>
                    <input type="text" name="genre" required class="form-input">
                </div>
                <div class="form-group">
                    <label>Цена:</label>
                    <input type="number" step="0.01" name="cost" required class="form-input">
                </div>
                <div class="modal-buttons">
                    <button type="submit" class="button">Добавить</button>
                    <button type="button" class="button cancel" onclick="closeAddGameModal()">Отмена</button>
                </div>
            </form>
        </div>
    </div>
    <jsp:include page="modal.jsp" />
    <script>
        function openAddGameModal() {
            document.getElementById('addGameModal').style.display = 'block';
        }

        function closeAddGameModal() {
            document.getElementById('addGameModal').style.display = 'none';
        }

        // Закрытие модалки при клике вне области
        window.onclick = function(event) {
            const modal = document.getElementById('addGameModal');
            if (event.target === modal) {
                closeAddGameModal();
            }
        }
    </script>

<c:if test="${not empty successAddGame}">
    <script>
        window.addEventListener('load', function() {
            // Открываем модалку с успешным сообщением
            openModal('${successAddGame}'); // true указывает на успех
        });
    </script>

    <!-- Удаляем атрибут после использования -->
    <c:remove var="successAddGame" scope="session"/>
</c:if>

</body>
</html>