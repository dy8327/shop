<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
String orderId = request.getParameter("orderId");
%>

<!doctype html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>주문 완료</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body class="complete-bg">

<%@ include file="/menu.jsp" %>

<main class="complete">
    <div class="complete-card">
        <div class="circle check">✓</div>

        <h1>주문이 완료되었습니다</h1>

        <p>주문번호: <strong><%= orderId %></strong></p>
        <p>주문해주셔서 감사합니다.</p>

        <div style="margin-top:30px;">
            <a class="btn" href="${pageContext.request.contextPath}/index.jsp">메인으로</a>
            <a class="outline" href="${pageContext.request.contextPath}/member/myPage.jsp">마이페이지</a>
        </div>
    </div>
</main>

</body>
</html>