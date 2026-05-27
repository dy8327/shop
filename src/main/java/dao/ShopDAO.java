package dao;

import java.sql.*;
import dto.Shop;

public class ShopDAO {

    // 상품 상세 + 옵션까지 조회
    public Shop getProductDetail(Connection conn, int proId) {

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
                shop.setProCategpry(rs.getString("PRO_CATEGORY"));
                shop.setProDate(rs.getString("PRO_DATE"));

                shop.setProOpId(rs.getInt("OPTION_ID"));
                shop.setProSize(rs.getString("PRO_SIZE"));
                shop.setProColor(rs.getString("PRO_COLOR"));
                shop.setProStock(rs.getInt("PRO_STOCK"));
            }

        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try { rs.close(); } catch(Exception e) {}
            try { pstmt.close(); } catch(Exception e) {}
        }

        return shop;
    }
}