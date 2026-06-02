<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.OrderDAO" %>
<%@ page import="dao.MemberDAO" %>
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

String orderIdParam = request.getParameter("orderId");

if (orderIdParam == null || orderIdParam.equals("")) {
%>
<script>
    alert("잘못된 접근입니다.");
    location.href = "<%= request.getContextPath() %>/product/cart.jsp";
</script>
<%
    return;
}

int orderId = Integer.parseInt(orderIdParam);

OrderDTO order = null;
String customerKey = "";

try {
    OrderDAO orderDAO = new OrderDAO(conn);
    MemberDAO memberDAO = new MemberDAO(conn);

    order = orderDAO.getReadyOrderForPayment(orderId, memId);
    customerKey = memberDAO.getCustomerKey(memId);

    if (order == null) {
%>
<script>
    alert("결제 가능한 주문이 없습니다.");
    location.href = "<%= request.getContextPath() %>/product/cart.jsp";
</script>
<%
        return;
    }

    if (customerKey == null || customerKey.equals("")) {
        customerKey = "CUST_" + memId;
    }

} catch (Exception e) {
    e.printStackTrace();
%>
<script>
    alert("결제 정보 조회 중 오류가 발생했습니다.");
    location.href = "<%= request.getContextPath() %>/product/cart.jsp";
</script>
<%
    return;
}
%>

<!doctype html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>결제 진행</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

<script src="https://js.tosspayments.com/v2/standard"></script>
</head>

<body class="soft">

<%@ include file="../menu.jsp" %>

<main class="order">

    <section class="panel">
        <h1>결제 진행</h1>

        <p>주문번호: <%= order.getOrderId() %></p>
        <p>결제금액: <%= order.getFinalPrice() %>원</p>

        <hr>

        <button type="button" class="button" style="margin-top: 30px;" onclick="requestPayment()">
            결제하기
        </button>

        <a class="outline wide" href="${pageContext.request.contextPath}/product/cart.jsp">
            장바구니로 돌아가기
        </a>
    </section>

</main>

<%@ include file="../footer.jsp" %>


<script>
const clientKey = "test_ck_Z1aOwX7K8m757RnxmxeaVyQxzvNP";

const tossPayments = TossPayments(clientKey);
const payment = tossPayments.payment({
    customerKey: "<%= customerKey %>"
});

async function requestPayment() {
    await payment.requestPayment({
        method: "CARD",
        amount: {
            currency: "KRW",
            value: <%= order.getFinalPrice() %>
        },
        orderId: "<%= order.getTossOrderId() %>",
        orderName: "SSU 의류 쇼핑몰 주문",
        successUrl: window.location.origin + "<%= request.getContextPath() %>/order/success.jsp",
        failUrl: window.location.origin + "<%= request.getContextPath() %>/order/fail.jsp",
        customerName: "<%= order.getReceiverName() %>",
        customerMobilePhone: "<%= order.getReceiverPhone() %>"
    });
}
</script>







</body>
</html>

<%
if (conn != null) {
    try { conn.close(); } catch(Exception e) {}
}
%>