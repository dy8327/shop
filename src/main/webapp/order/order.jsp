<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>

<%
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

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    int totalPrice = 0;
    int deliveryFee = 3000;

    String sql =
        "SELECT " +
        "C.CART_ID, C.MEM_ID, C.PRO_ID, C.OPTION_ID, C.CART_QTY, " +
        "P.PRO_NAME, P.PRO_PRICE, P.PRO_IMG, " +
        "O.PRO_SIZE, O.PRO_COLOR, O.PRO_STOCK " +
        "FROM CART C " +
        "JOIN PRODUCTS P ON C.PRO_ID = P.PRO_ID " +
        "JOIN PRO_OPTION O ON C.OPTION_ID = O.OPTION_ID " +
        "WHERE C.MEM_ID = ?";
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

<form action="${pageContext.request.contextPath}/order/processOrder.jsp" method="post">

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
                        try {
                            pstmt = conn.prepareStatement(sql);
                            pstmt.setString(1, orderLoginId);
                            rs = pstmt.executeQuery();

                            boolean hasCart = false;

                            while (rs.next()) {
                                hasCart = true;

                                int proPrice = rs.getInt("PRO_PRICE");
                                int cartQty = rs.getInt("CART_QTY");
                                int sumPrice = proPrice * cartQty;

                                totalPrice += sumPrice;
                    %>

                    <tr>
                        <td><%= rs.getString("PRO_NAME") %></td>
                        <td>
                            <%= rs.getString("PRO_COLOR") %> /
                            <%= rs.getString("PRO_SIZE") %>
                        </td>
                        <td><%=cartQty %></td>
                        <td><%=proPrice %>원</td>
                        <td><%=sumPrice %>원</td>
                    </tr>

                    <%
                            }

                            if (!hasCart) {
                    %>
                    <tr>
                        <td colspan="5">장바구니에 담긴 상품이 없습니다.</td>
                    </tr>
                    <%
                            }

                        } catch (Exception e) {
                            out.println("<tr><td colspan='5'>주문 상품 조회 오류: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if (rs != null) try { rs.close(); } catch(Exception e) {}
                            if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
                        }
                    %>

                </table>
            </section>

            <section class="panel">
                <h2>배송 정보</h2>

                <input type="text" name="receiverName" placeholder="받는 사람" required>
                <input type="text" name="receiverPhone" placeholder="연락처" required>
                <div class="address-row">
                   <input type="text" id="postcode"
                       placeholder="우편번호" readonly>

                   <button type="button"
                       onclick="execDaumPostcode()">
                   주소검색
                   </button>
                </div>

                <input type="text"
                       id="address"
                       name="receiverAddress"
                       placeholder="배송 주소"
                       readonly
                       required>

                <input type="text"
                       id="detailAddress"
                       placeholder="상세 주소">

                <textarea name="deliveryMemo" rows="4" placeholder="배송 요청사항"></textarea>
            </section>

        </div>

        <!-- 오른쪽 영역 -->
        <div>

            <section class="panel">
                <h2>결제 수단</h2>

            <div class="payment-list">
                <label class="payment-option">
                    <input type="radio" name="payment" value="CARD" checked>
                    <span>카드 결제</span>
                </label>

                <label class="payment-option">
                    <input type="radio" name="payment" value="BANK">
                    <span>무통장 입금</span>
                </label>

                <label class="payment-option">
                    <input type="radio" name="payment" value="PHONE">
                    <span>휴대폰 결제</span>
                </label>
            </div>
        </section>

            <section class="panel">
                <h2>결제 금액</h2>

                <%
                    int finalPrice = totalPrice;

                    if (totalPrice > 0) {
                        finalPrice = totalPrice + deliveryFee;
                    }
                %>

                <p>상품 금액: <%= totalPrice %>원</p>
                <p>배송비: <%= totalPrice > 0 ? deliveryFee : 0 %>원</p>
                <h2>총 결제 금액: <%= finalPrice %>원</h2>

                <input type="hidden" name="totalPrice" value="<%= finalPrice %>">

                <%
                    if (totalPrice > 0) {
                %>
                    <button type="submit" class="btn wide">결제하기</button>
                <%
                    } else {
                %>
                    <button type="button" class="btn wide" disabled>결제 불가</button>
                <%
                    }
                %>

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

            document.getElementById("postcode").value =
                data.zonecode;

            document.getElementById("address").value =
                data.roadAddress;

            document.getElementById("detailAddress").focus();
        }
    }).open();
}

</script>

</body>
</html>

<%
    if (conn != null) try { conn.close(); } catch(Exception e) {}
%>