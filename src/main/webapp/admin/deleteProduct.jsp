<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.ShopDAO" %>
<%@ include file="../dbconn.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String id = request.getParameter("id");

    if(id == null || id.trim().equals("")){
        out.println("일치하는 상품이 없습니다.");
        return;
    }

    int proId = 0;

    try{
        proId = Integer.parseInt(id);
    } catch(NumberFormatException e){
        out.println("잘못된 상품 번호입니다.");
        return;
    }

    try{
        ShopDAO dao = new ShopDAO();
        dao.deleteProduct(conn, proId);

        response.sendRedirect("adminMain.jsp");

    } catch(Exception e){
        out.println("상품 삭제 오류: " + e.getMessage());

    } finally{
        if(conn != null)
            conn.close();
    }
%>