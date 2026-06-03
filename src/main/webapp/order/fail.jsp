<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.OrderDAO" %>
<%@ include file="../dbconn.jsp" %>

<%
request.setCharacterEncoding("UTF-8");

String memId = (String) session.getAttribute("memId");

String code = request.getParameter("code");
String message = request.getParameter("message");
String tossOrderId = request.getParameter("orderId");

if (code == null) code = "UNKNOWN";
if (message == null) message = "결제가 취소되었거나 실패했습니다.";
if (tossOrderId == null) tossOrderId = "";

try {
    if (memId != null && !tossOrderId.equals("")) {
        OrderDAO orderDAO = new OrderDAO(conn);
        orderDAO.updatePaymentFail(tossOrderId, memId);
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (conn != null) {
        try { conn.close(); } catch(Exception e) {}
    }
}
%>

<!doctype html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>결제 실패</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="soft">

<%@ include file="../menu.jsp" %>

<main class="order">
    <section class="panel">
        <h1>결제가 완료되지 않았습니다.</h1>

        <p>결제 진행 중 취소 또는 오류가 발생했습니다.</p>

        <div style="margin: 24px 0; padding: 18px; border-radius: 16px; background: #fff5f7;">
            <p><strong>오류 코드</strong></p>
            <p><%= code %></p>

            <p><strong>오류 메시지</strong></p>
            <p><%= message %></p>

            <% if (!tossOrderId.equals("")) { %>
                <p><strong>결제 주문번호</strong></p>
                <p><%= tossOrderId %></p>
            <% } %>
        </div>

        <a class="button" href="${pageContext.request.contextPath}/cart/cart.jsp">
            장바구니로 돌아가기
        </a>

        <a class="outline wide" href="${pageContext.request.contextPath}/index.jsp">
            메인으로
        </a>
    </section>
</main>

<%@ include file="../footer.jsp" %>

</body>
</html>