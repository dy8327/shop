<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.OrderDAO" %>
<%@ page import="dto.OrderDTO" %>
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

String receiverName = request.getParameter("receiverName");
String receiverPhone = request.getParameter("receiverPhone");
String receiverAddress = request.getParameter("receiverAddress");
String deliveryMemo = request.getParameter("deliveryMemo");
String payment = request.getParameter("payment");

if (payment == null || payment.equals("")) {
    payment = "CARD";
}

try {
    conn.setAutoCommit(false);

    OrderDAO orderDAO = new OrderDAO(conn);

    OrderDTO order = new OrderDTO();
    order.setMemId(memId);
    order.setReceiverName(receiverName);
    order.setReceiverPhone(receiverPhone);
    order.setReceiverAddr(receiverAddress);
    order.setDeliveryMemo(deliveryMemo);
    order.setPayment(payment);

    order.setOrderStatus("결제대기");
    order.setPaymentStatus("READY");
    order.setTossOrderId(orderDAO.createTossOrderId());
    order.setPaidAmount(0);

    int orderId = orderDAO.createReadyOrder(order);

    conn.commit();

    response.sendRedirect(
        request.getContextPath()
        + "/order/payment.jsp?orderId=" + orderId
    );

} catch (Exception e) {
    if (conn != null) {
        try { conn.rollback(); } catch(Exception ex) {}
    }
%>
<script>
    alert("주문 생성 중 오류가 발생했습니다.\n<%= e.getMessage() %>");
    history.back();
</script>
<%
} finally {
    if (conn != null) {
        try {
            conn.setAutoCommit(true);
            conn.close();
        } catch(Exception e) {}
    }
}
%>