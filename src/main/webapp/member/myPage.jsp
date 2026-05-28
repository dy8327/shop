<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String myId = (String) session.getAttribute("memId");
    String myName = (String) session.getAttribute("memName");
    String myRole = (String) session.getAttribute("memRole");

    if (myId == null) {
%>
        <script>
            alert("로그인이 필요한 페이지입니다.");
            location.href = "<%= request.getContextPath() %>/member/login.jsp";
        </script>
<%
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이 페이지</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<%@ include file="../menu.jsp" %>
<section>
    <h2>내 정보</h2>
    <p>아이디: <%=myId %></p>
    <p>이름: <%=myName %></p>
    <p>회원구분: <%=myRole %></p>
</section>

<hr>

<section>
    <h2>주문내역</h2>
    <p>주문내역 기능은 준비 중입니다.</p>
</section>

<hr>

<section>
    <h2>배송정보</h2>
    <p>배송정보 조회 기능은 준비 중입니다.</p>
</section>

<hr>

<section>
    <h2>비밀번호 변경</h2>
    <p>비밀번호 변경 기능은 준비 중입니다.</p>
</section>

<p>
    <a href="${pageContext.request.contextPath}/product/cart.jsp">장바구니 가기</a>
</p>

<%@ include file="../footer.jsp" %>
</body>
</html>