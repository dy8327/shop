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

    
    <img src="${pageContext.request.contextPath}/images/<%=rs.getString("PRO_IMG")%>" alt="image" style="width:100%" />
    

    <form name="updateProduct" action="./processUpdateProduct.jsp" method="post" class="admin-form" enctype="multipart/form-data">
    <input type="hidden" name="proId" value="<%=rs.getString("PRO_ID") %>">
    <input type="hidden" name="oldFilename" value="<%=rs.getString("PRO_IMG") %>">
     <div class="form-row">
        <label for="proName">상품명</label>
        <input type="text" name="proName" id="proName" class="form-control" value='<%=rs.getString("PRO_NAME") %>'>
    </div>
    <div class="form-row">
        <label for="proPrice">가격</label>
        <input type="text" name="proPrice" id="proPrice" class="form-control" value='<%=rs.getString("PRO_PRICE") %>'>
    </div>
    <div class="form-row">
        <label for="proSize">사이즈</label>
        <input type="text" name="proSize" id="proSize" class="form-control" value='<%=rs.getString("PRO_SIZE") %>'>
    </div>
    <div class="form-row">
        <label for="proColor">색상</label>
        <input type="text" name="proColor" id="proColor" class="form-control" value='<%=rs.getString("PRO_COLOR") %>'>
    </div>
    <div class="form-row">
        <label for="proStock">재고수량</label>
        <input type="text" name="proStock" id="proStock" class="form-control" value='<%=rs.getString("PRO_STOCK") %>'>
    </div>
    <div class="form-row">
        <label for="proCont">상세정보</label>
        <textarea name="proCont" id="proCont" cols="50" rows="4" class="form-control" placeholder="100자 이상 적어주세요">
        <%=rs.getString("PRO_CONTENT") %>
        </textarea>
    </div>
    <div class="form-row">
        <label>카테고리</label>
        <div class="radio-group">
       <input type="radio" name="proCategory" value="TOP" <%="TOP".equals(category)? "checked" :"" %>> 상의
        <input type="radio" name="proCategory" value="BOTTOM" <%="BOTTOM".equals(category)? "checked" :"" %>> 하의
        <input type="radio" name="proCategory" value="DRESS" <%="DRESS".equals(category)? "checked" :"" %>> 원피스
        <input type="radio" name="proCategory" value="ACC" <%="ACC".equals(category)? "checked" :"" %>> 악세서리
        </div>
    </div>
    <div class="form-row">
        <label for="filename">이미지</label>
        <input type="file" name="filename" class="form-control">
    </div>
    <div class ="form-btn-area">
        <input type="submit" class="admin-btn" value="수정">
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