<%@ page contentType="text/html; charset = utf-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>
<html>
<head>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<title>상품 수정</title>
</head>

<body>
<%@ include file="/admin/adminMenu.jsp" %>

    <div class="admin-form-wrap">
        <div class="admin-page-title">
        <h1>상품 수정</h1>
        <p>Product Updating</p>
    </div>

<%
    String proId=request.getParameter("id");
    PreparedStatement pstmt=null;
    ResultSet rs=null;
    try{
    String sql="SELECT p.PRO_ID, p.PRO_NAME, p.PRO_PRICE, p.PRO_CONTENT, p.PRO_CATEGORY, p.PRO_IMG, " +
            "o.PRO_SIZE, o.PRO_COLOR, o.PRO_STOCK " +
            "FROM PRODUCTS p " +
            "LEFT JOIN PRO_OPTION o ON p.PRO_ID = o.PRO_ID " +
            "WHERE p.PRO_ID = ?";
    pstmt=conn.prepareStatement(sql);
    pstmt.setString(1, proId);
    rs=pstmt.executeQuery();
    if(rs.next()){
        String category = rs.getString("PRO_CATEGORY");
%>
<div class="row align-items-md-stretch">
    <div class="col-md-5">
    <img src="${pageContext.request.contextPath}/images/<%=rs.getString("PRO_IMG")%>" alt="image" style="width:100%" />
</div>
<div class="col-md-7">
    <form name="updateProduct" action="./processUpdateProduct.jsp" method="post" enctype="multipart/form-data">
    <input type="hidden" name="proId" value="<%=rs.getString("PRO_ID") %>">
    <input type="hidden" name="oldFilename" value="<%=rs.getString("PRO_IMG") %>">
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
        <textarea name="proCont" id="proCont" cols="50" rows="4" class="form-control" placeholder="100자 이상 적어주세요">
        <%=rs.getString("PRO_CONTENT") %>
        </textarea>
        </div>
    </div>
    <div class="mb-3 row">
        <label class="col-sm-2">카테고리</label>
        <div class="col-sm-5">
       <input type="radio" name="proCategory" value="TOP" <%="TOP".equals(category)? "checked" :"" %>> 상의
        <input type="radio" name="proCategory" value="BOTTOM" <%="BOTTOM".equals(category)? "checked" :"" %>> 하의
        <input type="radio" name="proCategory" value="DRESS" <%="DRESS".equals(category)? "checked" :"" %>> 원피스
        <input type="radio" name="proCategory" value="ACC" <%="ACC".equals(category)? "checked" :"" %>> 악세서리
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
        <input type="submit" class="btn btn-primary" value="수정">
        </div>
    </div>
    </form>
    </div>
<%
    } else{
        out.println("<p>해당상품을 찾을 수 없습니다.</p>");
    } 
    }catch(Exception e){
        out.println("상품 수정 페이지 오류: "+e.getMessage());
    } finally{
    if(rs!=null)
        rs.close();
    if(pstmt!=null)
        pstmt.close();
    if(conn!=null)
        conn.close();
    }
    %>


</div>
</body>
</html>