package main.java.dto;

import java.io.Serializable;

public class Shop implements Serializable {
    private int proId;          //제품ID
    private String proName;     //제품명
    private int proPrice;       //가격
    private String proCont;     //설명
    private String proImg;      //이미지
    private String proCategpry; //분류
    private String proDate;     //입력일
    private long proStock;      //재고
    private int proOpId;        //옵션ID
    private String proSize;     //사이즈
    private String proColor;    //색상
    private int quantity;       //장바구니
    public int getProId() {
        return proId;
    }
    public void setProId(int proId) {
        this.proId = proId;
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
    public String getProCont() {
        return proCont;
    }
    public void setProCont(String proCont) {
        this.proCont = proCont;
    }
    public String getProImg() {
        return proImg;
    }
    public void setProImg(String proImg) {
        this.proImg = proImg;
    }
    public String getProCategpry() {
        return proCategpry;
    }
    public void setProCategpry(String proCategpry) {
        this.proCategpry = proCategpry;
    }
    public String getProDate() {
        return proDate;
    }
    public void setProDate(String proDate) {
        this.proDate = proDate;
    }
    public long getProStock() {
        return proStock;
    }
    public void setProStock(long proStock) {
        this.proStock = proStock;
    }
    public int getProOpId() {
        return proOpId;
    }
    public void setProOpId(int proOpId) {
        this.proOpId = proOpId;
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
    public int getQuantity() {
        return quantity;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
}
