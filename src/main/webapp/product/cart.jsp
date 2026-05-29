<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dto.Shop" %>

<%
ArrayList<Shop> cartList =
(ArrayList<Shop>)session.getAttribute("cartList");

if(cartList == null){
    cartList = new ArrayList<Shop>();
}

int totalPrice = 0;
%>

<!doctype html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<title>장바구니</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body class="soft">

<%--<!-- HEADER -->
<header class="nav purple">
    <b>COSMIC MALL</b>
    <span class="right">⌕ ♡ 🛒</span>
</header>--%>

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
    <th>삭제</th> <!-- ⭐ 추가 -->
</tr>

<%
for(Shop item : cartList){

    int sum = item.getProPrice() * item.getQuantity();
    totalPrice += sum;
%>

<tr>

    <!-- 상품명 -->
    <td><%= item.getProName() %></td>

    <!-- 옵션 -->
    <td>
        <%= item.getProColor() %> / <%= item.getProSize() %>
    </td>

    <!-- 수량 -->
    <td>
        <a href="#">-</a>
        <%= item.getQuantity() %>
        <a href="#">+</a>
    </td>

    <!-- 가격 -->
    <td><%= item.getProPrice() %>원</td>

    <!-- 합계 -->
    <td><%= sum %>원</td>

    <!-- ⭐ 개별 삭제 -->
  <td>
   <a href="removeCart.jsp?proId=<%=item.getProId()%>&proOpId=<%=item.getProOpId()%>"
      onclick="return confirm('삭제하시겠습니까?')">

        삭제
   </a>
</td>

</tr>

<%
}
%>

</table>

<!-- 총합 -->
<div class="cart-total">
    <h2>총 합계 <%= totalPrice %>원</h2>

    <a class="btn" href="order.jsp">주문하기</a>

    <!-- ⭐ 전체 삭제 -->
    <a class="btn dark" href="deleteCart.jsp"
       onclick="return confirm('장바구니를 전체 삭제하시겠습니까?')">
        전체삭제
    </a>
</div>

</main>

<%@ include file="/footer.jsp" %>

</body>
</html>

