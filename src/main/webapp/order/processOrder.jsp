<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>

<%
request.setCharacterEncoding("UTF-8");

String memId = (String) session.getAttribute("memId");

if (memId == null) {
%>
    <script>
        alert("로그인이 필요한 서비스입니다.");
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

PreparedStatement pstmt = null;
PreparedStatement detailPstmt = null;
ResultSet rs = null;

try {
    int totalPrice = 0;
    int deliveryFee = 3000;
    int finalPrice = 0;
    int orderId = 0;

    // 1. 장바구니 상품 조회
    String cartSql =
        "SELECT " +
        "C.CART_ID, C.MEM_ID, C.PRO_ID, C.OPTION_ID, C.CART_STOCK, " +
        "P.PRO_NAME, P.PRO_PRICE, " +
        "O.PRO_SIZE, O.PRO_COLOR " +
        "FROM CART C " +
        "JOIN PRODUCTS P ON C.PRO_ID = P.PRO_ID " +
        "JOIN PRO_OPTION O ON C.OPTION_ID = O.OPTION_ID " +
        "WHERE C.MEM_ID = ?";

    pstmt = conn.prepareStatement(cartSql);
    pstmt.setString(1, memId);
    rs = pstmt.executeQuery();

    // 2. 장바구니 총액 계산
    boolean hasCart = false;

    while (rs.next()) {
        hasCart = true;

        int proPrice = rs.getInt("PRO_PRICE");
        int cartStock = rs.getInt("CART_STOCK");

        totalPrice += proPrice * cartStock;
    }

    rs.close();
    pstmt.close();

    if (!hasCart) {
%>
        <script>
            alert("장바구니가 비어 있습니다.");
            location.href = "<%= request.getContextPath() %>/cart/cart.jsp";
        </script>
<%
        return;
    }

    finalPrice = totalPrice + deliveryFee;

    // 3. 주문번호 생성
    String orderSeqSql = "SELECT ORDERS_SEQ.NEXTVAL FROM DUAL";

    pstmt = conn.prepareStatement(orderSeqSql);
    rs = pstmt.executeQuery();

    if (rs.next()) {
        orderId = rs.getInt(1);
    }

    rs.close();
    pstmt.close();

    // 4. ORDERS 저장
    String orderSql =
        "INSERT INTO ORDERS " +
        "(ORDER_ID, MEM_ID, RECEIVER_NAME, RECEIVER_PHONE, RECEIVER_ADDR, DELIVERY_MEMO, PAYMENT, TOTAL_PRICE) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    pstmt = conn.prepareStatement(orderSql);
    pstmt.setInt(1, orderId);
    pstmt.setString(2, memId);
    pstmt.setString(3, receiverName);
    pstmt.setString(4, receiverPhone);
    pstmt.setString(5, receiverAddress);
    pstmt.setString(6, deliveryMemo);
    pstmt.setString(7, payment);
    pstmt.setInt(8, finalPrice);

    pstmt.executeUpdate();
    pstmt.close();

    // 5. 장바구니 다시 조회해서 ORDER_DETAIL 저장
    pstmt = conn.prepareStatement(cartSql);
    pstmt.setString(1, memId);
    rs = pstmt.executeQuery();

    String detailSql =
        "INSERT INTO ORDER_DETAIL " +
        "(DETAIL_ID, ORDER_ID, PRO_ID, PRO_OP_ID, PRO_NAME, PRO_COLOR, PRO_SIZE, QUANTITY, PRO_PRICE, SUM_PRICE) " +
        "VALUES (ORDER_DETAIL_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    detailPstmt = conn.prepareStatement(detailSql);

    while (rs.next()) {
        int proPrice = rs.getInt("PRO_PRICE");
        int cartStock = rs.getInt("CART_STOCK");
        int sumPrice = proPrice * cartStock;

        detailPstmt.setInt(1, orderId);
        detailPstmt.setInt(2, rs.getInt("PRO_ID"));

        // CART의 OPTION_ID를 ORDER_DETAIL의 PRO_OP_ID에 저장
        detailPstmt.setInt(3, rs.getInt("OPTION_ID"));

        detailPstmt.setString(4, rs.getString("PRO_NAME"));
        detailPstmt.setString(5, rs.getString("PRO_COLOR"));
        detailPstmt.setString(6, rs.getString("PRO_SIZE"));
        detailPstmt.setInt(7, cartStock);
        detailPstmt.setInt(8, proPrice);
        detailPstmt.setInt(9, sumPrice);

        detailPstmt.executeUpdate();
    }

    rs.close();
    pstmt.close();
    detailPstmt.close();

    // 6. 주문 완료 후 CART 삭제
    String deleteCartSql = "DELETE FROM CART WHERE MEM_ID = ?";

    pstmt = conn.prepareStatement(deleteCartSql);
    pstmt.setString(1, memId);
    pstmt.executeUpdate();

    // 7. 주문 완료 페이지 이동
    response.sendRedirect("orderComplete.jsp?orderId=" + orderId);

} catch (Exception e) {
    out.println("<h3>주문 처리 오류</h3>");
    out.println("<p>" + e.getMessage() + "</p>");
} finally {
    if (rs != null) try { rs.close(); } catch(Exception e) {}
    if (detailPstmt != null) try { detailPstmt.close(); } catch(Exception e) {}
    if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
    if (conn != null) try { conn.close(); } catch(Exception e) {}
}
%>