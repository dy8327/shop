<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %> 
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

PreparedStatement pstmt = null; 
ResultSet rs = null; 
try { 
    String sql = "SELECT MEM_ID, MEM_NAME, MEM_ROLE FROM MEMBERS WHERE MEM_ID = ? AND MEM_PW = ?"; 
    pstmt = conn.prepareStatement(sql); 
    pstmt.setString(1, memId); 
    pstmt.setString(2, memPw); 
    rs = pstmt.executeQuery(); 
    if (rs.next()) { 
        session.setAttribute("memId", rs.getString("MEM_ID")); 
        session.setAttribute("memName", rs.getString("MEM_NAME")); 
        session.setAttribute("memRole", rs.getString("MEM_ROLE")); 
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
                    if (rs != null) 
                    rs.close(); 
                    if (pstmt != null) 
                    pstmt.close(); 
                    if (conn != null) 
                    conn.close(); 
                    } 
    %>