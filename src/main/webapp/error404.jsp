<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>페이지 없음</title>
</head>
<body>
    <h2>요청하신 페이지를 찾을 수 없습니다.</h2>
    <p>주소가 잘못되었거나 페이지가 이동되었습니다.</p>

    <a href="<%= request.getContextPath() %>/index.jsp">메인으로 이동</a>
</body>
</html>