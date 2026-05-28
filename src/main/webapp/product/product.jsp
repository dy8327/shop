<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="../dbconn.jsp" %>

<%
String proId = request.getParameter("proId");

if (proId == null || proId.equals("")) {
%>
    <h2>잘못된 접근입니다</h2>
<%
    return;
}

PreparedStatement pstmt = null;
ResultSet rs = null;

String name = "";
int price = 0;
String img = "";
String content = "";

ArrayList<String> colors = new ArrayList<>();
ArrayList<String> sizes = new ArrayList<>();

try {

    // =====================
    // 상품 기본 정보
    // =====================
    String sql = "SELECT PRO_NAME, PRO_PRICE, PRO_IMG, PRO_CONTENT " +
                 "FROM PRODUCTS WHERE PRO_ID = ?";

    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, Integer.parseInt(proId));
    rs = pstmt.executeQuery();

    if (!rs.next()) {
%>
        <h2>상품이 존재하지 않습니다.</h2>
<%
        return;
    }

    name = rs.getString("PRO_NAME");
    price = rs.getInt("PRO_PRICE");
    img = rs.getString("PRO_IMG");
    content = rs.getString("PRO_CONTENT");


    // =====================
    // 옵션 (COLOR + SIZE)
    // =====================
    String optSql = "SELECT PRO_COLOR, PRO_SIZE FROM PRO_OPTION WHERE PRO_ID = ?";
    PreparedStatement optStmt = conn.prepareStatement(optSql);
    optStmt.setInt(1, Integer.parseInt(proId));
    ResultSet optRs = optStmt.executeQuery();

    while(optRs.next()) {
        String color = optRs.getString("PRO_COLOR");
        String size = optRs.getString("PRO_SIZE");

        if(!colors.contains(color)) colors.add(color);
        if(!sizes.contains(size)) sizes.add(size);
    }

} catch(Exception e) {
    out.println("에러: " + e.getMessage());
}
%>

<!doctype html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<title>상품 상세</title>

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css">
</head>

<body class="soft">

<%--<header class="nav purple">

  <b>SSU</b>

  <a href="${pageContext.request.contextPath}/index.jsp">HOME</a>
  <a href="${pageContext.request.contextPath}/product/products.jsp">CLOTHING</a>

  <div class="right-area">
    <a href="${pageContext.request.contextPath}/search.jsp">⌕</a>
    <a href="${pageContext.request.contextPath}/wish.jsp">♡</a>
    <a href="${pageContext.request.contextPath}/cart.jsp">🛒</a>
  </div>

</header>--%>
<%@ include file="../menu.jsp" %>

<main class="detail">

  <p class="path">
    HOME &gt; CLOTHING &gt; 상의 &gt; <%= name %>
  </p>

  <section class="detail-grid">

    <div>
      <img class="main-img"
           src="${pageContext.request.contextPath}/images/<%= img %>"
           alt="<%= name %>">
    </div>

    <div class="info">

      <h1><%= name %></h1>
      <h2><%= price %>원</h2>

      <p>★ 4.8 (128)</p>

      <!-- COLOR -->
      <label>COLOR</label>
      <div>
        <%
        for(String c : colors) {
        %>
          <button class="color">
            <%= c %>
          </button>
        <%
        }
        %>
      </div>

      <!-- SIZE -->
      <label>SIZE</label>
      <div>
        <%
        for(String s : sizes) {
        %>
          <button class="size">
            <%= s %>
          </button>
        <%
        }
        %>
      </div>

      <label>수량</label>
      <div>
        <button class="size">-</button>
        <input class="qty" value="1" readonly>
        <button class="size">+</button>
      </div>

      <form action="addCart.jsp" method="post">

        <input type="hidden" name="proId" value="<%= proId %>">

       

        <input type="hidden" name="quantity" value="1">

        <button type="submit" class="btn wide">
            장바구니 담기
        </button>

      </form>

      <button class="dark wide">
        바로 구매하기
      </button>

    </div>

  </section>

  <div class="tabs">
    <button>상품 정보</button>
    <button>사이즈 가이드</button>
    <button>배송 안내</button>
    <button>리뷰 (128)</button>
  </div>

  <section class="desc">
    <p><%= content %></p>

    <ul>
      <li>소재: 폴리 60% / 레이온 40%</li>
      <li>핏: 크롭핏</li>
      <li>모델: 164cm / 착용 사이즈 M</li>
    </ul>
  </section>

</main>

<div class="modal-bg" id="confirmModal">
  <div class="modal">
    <div class="circle">🛒</div>
    <h3>장바구니에 추가하시겠습니까?</h3>
    <button class="outline" onclick="closeConfirm()">취소</button>
    <button class="btn" onclick="showDone()">확인</button>
  </div>
</div>

<div class="modal-bg" id="doneModal">
  <div class="modal">
    <div class="circle check">✓</div>
    <h3>장바구니에 추가되었습니다.</h3>
    <a class="btn" href="${pageContext.request.contextPath}/cart.jsp">
      장바구니 보기
    </a>
    <button class="outline" onclick="closeDone()">쇼핑 계속하기</button>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/product.js"></script>

<%@ include file="../footer.jsp" %>

</body>
</html>