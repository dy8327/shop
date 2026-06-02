<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="dao.OrderDAO" %>
<%@ page import="dto.OrderDetailDTO" %>
<%@ include file="../dbconn.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String orderLoginId = (String) session.getAttribute("memId");

    if (orderLoginId == null) {
%>
    <script>
        alert("로그인 후 주문할 수 있습니다.");
        location.href = "<%= request.getContextPath() %>/member/login.jsp";
    </script>
<%
        return;
    }

    OrderDAO orderDAO = new OrderDAO(conn);
    List<OrderDetailDTO> orderList = new ArrayList<OrderDetailDTO>();

    int totalPrice = 0;
    int deliveryFee = 3000;
    int finalPrice = 0;

    try {
        orderList = orderDAO.getOrderDetailsFromCart(orderLoginId);
        totalPrice = orderDAO.calculateTotalPrice(orderList);

        if (totalPrice > 0) {
            finalPrice = totalPrice + deliveryFee;
        }

    } catch (Exception e) {
        out.println("주문 상품 조회 오류: " + e.getMessage());
    }
%>

<!doctype html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>주문 / 결제</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>

<body class="soft">

<%@ include file="/menu.jsp" %>

<main class="order">

<h1>주문 / 결제</h1>

<form id="orderForm"
      action="${pageContext.request.contextPath}/order/processOrderReady.jsp"
      method="post"
      onsubmit="return prepareOrderSubmit();">

    <div class="order-grid">

        <!-- 왼쪽 영역 -->
        <div>

            <section class="panel">
                <h2>주문 상품</h2>

                <table>
                    <tr>
                        <th>상품</th>
                        <th>옵션</th>
                        <th>수량</th>
                        <th>가격</th>
                        <th>합계</th>
                    </tr>

                    <%
                        if (orderList == null || orderList.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="5">장바구니에 담긴 상품이 없습니다.</td>
                        </tr>
                    <%
                        } else {
                            for (OrderDetailDTO item : orderList) {
                    %>
                        <tr>
                            <td><%= item.getProName() %></td>
                            <td>
                                <%= item.getProColor() %> /
                                <%= item.getProSize() %>
                            </td>
                            <td><%= item.getQuantity() %></td>
                            <td><%= item.getProPrice() %>원</td>
                            <td><%= item.getSumPrice() %>원</td>
                        </tr>
                    <%
                            }
                        }
                    %>

                </table>
            </section>

            <section class="panel">
                <h2>배송 정보</h2>

                <input type="text" name="receiverName" placeholder="받는 사람" required>
                <input type="text" name="receiverPhone" placeholder="연락처" required>

                <div class="address-row">
                    <input type="text"
                           id="postcode"
                           placeholder="우편번호"
                           readonly>

                    <button type="button" onclick="execDaumPostcode()">
                        주소검색
                    </button>
                </div>

                <input type="text"
                       id="address"
                       placeholder="배송 주소"
                       readonly
                       required>

                <input type="text"
                       id="detailAddress"
                       placeholder="상세 주소">

                <input type="hidden"
                       name="receiverAddress"
                       id="receiverAddress">

                <textarea name="deliveryMemo" rows="4" placeholder="배송 요청사항"></textarea>
            </section>

        </div>

        <!-- 오른쪽 영역 -->
        <div>

            <section class="panel">
                <h2>결제 수단</h2>

                <input type="hidden" name="payment" value="CARD">

                <p>카드 결제</p>
                <p style="font-size:13px; color:#777;">
                    다음 단계에서 토스페이먼츠 테스트 결제위젯으로 이동합니다.
                </p>
            </section>

            <section class="panel">
                <h2>결제 금액</h2>

                <p>상품 금액: <%= totalPrice %>원</p>
                <p>배송비: <%= totalPrice > 0 ? deliveryFee : 0 %>원</p>
                <h2>총 결제 금액: <%= finalPrice %>원</h2>

                <input type="hidden" name="totalPrice" value="<%= finalPrice %>">

                <button type="submit" class="button" style="margin-top: 30px">
                    결제하기
                </button>

                <a class="outline wide" href="${pageContext.request.contextPath}/product/cart.jsp">
                    장바구니로 돌아가기
                </a>
            </section>

        </div>

    </div>

</form>

</main>

<%@ include file="/footer.jsp" %>

<script>
function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            document.getElementById("postcode").value = data.zonecode;
            document.getElementById("address").value = data.roadAddress;
            document.getElementById("detailAddress").focus();
        }
    }).open();
}

function prepareOrderSubmit() {
    const address = document.getElementById("address").value.trim();
    const detailAddress = document.getElementById("detailAddress").value.trim();

    if (address === "") {
        alert("주소를 검색해주세요.");
        return false;
    }

    if (detailAddress === "") {
        alert("상세 주소를 입력해주세요.");
        document.getElementById("detailAddress").focus();
        return false;
    }

    document.getElementById("receiverAddress").value =
        address + " " + detailAddress;

    return true;
}
</script>

</body>
</html>

<%
    if (conn != null) try { conn.close(); } catch(Exception e) {}
%>