<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String loginId = (String) session.getAttribute("memId");
    String loginName = (String) session.getAttribute("memName");
    String loginRole = (String) session.getAttribute("memRole");
%>

<header class="nav">
  <b onclick="location.href='${pageContext.request.contextPath}/index.jsp'"
     style="cursor:pointer;">
    SSU
  </b>

  <a href="${pageContext.request.contextPath}/product/new.jsp">NEW</a>
  <a href="${pageContext.request.contextPath}/product/best.jsp">BEST</a>
  <a href="${pageContext.request.contextPath}/product/products.jsp">ALLCLOTHING</a>
  <a href="${pageContext.request.contextPath}/product/top.jsp">TOP</a>
  <a href="${pageContext.request.contextPath}/product/bottom.jsp">BOTTOM</a>
  <a href="${pageContext.request.contextPath}/product/dress.jsp">DRESS</a>
  <a href="${pageContext.request.contextPath}/product/acc.jsp">ACC</a>

 <div class="right-area">
  <div class="search-area">
    <input type="text" name="search">
    <h4><a href="${pageContext.request.contextPath}/search.jsp">⌕</a></h4>
  </div>
      <% if (loginId == null) { %>
        <a href="${pageContext.request.contextPath}/member/login.jsp">로그인</a>
        <a href="${pageContext.request.contextPath}/member/join.jsp">회원가입</a>
        <% } else { %>
        <span><%=loginName %>님</span>
  <h4><a href="${pageContext.request.contextPath}/product/cart.jsp">🛒</a></h4>
  <a href="${pageContext.request.contextPath}/member/logout.jsp">로그아웃</a>
  <% if ("ADMIN".equals(loginRole)) { %>
            <a href="<%= request.getContextPath() %>/admin/adminMain.jsp">관리자 모드</a>
        <% } %>
    <%
        }
    %>
    
</div>

</header>