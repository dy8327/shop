<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>원피스</title>
<link rel="stylesheet" href="../css/style.css">
</head>

<body class="soft">

<%@ include file="../header.jsp" %>

<main class="layout">

<!-- ================= LEFT ================= -->
<aside>

  <h3>카테고리</h3>

  <p><a href="products.jsp">전체</a></p>
  <p><a href="top.jsp">상의</a></p>
  <p><a href="bottom.jsp">하의</a></p>
  <p><a href="outer.jsp">아우터</a></p>
  <p class="on"><a href="dress.jsp">원피스</a></p>
  <p><a href="acc.jsp">액세서리</a></p>
  <p><a href="sale.jsp">SALE</a></p>

</aside>

<!-- ================= RIGHT ================= -->
<section>

  <p class="path">
    HOME &gt; CLOTHING &gt; 원피스
  </p>

  <div class="title">
    <h1>원피스</h1>

    <select>
      <option>추천순</option>
      <option>신상품순</option>
    </select>
  </div>

  <!-- GRID -->
  <div class="grid three">

<%
PreparedStatement pstmt = null;
ResultSet rs = null;

try {

    String sql =
    "SELECT PRO_ID, PRO_NAME, PRO_PRICE, PRO_IMG " +
    "FROM PRODUCTS " +
    "WHERE PRO_CATEGORY = 'DRESS' " +
    "ORDER BY PRO_ID";

    pstmt = conn.prepareStatement(sql);
    rs = pstmt.executeQuery();

    while(rs.next()) {
%>

<a class="card"
   href="product.jsp?proId=<%= rs.getInt("PRO_ID") %>">

  <img class="main-img"
       src="<%=request.getContextPath()%>/images/<%= rs.getString("PRO_IMG") %>">

  <b><%= rs.getString("PRO_NAME") %></b>
  <p><%= rs.getInt("PRO_PRICE") %>원</p>

</a>

<%
    }

} catch(Exception e) {
    out.println(e.getMessage());
} finally {
    if(rs != null) rs.close();
    if(pstmt != null) pstmt.close();
}
%>

  </div>

  <!-- PAGING -->
  <div class="paging">
    <span>〈</span>
    <b>1</b>
    <span>2</span>
    <span>3</span>
    <span>4</span>
    <span>5</span>
    <span>〉</span>
  </div>

</section>

</main>

<%@ include file="../footer.jsp" %>

</body>
</html>