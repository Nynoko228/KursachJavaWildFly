public enum OrderStatus {
    IN_PROGRESS("В обработке"),
    READY_FOR_PICKUP("Готов к выдаче"),
    DELIVERED("Выдан"),
    CANCELLED("Отменён");

    private final String status;

    OrderStatus(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }
}