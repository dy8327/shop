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

    String cartIdStr = request.getParameter("cartId");
    String action = request.getParameter("action");

    if (cartIdStr == null || action == null ||
        cartIdStr.trim().equals("") || action.trim().equals("")) {
%>
        <script>
            alert("잘못된 요청입니다.");
            history.back();
        </script>
<%
        return;
    }

    int cartId = 0;

    try {
        cartId = Integer.parseInt(cartIdStr.trim());
    } catch (NumberFormatException e) {
%>
        <script>
            alert("장바구니 번호 형식이 올바르지 않습니다.");
            history.back();
        </script>
<%
        return;
    }

    try {
        CartDAO dao = new CartDAO(conn);

        if ("up".equals(action)) {
            dao.increaseQty(cartId, memId);

        } else if ("down".equals(action)) {
            dao.decreaseQty(cartId, memId);

        } else {
%>
            <script>
                alert("잘못된 수량 변경 요청입니다.");
                history.back();
            </script>
<%
            return;
        }

        response.sendRedirect("cart.jsp");

    } catch (Exception e) {
        out.println("수량 변경 오류: " + e.getMessage());

    } finally {
        if (conn != null) {
            conn.close();
        }
    }
%>