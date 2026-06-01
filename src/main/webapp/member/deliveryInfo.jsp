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
<title>배송정보 확인</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

<%@ include file="../menu.jsp" %>

<div class="order-wrap">

<h1>배송정보 확인</h1>
<p>주문별 배송 상태를 확인할 수 있습니다.</p>

<table class="order-table">
<tr>
    <th>주문일</th>
    <th>주문번호</th>
    <th>상품명</th>
    <th>받는사람</th>
    <th>연락처</th>
    <th>배송지</th>
    <th>배송메모</th>
    <th>배송상태</th>
</tr>

<%
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    String sql =
        "SELECT o.ORDER_ID, o.ORDER_DATE, o.RECEIVER_NAME, " +
        "o.RECEIVER_PHONE, o.RECEIVER_ADDR, o.DELIVERY_MEMO, " +
        "o.ORDER_STATUS, d.PRO_NAME " +
        "FROM ORDERS o " +
        "JOIN ORDER_DETAIL d ON o.ORDER_ID = d.ORDER_ID " +
        "WHERE o.MEM_ID = ? " +
        "ORDER BY o.ORDER_DATE DESC";

    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, memId);
    rs = pstmt.executeQuery();

    boolean hasDelivery = false;

    while (rs.next()) {
        hasDelivery = true;

        String orderStatus = rs.getString("ORDER_STATUS");
        String memo = rs.getString("DELIVERY_MEMO");

        if (memo == null || memo.trim().equals("")) {
            memo = "배송메모 없음";
        }
%>

<tr>
    <td><%= rs.getDate("ORDER_DATE") %></td>
    <td><%= rs.getInt("ORDER_ID") %></td>
    <td><%= rs.getString("PRO_NAME") %></td>
    <td><%= rs.getString("RECEIVER_NAME") %></td>
    <td><%= rs.getString("RECEIVER_PHONE") %></td>
    <td><%= rs.getString("RECEIVER_ADDR") %></td>
    <td><%= memo %></td>
    <td><strong><%= orderStatus %></strong></td>
</tr>

<%
    }

    if (!hasDelivery) {
%>
<tr>
    <td colspan="8" class="empty">배송정보가 없습니다.</td>
</tr>
<%
    }

} catch(Exception e) {
    out.println("<tr><td colspan='8'>배송정보 조회 오류: " + e.getMessage() + "</td></tr>");
} finally {
    if(rs != null) try { rs.close(); } catch(Exception e) {}
    if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
    if(conn != null) try { conn.close(); } catch(Exception e) {}
}
%>

</table>

<p style="margin-top:30px;">
    <a href="${pageContext.request.contextPath}/member/myPage.jsp">마이페이지로 돌아가기</a>
</p>

</div>

<%@ include file="../footer.jsp" %>

</body>
</html>