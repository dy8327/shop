<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">

<head>
  <meta charset="UTF-8">
  <title>상품 상세</title>

  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/style.css">
</head>

<body class="soft">

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
    HOME &gt; CLOTHING &gt; 상의 &gt; 오로라 크롭 후드
  </p>

  <section class="detail-grid">

    <!-- 왼쪽 상품 이미지 -->
    <div>

      <img class="main-img"
           src="${pageContext.request.contextPath}/images/orola_crp_hood.png"
           alt="오로라 크롭 후드">
    </div>

    <!-- 오른쪽 상품 정보 -->
    <div class="info">

      <h1>오로라 크롭 후드</h1>

      <h2>39,000원</h2>

      <p>★ 4.8 (128)</p>

      <!-- 색상 -->
      <label>COLOR</label>

      <div>
        <button class="color c1"></button>
        <button class="color c2"></button>
        <button class="color c3"></button>
      </div>

      <!-- 사이즈 -->
      <label>SIZE</label>

      <div>
        <button class="size">S</button>
        <button class="size selected">M</button>
        <button class="size">L</button>
      </div>

      <!-- 수량 -->
      <label>수량</label>

      <div>

        <button class="size">-</button>

        <input class="qty"
               value="1"
               readonly>

        <button class="size">+</button>

      </div>

      <!-- 버튼 -->
      <button class="btn wide"
              onclick="openConfirm()">
        장바구니 담기
      </button>

      <button class="dark wide">
        바로 구매하기
      </button>

    </div>

  </section>

  <!-- 탭 -->
  <div class="tabs">

    <button>상품 정보</button>
    <button>사이즈 가이드</button>
    <button>배송 안내</button>
    <button>리뷰 (128)</button>

  </div>

  <!-- 상품 설명 -->
  <section class="desc">

    <p>
      오로라빛 컬러와 메탈릭 무드가 돋보이는 후드입니다.
    </p>

    <ul>
      <li>소재: 폴리 60% / 레이온 40%</li>
      <li>핏: 크롭핏</li>
      <li>모델: 164cm / 착용 사이즈 M</li>
    </ul>

  </section>

</main>

<!-- 장바구니 확인 모달 -->
<div class="modal-bg" id="confirmModal">

  <div class="modal">

    <div class="circle">🛒</div>

    <h3>장바구니에 추가하시겠습니까?</h3>

    <button class="outline"
            onclick="closeConfirm()">
      취소
    </button>

    <button class="btn"
            onclick="showDone()">
      확인
    </button>

  </div>

</div>

<!-- 완료 모달 -->
<div class="modal-bg" id="doneModal">

  <div class="modal">

    <div class="circle check">✓</div>

    <h3>장바구니에 추가되었습니다.</h3>

    <a class="btn"
       href="${pageContext.request.contextPath}/cart.jsp">
      장바구니 보기
    </a>

    <button class="outline"
            onclick="closeDone()">
      쇼핑 계속하기
    </button>

  </div>

</div>

<!-- JS -->
<script src="${pageContext.request.contextPath}/js/product.js"></script>

<%@ include file="../footer.jsp" %>

</body>
</html>