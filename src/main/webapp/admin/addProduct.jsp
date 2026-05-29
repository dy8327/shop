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
        <label>상품 옵션</label>

        <div id="optionArea">
            <div class="option-row">
                <select name="proSize" class="option-size">
                    <option value="">사이즈 선택</option>
                    <option value="FREE">FREE</option>
                    <option value="S">S</option>
                    <option value="M">M</option>
                    <option value="L">L</option>
                    <option value="XL">XL</option>
                </select>

                <input type="text" name="proColor" class="option-color" placeholder="색상 입력">
                <input type="text" name="proStock" class="option-stock" placeholder="재고수량">

                <button type="button" class="option-delete-btn" onclick="removeOption(this)">삭제</button>
            </div>
        </div>

        <button type="button" class="option-add-btn" onclick="addOption()">옵션 추가</button>
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