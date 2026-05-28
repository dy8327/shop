<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="dto.Shop" %>
<%@ page import="dao.ShopDAO" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ include file="../dbconn.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    
    String proName=request.getParameter("proName");
    int proPrice=Integer.parseInt(request.getParameter("proPrice"));
    String proSize=request.getParameter("proSize");
    int proStock=Integer.parseInt(request.getParameter("proStock"));
    String proColor=request.getParameter("proColor");
    String proCont=request.getParameter("proCont");
    String proCategory=request.getParameter("proCategory");
    String filename="";

    Part filePart = request.getPart("filename");

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
    shop.setProSize(proSize);
    shop.setProStock(proStock);
    shop.setProColor(proColor);
    shop.setProCont(proCont);
    shop.setProCategory(proCategory);
    shop.setProImg(filename);

        try{
        ShopDAO dao = new ShopDAO();
        dao.insertProduct(conn, shop);
        response.sendRedirect("adminMain.jsp");
    } catch (Exception e){
            out.println("상품등록 오류: "+e.getMessage());
        } 
        finally{
            if(conn!=null)
                conn.close();
        }
    %>
