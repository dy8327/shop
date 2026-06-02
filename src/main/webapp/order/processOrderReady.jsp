<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
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

String tossOrderId = "TEST_" + System.currentTimeMillis();

PreparedStatement pstmt = null;
PreparedStatement cartPstmt = null;
PreparedStatement detailPstmt = null;
ResultSet rs = null;
ResultSet keyRs = null;

int totalPrice = 0;
int deliveryFee = 3000;
int finalPrice = 0;
int orderId = 0;

try {
    conn.setAutoCommit(false);

    String cartSql =
        "SELECT C.CART_ID, C.PRO_ID, C.OPTION_ID, C.CART_QTY, " +
        "P.PRO_PRICE " +
        "FROM CART C " +
        "JOIN PRODUCTS P ON C.PRO_ID = P.PRO_ID " +
        "WHERE C.MEM_ID = ?";

    cartPstmt = conn.prepareStatement(cartSql);
    cartPstmt.setString(1, memId);
    rs = cartPstmt.executeQuery();

    boolean hasCart = false;

    while (rs.next()) {
        hasCart = true;
        totalPrice += rs.getInt("PRO_PRICE") * rs.getInt("CART_QTY");
    }

    if (!hasCart) {
        conn.rollback();
%>
<script>
    alert("장바구니가 비어 있습니다.");
    location.href = "<%= request.getContextPath() %>/product/cart.jsp";
</script>
<%
        return;
    }

    finalPrice = totalPrice + deliveryFee;

    if (rs != null) try { rs.close(); } catch(Exception e) {}
    if (cartPstmt != null) try { cartPstmt.close(); } catch(Exception e) {}

    String orderSql =
        "INSERT INTO ORDERS ( " +
        "ORDER_ID, MEM_ID, RECEIVER_NAME, RECEIVER_PHONE, RECEIVER_ADDR, DELIVERY_MEMO, " +
        "PAYMENT, TOTAL_PRICE, DELIVERY_FEE, FINAL_PRICE, ORDER_STATUS, " +
        "PAYMENT_STATUS, ORDER_ID_TOSS, PAID_AMOUNT, ORDER_DATE " +
        ") VALUES ( " +
        "ORDER_SEQ.NEXTVAL, ?, ?, ?, ?, ?, " +
        "?, ?, ?, ?, '결제대기', " +
        "'READY', ?, 0, SYSDATE " +
        ")";

    pstmt = conn.prepareStatement(orderSql, new String[] {"ORDER_ID"});
    pstmt.setString(1, memId);
    pstmt.setString(2, receiverName);
    pstmt.setString(3, receiverPhone);
    pstmt.setString(4, receiverAddress);
    pstmt.setString(5, deliveryMemo);
    pstmt.setString(6, payment);
    pstmt.setInt(7, totalPrice);
    pstmt.setInt(8, deliveryFee);
    pstmt.setInt(9, finalPrice);
    pstmt.setString(10, tossOrderId);

    pstmt.executeUpdate();

    keyRs = pstmt.getGeneratedKeys();

    if (keyRs.next()) {
        orderId = keyRs.getInt(1);
    } else {
        throw new Exception("주문번호 생성 실패");
    }

    if (keyRs != null) try { keyRs.close(); } catch(Exception e) {}
    if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}

    cartPstmt = conn.prepareStatement(cartSql);
    cartPstmt.setString(1, memId);
    rs = cartPstmt.executeQuery();

    String detailSql =
        "INSERT INTO ORDER_DETAIL ( " +
        "ORDER_DETAIL_ID, ORDER_ID, PRO_ID, OPTION_ID, QUANTITY, PRO_PRICE, SUM_PRICE " +
        ") VALUES ( " +
        "ORDER_DETAIL_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ? " +
        ")";

    detailPstmt = conn.prepareStatement(detailSql);

    while (rs.next()) {
        int proId = rs.getInt("PRO_ID");
        int optionId = rs.getInt("OPTION_ID");
        int qty = rs.getInt("CART_QTY");
        int price = rs.getInt("PRO_PRICE");
        int sum = qty * price;

        detailPstmt.setInt(1, orderId);
        detailPstmt.setInt(2, proId);
        detailPstmt.setInt(3, optionId);
        detailPstmt.setInt(4, qty);
        detailPstmt.setInt(5, price);
        detailPstmt.setInt(6, sum);

        detailPstmt.addBatch();
    }

    detailPstmt.executeBatch();

    conn.commit();

    response.sendRedirect(
        request.getContextPath()
        + "/order/payment.jsp?orderId=" + orderId
    );

} catch (Exception e) {
    if (conn != null) try { conn.rollback(); } catch(Exception ex) {}

    out.println("주문 대기 생성 오류: " + e.getMessage());

} finally {
    if (keyRs != null) try { keyRs.close(); } catch(Exception e) {}
    if (rs != null) try { rs.close(); } catch(Exception e) {}
    if (detailPstmt != null) try { detailPstmt.close(); } catch(Exception e) {}
    if (cartPstmt != null) try { cartPstmt.close(); } catch(Exception e) {}
    if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
    if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch(Exception e) {}
}
%>