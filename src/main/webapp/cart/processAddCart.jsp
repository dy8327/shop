<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String memId = (String) session.getAttribute("memId");

    if (memId == null) {
%>
        <script>
            alert("로그인이 필요합니다.");
            location.href = "<%=request.getContextPath()%>/member/login.jsp";
        </script>
<%
        return;
    }

    String proIdStr = request.getParameter("proId");
    String optionIdStr = request.getParameter("optionId");
    String quantityStr = request.getParameter("quantity");

    if (proIdStr == null || optionIdStr == null || quantityStr == null ||
        proIdStr.equals("") || optionIdStr.equals("") || quantityStr.equals("")) {
%>
        <script>
            alert("상품 옵션 정보가 올바르지 않습니다.");
            history.back();
        </script>
<%
        return;
    }

    int proId = Integer.parseInt(proIdStr);
    int optionId = Integer.parseInt(optionIdStr);
    int cartQty = Integer.parseInt(quantityStr);

    if (cartQty < 1) {
        cartQty = 1;
    }

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String checkSql = "SELECT CART_ID, CART_QTY FROM CART " +
                          "WHERE MEM_ID = ? AND PRO_ID = ? AND OPTION_ID = ?";

        pstmt = conn.prepareStatement(checkSql);
        pstmt.setString(1, memId);
        pstmt.setInt(2, proId);
        pstmt.setInt(3, optionId);

        rs = pstmt.executeQuery();

        if (rs.next()) {
            int cartId = rs.getInt("CART_ID");
            int oldQty = rs.getInt("CART_QTY");
            int newQty = oldQty + cartQty;

            rs.close();
            pstmt.close();

            String updateSql = "UPDATE CART SET CART_QTY = ? " +
                               "WHERE CART_ID = ?";

            pstmt = conn.prepareStatement(updateSql);
            pstmt.setInt(1, newQty);
            pstmt.setInt(2, cartId);
            pstmt.executeUpdate();

        } else {
            rs.close();
            pstmt.close();

            String insertSql = "INSERT INTO CART " +
                               "(CART_ID, MEM_ID, PRO_ID, OPTION_ID, CART_QTY) " +
                               "VALUES (CART_SEQ.NEXTVAL, ?, ?, ?, ?)";

            pstmt = conn.prepareStatement(insertSql);
            pstmt.setString(1, memId);
            pstmt.setInt(2, proId);
            pstmt.setInt(3, optionId);
            pstmt.setInt(4, cartQty);
            pstmt.executeUpdate();
        }
%>
        <script>
            alert("장바구니에 추가되었습니다.");
            location.href = "<%=request.getContextPath()%>/product/product.jsp?proId=<%=proId%>&cart=success";
        </script>
<%
    } catch (Exception e) {
        out.println("장바구니 등록 오류: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if (conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>