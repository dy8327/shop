<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="../dbconn.jsp" %>

<%
request.setCharacterEncoding("UTF-8");
String proId = request.getParameter("proId");

if (proId == null || proId.equals("")) {
    // 테스트용으로 proId 파라미터가 안 넘어왔을 때 1번 상품으로 기본 세팅 (오류 방지)
    proId = "1"; 
}

PreparedStatement pstmt = null;
ResultSet rs = null;

String name = "";
int price = 0;
String img = "";
String content = "";

ArrayList<String> colors = new ArrayList<>();
ArrayList<String> sizes = new ArrayList<>();

// 자바스크립트로 전송할 옵션 리스트 JSON 문자열 정의
StringBuilder jsonOptions = new StringBuilder("[");

try {
    // 1. 상품 기본 정보 조회
    String sql = "SELECT PRO_NAME, PRO_PRICE, PRO_IMG, PRO_CONTENT " +
                 "FROM PRODUCTS WHERE PRO_ID = ?";

    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, Integer.parseInt(proId));
    rs = pstmt.executeQuery();

    if (rs.next()) {
        name = rs.getString("PRO_NAME");
        price = rs.getInt("PRO_PRICE");
        img = rs.getString("PRO_IMG");
        content = rs.getString("PRO_CONTENT");
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
    HOME &gt; CLOTHING &gt; 상의 &gt; <%= name %>  
  </p>
  
  <section class="detail-grid">
    <div>      
      <img class="main-img" src="${pageContext.request.contextPath}/images/<%= img %>" alt="<%= name %>">    
    </div>
    
    <div class="info">
      <h1><%= name %></h1>      
      <h2><%= price %>원</h2>
      <p>★ 4.8 (128)</p>
      
      <label>COLOR</label>      
      <div>                  
        <% for(String c : colors) { %>
          <button type="button" class="color" data-color="<%= c %>">            
            <%= c %>          
          </button>                  
        <% } %>
      </div>
      
      <label>SIZE</label>      
      <div>                  
        <% for(String s : sizes) { %>
          <button type="button" class="size" data-size="<%= s %>">            
            <%= s %>          
          </button>                  
        <% } %>
      </div>
      
      <label>수량</label>      
      <div>        
        <button type="button" class="btn-qty-minus" style="min-width: 38px; height: 38px; border: 1px solid #ded2ff; border-radius: 10px; background: #fff; cursor: pointer;">-</button>        
        <input class="qty" id="displayQty" value="1" readonly>        
        <button type="button" class="btn-qty-plus" style="min-width: 38px; height: 38px; border: 1px solid #ded2ff; border-radius: 10px; background: #fff; cursor: pointer;">+</button>      
      </div>
      
      <form id="cartForm">
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
    <button class="btn" onclick="showDone()">확인</button>  
  </div>
</div>

<div class="modal-bg" id="doneModal">  
  <div class="modal">    
    <div class="circle check">✓</div>    
    <h3>장바구니에 추가되었습니다.</h3>   
    <a class="btn" href="${pageContext.request.contextPath}/product/cart.jsp" onclick="closeDone()">장바구니 보기</a>    
    <button class="outline" onclick="closeDone()">쇼핑 계속하기</button>  
  </div>
</div>

<script>
    const optionList = <%= jsonOptions.toString() %>;
</script>
<script src="${pageContext.request.contextPath}/js2/product.js"></script>

<%@ include file="../footer.jsp" %>
</body>
</html>