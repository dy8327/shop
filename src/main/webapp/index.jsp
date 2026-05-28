<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconn.jsp" %>

<%
PreparedStatement pstmt = null;
ResultSet rs = null;

String sql = "SELECT PRO_ID, PRO_NAME, PRO_PRICE, PRO_IMG " +
             "FROM PRODUCTS " +
             "ORDER BY PRO_DATE DESC";

pstmt = conn.prepareStatement(sql);
rs = pstmt.executeQuery();
%>

<!doctype html>
<html lang="ko">
<head>
  <meta charset="UTF-8">

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

<%@ include file="menu.jsp" %>

<section class="hero">
  <div>
    <h1>Style,<br>Shine,<br>Universe</h1>
    <p>우주에서 발견한 스타일, 나만의 색으로 빛나보세요.</p>
    <a class="btn" href="${pageContext.request.contextPath}/list.jsp">SHOP NOW →</a>
  </div>
</section>

<section class="wrap">
  <div class="title">
    <h2>NEW ARRIVALS ✦</h2>
    <a href="${pageContext.request.contextPath}/new.jsp">더보기 →</a>
  </div>

  <div class="grid">

    <%
      while(rs.next()) {
        int id = rs.getInt("PRO_ID");
        String name = rs.getString("PRO_NAME");
        int price = rs.getInt("PRO_PRICE");
        String img = rs.getString("PRO_IMG");
    %>

    <!-- 🔥 여기만 수정됨 -->
    <a class="card"
       href="${pageContext.request.contextPath}/product/product.jsp?proId=<%= id %>">

      <img class="main-img"
           src="${pageContext.request.contextPath}/images/<%= img %>"
           alt="<%= name %>">

      <em>NEW</em>
      <button>♡</button>

      <b><%= name %></b>
      <p><%= String.format("%,d", price) %>원</p>

    </a>

    <%
      }
    %>

  </div>
</section>

<section class="banner">
  <h2>COSMIC RAINBOW COLLECTION</h2>
  <p>눈부신 컬러로 완성하는 나의 우주</p>
  <a class="light" href="${pageContext.request.contextPath}/list.jsp">컬렉션 보러가기 →</a>
</section>

<%
try {
    if(rs != null) rs.close();
    if(pstmt != null) pstmt.close();
    if(conn != null) conn.close();
} catch(Exception e) {}
%>

<%@ include file="footer.jsp" %>

</body>
</html>