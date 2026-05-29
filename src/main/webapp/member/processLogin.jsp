<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.MemberDAO" %> 
<%@ page import="dto.Member" %> 
<%@ include file="../dbconn.jsp" %> 

<% 
request.setCharacterEncoding("UTF-8"); 
String memId = request.getParameter("memId"); 
String memPw = request.getParameter("memPw"); 

 // 1. 입력값 유효성 검사
    if (memId == null || memId.trim().equals("")) {
        response.sendRedirect("login.jsp?error=id_empty");
        return;
    }

    if (memPw == null || memPw.trim().equals("")) {
        response.sendRedirect("login.jsp?error=pw_empty");
        return;
    }


try { 
        MemberDAO dao=new MemberDAO(conn);
        Member member = dao.login(memId, memPw);
        if(member!=null){
        session.setAttribute("memId", member.getMemId()); 
        session.setAttribute("memName", member.getMemName()); 
        session.setAttribute("memRole", member.getMemRole());
        session.setAttribute("memGrade", member.getMemGrade()); 
        response.sendRedirect("../index.jsp"); 
        } else { 
            %>
            <script>
            alert("아이디 또는 비밀번호를 확인해주세요.");
            location.href = "login.jsp";
            </script>
            <%
            }   
            } catch (Exception e) {
                out.println("로그인 오류: " + e.getMessage()); 
                } finally { 
                    if (conn != null) 
                    conn.close(); 
                    } 
    %>