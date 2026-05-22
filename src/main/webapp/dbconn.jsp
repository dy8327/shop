<%@ page import="java.sql.*" %>
<%
    Connection conn=null;

    String url = "jdbc:oracle:thin:@localhost:1521:xe";
    String user = "system";
    String password = "1234";

    Class.forName("oracle.jdbc.OracleDriver");
    conn=DriverManager.getConnection(url, user, password);
%>