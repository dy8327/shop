<%@ page contentType="text/html; charset=UTF-8" %>

<%
    session.removeAttribute("cartList");
    response.sendRedirect("cart.jsp");
%>