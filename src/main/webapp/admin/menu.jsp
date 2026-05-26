<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String loginId = (String) session.getAttribute("memId");
    String loginName = (String) session.getAttribute("memName");
    String loginRole = (String) session.getAttribute("memRole");
%>

<header class="nav">
  <h3><a href="${pageContext.request.contextPath}/index.jsp">SSU</a></h3>

  <a href="${pageContext.request.contextPath}/addProduct.jsp">상품등록</a>
  <a href="${pageContext.request.contextPath}/editProduct.jsp">상품수정</a>
  <a href="${pageContext.request.contextPath}/deleteProduct.jsp">상품삭제</a>
  <a href="${pageContext.request.contextPath}/editMember.jsp">회원관리</a>
  <a href="${pageContext.request.contextPath}/orderManage.jsp">주문관리</a>
  <a href="${pageContext.request.contextPath}/sales.jsp">매출관리</a>
  
 <div class="right-area">
        <span><%=loginName %>님</span>
  <a href="${pageContext.request.contextPath}/member/logout.jsp">로그아웃</a>
</div>

</header>