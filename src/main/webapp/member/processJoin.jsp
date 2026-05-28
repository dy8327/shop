<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.MemberDAO" %> 
<%@ page import="dto.Member" %> 
<%@ include file="../dbconn.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    String memId=request.getParameter("memId");
    String memPw=request.getParameter("memPw");
    String memName = request.getParameter("memName");
    String memPhone = request.getParameter("memPhone");
    String memEmail = request.getParameter("memEmail");
try{
    Member member = new Member();
    member.setMemId(memId);
    member.setMemPw(memPw);
    member.setMemName(memName);
    member.setMemPhone(memPhone);
    member.setMemEmail(memEmail);

    MemberDAO dao = new MemberDAO(conn);

    int result = dao.join(member);

    if(result>0){     
        response.sendRedirect("joinResult.jsp");
        return;
    } else{
        response.sendRedirect("join.jsp?error=fail");
        return;
    }
    } catch (Exception e){
        out.println("회원가입 오류: "+e.getMessage());
    } 
    finally {
        if(conn != null)
        conn.close();
    }

%>