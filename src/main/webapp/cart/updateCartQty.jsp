<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String memId = (String) session.getAttribute("memId");


    String cartIdStr = request.getParameter("cartId");
    String action = request.getParameter("action");

    if (cartIdStr == null || action == null || cartIdStr.equals("") || action.equals("")) {
%>
        <script>
            alert("잘못된 요청입니다.");
            history.back();
        </script>
<%
        return;
    }

    int cartId = Integer.parseInt(cartIdStr);

    PreparedStatement pstmt = null;

    try {
        String sql = "";

        if ("up".equals(action)) {
            sql = "UPDATE CART SET CART_QTY = CART_QTY + 1 WHERE CART_ID = ? AND MEM_ID = ?";
        } else if ("down".equals(action)) {
            sql = "UPDATE CART SET CART_QTY = CART_QTY - 1 WHERE CART_ID = ? AND MEM_ID = ? AND CART_QTY > 1";
        } else {
%>
            <script>
                alert("잘못된 수량 변경 요청입니다.");
                history.back();
            </script>
<%
            return;
        }

        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, cartId);
        pstmt.setString(2, memId);
        pstmt.executeUpdate();

        response.sendRedirect("cart.jsp");

    } catch (Exception e) {
        out.println("수량 변경 오류: " + e.getMessage());
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>