<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.OrderDAO" %>
<%@ page import="dto.OrderDTO" %>
<%@ page import="java.net.URI" %>
<%@ page import="java.net.http.HttpClient" %>
<%@ page import="java.net.http.HttpRequest" %>
<%@ page import="java.net.http.HttpResponse" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.util.Base64" %>
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

String paymentKey = request.getParameter("paymentKey");
String tossOrderId = request.getParameter("orderId");
String amountParam = request.getParameter("amount");

if (paymentKey == null || tossOrderId == null || amountParam == null ||
    paymentKey.equals("") || tossOrderId.equals("") || amountParam.equals("")) {
%>
<script>
    alert("결제 승인 정보가 올바르지 않습니다.");
    location.href = "<%= request.getContextPath() %>/cart/cart.jsp";
</script>
<%
    return;
}

int amount = 0;

try {
    amount = Integer.parseInt(amountParam);
} catch (NumberFormatException e) {
%>
<script>
    alert("결제 금액 정보가 올바르지 않습니다.");
    location.href = "<%= request.getContextPath() %>/cart/cart.jsp";
</script>
<%
    return;
}

try {
    OrderDAO orderDAO = new OrderDAO(conn);

    // 1. DB에 있는 결제대기 주문 조회
    OrderDTO order = orderDAO.getReadyOrderByTossOrderId(tossOrderId, memId);

    if (order == null) {
%>
<script>
    alert("결제대기 주문을 찾을 수 없습니다.");
    location.href = "<%= request.getContextPath() %>/cart/cart.jsp";
</script>
<%
        return;
    }

    // 2. 금액 검증
    if (order.getFinalPrice() != amount) {
%>
<script>
    alert("결제 금액이 주문 금액과 일치하지 않습니다.");
    location.href = "<%= request.getContextPath() %>/cart/cart.jsp";
</script>
<%
        return;
    }

    // 3. 토스 결제 승인 API 호출
    String secretKey = "test_sk_Z61JOxRQVEapY1ZqzDWDVW0X9bAq";
    String encodedAuth = Base64.getEncoder().encodeToString((secretKey + ":").getBytes(StandardCharsets.UTF_8));

    String jsonBody =
        "{" +
        "\"paymentKey\":\"" + paymentKey + "\"," +
        "\"orderId\":\"" + tossOrderId + "\"," +
        "\"amount\":" + amount +
        "}";

    HttpRequest tossRequest = HttpRequest.newBuilder()
        .uri(URI.create("https://api.tosspayments.com/v1/payments/confirm"))
        .header("Authorization", "Basic " + encodedAuth)
        .header("Content-Type", "application/json")
        .POST(HttpRequest.BodyPublishers.ofString(jsonBody, StandardCharsets.UTF_8))
        .build();

    HttpClient client = HttpClient.newHttpClient();
    HttpResponse<String> tossResponse = client.send(tossRequest, HttpResponse.BodyHandlers.ofString());

    int statusCode = tossResponse.statusCode();

    if (statusCode < 200 || statusCode >= 300) {
        System.out.println("토스 결제 승인 실패");
        System.out.println(tossResponse.body());
%>
<script>
    alert("토스 결제 승인에 실패했습니다. 서버 로그를 확인해주세요.");
    location.href = "<%= request.getContextPath() %>/cart/cart.jsp";
</script>
<%
        return;
    }

    // 4. DB 주문 완료 처리
    conn.setAutoCommit(false);

    if (!orderDAO.hasEnoughStock(order.getOrderId())) {
        conn.rollback();
%>
<script>
    alert("재고가 부족하여 주문을 완료할 수 없습니다.");
    location.href = "<%= request.getContextPath() %>/cart/cart.jsp";
</script>
<%
        return;
    }

    orderDAO.decreaseStockByOrderId(order.getOrderId());
    orderDAO.updatePaymentSuccess(order.getOrderId(), paymentKey, amount);
    orderDAO.deleteCartByMemId(memId);

    conn.commit();

    response.sendRedirect(request.getContextPath() + "/order/orderComplete.jsp?orderId=" + order.getOrderId());
    return;

} catch (Exception e) {
    if (conn != null) {
        try { conn.rollback(); } catch(Exception ex) {}
    }

    e.printStackTrace();
%>
<script>
    alert("결제 완료 처리 중 오류가 발생했습니다.");
    location.href = "<%= request.getContextPath() %>/cart/cart.jsp";
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