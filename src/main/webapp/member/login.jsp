<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 완료</title>
<link rel="stylesheet"href="../css/style.css">
</head>
<body>
<%@ include file="../menu.jsp" %>


<form action="${pageContext.request.contextPath}/member/processLogin.jsp" method="post">
    <input type="text" name="memId" placeholder="아이디" required>아이디<br>
    <input type="password" name="memPw" placeholder="비밀번호" required>비밀번호<br>
    <button type="submit">로그인</button> 
</form>
    <p> 아직 SSU 가족이 아니신가요?<br>회원가입을 눌러주세요.</p>
    <a href="${pageContext.request.contextPath}/member/join.jsp">회원가입</a>
<%@ include file="../footer.jsp" %>

</body>
</html>
