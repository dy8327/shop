package dto;

public class OrderDetailDTO {
    private int detailId;
    private int orderId;
    private int proId;
    private int proOpId;
    private int quantity;
    private int proPrice;
    private int sumPrice;
    private String proName;
    private String proColor;
    private String proSize;
    public int getDetailId() {
        return detailId;
    }
    public void setDetailId(int detailId) {
        this.detailId = detailId;
    }
    public int getOrderId() {
        return orderId;
    }
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }
    public int getProId() {
        return proId;
    }
    public void setProId(int proId) {
        this.proId = proId;
    }
    public int getProOpId() {
        return proOpId;
    }
    public void setProOpId(int proOpId) {
        this.proOpId = proOpId;
    }
    public int getQuantity() {
        return quantity;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    public int getProPrice() {
        return proPrice;
    }
    public void setProPrice(int proPrice) {
        this.proPrice = proPrice;
    }
    public int getSumPrice() {
        return sumPrice;
    }
    public void setSumPrice(int sumPrice) {
        this.sumPrice = sumPrice;
    }
    public String getProName() {
        return proName;
    }
    public void setProName(String proName) {
        this.proName = proName;
    }
    public String getProColor() {
        return proColor;
    }
    public void setProColor(String proColor) {
        this.proColor = proColor;
    }
    public String getProSize() {
        return proSize;
    }
    public void setProSize(String proSize) {
        this.proSize = proSize;
    }
    
}
