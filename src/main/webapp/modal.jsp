<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    </style>
</head>
<body>
    <div id="myModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <div class="modal-message">
                <p>${message}</p>
            </div>
            <button class="modal-button" onclick="closeModal()">OK</button>
        </div>
    </div>

    <script>
        function openModal(message) {
            document.getElementById('myModal').style.display = 'block';
            document.querySelector('.modal-message p').innerText = message;
        }

        function closeModal() {
            document.getElementById('myModal').style.display = 'none';
        }

        // Закрытие модального окна при клике на крестик
        document.querySelector('.close').addEventListener('click', closeModal);

        // Закрытие модального окна при клике вне его области
        window.onclick = function(event) {
            if (event.target === document.getElementById('myModal')) {
                closeModal();
            }
        }
    </script>
</body>
</html>