<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Header</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <style>
        .header {
            background-color: #007bff;
            color: white;
            padding: 20px;
            text-align: center;
            position: fixed;  /* Фиксируем хедер */
            top: 0;           /* Прижимаем к верхнему краю */
            left: 0;
            right: 0;
            z-index: 1000;    /* Убедимся, что хедер поверх других элементов */
            height: 100px;
        }
        .main-content {
            padding-top: 130px;  /* Отступ = высота хедера + дополнительные пиксели */
            padding-left: 20px;
            padding-right: 20px;
        }
        .header a {
            color: white;
            margin: 0 15px;
            text-decoration: none;
        }
        .header a:hover {
            text-decoration: underline;
        }
        .header h1 a {
            text-decoration: none;
            cursor: pointer;
        }
        .header h1 a:hover {
            text-decoration: none !important;
        }
        .header__title {
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1 class="header__title">
            <a href="${pageContext.request.contextPath}/games">Магазин игр</a>
        </h1>
        <a href="${pageContext.request.contextPath}/home">Главная</a>
        <a href="${pageContext.request.contextPath}/profile">Мои профиль</a>
        <a href="${pageContext.request.contextPath}/profile/orders">Мои заказы</a>
        <a href="${pageContext.request.contextPath}/cart">Корзина</a>
    </div>
</body>
</html>