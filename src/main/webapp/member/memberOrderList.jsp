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

<div class="order-wrap">

<h1>내 주문내역</h1>
<p>내가 주문한 상품 목록입니다.</p>

<table class="order-table">
<tr>
    <th>상품명</th>
    <th>컬러</th>
    <th>사이즈</th>
    <th>수량</th>
    <th>단가</th>
    <th>합계금액</th>
    <th>배송지</th>
    <th>연락처</th>
    <th>주문상태</th>
    <th>주문일</th>
</tr>

<%
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    String sql =
        "SELECT d.PRO_NAME, d.PRO_COLOR, d.PRO_SIZE, d.QUANTITY, " +
        "d.PRO_PRICE, d.SUM_PRICE, " +
        "o.RECEIVER_ADDR, o.RECEIVER_PHONE, o.ORDER_STATUS, o.ORDER_DATE " +
        "FROM ORDERS o " +
        "JOIN ORDER_DETAIL d ON o.ORDER_ID = d.ORDER_ID " +
        "WHERE o.MEM_ID = ? " +
        "ORDER BY o.ORDER_DATE DESC";

    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, memId);
    rs = pstmt.executeQuery();

    boolean hasOrder = false;

    while(rs.next()){
        hasOrder = true;
%>

<tr>
    <td><%= rs.getString("PRO_NAME") %></td>
    <td><%= rs.getString("PRO_COLOR") %></td>
    <td><%= rs.getString("PRO_SIZE") %></td>
    <td><%= rs.getInt("QUANTITY") %></td>
    <td><%= rs.getInt("PRO_PRICE") %>원</td>
    <td><%= rs.getInt("SUM_PRICE") %>원</td>
    <td><%= rs.getString("RECEIVER_ADDR") %></td>
    <td><%= rs.getString("RECEIVER_PHONE") %></td>
    <td><%= rs.getString("ORDER_STATUS") %></td>
    <td><%= rs.getDate("ORDER_DATE") %></td>
</tr>

<%
    }

    if(!hasOrder){
%>
<tr>
    <td colspan="10" class="empty">주문내역이 없습니다.</td>
</tr>
<%
    }

} catch(Exception e){
    out.println("<tr><td colspan='10'>주문내역 조회 오류: " + e.getMessage() + "</td></tr>");
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