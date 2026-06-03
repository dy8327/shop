<%@ page contentType="text/html; charset=utf-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="dao.OrderDAO" %>
<%@ page import="dto.OrderDetailDTO" %>
<%@ include file="../dbconn.jsp" %>

<%
    String memId = request.getParameter("id");

    List<OrderDetailDTO> orderList = new ArrayList<>();

    try {
        OrderDAO orderDAO = new OrderDAO(conn);
        orderList = orderDAO.getMemberOrderList(memId);
    } catch(Exception e) {
        out.println("<script>alert('주문내역 조회 오류: " + e.getMessage() + "');</script>");
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 주문내역</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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
    if (orderList == null || orderList.size() == 0) {
%>
<tr>
    <td colspan="12" style="text-align:center;">주문내역이 없습니다.</td>
</tr>
<%
    } else {
        for (OrderDetailDTO order : orderList) {
            String orderStatus = order.getOrderStatus();
%>

<tr>
    <td><%=order.getMemName() %></td>
    <td><%=order.getMemId() %></td>
    <td><%=order.getProName() %></td>
    <td><%=order.getProColor() %></td>
    <td><%=order.getProSize() %></td>
    <td><%=order.getQuantity() %></td>
    <td><%=order.getProPrice() %></td>
    <td><%=order.getSumPrice() %></td>
    <td class="delivery-info"><%=order.getReceiverAddr() %></td>
    <td><%=order.getReceiverPhone() %></td>
    <td style="<%="취소요청".equals(orderStatus) ? "color:red; font-weight:900;" : "" %>">
        <%=orderStatus %>
    </td>
    <td><%=order.getOrderDate() %></td>
</tr>

<%
        }
    }

    if (conn != null) 
        conn.close();
%>

</table>
</div>
</body>
</html>