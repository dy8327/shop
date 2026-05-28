<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<header class="nav purple">

  <!-- 로고 -->
  <b onclick="location.href='${pageContext.request.contextPath}/index.jsp'"
     style="cursor:pointer;">
    COSMIC MALL
  </b>

  <!-- 메뉴 -->
  <a href="${pageContext.request.contextPath}/index.jsp">HOME</a>
  <a href="${pageContext.request.contextPath}/product/products.jsp">CLOTHING</a>

  <!-- 오른쪽 아이콘 영역 -->
  <div class="right-area">

    <!-- 검색 -->
    <a href="${pageContext.request.contextPath}/search.jsp">⌕</a>

    <!-- 찜 -->
    <a href="${pageContext.request.contextPath}/wish.jsp">♡</a>

    <!-- 장바구니 -->
    <a href="${pageContext.request.contextPath}/product/cart.jsp">🛒</a>

  </div>

</header>