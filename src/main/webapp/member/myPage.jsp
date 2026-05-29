<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String myId = (String) session.getAttribute("memId");
    String myName = (String) session.getAttribute("memName");
    String myGrade = (String) session.getAttribute("memGrade");

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

<div class="mypage-wrap">

    <div class="mypage-hero">
        <p class="mypage-label">MY PAGE</p>
        <h1><%= myName %>님의 마이페이지</h1>
        <p>회원 정보와 주문/배송 정보를 확인할 수 있습니다.</p>
    </div>

    <div class="mypage-grid">

        <section class="mypage-card profile-card">
            <h2>내 정보</h2>
            <div class="profile-info">
                <p><span>아이디</span><strong><%=myId %></strong></p>
                <p><span>이름</span><strong><%=myName %></strong></p>
                <p><span>회원구분</span><strong><%=myGrade %></strong></p>
            </div>
        </section>

        <section class="mypage-card">
            <h2>주문내역</h2>
            <p>주문내역 기능은 준비 중입니다.</p>
            <a class="mypage-btn" href="#">주문내역 보기</a>
        </section>

        <section class="mypage-card">
            <h2>배송정보</h2>
            <p>배송정보 조회 기능은 준비 중입니다.</p>
            <a class="mypage-btn" href="#">배송정보 확인</a>
        </section>

        <section class="mypage-card">
            <h2>비밀번호 변경</h2>
            <p>비밀번호 변경 기능은 준비 중입니다.</p>
            <a class="mypage-btn outline-btn" href="#">비밀번호 변경</a>
        </section>

    </div>

    <div class="mypage-bottom">
        <a href="${pageContext.request.contextPath}/product/cart.jsp">장바구니 가기</a>
        <a href="${pageContext.request.contextPath}/index.jsp">메인으로 돌아가기</a>
    </div>

</div>

<%@ include file="../footer.jsp" %>

</body>
</html>