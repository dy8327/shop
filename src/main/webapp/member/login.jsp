<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link rel="stylesheet"href="../css/style.css">
</head>
<body>
<%@ include file="../menu.jsp" %>
<main class="join-container">
    <h1>로그인</h1>
    <form class="join-form" action="processLogin.jsp" method="post">
        <div class="form-group">
            <label for="memId">ID</label>
            <input type="text" id="memId" name="memId" placeholder="아이디">
        </div>
        <div class="form-group">
            <label for="memPw">비밀번호</label>
            <input type="password" id="memPw" name="memPw" placeholder="비밀번호" required>
        </div>
        <button type="submit" class="join-btn">로그인</button>
    </form>
    <p> 아직 SSU 가족이 아니신가요?<br>회원가입을 눌러주세요.</p>
    <a href="${pageContext.request.contextPath}/member/join.jsp">회원가입</a>
</main>
<%@ include file="../footer.jsp" %>

</body>
</html>
