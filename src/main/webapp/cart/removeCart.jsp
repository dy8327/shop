<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="/dbconn.jsp" %>

<%
request.setCharacterEncoding("UTF-8");

String memId = (String) session.getAttribute("memId");

if (memId == null) {
%>
    <script>
        alert("로그인이 필요합니다.");
        location.href = "<%= request.getContextPath() %>/member/login.jsp";
    </script>
<%
    return;
}

String cartIdParam = request.getParameter("cartId");

if (cartIdParam == null || cartIdParam.equals("")) {
%>
    <script>
        alert("삭제할 장바구니 상품 정보가 없습니다.");
        history.back();
    </script>
<%
    return;
}

int cartId = Integer.parseInt(cartIdParam);

PreparedStatement pstmt = null;

try {
    String sql = "DELETE FROM CART WHERE CART_ID = ? AND MEM_ID = ?";

    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, cartId);
    pstmt.setString(2, memId);

    pstmt.executeUpdate();

    response.sendRedirect(request.getContextPath() + "/cart/cart.jsp");

} catch (Exception e) {
    out.println("장바구니 삭제 오류: " + e.getMessage());
} finally {
    if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
    if (conn != null) try { conn.close(); } catch(Exception e) {}
}
%>