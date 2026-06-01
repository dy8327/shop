<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>

<%
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
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 주문내역</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

<%@ include file="../menu.jsp" %>

<div class="wrap">

    <div class="panel">
        <h1>내 주문내역</h1>
        <p>주문번호 기준으로 주문 상품과 배송 정보를 확인할 수 있습니다.</p>

        <p style="margin-top:20px;">
            <a class="outline" href="${pageContext.request.contextPath}/member/myPage.jsp">
                마이페이지로 돌아가기
            </a>
            <a class="dark" href="${pageContext.request.contextPath}/product/products.jsp">
                쇼핑 계속하기
            </a>
        </p>
    </div>

    <div class="order-table">

        <table>
            <tr>
                <th>주문일</th>
                <th>주문상품</th>
                <th>총 결제금액</th>
                <th>배송지</th>
                <th>연락처</th>
                <th>주문상태</th>
            </tr>

<%
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    String sql =
        "SELECT o.ORDER_ID, " +
        "LISTAGG(d.PRO_NAME || ' / ' || d.PRO_COLOR || ' / ' || d.PRO_SIZE || ' / ' || d.QUANTITY || '개', '<br>') " +
        "WITHIN GROUP (ORDER BY d.PRO_NAME) AS PRODUCT_INFO, " +
        "SUM(d.SUM_PRICE) AS ORDER_SUM_PRICE, " +
        "o.RECEIVER_ADDR, o.RECEIVER_PHONE, o.ORDER_STATUS, o.ORDER_DATE " +
        "FROM ORDERS o " +
        "JOIN ORDER_DETAIL d ON o.ORDER_ID = d.ORDER_ID " +
        "WHERE o.MEM_ID = ? " +
        "GROUP BY o.ORDER_ID, o.RECEIVER_ADDR, o.RECEIVER_PHONE, o.ORDER_STATUS, o.ORDER_DATE " +
        "ORDER BY o.ORDER_DATE DESC, o.ORDER_ID DESC";

    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, memId);
    rs = pstmt.executeQuery();

    boolean hasOrder = false;

    while(rs.next()){
        hasOrder = true;

        int orderId = rs.getInt("ORDER_ID");
        String orderStatus = rs.getString("ORDER_STATUS");
%>

            <tr>
                <td><%= rs.getDate("ORDER_DATE") %></td>
                <td><%= rs.getString("PRODUCT_INFO") %></td>
                <td><strong><%= rs.getInt("ORDER_SUM_PRICE") %>원<br>(배송비 제외)</strong></td>
                <td><%= rs.getString("RECEIVER_ADDR") %></td>
                <td><%= rs.getString("RECEIVER_PHONE") %></td>
                <td>
                    <strong><%= orderStatus %></strong>

<%
        if ("주문완료".equals(orderStatus) || "배송준비중".equals(orderStatus)|| "배송중".equals(orderStatus)
    || "배송완료".equals(orderStatus)) {
%>
                    <form action="${pageContext.request.contextPath}/member/requestCancel.jsp"
                          method="post"
                          style="margin-top:8px;">
                        <input type="hidden" name="orderId" value="<%= orderId %>">

                        <button type="submit"
                                class="cancel-btn"
                                onclick="return confirm('주문 취소를 신청하시겠습니까?');">
                            취소신청
                        </button>
                    </form>
<%
        }
%>
                </td>
            </tr>

<%
    }

    if(!hasOrder){
%>
            <tr>
                <td colspan="6" style="text-align:center; padding:40px;">
                    주문내역이 없습니다.
                </td>
            </tr>
<%
    }

} catch(Exception e){
%>
            <tr>
                <td colspan="6" style="text-align:center; padding:40px; color:red;">
                    주문내역 조회 오류: <%= e.getMessage() %>
                </td>
            </tr>
<%
} finally {
    if(rs != null) try { rs.close(); } catch(Exception e) {}
    if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
    if(conn != null) try { conn.close(); } catch(Exception e) {}
}
%>

        </table>

    </div>

</div>

<%@ include file="../footer.jsp" %>

</body>
</html>