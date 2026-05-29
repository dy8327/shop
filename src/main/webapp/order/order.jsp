<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dto.Shop" %>

<%
    String orderloginId = (String) session.getAttribute("memId");

    if (orderloginId == null) {
%>
    <script>
        alert("로그인 후 주문할 수 있습니다.");
        location.href = "<%= request.getContextPath() %>/member/login.jsp";
    </script>
<%
        return;
    }

    ArrayList<Shop> cartList =
        (ArrayList<Shop>) session.getAttribute("cartList");

    int totalPrice = 0;
    int deliveryFee = 3000;
%>

<!doctype html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>주문 / 결제</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body class="soft">

<%@ include file="/menu.jsp" %>

<main class="order">

<h1>주문 / 결제</h1>

<form action="${pageContext.request.contextPath}/order/processOrder.jsp" method="post">

    <div class="order-grid">

        <!-- 왼쪽: 주문 상품 / 배송 정보 -->
        <div>

            <section class="panel">
                <h2>주문 상품</h2>

                <%
                    if (cartList == null || cartList.size() == 0) {
                %>
                    <p>장바구니에 담긴 상품이 없습니다.</p>
                    <a class="btn" href="${pageContext.request.contextPath}/product/products.jsp">
                        상품 보러가기
                    </a>
                <%
                    } else {
                %>

                <table>
                    <tr>
                        <th>상품</th>
                        <th>옵션</th>
                        <th>수량</th>
                        <th>합계</th>
                    </tr>

                    <%
                        for (Shop item : cartList) {
                            int sum = item.getProPrice() * item.getQuantity();
                            totalPrice += sum;
                    %>

                    <tr>
                        <td><%= item.getProName() %></td>
                        <td><%= item.getProColor() %> / <%= item.getProSize() %></td>
                        <td><%= item.getQuantity() %></td>
                        <td><%= sum %>원</td>
                    </tr>

                    <%
                        }
                    %>
                </table>

                <%
                    }
                %>
            </section>

            <section class="panel">
                <h2>배송 정보</h2>

                <input type="text" name="receiverName" placeholder="받는 사람" required>
                <input type="text" name="receiverPhone" placeholder="연락처" required>
                <input type="text" name="receiverAddress" placeholder="배송 주소" required>
                <textarea name="deliveryMemo" rows="4" placeholder="배송 요청사항"></textarea>
            </section>

        </div>

        <!-- 오른쪽: 결제 정보 -->
        <div>

            <section class="panel">
                <h2>결제 수단</h2>

                <p>
                    <label>
                        <input type="radio" name="payment" value="CARD" checked>
                        카드 결제
                    </label>
                </p>

                <p>
                    <label>
                        <input type="radio" name="payment" value="BANK">
                        무통장 입금
                    </label>
                </p>

                <p>
                    <label>
                        <input type="radio" name="payment" value="PHONE">
                        휴대폰 결제
                    </label>
                </p>
            </section>

            <section class="panel">
                <h2>결제 금액</h2>

                <%
                    int finalPrice = totalPrice;

                    if (cartList != null && cartList.size() > 0) {
                        finalPrice = totalPrice + deliveryFee;
                    }
                %>

                <p>상품 금액: <%= totalPrice %>원</p>
                <p>배송비: <%= (cartList == null || cartList.size() == 0) ? 0 : deliveryFee %>원</p>
                <h2>총 결제 금액: <%= finalPrice %>원</h2>

                <input type="hidden" name="totalPrice" value="<%= finalPrice %>">

                <%
                    if (cartList != null && cartList.size() > 0) {
                %>
                    <button type="submit" class="btn wide">결제하기</button>
                <%
                    } else {
                %>
                    <button type="button" class="btn wide" disabled>결제 불가</button>
                <%
                    }
                %>

                <a class="outline wide" href="${pageContext.request.contextPath}/cart/cart.jsp">
                    장바구니로 돌아가기
                </a>
            </section>

        </div>

    </div>

</form>

</main>

<%@ include file="/footer.jsp" %>

</body>
</html>