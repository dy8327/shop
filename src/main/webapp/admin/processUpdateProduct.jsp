<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
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
    PreparedStatement pstmt=null;
    
    
        try{
            conn.setAutoCommit(false);
               
            String productSql=
            "UPDATE PRODUCTS SET "+
            "PRO_NAME=?, PRO_PRICE=?, PRO_CONTENT=?, PRO_CATEGORY=?, PRO_IMG=? "+
            "WHERE PRO_ID=?";

            pstmt=conn.prepareStatement(productSql);
            
            pstmt.setString(1, proName);
            pstmt.setInt(2, proPrice);
            pstmt.setString(3, proCont);
            pstmt.setString(4, proCategory);
            pstmt.setString(5, filename);
            pstmt.setInt(6, proId);
            pstmt.executeUpdate();
            pstmt.close();

            String optionSql=
            "UPDATE PRO_OPTION SET "+
            "PRO_SIZE=?, PRO_COLOR=?, PRO_STOCK=? "+
            "WHERE PRO_ID=?";

            pstmt=conn.prepareStatement(optionSql);
            
            pstmt.setString(1, proSize);
            pstmt.setString(2, proColor);
            pstmt.setInt(3, proStock);
            pstmt.setInt(4, proId);
            pstmt.executeUpdate();
            conn.commit();

            response.sendRedirect("adminMain.jsp");
        } catch (Exception e){
            if (conn!=null){
                conn.rollback();
            }
            out.println("상품수정 오류: "+e.getMessage());
        } 
        finally{
            if(pstmt!=null)
                pstmt.close();
            if(conn!=null)
                conn.close();
        }

%>