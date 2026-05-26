<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>상품 목록</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body class="soft">

<header class="nav purple">

  <b>COSMIC MALL</b>

  <div class="right-area">

    <div class="search-area">
      <input type="text" placeholder="검색어를 입력하세요">
      <a href="${pageContext.request.contextPath}/search.jsp">⌕</a>
    </div>

    <a href="${pageContext.request.contextPath}/wish.jsp">♡</a>
    <a href="${pageContext.request.contextPath}/cart.jsp">🛒</a>

  </div>

</header>

<main class="layout">

  <aside>

    <h3>카테고리</h3>

    <p>
      <a href="${pageContext.request.contextPath}/list.jsp">전체</a>
    </p>
   
    <p class="on">
      <a href="${pageContext.request.contextPath}/top.jsp">상의</a>
    </p>

    <p>
      <a href="${pageContext.request.contextPath}/top.jsp?type=tshirt">- 티셔츠</a>
    </p>

    <p>
      <a href="${pageContext.request.contextPath}/top.jsp?type=shirt">- 셔츠</a>
    </p>

    <p>
      <a href="${pageContext.request.contextPath}/top.jsp?type=knit">- 니트</a>
    </p>

    <p>
      <a href="${pageContext.request.contextPath}/outer.jsp">아우터</a>
    </p>

    <p>
      <a href="${pageContext.request.contextPath}/bottom.jsp">하의</a>
    </p>

    <p>
      <a href="${pageContext.request.contextPath}/dress.jsp">원피스</a>
    </p>

    <p>
      <a href="${pageContext.request.contextPath}/acc.jsp">액세서리</a>
    </p>

    <p>
      <a href="${pageContext.request.contextPath}/sale.jsp">SALE</a>
    </p>

  </aside>

  <section>

    <p class="path">
      HOME &gt; CLOTHING &gt; 상의
    </p>

    <div class="title">

      <h1>상의</h1>

      <select>
        <option>추천순</option>
        <option>신상품순</option>
      </select>

    </div>

    <div class="grid three">

      <!-- 상품 1 -->
      <a class="card" href="${pageContext.request.contextPath}/detail.jsp?id=1">

        <img class="main-img"
             src="${pageContext.request.contextPath}/images/orola_crp_hood.png"
             alt="오로라 크롭 후드">

        <button>♡</button>

        <b>오로라 크롭 후드</b>
        <p>39,000원</p>

      </a>

      <!-- 상품 2 -->
      <a class="card" href="${pageContext.request.contextPath}/detail.jsp?id=2">

        <img class="main-img"
             src="${pageContext.request.contextPath}/images/over_t.png"
             alt="유니버스 오버핏 티셔츠">

        <button>♡</button>

        <b>유니버스 오버핏 티셔츠</b>
        <p>22,000원</p>

      </a>

      <!-- 상품 3 -->
      <a class="card" href="${pageContext.request.contextPath}/detail.jsp?id=3">

        <img class="main-img"
             src="${pageContext.request.contextPath}/images/shirt.png"
             alt="오버핏 셔츠">

        <button>♡</button>

        <b>오버핏 셔츠</b>
        <p>36,000원</p>

      </a>

      <!-- 상품 4 -->
      <a class="card" href="${pageContext.request.contextPath}/detail.jsp?id=4">

        <img class="main-img"
             src="${pageContext.request.contextPath}/images/jacket.png"
             alt="글로우 자켓 셋업">

        <button>♡</button>

        <b>글로우 자켓 셋업</b>
        <p>79,000원</p>

      </a>

      <!-- 상품 5 -->
      <a class="card" href="${pageContext.request.contextPath}/detail.jsp?id=5">

        <img class="main-img"
             src="${pageContext.request.contextPath}/images/wide_denim.png"
             alt="코스믹 와이드 데님">

        <button>♡</button>

        <b>코스믹 와이드 데님</b>
        <p>45,000원</p>

      </a>

      <!-- 상품 6 -->
      <a class="card" href="${pageContext.request.contextPath}/detail.jsp?id=6">

        <img class="main-img"
             src="${pageContext.request.contextPath}/images/one.png"
             alt="스타라잇 나시 원피스">

        <button>♡</button>

        <b>스타라잇 나시 원피스</b>
        <p>36,000원</p>

      </a>

    </div>

    <div class="paging">
      〈 <b>1</b> 2 3 4 5 〉
    </div>

  </section>

</main>
<%@ include file="../footer.jsp" %>
</body>
</html>