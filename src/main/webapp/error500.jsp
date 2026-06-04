<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>오류 안내</title>
</head>
<body>
    <h2>일시적인 오류가 발생했습니다.</h2>
    <p>서비스 이용 중 문제가 발생했습니다. 잠시 후 다시 시도해 주세요.</p>

    <a href="<%= request.getContextPath() %>/index.jsp">메인으로 이동</a>
</body>
</html>