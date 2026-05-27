<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dto.Shop" %>
<%@ page import="dao.ShopDAO" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>

<%
request.setCharacterEncoding("UTF-8");

int proId = Integer.parseInt(request.getParameter("proId"));

String color = request.getParameter("color");
String size = request.getParameter("size");

int quantity = Integer.parseInt(request.getParameter("quantity"));

ShopDAO dao = new ShopDAO();

Shop product = dao.getProductDetail(conn, proId);

if(product == null){
    response.sendRedirect("products.jsp");
    return;
}

product.setProColor(color);
product.setProSize(size);
product.setQuantity(quantity);

ArrayList<Shop> cartList =
(ArrayList<Shop>)session.getAttribute("cartList");

if(cartList == null){
    cartList = new ArrayList<Shop>();
    session.setAttribute("cartList", cartList);
}

boolean exists = false;

for(Shop item : cartList){

    if(item.getProId() == proId &&
   color != null && size != null &&
   color.equals(item.getProColor()) &&
   size.equals(item.getProSize())){

        item.setQuantity(item.getQuantity() + quantity);

        exists = true;
        break;
    }
}

if(!exists){
    cartList.add(product);
}

response.sendRedirect("cart.jsp");
%>