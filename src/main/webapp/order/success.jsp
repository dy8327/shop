<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
request.setCharacterEncoding("UTF-8");

String paymentKey = request.getParameter("paymentKey");
String tossOrderId = request.getParameter("orderId");
String amount = request.getParameter("amount");

if (paymentKey == null || tossOrderId == null || amount == null) {
%>
<script>
    alert("결제 승인 정보가 올바르지 않습니다.");
    location.href = "<%= request.getContextPath() %>/cart/cart.jsp";
</script>
<%
    return;
}
%>

<!doctype html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>결제 처리 중</title>
</head>
<body>

<form id="successForm" method="post" action="<%= request.getContextPath() %>/order/processPaymentSuccess.jsp">
    <input type="hidden" name="paymentKey" value="<%= paymentKey %>">
    <input type="hidden" name="orderId" value="<%= tossOrderId %>">
    <input type="hidden" name="amount" value="<%= amount %>">
</form>

<script>
    document.getElementById("successForm").submit();
</script>

</body>
</html>