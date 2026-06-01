<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>

<%
String memId = (String) session.getAttribute("memId");
String orderId = request.getParameter("orderId");

if (memId == null) {
%>
<script>
    alert("로그인이 필요합니다.");
    location.href = "<%=request.getContextPath()%>/member/login.jsp";
</script>
<%
    return;
}

PreparedStatement pstmt = null;

try {
    String sql =
        "UPDATE ORDERS " +
        "SET ORDER_STATUS = '취소요청' " +
        "WHERE ORDER_ID = ? " +
        "AND MEM_ID = ? " +
        "AND ORDER_STATUS = '주문완료'";

    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, Integer.parseInt(orderId));
    pstmt.setString(2, memId);

    int result = pstmt.executeUpdate();

    if (result > 0) {
%>
<script>
    alert("취소신청이 완료되었습니다.");
    location.href = "<%=request.getContextPath()%>/member/memberOrderList.jsp";
</script>
<%
    } else {
%>
<script>
    alert("취소신청할 수 없는 주문입니다.");
    location.href = "<%=request.getContextPath()%>/member/memberOrderList.jsp";
</script>
<%
    }

} catch(Exception e) {
    out.println("취소신청 오류: " + e.getMessage());
} finally {
    if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
    if(conn != null) try { conn.close(); } catch(Exception e) {}
}
%>