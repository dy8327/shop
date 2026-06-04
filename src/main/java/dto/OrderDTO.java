package dto;

public class OrderDTO {
    private int orderId;
    private String memId;

    private String receiverName;
    private String receiverPhone;
    private String receiverAddr;
    private String deliveryMemo;

    private String payment;

    private int totalPrice;
    private int deliveryFee;
    private int finalPrice;

    private String orderStatus;
    private String paymentStatus;
    private String tossOrderId;
    private String paymentKey;
    private int paidAmount;
    private String proName;
    private int productCount;
    private String orderDate;
    private String deliveryCompany;
    private String trackingNumber;
    private String memName;
    
    public int getOrderId() {
        return orderId;
    }
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }
    public String getMemId() {
        return memId;
    }
    public void setMemId(String memId) {
        this.memId = memId;
    }
    public String getReceiverName() {
        return receiverName;
    }
    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }
    public String getReceiverPhone() {
        return receiverPhone;
    }
    public void setReceiverPhone(String receiverPhone) {
        this.receiverPhone = receiverPhone;
    }
    public String getReceiverAddr() {
        return receiverAddr;
    }
    public void setReceiverAddr(String receiverAddr) {
        this.receiverAddr = receiverAddr;
    }
    public String getDeliveryMemo() {
        return deliveryMemo;
    }
    public void setDeliveryMemo(String deliveryMemo) {
        this.deliveryMemo = deliveryMemo;
    }
    public String getPayment() {
        return payment;
    }
    public void setPayment(String payment) {
        this.payment = payment;
    }
    public int getTotalPrice() {
        return totalPrice;
    }
    public void setTotalPrice(int totalPrice) {
        this.totalPrice = totalPrice;
    }
    public int getDeliveryFee() {
        return deliveryFee;
    }
    public void setDeliveryFee(int deliveryFee) {
        this.deliveryFee = deliveryFee;
    }
    public int getFinalPrice() {
        return finalPrice;
    }
    public void setFinalPrice(int finalPrice) {
        this.finalPrice = finalPrice;
    }
    public String getOrderStatus() {
        return orderStatus;
    }
    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }
    public String getPaymentStatus() {
        return paymentStatus;
    }
    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    public String getTossOrderId() {
        return tossOrderId;
    }
    public void setTossOrderId(String tossOrderId) {
        this.tossOrderId = tossOrderId;
    }
    public String getPaymentKey() {
        return paymentKey;
    }
    public void setPaymentKey(String paymentKey) {
        this.paymentKey = paymentKey;
    }
    public int getPaidAmount() {
        return paidAmount;
    }
    public void setPaidAmount(int paidAmount) {
        this.paidAmount = paidAmount;
    }
    public String getOrderDate() {
        return orderDate;
    }
    public void setOrderDate(String orderDate) {
        this.orderDate = orderDate;
    }
    public String getDeliveryCompany() {
        return deliveryCompany;
    }
    public void setDeliveryCompany(String deliveryCompany) {
        this.deliveryCompany = deliveryCompany;
    }
    public String getTrackingNumber() {
        return trackingNumber;
    }
    public void setTrackingNumber(String trackingNumber) {
        this.trackingNumber = trackingNumber;
    }
    public String getMemName() {
        return memName;
    }
    public void setMemName(String memName) {
        this.memName = memName;
    }
    public String getProName() {
        return proName;
    }
    public void setProName(String proName) {
        this.proName = proName;
    }
    public int getProductCount() {
        return productCount;
    }
    public void setProductCount(int productCount) {
        this.productCount = productCount;
    }
    public String getDisplayProductName() {
        if (productCount > 1) {
            return proName + " 외 " + (productCount - 1) + "개";
        }
        return proName;
    }
   
   
    
}
