<%@ page contentType = "text/html; charset = utf-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
<title>상품 수정</title>
</head>
<%
    String edit=request.getParameter("edit");
%>
<body>
<div class="container py-4">
<%@ include file="/admin/adminMenu.jsp" %>

<div class="p-5 mb-4 bg-body-tertiary rounded-3">
    <div class="container-fluid py-5">
        <h1 class="display-5 fw-bold">상품 수정</h1>
        <p class="col-md-8 fs-4">Product Updating</p>
    </div>
</div>

<%
    String proId=request.getParameter("id");
    PreparedStatement pstmt=null;
    ResultSet rs=null;
    String sql="SELECT * FROM PRODUCTS WHERE PRO_ID=?";
    pstmt=conn.prepareStatement(sql);
    pstmt.setString(1, proId);
    rs=pstmt.executeQuery();
    if(rs.next()){
%>
<div class="row align-itmems-md-stretch">
    <div class="col-md-5">
    <img src="/images/<%=rs.getString("PRO_IMG")%>" alt="image" style="width:100%" />
</div>
<div class="col-md-7">
    <form name="updateProduct" action="./processUpdateProduct.jsp" method="post" enctype="multipart/form-data">
     <div class="mb-3 row">
        <label class="col-sm-2">상품명</label>
        <div class="col-sm-5">
        <input type="text" name="proName" id="proName" class="form-control" value='<%=rs.getString("PRO_NAME") %>'>
        </div>
    </div>
    <div class="mb-3 row">
        <label class="col-sm-2">가격</label>
        <div class="col-sm-5">
        <input type="text" name="proPrice" id="proPrice" class="form-control" value='<%=rs.getString("PRO_PRICE") %>'>
        </div>
    </div>
    <div class="mb-3 row">
        <label class="col-sm-2">사이즈</label>
        <div class="col-sm-5">
        <input type="text" name="proSize" id="proSize" class="form-control" value='<%=rs.getString("PRO_SIZE") %>'>
        </div>
    </div>
        <div class="mb-3 row">
        <label class="col-sm-2">색상</label>
        <div class="col-sm-5">
        <input type="text" name="proColor" id="proColor" class="form-control" value='<%=rs.getString("PRO_COLOR") %>'>
        </div>
    </div>
    <div class="mb-3 row">
        <label class="col-sm-2">재고수량</label>
        <div class="col-sm-5">
        <input type="text" name="proStock" id="proStock" class="form-control" value='<%=rs.getString("PRO_STOCK") %>'>
        </div>
    </div>
    <div class="mb-3 row">
        <label class="col-sm-2">상세정보</label>
        <div class="col-sm-8">
        <textarea name="proCont" id="proCont" cols="50" rows="2" class="form-control" placeholder="100자 이상 적어주세요">
        <%=rs.getString("PRO_CONTENT") %>
        </textarea>
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
        <div class="col-sm-8">
        <input type="file" name="filename" class="form-control">
        </div>
    </div>
    <div class="mb-3 row">
        <div class="col-sm-offset-2 col-sm-10">
        <input type="submit" class="btn btn-primary" value="등록">
        </div>
    </div>
    </form>
    </div>
<%
    }
    if(rs!=null)
        rs.close();
    if(pstmt!=null)
        pstmt.close();
    if(conn!=null)
        conn.close();
    %>


</div>
</body>
</html>