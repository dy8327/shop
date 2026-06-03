<%@ page contentType="text/html; charset=utf-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="dao.MemberDAO" %>
<%@ page import="dto.Member" %>
<%@ include file="../dbconn.jsp" %>

<%
    List<Member> memberList = new ArrayList<>();

    try {
        MemberDAO memberDAO = new MemberDAO(conn);
        memberList = memberDAO.getAllMembers();
    } catch(Exception e) {
        out.println("<script>alert('회원 목록 조회 오류: " + e.getMessage() + "');</script>");
    }
%>

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
            if (memberList == null || memberList.size() == 0) {
        %>
        <tr>
            <td colspan="5" style="text-align:center;">회원 목록이 없습니다.</td>
        </tr>
        <%
            } else {
                for (Member member : memberList) {
        %>
        <tr>
            <td><%=member.getMemId() %></td>
            <td><%=member.getMemName() %></td>
            <td><%=member.getMemGrade() %></td>
            <td><%=member.getMemPhone() %></td>
            <td>
                <a href="adminOrderList.jsp?id=<%=member.getMemId() %>" class="admin-btn">
                    주문내역
                </a>
            </td>
        </tr>
        <%
                }
            }

            if (conn != null) conn.close();
        %>
    </table>
</div>

</body>
</html>