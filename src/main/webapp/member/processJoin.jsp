<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    String memId=request.getParameter("memId");
    String memPw=request.getParameter("memPw");
    String memName=request.getParameter("memName");
    String memPhone=request.getParameter("memPhone");
    String memEmail=request.getParameter("memEmail");

    PreparedStatement pstmt = null;

    try{
        String sql = "INSERT INTO MEMBERS (MEM_ID, MEM_PW, MEM_NAME, MEM_PHONE, MEM_EMAIL, MEM_ROLE, MEM_GRADE, MEM_DATE) VALUES(?, ?, ?, ?, ?, 'USER', 'GREEN', SYSDATE)";
        pstmt = conn.prepareStatement(sql);

        pstmt.setString(1, memId);
        pstmt.setString(2, memPw);
        pstmt.setString(3, memName);
        pstmt.setString(4, memPhone);
        pstmt.setString(5, memEmail);

        pstmt.executeUpdate();
        
        response.sendRedirect("joinResult.jsp");
    } catch (Exception e){
        out.println("회원가입 오류: " + e. getMessage());
    } finally {
        if (pstmt != null)
        pstmt.close();
        if(conn != null)
        conn.close();
    }
%>