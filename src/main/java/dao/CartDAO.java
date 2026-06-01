package dao;

import dto.CartItem;
import java.sql.*;
import java.util.ArrayList;

public class CartDAO {

    private Connection conn;

    public CartDAO(Connection conn) {
        this.conn = conn;
    }

    // 장바구니 목록 조회
    public ArrayList<CartItem> getCartList(String memId) throws SQLException {

        ArrayList<CartItem> cartList = new ArrayList<CartItem>();

        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            String sql = "SELECT C.CART_ID, P.PRO_NAME, P.PRO_PRICE, " +
                         "O.OPTION_ID, O.PRO_COLOR, O.PRO_SIZE, C.CART_QTY " +
                         "FROM CART C " +
                         "JOIN PRODUCTS P ON C.PRO_ID = P.PRO_ID " +
                         "JOIN PRO_OPTION O ON C.OPTION_ID = O.OPTION_ID " +
                         "WHERE C.MEM_ID = ? " +
                         "ORDER BY C.CREATE_DATE DESC";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memId);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                CartItem item = new CartItem();

                item.setCartId(rs.getInt("CART_ID"));
                item.setProName(rs.getString("PRO_NAME"));
                item.setProPrice(rs.getInt("PRO_PRICE"));
                item.setOptionId(rs.getInt("OPTION_ID"));
                item.setProColor(rs.getString("PRO_COLOR"));
                item.setProSize(rs.getString("PRO_SIZE"));
                item.setCartQty(rs.getInt("CART_QTY"));

                cartList.add(item);
            }

        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        }

        return cartList;
    }

    // 장바구니 추가
    public void addCart(String memId, int proId, int optionId, int cartQty) throws SQLException {

        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            String checkSql = "SELECT CART_ID, CART_QTY FROM CART " +
                              "WHERE MEM_ID = ? AND PRO_ID = ? AND OPTION_ID = ?";

            pstmt = conn.prepareStatement(checkSql);
            pstmt.setString(1, memId);
            pstmt.setInt(2, proId);
            pstmt.setInt(3, optionId);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                int cartId = rs.getInt("CART_ID");
                int oldQty = rs.getInt("CART_QTY");
                int newQty = oldQty + cartQty;

                rs.close();
                pstmt.close();

                String updateSql = "UPDATE CART SET CART_QTY = ? WHERE CART_ID = ?";

                pstmt = conn.prepareStatement(updateSql);
                pstmt.setInt(1, newQty);
                pstmt.setInt(2, cartId);

                pstmt.executeUpdate();

            } else {
                rs.close();
                pstmt.close();

                String insertSql = "INSERT INTO CART " +
                                   "(CART_ID, MEM_ID, PRO_ID, OPTION_ID, CART_QTY) " +
                                   "VALUES (CART_SEQ.NEXTVAL, ?, ?, ?, ?)";

                pstmt = conn.prepareStatement(insertSql);
                pstmt.setString(1, memId);
                pstmt.setInt(2, proId);
                pstmt.setInt(3, optionId);
                pstmt.setInt(4, cartQty);

                pstmt.executeUpdate();
            }

        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        }
    }

    // 장바구니 수량 증가
    public int increaseQty(int cartId, String memId) throws SQLException {

        PreparedStatement pstmt = null;

        try {
            String sql = "UPDATE CART SET CART_QTY = CART_QTY + 1 " +
                         "WHERE CART_ID = ? AND MEM_ID = ?";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, cartId);
            pstmt.setString(2, memId);

            return pstmt.executeUpdate();

        } finally {
            if (pstmt != null) pstmt.close();
        }
    }

    // 장바구니 수량 감소
    public int decreaseQty(int cartId, String memId) throws SQLException {

        PreparedStatement pstmt = null;

        try {
            String sql = "UPDATE CART SET CART_QTY = CART_QTY - 1 " +
                         "WHERE CART_ID = ? AND MEM_ID = ? AND CART_QTY > 1";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, cartId);
            pstmt.setString(2, memId);

            return pstmt.executeUpdate();

        } finally {
            if (pstmt != null) pstmt.close();
        }
    }

    // 장바구니 상품 개별 삭제
    public int removeCart(int cartId, String memId) throws SQLException {

        PreparedStatement pstmt = null;

        try {
            String sql = "DELETE FROM CART WHERE CART_ID = ? AND MEM_ID = ?";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, cartId);
            pstmt.setString(2, memId);

            return pstmt.executeUpdate();

        } finally {
            if (pstmt != null) pstmt.close();
        }
    }

    // 장바구니 전체 삭제
    public int deleteCart(String memId) throws SQLException {

        PreparedStatement pstmt = null;

        try {
            String sql = "DELETE FROM CART WHERE MEM_ID = ?";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memId);

            return pstmt.executeUpdate();

        } finally {
            if (pstmt != null) pstmt.close();
        }
    }
}