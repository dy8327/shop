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

try {
    CartDAO dao = new CartDAO(conn);

    dao.removeCart(cartId, memId);

    response.sendRedirect(request.getContextPath() + "/cart/cart.jsp");

} catch (Exception e) {
    out.println("장바구니 삭제 오류: " + e.getMessage());
} finally {
    if (conn != null)
        conn.close(); 
}
%>