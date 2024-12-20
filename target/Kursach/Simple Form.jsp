<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Авторизация</title>
    <style>
        body {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            font-family: Arial, sans-serif;
        }
        form, .table-container {
            margin-bottom: 20px;
        }
        .table-container {
            max-height: 200px; /* 5 строк при высоте строки ~40px */
            overflow-y: auto;
            width: 80%;
            border: 1px solid #ccc;
        }
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
        button {
            padding: 10px 20px;
            font-size: 16px;
            margin: 5px;
            cursor: pointer;
            border-radius: 15px;
        }
        .button-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgb(0,0,0);
            background-color: rgba(0,0,0,0.4);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            max-width: 30%;
            border-radius: 30px;
            width: fit-content;
        }
        .modal-content  label, select, button {
          font-size: 18px; /* Установите желаемый размер шрифта, например 18px */
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }
        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
        .container {
          display: flex;
          justify-content: center; /* Выравнивание по горизонтали */
          align-items: center;    /* Выравнивание по вертикали (опционально, если нужно по центру экрана) */
        }
    </style>
</head>
<body>
<h1>Добро пожаловать</h1>
<form action="base" method="post">
    <div class="button-container">
        <button type="button" onclick="openModal('registration')">Зарегистрироваться</button>
        <!--<button type="button" onclick="document.getElementById('authorization').style.display='block'">Авторизоваться</button>-->
        <button type="submit" name="submitAction" value="auth">Авторизоваться</button>
    </div>
</form>

<!-- Всплывающее окно для добавления -->
<div id="registration" class="modal">
    <!-- Check for errors and show an alert if there is one -->
    <% String message = (String) request.getSession().getAttribute("resultMessage");
    if (message != null && !message.isEmpty()) { %>
        <script>
            alert("<%= message %>");
        </script>
    <% request.getSession().removeAttribute("resultMessage"); // Удаляем сообщение из сессии после его использования
    } %>
    <div class="modal-content">
        <span class="close" onclick="closeModal('registration')">&times;</span>
        <h2 style="text-align: center;">Зарегистрироваться</h2>
          <div class="container">
            <form action="base" method="post">
              <label for="modalName">Имя:</label>
              <input type="text" id="modalName" name="name" required><br><br>
              <label for="modaPswd">Пароль:</label>
              <input type="password" id="modaPswd" name="pswd" required><br><br>
              <label for="role">Роль:</label>
              <select id="role" name="role" required>
                <option value="employee">Employee</option>
                <option value="customer">Customer</option>
                <option value="director">Director</option>
              </select><br><br>
              <div class="button-container">
                <button type="submit" name="submitAction" value="reg">Зарегистрироваться</button>
              </div>
            </form>
          </div>
    </div>
</div>

<script>
    let activeModalId = null;

    // Функция для открытия модального окна
    function openModal(modalId) {
        var modal = document.getElementById(modalId);
        modal.style.display = "block";
        activeModalId = modalId;
    }

    // Функция для закрытия модального окна
    function closeModal(modalId) {
        var modal = document.getElementById(modalId);
        modal.style.display = "none";
    }
    // Функция для обработки нажатия клавиши ESC
    function handleEsc(event) {
        if (event.key === 'Escape' || event.keyCode === 27) {
            if(activeModalId) {
                closeModal(activeModalId);
            }
        }
    }

    // Добавляем слушатель события keydown на document
    document.addEventListener('keydown', handleEsc);
</script>

</body>
</html>

