<%@ page contentType="text/html; charset = utf-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>
<html>
<head>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<title>상품 편집</title>
</head>
<%
    String edit=request.getParameter("edit");
%>
<body>
<div class="container py-4">
    <%@ include file="/admin/adminMenu.jsp" %>

<div class="p-5 mb-4 bg-body-tertiary rounded-3">
    <div class="container-fluid py-5">
        <h1 class="display-5 fw-bold">상품 편집</h1>
        <p class="col-md-8 fs-4">ProductEditing</p>
    </div>
</div>

<div class="row align-items-md-stretch text-center">
    <%
        PreparedStatement pstmt=null;
        ResultSet rs=null;
        String sql="SELECT p.PRO_ID, p.PRO_NAME, p.PRO_PRICE, p.PRO_CONTENT, p.PRO_CATEGORY, p.PRO_IMG, " +
                "o.PRO_SIZE, o.PRO_COLOR, o.PRO_STOCK " +
                "FROM PRODUCTS p " +
                "LEFT JOIN PRO_OPTION o ON p.PRO_ID = o.PRO_ID " +
                "ORDER BY p.PRO_ID DESC";
        pstmt=conn.prepareStatement(sql);
        rs=pstmt.executeQuery();
        while(rs.next()){
    %>
    <div class="col-md-4">
        <div class="h-100 p-2 rounded-3">
            <img src="${pageContext.request.contextPath}/images/<%=rs.getString("PRO_IMG") %>" style="width: 250px; height: 350px" />
            <h5><b><%=rs.getString("PRO_NAME") %></b></h5>
            <p><%=rs.getString("PRO_COLOR") %>
            <p><%=rs.getString("PRO_SIZE") %>
            <P><%=rs.getString("PRO_PRICE") %>원 | 재고<%=rs.getString("PRO_STOCK") %>개</p>
            <p><%
                if("update".equals(edit)){
                %>
            <a href="./updateProduct.jsp?id=<%=rs.getString("PRO_ID") %>" class="btn btn-success" role="button">수정 &raquo;</a>
            <%
                } else if("delete".equals(edit)){
            %>
            <a href="./deleteProduct.jsp?id=<%=rs.getString("PRO_ID") %>" onclick="return confirm('정말 삭제하시겠습니까?')" class="btn btn-danger" role="button">삭제 &raquo;</a>
            <%
                }
            %>
        </div>
    </div>
    <%
        }
        if(rs!=null)
            rs.close();
        if(pstmt!=null)
            pstmt.close();
        if(conn!=null)
            conn.close();
    %>
    </div>

</div>
</body>
</html>