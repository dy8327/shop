<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link rel="stylesheet"href="../css/style.css">
</head>
<body>
<%@ include file="../menu.jsp" %>

<h1>회원가입</h1>
<form action="processJoin.jsp" method="post">
    <input type="text" name="memId" placeholder="아이디" required>
    <input type="password" name="memPw" placeholder="비밀번호" required>
    <input type="text" name="memName" placeholder="이름" required>
    <input type="text" name="memPhone" placeholder="하이픈(-) 제외하고 숫자만 입력" required>
    <input type="email" name="memEmail" placeholder="이메일" required>
    <button type="submit">가입하기</button> 
</form>

<%@ include file="../footer.jsp" %>

</body>
</html>
