<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dto.Shop" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>

<%
request.setCharacterEncoding("UTF-8");

int proId = Integer.parseInt(request.getParameter("proId"));
String color = request.getParameter("color");
String size = request.getParameter("size");
int quantity = Integer.parseInt(request.getParameter("quantity"));

PreparedStatement pstmt = null;
ResultSet rs = null;

try {

    // ==========================
    // 1. OPTION_ID 찾기
    // ==========================
    String optSql =
        "SELECT OPTION_ID FROM PRO_OPTION " +
        "WHERE PRO_ID=? AND PRO_COLOR=? AND PRO_SIZE=?";

    pstmt = conn.prepareStatement(optSql);
    pstmt.setInt(1, proId);
    pstmt.setString(2, color);
    pstmt.setString(3, size);

    rs = pstmt.executeQuery();

    int optionId = -1;

    if(rs.next()){
        optionId = rs.getInt("OPTION_ID");
    }

    if(optionId == -1){
        throw new Exception("옵션 없음 (OPTION_ID 찾기 실패)");
    }

    // ==========================
    // 2. CART_ID 생성 (현재 방식 유지)
    // ==========================
    String idSql = "SELECT NVL(MAX(CART_ID),0)+1 FROM CART";
    pstmt = conn.prepareStatement(idSql);
    rs = pstmt.executeQuery();

    int cartId = 1;

    if(rs.next()){
        cartId = rs.getInt(1);
    }

    // ==========================
    // 3. INSERT CART
    // ==========================
    String insertSql =
        "INSERT INTO CART (CART_ID, MEM_ID, PRO_ID, OPTION_ID, CART_STOCK) " +
        "VALUES (?, ?, ?, ?, ?)";

    pstmt = conn.prepareStatement(insertSql);

    pstmt.setInt(1, cartId);

    // 임시 유저
    pstmt.setString(2, "test");

    pstmt.setInt(3, proId);
    pstmt.setInt(4, optionId);
    pstmt.setInt(5, quantity);

    int result = pstmt.executeUpdate();

    if(result > 0){
        response.sendRedirect("cart.jsp");
    } else {
        out.println("장바구니 저장 실패");
    }

} catch(Exception e){
    out.println("에러: " + e.getMessage());
}
%>