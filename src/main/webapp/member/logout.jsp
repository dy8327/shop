<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    sesion.invalidate();
    response.sendRedirect("${pageContext.request.contextPath}/index.jsp");
%>