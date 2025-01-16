<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Вход в систему</title>
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
        form {
            display: flex;
            flex-direction: column;
            padding: 20px;
            border: 1px solid #ccc;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            background-color: #fff;
        }
        input {
            margin: 10px 0;
            padding: 10px;
            font-size: 16px;
        }
        button {
            padding: 10px;
            font-size: 16px;
            cursor: pointer;
            background-color: #007bff;
            border: 1px solid transparent;
            border-radius: 15px;
            color: white;
        }
        button:hover {
            background-color: #0056b3;
        }
        .button-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
            gap: 3%;
        }
    </style>
</head>
<body>
    <h1>Некорректные данные</h1>
        <div class="button-container">
        <button type="button" onclick="goBack()">Назад</button>
        </div>

</body>
<script>
    function goBack() {
        window.location.href = '${pageContext.request.contextPath}/base';
    }
</script>
</html>