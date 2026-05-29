<%@ page contentType="text/html; charset=utf-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 편집</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<%
    String edit = request.getParameter("edit");
%>

<body>

<%@ include file="/admin/adminMenu.jsp" %>

<div class="admin-wrap">
    <h1>상품 편집</h1>
    <p class="admin-subtitle">Product Editing</p>

    <div class="admin-product-grid">

    <%
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            String sql = "SELECT p.PRO_ID, p.PRO_NAME, p.PRO_PRICE, p.PRO_CONTENT, p.PRO_CATEGORY, p.PRO_IMG, " +
                         "o.OPTION_ID, o.PRO_SIZE, o.PRO_COLOR, o.PRO_STOCK " +
                         "FROM PRODUCTS p " +
                         "LEFT JOIN PRO_OPTION o ON p.PRO_ID = o.PRO_ID " +
                         "ORDER BY p.PRO_ID DESC";

            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
    %>

        <div class="admin-product-card">
            <img src="${pageContext.request.contextPath}/images/<%=rs.getString("PRO_IMG") %>"
                 class="admin-edit-img">

            <h3><%=rs.getString("PRO_NAME") %></h3>

            <p>색상: <%=rs.getString("PRO_COLOR") %></p>
            <p>사이즈: <%=rs.getString("PRO_SIZE") %></p>
            <p><%=rs.getString("PRO_PRICE") %>원 | 재고 <%=rs.getString("PRO_STOCK") %>개</p>

            <div class="admin-card-btn-area">
                <%
                    if ("update".equals(edit)) {
                %>
                    <a href="./updateProduct.jsp?id=<%=rs.getString("PRO_ID") %>&optionId=<%=rs.getString("OPTION_ID")%>" class="admin-btn small">
                        수정 &raquo;
                    </a>
                <%
                    } else if ("delete".equals(edit)) {
                %>
                    <a href="./deleteProduct.jsp?id=<%=rs.getString("PRO_ID") %>"
                       onclick="return confirm('정말 삭제하시겠습니까?')"
                       class="admin-btn danger small">
                        삭제 &raquo;
                    </a>
                <%
                    }
                %>
            </div>
        </div>

    <%
            }
        } catch (Exception e) {
            out.println("상품 편집 목록 오류: " + e.getMessage());
        } finally {
            if (rs != null) 
                rs.close();
            if (pstmt != null) 
                pstmt.close();
            if (conn != null) 
            conn.close();
        }
    %>

    </div>
</div>

</body>
</html>