<%@ page contentType="text/html; charset=utf-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>

<%
    String memId = request.getParameter("id"); // 회원ID
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 주문내역</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

<style>
.admin-table{
    width:100%;
    border-collapse:collapse;
    background:#fff;
    margin-top:20px;
}
.admin-table th,
.admin-table td{
    border:1px solid #ddd;
    padding:12px;
    text-align:center;
}
.admin-table th{
    background:#f5f5f5;
}
.delivery-info{
    font-size:0.9em;
    color:#555;
    line-height:1.5;
}
</style>

</head>

<body>

<%@ include file="/admin/adminMenu.jsp" %>

<div class="admin-wrap">

<h1>회원 주문내역</h1>
<p class="admin-subtitle">Member Order List</p>

<table class="admin-table">

<tr>
    <th>회원명</th>
    <th>회원ID</th>
    <th>상품명</th>
    <th>컬러</th>
    <th>사이즈</th>
    <th>수량</th>
    <th>단가</th>
    <th>합계금액</th>
    <th>주소</th>
    <th>연락처</th>
    <th>배송여부</th>
    <th>주문일</th>
</tr>

<%
PreparedStatement pstmt = null;
ResultSet rs = null;

try {

    String sql =
        "SELECT m.MEM_ID, m.MEM_NAME, " +
        "d.PRO_NAME, d.PRO_COLOR, d.PRO_SIZE, d.QUANTITY, d.PRO_PRICE, d.SUM_PRICE, " +
        "o.RECEIVER_ADDR, o.RECEIVER_PHONE, o.ORDER_STATUS, o.ORDER_DATE " +
        "FROM ORDERS o " +
        "JOIN ORDER_DETAIL d ON o.ORDER_ID = d.ORDER_ID " +
        "JOIN MEMBERS m ON o.MEM_ID = m.MEM_ID " +
        "WHERE o.MEM_ID = ? " +
        "ORDER BY o.ORDER_DATE DESC";

    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, memId);
    rs = pstmt.executeQuery();

    while(rs.next()){
%>

<tr>
    <td><%= rs.getString("MEM_NAME") %></td>
    <td><%= rs.getString("MEM_ID") %></td>

    <td><%= rs.getString("PRO_NAME") %></td>

    <td><%= rs.getString("PRO_COLOR") %></td>
    <td><%= rs.getString("PRO_SIZE") %></td>

    <td><%= rs.getInt("QUANTITY") %></td>
    <td><%= rs.getInt("PRO_PRICE") %></td>
    <td><%= rs.getInt("SUM_PRICE") %></td>

    <td class="delivery-info">
        <%= rs.getString("RECEIVER_ADDR") %>
    </td>

    <td>
        <%= rs.getString("RECEIVER_PHONE") %>
    </td>

    <td>
        <%= rs.getString("ORDER_STATUS") %>
    </td>

    <td>
        <%= rs.getDate("ORDER_DATE") %>
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