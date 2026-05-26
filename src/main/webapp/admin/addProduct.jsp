<%@ page contentType="text/html; charset = utf-8" pageEncoding="UTF-8" %>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/validation.js"></script>
<title>상품 등록</title>
</head>
<body>
<div class="container py-4">
    <%@ include file="/admin/adminMenu.jsp" %>

    <div class="p-5 mb-4 bg-body-tertiary rounded-3">
        <div class="container-fluid py-5">
            <h1 class="display-5 fw-bold">상품 등록</h1>
            <p class="col-md-8 fs-4">Product Addition</p>
        </div>
    </div>

    <div class="row align-items-md-stretch">
        <p></p>
        <form name="newProduct" action="${pageContext.request.contextPath}/admin/processAddProduct.jsp" method="post" class="form-horizontal" enctype="multipart/form-data">
            <div class="mb-3 row">
                <label class="col-sm-2">상품명</label>
                <div class="col-sm-3">
                    <input type="text" id="proName" name="proName" class="form-control">
                </div>
            </div>
            <div class="mb-3 row">
                <label class="col-sm-2">가격</label>
                <div class="col-sm-3">
                    <input type="text" id="proPrice" name="proPrice" class="form-control">
                </div>
            </div>
           <div class="mb-3 row">
                <label class="col-sm-2">사이즈</label>
                <div class="col-sm-3">
                    <input type="text" id="proSize" name="proSize" class="form-control">
                </div>
            </div>
             <div class="mb-3 row">
                <label class="col-sm-2">재고수량</label>
                <div class="col-sm-3">
                    <input type="text" id="proStock" name="proStock" class="form-control">
                </div>
            </div>
                <div class="mb-3 row">
                <label class="col-sm-2">색상</label>
                <div class="col-sm-3">
                    <input type="text" id="proColor" name="proColor" class="form-control">
                </div>
            </div>
            
            <div class="mb-3 row">
                <label class="col-sm-2">상세정보</label>
                <div class="col-sm-5">
                    <textarea name="proCont" id="proCont" cols="50" rows="2"
                    class="form-control" placeholder="100자 이상 적어주세요."></textarea>
                </div>
            </div>
            
            <div class="mb-3 row">
                <label class="col-sm-2">카테고리</label>
                <div class="col-sm-5">
                    <input type="radio" name="proCategory" value="TOP"> 상의
                    <input type="radio" name="proCategory" value="BOTTOM"> 하의
                    <input type="radio" name="proCategory" value="DRESS"> 원피스
                    <input type="radio" name="proCategory" value="ACC"> 악세서리
                </div>
            </div>
            <div class="mb-3 row">
                <label class="col-sm-2">이미지</label>
                <div class="col-sm-5">
                    <input type="file" name="filename" class="form-control">
                </div>
            </div>  
            <div class ="mb-3 row">
                <div class="col-sm-offset-2 col-sm-10">
                    <input type="button" class="btn btn-primary" value="등록" onclick="CheckAddProduct()">
                </div>
            </div>
        </form>
    </div>
</div>
</body>
</html>