<%@ page contentType="text/html; charset=utf-8" pageEncoding="UTF-8" %>
<%@ page import="dto.OrderDTO" %>
<%@ page import="java.util.*" %>
<%@ page import="service.OrderService" %>
<%@ include file="../dbconn.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    List<OrderDTO> orderList = new ArrayList<>();
    String errorMessage = null;

    try {
        OrderService orderService = new OrderService();
        orderList = orderService.getAdminOrderList(conn);

    } catch (Exception e) {
        errorMessage = "주문내역 조회 오류: " + e.getMessage();

    } finally {
        if (conn != null) conn.close();
    }
%>

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
    if (errorMessage != null) {
%>
        <tr>
            <td colspan="8"><%= errorMessage %></td>
        </tr>
<%
    } else if (orderList.size() == 0) {
%>
        <tr>
            <td colspan="8">주문내역이 없습니다.</td>
        </tr>
<%
    } else {
        for (OrderDTO order : orderList) {
%>

<tr>
    <td><%= order.getOrderId() %></td>
    <td><%= order.getMemName() %></td>
    <td><%= order.getMemId() %></td>
    <td><%= order.getDisplayProductName() %></td>
    <td><%= String.format("%,d", order.getTotalPrice()) %>원</td>
    <td><%= order.getOrderStatus() %></td>
    <td><%= order.getOrderDate() %></td>
    <td>
        <a class="admin-btn small"
           href="<%= request.getContextPath() %>/admin/orderDetail.jsp?orderId=<%= order.getOrderId() %>">
            상세
        </a>
    </td>
</tr>

<%
        }
    }
%>

</table>

</div>
</body>
</html> -