<%@ page contentType="text/html; charset = utf-8" pageEncoding="UTF-8" %>
<html>
<head>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/validation.js"></script>
<title>상품 등록</title>
</head>
<body>
    <%@ include file="/admin/adminMenu.jsp" %>

    <div class="admin-form-wrap">
        <div class="admin-page-title">
            <h1>상품 등록</h1>
            <p>Product Addition</p>
        </div>
   
        <form name="newProduct" 
        action="${pageContext.request.contextPath}/admin/processAddProduct.jsp" 
        method="post" class="admin-form" enctype="multipart/form-data">
            <div class="form-row">
                <label for="proName">상품명</label>
                    <input type="text" id="proName" name="proName">
                </div>
            
            <div class="form-row">
                <label for="proPrice">가격</label>
                    <input type="text" id="proPrice" name="proPrice">
            </div>
           <div class="form-row">
                <label for="proSize">사이즈</label>
                    <input type="text" id="proSize" name="proSize">
            </div>
            <div class="form-row">
                <label for="proStock">재고수량</label>
                    <input type="text" id="proStock" name="proStock">
            </div>
                <div class="form-row">
                <label for="proColor">색상</label>
                    <input type="text" id="proColor" name="proColor">
            </div>
            
            <div class="form-row">
                <label for="proCont">상세정보</label>
                    <textarea name="proCont" id="proCont"
                    placeholder="100자 이상 적어주세요."></textarea>
            </div>
            <div class="form-row">
                <label>카테고리</label>
                <div class="radio-group">
                    <label><input type="radio" name="proCategory" value="TOP"> 상의</label>
                    <label><input type="radio" name="proCategory" value="BOTTOM"> 하의</label>
                    <label><input type="radio" name="proCategory" value="DRESS"> 원피스</label>
                    <label><input type="radio" name="proCategory" value="ACC"> 악세서리</label>
                </div>
            </div>
            <div class="form-row">
                <label class="filename">이미지</label>
                    <input type="file" name="filename">
            </div>  

            <div class ="form-btn-area">
                <input type="button" class="admin-btn" value="등록" onclick="CheckAddProduct()">
                </div>
            </div>
        </form>
    </div>
</body>
</html>