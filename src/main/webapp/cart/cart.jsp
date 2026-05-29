<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>

<%
// 세션 기반 로그인 아이디 검증 (여기서도 본인의 로그인 세션 변수명에 맞춤 필수)
String memId = (String) session.getAttribute("memId");
if (memId == null) {
    response.sendRedirect(request.getContextPath() + "/member/login.jsp"); // 로그인하지 않았다면 로그인 홈으로 튕겨냅니다.
    return;
}

PreparedStatement pstmt = null;
ResultSet rs = null;
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
try {
    // 생성하신 테이블에 맞추어 CARTId, 상품명, 고유단가, 선택한 컬러명, 사이즈명, 누적수량을 조인 연산 처리합니다.
    String sql = "SELECT C.CART_ID, P.PRO_NAME, P.PRO_PRICE, O.OPTION_ID, O.PRO_COLOR, O.PRO_SIZE, C.CART_QTY " +
                 "FROM CART C " +
                 "JOIN PRODUCTS P ON C.PRO_ID = P.PRO_ID " +
                 "JOIN PRO_OPTION O ON C.OPTION_ID = O.OPTION_ID " +
                 "WHERE C.MEM_ID = ? " +
                 "ORDER BY C.CREATE_DATE DESC";
                 
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, memId);
    rs = pstmt.executeQuery();

    boolean hasItems = false;
    while(rs.next()) {
        hasItems = true;
        int cartId = rs.getInt("CART_ID");
        String proName = rs.getString("PRO_NAME");
        int proPrice = rs.getInt("PRO_PRICE");
        String color = rs.getString("PRO_COLOR");
        String size = rs.getString("PRO_SIZE");
        int quantity = rs.getInt("CART_QTY");

        int sum = proPrice * quantity;
        totalPrice += sum;
%>

<tr>
    <td><%=proName %></td>

    <td><%=color %> / <%=size %></td>

    <td>
        <a href="updateCartQty.jsp?cartId=<%=cartId %>&action=down">-</a>
        <%=quantity %>
        <a href="updateCartQty.jsp?cartId=<%=cartId %>&action=up">+</a>
    </td>

    <td><%= proPrice %>원</td>

    <td><%= sum %>원</td>

    <td>
       <a href="${pageContext.request.contextPath}/cart/removeCart.jsp?cartId=<%=cartId %>" onclick="return confirm('삭제하시겠습니까?')">삭제</a>
    </td>
</tr>

<%
    }
    if(!hasItems) {
%>
    <tr>
        <td colspan="6" style="text-align:center; padding: 60px 0; color: #77689d;">
            장바구니에 담긴 내역이 존재하지 않습니다.
        </td>
    </tr>
<%
    }
} catch(Exception e) {
    out.println("<tr><td colspan='6'>데이터 로드 중 장애 발생: " + e.getMessage() + "</td></tr>");
} finally {
    if(rs != null) rs.close();
    if(pstmt != null) pstmt.close();
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

</body>
</html>