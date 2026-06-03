<%@ page contentType="text/html; charset=utf-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="dao.ShopDAO" %>
<%@ page import="dto.Shop" %>
<%@ include file="../dbconn.jsp" %>

<%
    String edit = request.getParameter("edit");

    List<Shop> productList = new ArrayList<>();

    try {
        ShopDAO shopDAO = new ShopDAO(conn);
        productList = shopDAO.getProductEditList();
    } catch(Exception e) {
        out.println("<script>alert('상품 편집 목록 오류: " + e.getMessage() + "');</script>");
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 편집</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

<%@ include file="/admin/adminMenu.jsp" %>

<div class="admin-wrap">
    <h1>상품 편집</h1>
    <p class="admin-subtitle">Product Editing</p>

    <div class="admin-product-grid">

    <%
        if (productList == null || productList.size() == 0) {
    %>
        <p>등록된 상품이 없습니다.</p>
    <%
        } else {
            for (Shop shop : productList) {
    %>

        <div class="admin-product-card">
            <img src="${pageContext.request.contextPath}/images/<%=shop.getProImg() %>"
                 class="admin-edit-img">

            <h3><%=shop.getProName() %></h3>

            <p>색상: <%=shop.getProColor() %></p>
            <p>사이즈: <%=shop.getProSize() %></p>
            <p><%=shop.getProPrice() %>원 | 재고 <%=shop.getProStock() %>개</p>

            <div class="admin-card-btn-area">
                <%
                    if ("update".equals(edit)) {
                %>
                    <a href="./updateProduct.jsp?id=<%=shop.getProId() %>&optionId=<%=shop.getProOpId() %>" 
                       class="admin-btn small">
                        수정 &raquo;
                    </a>
                <%
                    } else if ("delete".equals(edit)) {
                %>
                    <a href="./deleteProduct.jsp?id=<%=shop.getProId() %>"
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
        }

        if (conn != null) 
            conn.close();
    %>

    </div>
</div>

</body>
</html>