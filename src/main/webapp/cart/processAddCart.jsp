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

    String proIdStr = request.getParameter("proId");
    String optionIdStr = request.getParameter("optionId");
    String quantityStr = request.getParameter("quantity");

    if (proIdStr == null || optionIdStr == null || quantityStr == null ||
        proIdStr.equals("") || optionIdStr.equals("") || quantityStr.equals("")) {
%>
        <script>
            alert("상품 옵션 정보가 올바르지 않습니다.");
            history.back();
        </script>
<%
        return;
    }

    int proId = Integer.parseInt(proIdStr);
    int optionId = Integer.parseInt(optionIdStr);
    int cartQty = Integer.parseInt(quantityStr);

    if (cartQty < 1) {
        cartQty = 1;
    }

    try {
        CartDAO dao = new CartDAO(conn);

        dao.addCart(memId, proId, optionId, cartQty);
%>
        <script>
            alert("장바구니에 추가되었습니다.");
            location.href = "<%=request.getContextPath()%>/product/product.jsp?proId=<%=proId%>&cart=success";
        </script>
<%
    } catch (Exception e) {
        out.println("장바구니 등록 오류: " + e.getMessage());
    } finally {
        if (conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>