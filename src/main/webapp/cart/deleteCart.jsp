<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="/dbconn.jsp" %>

<%
request.setCharacterEncoding("UTF-8");

String memId = (String) session.getAttribute("memId");


PreparedStatement pstmt = null;

try {
    String sql = "DELETE FROM CART WHERE MEM_ID = ?";

    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, memId);

    pstmt.executeUpdate();

    response.sendRedirect(request.getContextPath() + "/cart/cart.jsp");

} catch (Exception e) {
    out.println("장바구니 전체 삭제 오류: " + e.getMessage());
} finally {
    if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
    if (conn != null) try { conn.close(); } catch(Exception e) {}
}
%>