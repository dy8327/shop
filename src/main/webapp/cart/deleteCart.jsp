<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.CartDAO" %>
<%@ page import="dto.CartItem" %>
<%@ include file="../dbconn.jsp" %>

<%
request.setCharacterEncoding("UTF-8");

String memId = (String) session.getAttribute("memId");

if (memId == null) {
%>
    <script>
        alert("로그인이 필요합니다.");
        location.href = "<%=request.getContextPath()%>/member/login.jsp";
    </script>
<%
    return;
}

try {
    CartDAO dao = new CartDAO(conn);

    dao.deleteCart(memId);

    response.sendRedirect(request.getContextPath() + "/cart/cart.jsp");

} catch (Exception e) {
    out.println("장바구니 전체 삭제 오류: " + e.getMessage());
} finally {
    if (conn != null) try { conn.close(); } catch(Exception e) {}
}
%>