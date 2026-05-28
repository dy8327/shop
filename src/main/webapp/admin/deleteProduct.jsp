<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");
    String proId = request.getParameter("id");

    PreparedStatement pstmt=null;
    ResultSet rs= null;
    
    try{
        conn.setAutoCommit(false);
    
    String delsql="SELECT * FROM PRODUCTS WHERE PRO_ID=?";
    pstmt=conn.prepareStatement(delsql);
    pstmt.setString(1, proId);
    rs=pstmt.executeQuery();

    if(rs.next()){
        rs.close();
        rs=null;
        pstmt.close();
        pstmt=null;

        String optionSql="DELETE FROM PRO_OPTION WHERE PRO_ID=?";
        pstmt=conn.prepareStatement(optionSql);
        pstmt.setString(1, proId);
        pstmt.executeUpdate();
        pstmt.close();
        pstmt=null; //중복 닫힘 예방

        String prosql="DELETE FROM PRODUCTS WHERE PRO_ID=?";
        pstmt=conn.prepareStatement(prosql);
        pstmt.setString(1, proId);
        pstmt.executeUpdate();

        conn.commit();
       response.sendRedirect("adminMain.jsp");
    } else{
        conn.rollback();
        out.println("일치하는 상품이 없습니다.");
    }
    } catch(Exception e){
        if(conn!=null){
            conn.rollback();
        }
        out.println("상품 삭제 오류: "+e.getMessage());
    } finally{
         if(rs!=null)
                rs.close();
            if(pstmt!=null)
                pstmt.close();
            if(conn!=null)
                conn.close();
    }
%>