<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
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
PreparedStatement colorStmt = null;
PreparedStatement sizeStmt = null;

ResultSet rs = null;
ResultSet colorRs = null;
ResultSet sizeRs = null;

String name = "";
int price = 0;
String img = "";
String content = "";

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
    // 옵션 (COLOR)
    // =====================
    String colorSql = "SELECT DISTINCT PRO_COLOR FROM PRO_OPTION WHERE PRO_ID = ?";
    colorStmt = conn.prepareStatement(colorSql);
    colorStmt.setInt(1, Integer.parseInt(proId));
    colorRs = colorStmt.executeQuery();

    // =====================
    // 옵션 (SIZE)
    // =====================
    String sizeSql = "SELECT DISTINCT PRO_SIZE FROM PRO_OPTION WHERE PRO_ID = ?";
    sizeStmt = conn.prepareStatement(sizeSql);
    sizeStmt.setInt(1, Integer.parseInt(proId));
    sizeRs = sizeStmt.executeQuery();

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

<!-- HEADER 그대로 유지 -->
<header class="nav purple">

  <b>COSMIC MALL</b>

  <a href="${pageContext.request.contextPath}/index.jsp">HOME</a>
  <a href="${pageContext.request.contextPath}/product/products.jsp">CLOTHING</a>

  <div class="right-area">
    <a href="${pageContext.request.contextPath}/search.jsp">⌕</a>
    <a href="${pageContext.request.contextPath}/wish.jsp">♡</a>
    <a href="${pageContext.request.contextPath}/cart.jsp">🛒</a>
  </div>

</header>

<main class="detail">

  <p class="path">
    HOME &gt; CLOTHING &gt; 상의 &gt; <%= name %>
  </p>

  <section class="detail-grid">

    <!-- 이미지 (그대로 유지) -->
    <div>
      <img class="main-img"
           src="${pageContext.request.contextPath}/images/<%= img %>"
           alt="<%= name %>">
    </div>

    <!-- 정보 -->
    <div class="info">

      <!-- 상품명/가격만 DB -->
      <h1><%= name %></h1>
      <h2><%= price %>원</h2>

      <!-- 리뷰 (고정 유지) -->
      <p>★ 4.8 (128)</p>

      <!-- COLOR (UI 유지 + DB만 적용) -->
      <label>COLOR</label>
      <div>
        <%
          while(colorRs.next()) {
        %>
          <button class="color">
            <%= colorRs.getString("PRO_COLOR") %>
          </button>
        <%
          }
        %>
      </div>

      <!-- SIZE (UI 유지 + DB만 적용) -->
      <label>SIZE</label>
      <div>
        <%
          while(sizeRs.next()) {
        %>
          <button class="size">
            <%= sizeRs.getString("PRO_SIZE") %>
          </button>
        <%
          }
        %>
      </div>

      <!-- 수량 (그대로 유지) -->
      <label>수량</label>
      <div>
        <button class="size">-</button>
        <input class="qty" value="1" readonly>
        <button class="size">+</button>
      </div>

      <!-- 버튼 (그대로 유지) -->
      <button class="btn wide" onclick="openConfirm()">
        장바구니 담기
      </button>

      <button class="dark wide">
        바로 구매하기
      </button>

    </div>

  </section>

  <!-- 탭 (그대로 유지) -->
  <div class="tabs">
    <button>상품 정보</button>
    <button>사이즈 가이드</button>
    <button>배송 안내</button>
    <button>리뷰 (128)</button>
  </div>

  <!-- 설명 (DB만 변경) -->
  <section class="desc">
    <p><%= content %></p>

    <ul>
      <li>소재: 폴리 60% / 레이온 40%</li>
      <li>핏: 크롭핏</li>
      <li>모델: 164cm / 착용 사이즈 M</li>
    </ul>
  </section>

</main>

<!-- 모달 (그대로 유지) -->
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