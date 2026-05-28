<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="dto.Shop" %>
<%@ page import="dao.ShopDAO" %>
<%@ include file="../dbconn.jsp" %>
<%
    ShopDAO dao = new ShopDAO();
    ArrayList<Shop> productList = dao.getAllProducts(conn);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 모드</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="/admin/adminMenu.jsp" %>

<div class="admin-wrap">

    <h1>관리자 메인</h1>
    <h2>전체 상품 현황</h2>

    <table class="admin-product-table">
        <thead>
            <tr>
                <th>순번</th>
                <th>카테고리</th>
                <th>썸네일</th>
                <th>상품명</th>
                <th>판매금액</th>
                <th>색상</th>
                <th>사이즈</th>
                <th>재고</th>
            </tr>
        </thead>

        <tbody>
        <%
            if (productList == null || productList.size() == 0) {
        %>
            <tr>
                <td colspan="8">등록된 상품이 없습니다.</td>
            </tr>
        <%
            } else {
                for (int i = 0; i < productList.size(); i++) {
                    Shop shop = productList.get(i);
        %>
            <tr>
                <td><%= i + 1 %></td>
                <td><%= shop.getProCategory() %></td>
                <td>
                    <img 
                        src="${pageContext.request.contextPath}/images/<%= shop.getProImg() %>" 
                        alt="<%= shop.getProName() %>"
                        class="admin-thumb"
                    >
                </td>
                <td><%= shop.getProName() %></td>
                <td><%= String.format("%,d", shop.getProPrice()) %>원</td>
                <td><%= shop.getProColor() %></td>
                <td><%= shop.getProSize() %></td>
                <td><%= shop.getProStock() %>개</td>
            </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>

</div>



</main>
</body>
</html>