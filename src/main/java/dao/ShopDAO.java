package dao;

import java.sql.*;
import java.util.ArrayList;

import dto.Shop;

public class ShopDAO {
        
    // 상품 상세 + 옵션까지 조회
    public Shop getProductDetail(Connection conn, int proId) throws Exception {

        Shop shop = null;

        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {

            String sql =
                "SELECT P.PRO_ID, P.PRO_NAME, P.PRO_PRICE, P.PRO_CONTENT, " +
                "P.PRO_IMG, P.PRO_CATEGORY, P.PRO_DATE, " +
                "O.OPTION_ID, O.PRO_SIZE, O.PRO_COLOR, O.PRO_STOCK " +
                "FROM PRODUCTS P " +
                "LEFT JOIN PRO_OPTION O ON P.PRO_ID = O.PRO_ID " +
                "WHERE P.PRO_ID = ?";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, proId);

            rs = pstmt.executeQuery();

            // 같은 상품 + 옵션 여러개 나올 수 있음 → 일단 첫 row 기준
            if (rs.next()) {

                shop = new Shop();

                shop.setProId(rs.getInt("PRO_ID"));
                shop.setProName(rs.getString("PRO_NAME"));
                shop.setProPrice(rs.getInt("PRO_PRICE"));
                shop.setProCont(rs.getString("PRO_CONTENT"));
                shop.setProImg(rs.getString("PRO_IMG"));
                shop.setProCategory(rs.getString("PRO_CATEGORY"));
                shop.setProDate(rs.getString("PRO_DATE"));

                shop.setProOpId(rs.getInt("OPTION_ID"));
                shop.setProSize(rs.getString("PRO_SIZE"));
                shop.setProColor(rs.getString("PRO_COLOR"));
                shop.setProStock(rs.getInt("PRO_STOCK"));
            }

        
        } finally {
            if (rs!=null)
                rs.close();
            if(pstmt!=null)
                pstmt.close(); 
        }

        return shop;
    }

    public void deleteProduct(Connection conn, int proId) throws Exception{
        PreparedStatement pstmt=null;
    
    
    try{
        conn.setAutoCommit(false);
    

        String optionSql="DELETE FROM PRO_OPTION WHERE PRO_ID=?";
        pstmt=conn.prepareStatement(optionSql);
        pstmt.setInt(1, proId);
        pstmt.executeUpdate();
        pstmt.close();
        pstmt = null;
        
        String prosql="DELETE FROM PRODUCTS WHERE PRO_ID=?";
        pstmt=conn.prepareStatement(prosql);
        pstmt.setInt(1, proId);
        pstmt.executeUpdate();

        conn.commit();
       
    } catch(Exception e){
        conn.rollback();
        throw e;
        } finally{
            if(pstmt!=null)
                pstmt.close();
    }
    }

    public void updateProduct(Connection conn, Shop shop) throws Exception{
       
        PreparedStatement pstmt=null;
    
        try{
            conn.setAutoCommit(false);
               
            String productSql=
            "UPDATE PRODUCTS SET "+
            "PRO_NAME=?, PRO_PRICE=?, PRO_CONTENT=?, PRO_CATEGORY=?, PRO_IMG=? "+
            "WHERE PRO_ID=?";

            pstmt=conn.prepareStatement(productSql);
            
            pstmt.setString(1, shop.getProName());
            pstmt.setInt(2, shop.getProPrice());
            pstmt.setString(3, shop.getProCont());
            pstmt.setString(4, shop.getProCategory());
            pstmt.setString(5, shop.getProImg());
            pstmt.setInt(6, shop.getProId());
            pstmt.executeUpdate();
            pstmt.close();
            pstmt = null;

            String optionSql=
            "UPDATE PRO_OPTION SET "+
            "PRO_SIZE=?, PRO_COLOR=?, PRO_STOCK=? "+
            "WHERE PRO_ID=?";

            pstmt=conn.prepareStatement(optionSql);
            
            pstmt.setString(1, shop.getProSize());
            pstmt.setString(2, shop.getProColor());
            pstmt.setInt(3, shop.getProStock());
            pstmt.setInt(4, shop.getProId());
            pstmt.executeUpdate();
            conn.commit();
        }catch(Exception e) {
            conn.rollback();
            throw e;
    
        } finally {
            if(pstmt != null) {
                pstmt.close();
            }
        }
    }

    public void insertProduct(Connection conn, Shop shop, String[] proSizeArr, String[] proColorArr, String[] proStockArr) throws Exception{

        PreparedStatement pstmt=null;
        ResultSet rs= null;
        
            try{
                conn.setAutoCommit(false);
                int proId=0;
    
                String seqSql="SELECT SEQ_PRODUCTS.NEXTVAL FROM DUAL";
                pstmt=conn.prepareStatement(seqSql);
                rs=pstmt.executeQuery();
    
                if(rs.next()){
                    proId=rs.getInt(1);
                }
                rs.close();
                rs = null;
                pstmt.close();
                pstmt = null;
    
                String productSql=
                "INSERT INTO PRODUCTS "+
                "(PRO_ID, PRO_NAME, PRO_PRICE, PRO_CONTENT, PRO_CATEGORY, PRO_IMG) "+
                "VALUES(?, ?, ?, ?, ?, ?)";
    
                pstmt=conn.prepareStatement(productSql);
                pstmt.setInt(1, proId);
                pstmt.setString(2, shop.getProName());
                pstmt.setInt(3, shop.getProPrice());
                pstmt.setString(4, shop.getProCont());
                pstmt.setString(5, shop.getProCategory());
                pstmt.setString(6, shop.getProImg());
                pstmt.executeUpdate();
                pstmt.close();
                pstmt = null;
    
                String optionSql=
                "INSERT INTO PRO_OPTION "+
                "(OPTION_ID, PRO_ID, PRO_SIZE, PRO_COLOR, PRO_STOCK) "+
                "VALUES(SEQ_PRODUCTS_OPTION.NEXTVAL, ?, ?, ?, ?)";
    
                pstmt=conn.prepareStatement(optionSql);
                for(int i = 0; i < proSizeArr.length; i++){
                    pstmt.setInt(1, proId);
                    pstmt.setString(2, proSizeArr[i]);
                    pstmt.setString(3, proColorArr[i]);
                    pstmt.setInt(4, Integer.parseInt(proStockArr[i]));
                    pstmt.executeUpdate();
                }
                conn.commit();
    }catch(Exception e) {
        conn.rollback();
        throw e;

    } finally {
        if(rs != null)
            rs.close();

        if(pstmt != null)
            pstmt.close();
    }

}

// 관리자 메인 - 전체 상품 현황 조회
public ArrayList<Shop> getAllProducts(Connection conn) throws Exception {

    ArrayList<Shop> productList = new ArrayList<>();

    String sql = "SELECT p.PRO_ID, p.PRO_CATEGORY, p.PRO_IMG, p.PRO_NAME, p.PRO_PRICE, " +
                    "o.PRO_COLOR, o.PRO_SIZE, o.PRO_STOCK " +
                    "FROM PRODUCTS p " +
                    "JOIN PRO_OPTION o ON p.PRO_ID = o.PRO_ID " +
                    "ORDER BY p.PRO_ID DESC";

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            Shop shop = new Shop();

            shop.setProId(rs.getInt("PRO_ID"));
            shop.setProCategory(rs.getString("PRO_CATEGORY"));
            shop.setProImg(rs.getString("PRO_IMG"));
            shop.setProName(rs.getString("PRO_NAME"));
            shop.setProPrice(rs.getInt("PRO_PRICE"));
            shop.setProColor(rs.getString("PRO_COLOR"));
            shop.setProSize(rs.getString("PRO_SIZE"));
            shop.setProStock(rs.getInt("PRO_STOCK"));

            productList.add(shop);
        }

    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
    }

    return productList;
}
}