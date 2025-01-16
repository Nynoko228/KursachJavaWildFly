<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    /* Заголовок */
    .header {
        position: fixed; /* Фиксация заголовка сверху */
        top: 0;
        left: 0;
        width: 100%; /* Заголовок занимает всю ширину экрана */
        height: 5%; /* Высота заголовка: 10% от высоты окна */
        z-index: 1000; /* Отображается поверх остального содержимого */
        display: flex; /* Для выравнивания содержимого */
        align-items: center; /* Центрируем элементы по вертикали */
    }

    /* Основное содержимое */
    .main-content {
        margin-top: 5%; /* Отступ сверху равен высоте заголовка */
        padding: 20px; /* Внутренние отступы для контента */
    }
</style>
<div class="header">
    <a href="${pageContext.request.contextPath}/profile" class="header-link">Профиль</a>
    <a href="${pageContext.request.contextPath}/cart" class="header-link">Корзина</a>
    <a href="${pageContext.request.contextPath}/games" class="header-link">Каталог</a>
</div>