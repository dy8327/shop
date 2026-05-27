<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dto.Shop" %>
<%@ page import="dao.ShopDAO" %>

<%
int proId = Integer.parseInt(request.getParameter("proId"));
int proOpId = Integer.parseInt(request.getParameter("proOpId"));

ArrayList<Shop> cartList =
(ArrayList<Shop>) session.getAttribute("cartList");

if (cartList != null) {

    for (int i = 0; i < cartList.size(); i++) {

        Shop item = cartList.get(i);

       if (item.getProId() == proId &&
           item.getProOpId() == proOpId) {

            cartList.remove(i);
            break;
        }
    }
}

response.sendRedirect("cart.jsp");
%>