<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>LUNA RAIN</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

<header class="nav">
  <b>SSU</b>

  <a href="${pageContext.request.contextPath}/new.jsp">NEW</a>
  <a href="${pageContext.request.contextPath}/best.jsp">BEST</a>
  <a href="${pageContext.request.contextPath}/list.jsp">ALLCLOTHING</a>
  <a href="${pageContext.request.contextPath}/top.jsp">TOP</a>
  <a href="${pageContext.request.contextPath}/bottom.jsp">BOTTOM</a>
  <a href="${pageContext.request.contextPath}/dress.jsp">DRESS</a>
  <a href="${pageContext.request.contextPath}/acc.jsp">ACC</a>

 <div class="right-area">
  <div class="search-area">
    <input type="text" name="search">
    <a href="${pageContext.request.contextPath}/search.jsp">⌕</a>
  </div>

  <a href="${pageContext.request.contextPath}/cart.jsp">🛒</a>
  <a href="${pageContext.request.contextPath}/member/login.jsp">로그인</a>
</div>

</header>

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

    <a class="card" href="detail.jsp?id=1">
      <img class="main-img" src="${pageContext.request.contextPath}/images/orola_crp_hood.png" alt="오로라 크롭 후드">
      <em>NEW</em><button>♡</button>
      <b>오로라 크롭 후드</b><p>39,000원</p>
    </a>

    <a class="card" href="detail.jsp?id=2">
      <img class="main-img" src="${pageContext.request.contextPath}/images/over_t.png" alt="유니버스 오버핏 티셔츠">
      <em>NEW</em><button>♡</button>
      <b>유니버스 오버핏 티셔츠</b><p>22,000원</p>
    </a>

    <a class="card" href="detail.jsp?id=3">
      <img class="main-img" src="${pageContext.request.contextPath}/images/wide_denim.png" alt="코스믹 와이드 데님">
      <button>♡</button>
      <b>코스믹 와이드 데님</b><p>45,000원</p>
    </a>

    <a class="card" href="detail.jsp?id=4">
      <img class="main-img" src="${pageContext.request.contextPath}/images/one.png" alt="스타라잇 나시 원피스">
      <button>♡</button>
      <b>스타라잇 나시 원피스</b><p>36,000원</p>
    </a>

  </div>
</section>

<section class="banner">
  <h2>COSMIC RAINBOW COLLECTION</h2>
  <p>눈부신 컬러로 완성하는 나의 우주</p>
  <a class="light" href="${pageContext.request.contextPath}/list.jsp">컬렉션 보러가기 →</a>
</section>

<%@ include file="footer.jsp" %>

</body>
</html>