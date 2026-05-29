<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="dto.Shop" %>
<%@ page import="dao.ShopDAO" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ include file="../dbconn.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    int proId=Integer.parseInt(request.getParameter("proId"));
    String proName=request.getParameter("proName");
    int proPrice=Integer.parseInt(request.getParameter("proPrice"));
    String proSize=request.getParameter("proSize");
    int proStock=Integer.parseInt(request.getParameter("proStock"));
    String proColor=request.getParameter("proColor");
    String proCont=request.getParameter("proCont");
    String proCategory=request.getParameter("proCategory");
    String oldFilename=request.getParameter("oldFilename");
    int proOpId=Integer.parseInt(request.getParameter("proOpId"));

    String filename=oldFilename;

    Part filePart=request.getPart("filename");

    if(filePart!=null && filePart.getSize()>0){
        String newFilename=filePart.getSubmittedFileName();

        if(newFilename!=null && !newFilename.equals("")){
            filename=newFilename;

            String uploadPath=request.getServletContext().getRealPath("/images");
        
            File uploadDir=new File(uploadPath);
            if(!uploadDir.exists()){
                uploadDir.mkdirs();
            }
            filePart.write(uploadPath+File.separator+filename);
        }
    }

     //DB 정보저장
    Shop shop = new Shop();
    shop.setProId(proId);
    shop.setProName(proName);
    shop.setProPrice(proPrice);
    shop.setProSize(proSize);
    shop.setProStock(proStock);
    shop.setProColor(proColor);
    shop.setProCont(proCont);
    shop.setProCategory(proCategory);
    shop.setProImg(filename);
    shop.setProOpId(proOpId);

    try{
        ShopDAO dao = new ShopDAO();
        dao.updateProduct(conn, shop);
        response.sendRedirect("adminMain.jsp");
    } catch (Exception e){
            out.println("상품수정 오류: "+e.getMessage());
        } 
        finally{
            if(conn!=null)
                conn.close();
        }

%>