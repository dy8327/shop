<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="dto.Shop" %>
<%@ page import="dao.ShopDAO" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ include file="../dbconn.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    Part filePart = request.getPart("filename");
    String proName=request.getParameter("proName");
   String proPriceStr = request.getParameter("proPrice");

if(proPriceStr == null || proPriceStr.trim().equals("")){
    out.println("가격 값이 넘어오지 않았습니다. addProduct.jsp의 name='proPrice' 또는 form 범위를 확인하세요.");
    return;
}

    int proPrice = Integer.parseInt(proPriceStr);
    String proCont=request.getParameter("proCont");
    String proCategory=request.getParameter("proCategory");
    String[] proSizeArr = request.getParameterValues("proSize");
    String[] proStockArr = request.getParameterValues("proStock");
    String[] proColorArr = request.getParameterValues("proColor");
    String filename="";

    

    if(filePart != null && filePart.getSize()>0){
        filename=filePart.getSubmittedFileName();

        String uploadPath=request.getServletContext().getRealPath("/images");

        File uploadDir=new File(uploadPath);
        if(!uploadDir.exists()){
            uploadDir.mkdirs();
        }
        filePart.write(uploadPath+File.separator+filename);
        
    }

    //DB 정보저장
    Shop shop = new Shop();
    shop.setProName(proName);
    shop.setProPrice(proPrice);
    shop.setProCont(proCont);
    shop.setProCategory(proCategory);
    shop.setProImg(filename);

        try{
        ShopDAO dao = new ShopDAO();
        dao.insertProduct(conn, shop, proSizeArr, proColorArr, proStockArr);
        response.sendRedirect("adminMain.jsp");
    } catch (Exception e){
            out.println("상품등록 오류: "+e.getMessage());
        } 
        finally{
            if(conn!=null)
                conn.close();
        }
    %>
