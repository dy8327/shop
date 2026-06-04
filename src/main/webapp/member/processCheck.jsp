<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../dbconn.jsp" %>
<%@ page import="service.MemberService" %>

<%
    request.setCharacterEncoding("UTF-8");

    String memId = request.getParameter("memId");
    boolean isDuplicate = false;
    String errorMessage = null;

    MemberService memberService = new MemberService();

    try {
        isDuplicate = memberService.isDuplicateId(conn, memId);
        memId = memId.trim();

    } catch (IllegalArgumentException e) {
        errorMessage = e.getMessage();

    } catch (Exception e) {
        errorMessage = "아이디 중복확인 오류가 발생했습니다.";

    } finally {
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 중복확인</title>
</head>
<body>

<%
    if (errorMessage != null) {
%>
        <h3><%= errorMessage %></h3>
        <button type="button" onclick="window.close();">닫기</button>
<%
    } else if (isDuplicate) {
%>
        <h3>이미 사용 중인 아이디입니다.</h3>
        <p>다른 아이디를 입력해주세요.</p>
        <button type="button" onclick="window.close();">닫기</button>
<%
    } else {
%>
        <h3>사용 가능한 아이디입니다.</h3>
        <p><strong><%= memId %></strong> 는 사용할 수 있습니다.</p>

        <button type="button" onclick="useId();">이 아이디 사용하기</button>

        <script>
            function useId() {
                opener.document.getElementById("memId").value = "<%= memId %>";
                opener.document.getElementById("idChecked").value = "Y";
                window.close();
            }
        </script>
<%
    }
%>

</body>
</html>