<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="../menu.jsp" %>

<main class="join-container">
    <h1>회원가입</h1>
    <form class="join-form" action="processJoin.jsp" method="post">
        <div class="form-group">
            <label for="memId">ID</label>
            <input type="text" id="memId" name="memId" placeholder="아이디" oninput="resetIdCheck();">
            <button type="button" onclick="checkId();">중복확인</button>
            <input type="hidden" name="idChecked" id="idChecked" value="N">
        </div>
        <div class="form-group">
            <label for="memPw">비밀번호</label>
            <input type="password" id="memPw" name="memPw" placeholder="비밀번호" required>
        </div>
        <div class="form-group">
            <label for="memName">이름</label>
            <input type="text" id="memName" name="memName" placeholder="이름" required>
        </div>
        <div class="form-group">
            <label for="memPhone">전화번호</label>
            <input type="text" id="memPhone" name="memPhone" placeholder="하이픈(-) 제외하고 숫자만 입력" required>
        </div>
        <div class="form-group">
            <label for="memEmail">E-mail</label>
            <input type="email" id="memEmail" name="memEmail" placeholder="이메일" required>
        </div>
        <button type="submit" class="join-btn">가입하기</button> 
        <script>
    function checkId() {
    const memId = document.getElementById("memId").value.trim();

    if (memId === "") {
        alert("아이디를 입력하세요.");
        document.getElementById("memId").focus();
        return;
    }

    window.open(
        "processCheck.jsp?memId=" + encodeURIComponent(memId),
        "idCheck",
        "width=400,height=250"
    );
}

function resetIdCheck() {
    document.getElementById("idChecked").value = "N";
}

function validateJoin() {
    const memId = document.getElementById("memId").value.trim();
    const memPw = document.getElementById("memPw").value.trim();
    const memName = document.getElementById("memName").value.trim();
    const memEmail = document.getElementById("memEmail").value.trim();
    const idChecked = document.getElementById("idChecked").value;

    if (memId === "") {
        alert("아이디를 입력하세요.");
        return false;
    }

    if (idChecked !== "Y") {
        alert("아이디 중복확인을 해주세요.");
        return false;
    }

    if (memPw === "") {
        alert("비밀번호를 입력하세요.");
        return false;
    }

    if (memName === "") {
        alert("이름을 입력하세요.");
        return false;
    }

    if (memEmail === "") {
        alert("이메일을 입력하세요.");
        return false;
    }

    if (!memEmail.includes("@")) {
        alert("이메일 형식이 올바르지 않습니다.");
        return false;
    }

    return true;
}
</script>
    </form>
</main>

<%@ include file="../footer.jsp" %>

</body>
</html>
