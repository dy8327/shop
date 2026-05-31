<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconn.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String keyword = request.getParameter("keyword");
    if (keyword == null) {
        keyword = "";
    }

    keyword = keyword.trim();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 검색</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<%@ include file="menu.jsp" %>

<section class="wrap">
    <div class="title">
        <div>
            <h2>검색 결과</h2>
            <p>
                검색어:
                <strong><%= keyword %></strong>
            </p>
        </div>
    </div>

<%
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    boolean hasResult = false;

    if (keyword.equals("")) {
%>
        <div class="panel">
            <p>검색어를 입력해주세요.</p>
        </div>
<%
    } else {
        try {
            String sql = "SELECT * FROM PRODUCTS WHERE PRO_NAME LIKE ? ORDER BY PRO_ID DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");

            rs = pstmt.executeQuery();
%>

    <div class="grid">

<%
            while (rs.next()) {
                hasResult = true;
%>
        <div class="card">
            <a href="${pageContext.request.contextPath}/product/product.jsp?proId=<%= rs.getInt("PRO_ID") %>">
                <div class="img">
                    <img src="${pageContext.request.contextPath}/images/<%= rs.getString("PRO_IMG") %>"
                         alt="<%= rs.getString("PRO_NAME") %>">
                </div>
                <h3><%= rs.getString("PRO_NAME") %></h3>
                <p><%= rs.getInt("PRO_PRICE") %>원</p>
            </a>
        </div>
<%
            }
%>

    </div>

<%
            if (!hasResult) {
%>
        <div class="panel">
            <p>검색 결과가 없습니다.</p>
        </div>
<%
            }

        } catch (Exception e) {
%>
        <div class="panel">
            <p>검색 중 오류가 발생했습니다: <%= e.getMessage() %></p>
        </div>
<%
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }
%>

</section>

<%@ include file="footer.jsp" %>

</body>
</html>