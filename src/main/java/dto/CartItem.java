package dto;

public class CartItem {
    private int cartId;
    private String memId;
    private int proId;
    private int optionId;
    private int cartStock;

    private String proName;
    private int proPrice;
    private String proImg;

    public int getCartId() {
        return cartId;
    }
    public void setCartId(int cartId) {
        this.cartId = cartId;
    }
    public String getMemId() {
        return memId;
    }
    public void setMemId(String memId) {
        this.memId = memId;
    }
    public int getProId() {
        return proId;
    }
    public void setProId(int proId) {
        this.proId = proId;
    }
    public int getOptionId() {
        return optionId;
    }
    public void setOptionId(int optionId) {
        this.optionId = optionId;
    }
    public int getCartStock() {
        return cartStock;
    }
    public void setCartStock(int cartStock) {
        this.cartStock = cartStock;
    }
    public String getProName() {
        return proName;
    }
    public void setProName(String proName) {
        this.proName = proName;
    }
    public int getProPrice() {
        return proPrice;
    }
    public void setProPrice(int proPrice) {
        this.proPrice = proPrice;
    }
    public String getProImg() {
        return proImg;
    }
    public void setProImg(String proImg) {
        this.proImg = proImg;
    }
    public String getProSize() {
        return proSize;
    }
    public void setProSize(String proSize) {
        this.proSize = proSize;
    }
    public String getProColor() {
        return proColor;
    }
    public void setProColor(String proColor) {
        this.proColor = proColor;
    }
    public int getProStock() {
        return proStock;
    }
    public void setProStock(int proStock) {
        this.proStock = proStock;
    }
    private String proSize;
    private String proColor;
    private int proStock;
}
