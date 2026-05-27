<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dto.Shop" %>
<%@ page import="dao.ShopDAO" %>

<%
int proId = Integer.parseInt(request.getParameter("proId"));
String color = request.getParameter("color");
String size = request.getParameter("size");

ArrayList<Shop> cartList =
(ArrayList<Shop>) session.getAttribute("cartList");

if (cartList != null) {

    for (int i = 0; i < cartList.size(); i++) {

        Shop item = cartList.get(i);

        if (item.getProId() == proId &&
            item.getProColor().equals(color) &&
            item.getProSize().equals(size)) {

            cartList.remove(i);
            break;
        }
    }
}

response.sendRedirect("cart.jsp");
%>