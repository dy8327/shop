<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.CartDAO" %>
<%@ page import="dto.CartItem" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="../dbconn.jsp" %>

<%
String memId = (String) session.getAttribute("memId");

if (memId == null) {
    response.sendRedirect(request.getContextPath() + "/member/login.jsp");
    return;
}

int totalPrice = 0;
ArrayList<CartItem> cartList = null;

try {
    CartDAO dao = new CartDAO(conn);
    cartList = dao.getCartList(memId);
} catch (Exception e) {
    out.println("장바구니 조회 오류: " + e.getMessage());
}
%>

<!doctype html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>장바구니</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body class="soft">

<%@ include file="/menu.jsp" %>

<main class="wrap">

<h1>장바구니</h1>

<table>
<tr>
    <th>상품</th>
    <th>옵션</th>
    <th>수량</th>
    <th>가격</th>
    <th>합계</th>
    <th>삭제</th> 
</tr>

<%
if (cartList == null || cartList.size() == 0) {
%>
    <tr>
        <td colspan="6" style="text-align:center; padding: 60px 0; color: #77689d;">
            장바구니에 담긴 내역이 존재하지 않습니다.
        </td>
    </tr>
<%
} else {
    for (CartItem item : cartList) {
        int sum = item.getProPrice() * item.getCartQty();
        totalPrice += sum;
%>

<tr>
    <td><%= item.getProName() %></td>

    <td><%= item.getProColor() %> / <%= item.getProSize() %></td>

    <td>
        <a href="${pageContext.request.contextPath}/cart/updateCartQty.jsp?cartId=<%= item.getCartId() %>&action=down">-</a>
        <%= item.getCartQty() %>
        <a href="${pageContext.request.contextPath}/cart/updateCartQty.jsp?cartId=<%= item.getCartId() %>&action=up">+</a>
    </td>

    <td><%= item.getProPrice() %>원</td>

    <td><%= sum %>원</td>

    <td>
       <a href="${pageContext.request.contextPath}/cart/removeCart.jsp?cartId=<%= item.getCartId() %>"
          onclick="return confirm('삭제하시겠습니까?')">삭제</a>
    </td>
</tr>

<%
    }
}
%>

</table>

<div class="cart-total">
    <h2>총 합계 <%= totalPrice %>원</h2>

    <a class="btn" href="${pageContext.request.contextPath}/order/order.jsp">주문하기</a>

    <a class="btn dark" href="${pageContext.request.contextPath}/cart/deleteCart.jsp"
       onclick="return confirm('장바구니를 전체 삭제하시겠습니까?')">
        전체삭제
    </a>
</div>

</main>

<%@ include file="../footer.jsp" %>

<%
if (conn != null) try { conn.close(); } catch(Exception e) {}
%>

</body>
</html>