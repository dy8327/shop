<%@ page contentType="text/html; charset = utf-8" pageEncoding="UTF-8" %>
<%@ page import="dto.Shop" %>
<%@ page import="java.io.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="java.sql.*" %>
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

    Part filepart = request.getPart("filename");

    if(filePart != null && filePart.getSize()>0){
        filename=filePart.getSubmittedFileName();

        String uploadPath=request.getServletContext().getRealPath("/images");

        File uploadDir=new File(uploadPath);
        
    }

    //DB 정보저장
    PreparedStatement pstmt=null;
    ResultSet rs= null;
    
        try{
            conn.setAutoCommit(false);
            int proId=0;

            String seqSql="SELECT SEQ_PRODUCTS.NEXTVAL FROM DUAL";
            pstmt=conn.prepareStatement(seqSql);
            rs=pstmt.executeQuery();

            if(rs.next()){
                proId=rs.getInt(1);
            }
            rs.close();
            pstmt.close();

            String productSql=
            "INSERT INTO PRODUCTS "+
            "(PRO_ID, PRO_NAME, PRO_PRICE, PRO_CONT, PRO_CATEGORY, PRO_IMG) "+
            "VALUES(?, ?, ?, ?, ?, ?)";

            pstmt=conn.prepareStatement(productSql);
            pstmt.setInt(1, proId);
            pstmt.setString(2, proName);
            pstmt.setInt(3, proPrice);
            pstmt.setString(4, proCont);
            pstmt.setString(5, proCategory);
            pstmt.setString(6, filename);
            pstmt.executeUpdate();
            pstmt.close();

            String optionSql=
            "INSERT INTO PRO_OPTION "+
            "(OPTION_ID, PRO_ID, PRO_SIZE, PRO_COLOR, PRO_STOCK) "+
            "VALUES(SEQ_PRODUCTSOPTION.NEXTVAL, ?, ?, ?, ?)";

            pstmt=conn.prepareStatement(optionSql);
            pstmt.setInt(1, proId);
            pstmt.setString(2, proSize);
            pstmt.setString(3, proColor);
            pstmt.setInt(4, proStock);
            pstmt.executeUpdate();
            conn.commit();

            response.sendRedirect("adminMain.jsp");
        } finally{
            if(rs!=null)
                rs.close();
            if(pstmt!=null)
                pstmt.close();
            if(conn!=null)
                conn.close();
        }
    %>
