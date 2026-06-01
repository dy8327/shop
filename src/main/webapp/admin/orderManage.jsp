<%@ page contentType="text/html; charset=utf-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 주문내역 조회</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

</head>

<body>

<%@ include file="/admin/adminMenu.jsp" %>

<div class="admin-wrap">

<h1>회원 주문내역</h1>
<p class="admin-subtitle">Member Order List</p>

<table class="admin-table">

<tr>
    <th>주문번호</th>
    <th>회원명</th>
    <th>회원ID</th>
    <th>상품명</th>
    <th>합계금액</th>
    <th>상태</th>   
    <th>주문일</th>
    <th>상세보기</th>
</tr>

<%
PreparedStatement pstmt = null;
ResultSet rs = null;

try {

String sql =
    "SELECT " +
    "o.ORDER_ID, m.MEM_NAME, o.MEM_ID, " +
    "MIN(d.PRO_NAME) AS PRO_NAME, " +
    "COUNT(d.PRO_ID) AS PRODUCT_COUNT, " +
    "o.TOTAL_PRICE, o.ORDER_STATUS, o.ORDER_DATE " +
    "FROM ORDERS o " +
    "JOIN MEMBERS m ON o.MEM_ID = m.MEM_ID " +
    "JOIN ORDER_DETAIL d ON o.ORDER_ID = d.ORDER_ID " +
    "GROUP BY o.ORDER_ID, m.MEM_NAME, o.MEM_ID, o.TOTAL_PRICE, o.ORDER_STATUS, o.ORDER_DATE " +
    "ORDER BY o.ORDER_ID DESC";

    pstmt = conn.prepareStatement(sql);
    rs = pstmt.executeQuery();

    while(rs.next()){
%>

<tr>
    <td><%=rs.getString("ORDER_ID") %></td>
    <td><%=rs.getString("MEM_NAME") %></td>
    <td><%=rs.getString("MEM_ID") %></td>
    <td>
<%
    String proName = rs.getString("PRO_NAME");
    int productCount = rs.getInt("PRODUCT_COUNT");

    if (productCount > 1) {
%>
        <%=proName %> 외 <%=productCount - 1 %>개
<%
    } else {
%>
        <%=proName %>
<%
    }
%>
</td>
    <td><%=String.format("%,d", rs.getInt("TOTAL_PRICE")) %>원</td>
    <td><%=rs.getString("ORDER_STATUS") %></td>
    <td><%=rs.getDate("ORDER_DATE") %></td>
    <td>
    <a class="admin-btn small"
       href="<%=request.getContextPath() %>/admin/orderDetail.jsp?orderId=<%=rs.getInt("ORDER_ID") %>">
        상세
    </a>
</td>
</tr>

<%
    }

} catch(Exception e){
    out.println("<tr><td colspan='12'>주문내역 조회 오류: " + e.getMessage() + "</td></tr>");
} finally {
    if(rs != null) rs.close();
    if(pstmt != null) pstmt.close();
    if(conn != null) conn.close();
}
%>

</table>

</div>
</body>
</html>