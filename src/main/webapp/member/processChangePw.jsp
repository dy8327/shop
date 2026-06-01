<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>

<%
String memId = (String)session.getAttribute("memId");

if(memId == null){
%>
<script>
alert("로그인이 필요합니다.");
location.href="<%=request.getContextPath()%>/member/login.jsp";
</script>
<%
return;
}

String currentPw =
request.getParameter("currentPw");

String currentPwCheck =
request.getParameter("currentPwCheck");

String newPw =
request.getParameter("newPw");


if(!currentPw.equals(currentPwCheck)){
%>
<script>
alert("현재 비밀번호 확인이 일치하지 않습니다.");
history.back();
</script>
<%
return;
}

PreparedStatement pstmt = null;
ResultSet rs = null;

try{

    String sql =
    "SELECT MEM_PW " +
    "FROM MEMBERS " +
    "WHERE MEM_ID=?";

    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, memId);

    rs = pstmt.executeQuery();

    if(rs.next()){

        String dbPw =
        rs.getString("MEM_PW");

        if(!dbPw.equals(currentPw)){
%>
<script>
alert("현재 비밀번호가 올바르지 않습니다.");
history.back();
</script>
<%
return;
        }
    }

    if(rs!=null) rs.close();
    if(pstmt!=null) pstmt.close();

    sql =
    "UPDATE MEMBERS " +
    "SET MEM_PW=? " +
    "WHERE MEM_ID=?";

    pstmt = conn.prepareStatement(sql);

    pstmt.setString(1,newPw);
    pstmt.setString(2,memId);

    int result =
    pstmt.executeUpdate();

    if(result>0){
%>
<script>
alert("비밀번호가 변경되었습니다.");
location.href="<%=request.getContextPath()%>/member/myPage.jsp";
</script>
<%
    }else{
%>
<script>
alert("비밀번호 변경 실패");
history.back();
</script>
<%
    }

}catch(Exception e){

    out.println("오류 : "+e.getMessage());

}finally{

    if(rs!=null) try{rs.close();}catch(Exception e){}
    if(pstmt!=null) try{pstmt.close();}catch(Exception e){}
    if(conn!=null) try{conn.close();}catch(Exception e){}
}
%>