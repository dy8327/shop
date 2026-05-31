<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="../dbconn.jsp" %>

<%
  request.setCharacterEncoding("UTF-8");
  String proId = request.getParameter("proId");
  String cartResult = request.getParameter("cart");
  
  PreparedStatement pstmt = null;
  ResultSet rs = null;
  
  String name = "";
  int price = 0;
  String img = "";
  String content = "";
  String category = "";
  
  ArrayList<String> colors = new ArrayList<>();
  ArrayList<String> sizes = new ArrayList<>();
  
  // 자바스크립트로 전송할 옵션 리스트 JSON 문자열 정의
  StringBuilder jsonOptions = new StringBuilder("[");
  
  try {
    // 1. 상품 기본 정보 조회
    String sql = "SELECT PRO_NAME, PRO_PRICE, PRO_IMG, PRO_CONTENT, PRO_CATEGORY " +
    "FROM PRODUCTS WHERE PRO_ID = ?";
    
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, Integer.parseInt(proId));
    rs = pstmt.executeQuery();
    
    if (rs.next()) {
      name = rs.getString("PRO_NAME");
      price = rs.getInt("PRO_PRICE");
      img = rs.getString("PRO_IMG");
      content = rs.getString("PRO_CONTENT");
      category = rs.getString("PRO_CATEGORY");
    }
    
    if(rs != null) rs.close();
    if(pstmt != null) pstmt.close();
    
    // 2. 옵션 상세 정보 조회 (OPTION_ID, 재고 포함)
    String optSql = "SELECT OPTION_ID, PRO_COLOR, PRO_SIZE, PRO_STOCK FROM PRO_OPTION WHERE PRO_ID = ?";
    PreparedStatement optStmt = conn.prepareStatement(optSql);
    optStmt.setInt(1, Integer.parseInt(proId));
    ResultSet optRs = optStmt.executeQuery();
    
    while(optRs.next()) {
      int optionId = optRs.getInt("OPTION_ID");
      String color = optRs.getString("PRO_COLOR").trim();
      String size = optRs.getString("PRO_SIZE").trim();
      int stock = optRs.getInt("PRO_STOCK");
      
      if(!colors.contains(color)) colors.add(color);
      if(!sizes.contains(size)) sizes.add(size);
      
      jsonOptions.append(String.format(
      "{\"optionId\":%d, \"color\":\"%s\", \"size\":\"%s\", \"stock\":%d},",
      optionId, color, size, stock
      ));
    }
    
    if (jsonOptions.length() > 1) {
      jsonOptions.setLength(jsonOptions.length() - 1);
    }
    jsonOptions.append("]");
    
    if(optRs != null) optRs.close();
    if(optStmt != null) optStmt.close();
    
  } catch(Exception e) {
    out.println("디비 조회 에러: " + e.getMessage());
  }
%>

<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8">
    <title>상품 상세</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  </head>

  <body class="soft">

    <%@ include file="../menu.jsp" %>

    <main class="detail">
      <p class="path">
        HOME &gt; CLOTHING &gt; <%=category %> &gt; <%=name %>
      </p>

      <section class="detail-grid">
        <div>
          <img class="main-img" src="${pageContext.request.contextPath}/images/<%=img %>" alt="<%=name %>">
        </div>

        <div class="info">
          <h1><%=name %></h1>
          <h2><%=price %>원</h2>
          <p>★ 4.8 (128)</p>

          <label>COLOR</label>
          <div>
            <% for(String c : colors) { %>
            <button type="button" class="color" data-color="<%=c %>">
              <%=c %>
            </button>
            <% } %>
          </div>

          <label>SIZE</label>

          <div class="size-option-area">
            <div class="size-buttons">
              <% for(String s : sizes) { %>
              <button type="button" class="size" data-size="<%=s %>">
                <%=s %>
              </button>
              <% } %>
            </div>

            <span id="stockInfo" class="stock-info">
              색상과 사이즈를 선택해주세요
            </span>
          </div>

          <label>수량</label>
          <div>
            <button type="button" class="btn-qty-minus" style="min-width: 38px; height: 38px; border: 1px solid #ded2ff; border-radius: 10px; background: #fff; cursor: pointer;">-</button>
            <input class="qty" id="displayQty" value="1" readonly>
            <button type="button" class="btn-qty-plus" style="min-width: 38px; height: 38px; border: 1px solid #ded2ff; border-radius: 10px; background: #fff; cursor: pointer;">+</button>
          </div>

          <% if ("TOP".equals(category)) { %>

          <div class="size-recommend-box">
            <h3>상의 사이즈 추천</h3>
            <p>가슴둘레와 어깨너비를 입력하면 추천 사이즈를 알려드려요.</p>

            <div class="size-input-row">
              <input type="number" id="bust" placeholder="가슴둘레(cm)">
              <input type="number" id="shoulder" placeholder="어깨너비(cm)">
            </div>

            <button type="button" class="btn size-btn" onclick="recommendTopSize()">
              추천받기
            </button>

            <p id="topSizeResult" class="size-result"></p>
          </div>

          <% } else if ("BOTTOM".equals(category)) { %>

          <div class="size-recommend-box">
            <h3>하의 사이즈 추천</h3>
            <p>허리둘레와 엉덩이둘레를 입력하면 추천 사이즈를 알려드려요.</p>

            <div class="size-input-row">
              <input type="number" id="waist" placeholder="허리둘레(cm)">
              <input type="number" id="hip" placeholder="엉덩이둘레(cm)">
            </div>

            <button type="button" class="btn size-btn" onclick="recommendBottomSize()">
              추천받기
            </button>

            <p id="bottomSizeResult" class="size-result"></p>
          </div>

          <% } else if ("DRESS".equals(category)) { %>

          <div class="size-recommend-box">
            <h3>원피스 사이즈 추천</h3>
            <p>키, 몸무게, 가슴둘레, 허리둘레를 입력하면 추천 사이즈와 기장감을 알려드려요.</p>

            <div class="size-input-row">
              <input type="number" id="dressHeight" placeholder="키(cm)">
              <input type="number" id="dressWeight" placeholder="몸무게(kg)">
            </div>

            <div class="size-input-row">
              <input type="number" id="dressBust" placeholder="가슴둘레(cm)">
              <input type="number" id="dressWaist" placeholder="허리둘레(cm)">
            </div>

            <button type="button" class="btn size-btn" onclick="recommendDressSize()">
              추천받기
            </button>

            <p id="dressSizeResult" class="size-result"></p>
          </div>

          <% } %>

          <form id="cartForm" action="${pageContext.request.contextPath}/cart/processAddCart.jsp" method="post">
            <input type="hidden" name="proId" value="<%= proId %>">

            <input type="hidden" name="color" id="selectedColor" value="">
            <input type="hidden" name="size" id="selectedSize" value="">
            <input type="hidden" name="optionId" id="selectedOptionId" value="">
            <input type="hidden" name="quantity" id="cartQuantity" value="1">

            <button type="button" class="btn wide" onclick="openConfirm()">
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
        <button class="btn" onclick="submitCart()">확인</button>
      </div>
    </div>

    <div class="modal-bg" id="doneModal">
      <div class="modal">
        <div class="circle check">✓</div>
        <h3>장바구니에 추가되었습니다.</h3>
        <a class="btn" href="${pageContext.request.contextPath}/cart/cart.jsp" onclick="closeDone()">장바구니 보기</a>
        <button type="button" class="outline" onclick="closeDone()">쇼핑 계속하기</button>
      </div>
    </div>

    <script>
      const optionList = <%=jsonOptions.toString() %>;
    </script>
    <script src="${pageContext.request.contextPath}/js/product.js"></script>

    <% if ("success".equals(cartResult)) { %>
    <script>
      document.addEventListener("DOMContentLoaded", function() {
        document.getElementById("doneModal").classList.add("show");
      });
    </script>
    <% } %>

    <%@ include file="../footer.jsp" %>

    <script>
      function recommendTopSize() {
        const bust = Number(document.getElementById("bust").value);
        const shoulder = Number(document.getElementById("shoulder").value);
        const result = document.getElementById("topSizeResult");
        
        if (!bust || !shoulder) {
          result.innerHTML = "가슴둘레와 어깨너비를 모두 입력해주세요.";
          return;
        }
        
        let size = "";
        
        if (bust <= 84 && shoulder <= 37) {
          size = "S";
        } else if (bust <= 90 && shoulder <= 39) {
          size = "M";
        } else {
          size = "L";
        }
        
        result.innerHTML = "추천 사이즈는 <strong>" + size + "</strong> 입니다.";
      }
      
      function recommendBottomSize() {
        const waist = Number(document.getElementById("waist").value);
        const hip = Number(document.getElementById("hip").value);
        const result = document.getElementById("bottomSizeResult");
        
        if (!waist || !hip) {
          result.innerHTML = "허리둘레와 엉덩이둘레를 모두 입력해주세요.";
          return;
        }
        
        let size = "";
        
        if (waist <= 64 && hip <= 90) {
          size = "S";
        } else if (waist <= 70 && hip <= 96) {
          size = "M";
        } else {
          size = "L";
        }
        
        result.innerHTML = "추천 사이즈는 <strong>" + size + "</strong> 입니다.";
      }
      
      function recommendDressSize() {
        const height = Number(document.getElementById("dressHeight").value);
        const weight = Number(document.getElementById("dressWeight").value);
        const bust = Number(document.getElementById("dressBust").value);
        const waist = Number(document.getElementById("dressWaist").value);
        const result = document.getElementById("dressSizeResult");
        
        if (!height || !weight || !bust || !waist) {
          result.innerHTML = "키, 몸무게, 가슴둘레, 허리둘레를 모두 입력해주세요.";
          return;
        }
        
        let size = "";
        
        if (bust <= 84 && waist <= 66 && weight <= 50) {
          size = "S";
        } else if (bust <= 90 && waist <= 72 && weight <= 60) {
          size = "M";
        } else {
          size = "L";
        }
        
        let lengthMsg = "";
        
        if (height < 158) {
          lengthMsg = "기장이 다소 길 수 있어요.";
        } else if (height > 170) {
          lengthMsg = "기장이 짧게 느껴질 수 있어요.";
        } else {
          lengthMsg = "기장도 무난할 가능성이 높아요.";
        }
        
        result.innerHTML =
        "추천 사이즈는 <strong>" + size + "</strong> 입니다.<br>" +
        "<span>" + lengthMsg + "</span>";
      }
    </script>
  </body>
</html>