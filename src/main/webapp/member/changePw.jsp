<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
String memId = (String)session.getAttribute("memId");

if(memId == null){
%>
<script>
alert("로그인이 필요합니다.");
location.href="<%=request.getContextPath()%>/member/login.jsp";
</script>
<%
return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 변경</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<%@ include file="../menu.jsp" %>

<div class="join-container">

<h1>비밀번호 변경</h1>

<form action="${pageContext.request.contextPath}/member/processChangePw.jsp"
      method="post"
      class="join-form">

    <div class="form-group">
        <label>현재 비밀번호</label>
        <input type="password"
               name="currentPw"
               required>
    </div>

    <div class="form-group">
        <label>현재 비밀번호 확인</label>
        <input type="password"
               name="currentPwCheck"
               required>
    </div>

    <div class="form-group">
        <label>새 비밀번호</label>
        <input type="password"
               name="newPw"
               required>
    </div>

    <button type="submit"
            class="join-btn">
        비밀번호 변경
    </button>

</form>

</div>

<%@ include file="../footer.jsp" %>

</body>
</html>