<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>

<%
request.setCharacterEncoding("UTF-8");

// 회원용 세션 로그인 ID 검증 로직 (본인 쇼핑몰 로그인 세션 변수명에 맞게 "memberId"를 고치세요)
String memId = (String) session.getAttribute("memberId"); 

if (memId == null) {
    // 세션이 풀렸거나 없으면 JS 통신창에 401 코드를 리턴하여 로그인 차단
    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
    return;
}

int proId = Integer.parseInt(request.getParameter("proId"));
int optionId = Integer.parseInt(request.getParameter("optionId"));
int quantity = Integer.parseInt(request.getParameter("quantity"));

PreparedStatement checkPstmt = null;
PreparedStatement insertPstmt = null;
PreparedStatement updatePstmt = null;
ResultSet rs = null;

try {
    // 1. 이미 동일한 사용자가 똑같은 상품 옵션 조합을 장바구니 테이블에 가지고 있는지 먼저 체크합니다.
    String checkSql = "SELECT CART_ID, CART_STOCK FROM CART WHERE MEM_ID = ? AND PRO_ID = ? AND OPTION_ID = ?";
    checkPstmt = conn.prepareStatement(checkSql);
    checkPstmt.setString(1, memId);
    checkPstmt.setInt(2, proId);
    checkPstmt.setInt(3, optionId);
    rs = checkPstmt.executeQuery();

    if (rs.next()) {
        // [CASE 1] 이미 담은 이력이 있는 아이템일 경우 -> 기존 수량에 현재 수량을 누적 합산 업데이트
        int cartId = rs.getInt("CART_ID");
        int currentStock = rs.getInt("CART_STOCK");
        
        String updateSql = "UPDATE CART SET CART_STOCK = ? WHERE CART_ID = ?";
        updatePstmt = conn.prepareStatement(updateSql);
        updatePstmt.setInt(1, currentStock + quantity);
        updatePstmt.setInt(2, cartId);
        updatePstmt.executeUpdate();
    } else {
        // [CASE 2] 최초로 담는 새로운 아이템 옵션일 경우 -> 생성한 CART 시퀀스를 동반하여 새로 한 줄 삽입(INSERT)
        String insertSql = "INSERT INTO CART (CART_ID, MEM_ID, PRO_ID, OPTION_ID, CART_STOCK, CREATE_DATE) " +
                          "VALUES (SEQ_CART.NEXTVAL, ?, ?, ?, ?, SYSDATE)";
        insertPstmt = conn.prepareStatement(insertSql);
        insertPstmt.setString(1, memId);
        insertPstmt.setInt(2, proId);
        insertPstmt.setInt(3, optionId);
        insertPstmt.setInt(4, quantity);
        insertPstmt.executeUpdate();
    }
    
} catch (Exception e) {
    e.printStackTrace();
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
} finally {
    if (rs != null) rs.close();
    if (checkPstmt != null) checkPstmt.close();
    if (insertPstmt != null) insertPstmt.close();
    if (updatePstmt != null) updatePstmt.close();
}
%>