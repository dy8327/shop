<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="service.OrderService" %>
<%@ include file="../dbconn.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String adminId = (String) session.getAttribute("memId");
    String adminRole = (String) session.getAttribute("memRole");

    if (adminId == null || !"ADMIN".equals(adminRole)) {
%>
        <script>
            alert("관리자만 접근 가능합니다.");
            location.href = "<%= request.getContextPath() %>/member/login.jsp";
        </script>
<%
        return;
    }

    String orderIdStr = request.getParameter("orderId");
    String orderStatus = request.getParameter("orderStatus");
    String deliveryCompany = request.getParameter("deliveryCompany");
    String trackingNumber = request.getParameter("trackingNumber");

    int orderId = 0;

    try {
        orderId = Integer.parseInt(orderIdStr);
    } catch (Exception e) {
%>
        <script>
            alert("주문번호 형식이 올바르지 않습니다.");
            history.back();
        </script>
<%
        return;
    }

    try {
        OrderService orderService = new OrderService();

        orderService.updateOrderStatus(
            conn,
            orderId,
            orderStatus,
            deliveryCompany,
            trackingNumber
        );
%>
        <script>
            alert("주문 상태가 변경되었습니다.");
            location.href = "<%= request.getContextPath() %>/admin/orderDetail.jsp?orderId=<%= orderId %>";
        </script>
<%
    } catch (IllegalArgumentException e) {
%>
        <script>
            alert("<%= e.getMessage() %>");
            history.back();
        </script>
<%
    } catch (Exception e) {
        e.printStackTrace();
%>
        <script>
            alert("주문 상태 변경 오류가 발생했습니다.");
            history.back();
        </script>
<%
    } finally {
        if (conn != null) {
            try { conn.close(); } catch(Exception e) {}
        }
    }
%>