<%@ page contentType="text/html; charset=utf-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 관리</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<%@ include file="/admin/adminMenu.jsp" %>

<div class="admin-wrap">
    <h1>회원 관리</h1>
    <p class="admin-subtitle">Member Management</p>

    <table class="admin-table">
        <tr>
            <th>회원ID</th>
            <th>회원명</th>
            <th>등급</th>
            <th>전화번호</th>
            <th>주문내역</th>
        </tr>

        <%
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try{
                String sql = "SELECT MEM_ID, MEM_NAME, MEM_GRADE, MEM_PHONE FROM MEMBERS ORDER BY MEM_ID DESC";
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();

                while(rs.next()){
        %>
        <tr>
            <td><%=rs.getString("MEM_ID") %></td>
            <td><%=rs.getString("MEM_NAME") %></td>
            <td><%=rs.getString("MEM_GRADE") %></td>
            <td><%=rs.getString("MEM_PHONE") %></td>
            <td>
                <a href="adminOrderList.jsp?id=<%= rs.getString("MEM_ID") %>" class="admin-btn">
                    주문내역
                </a>
            </td>
        </tr>
        <%
                }
            } catch(Exception e){
                out.println("<tr><td colspan='5'>회원 목록 조회 오류: "+ e.getMessage() +"</td></tr>");
            } finally {
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            }
        %>
    </table>
</div>

</body>
</html>