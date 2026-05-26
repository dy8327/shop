<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String memId = request.getParameter("memId");

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    boolean isDuplicate = false;

    try {
        if (memId == null || memId.trim().equals("")) {
%>
            <script>
                alert("아이디를 입력하세요.");
                window.close();
            </script>
<%
            return;
        }

        memId = memId.trim();

        String sql = "SELECT COUNT(*) FROM MEMBERS WHERE MEM_ID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, memId);

        rs = pstmt.executeQuery();

        if (rs.next()) {
            int count = rs.getInt(1);

            if (count > 0) {
                isDuplicate = true;
            }
        }

    } catch (Exception e) {
        out.println("아이디 중복확인 오류: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
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
    if (isDuplicate) {
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