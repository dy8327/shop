<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String adminId = (String) session.getAttribute("memId");
    String adminRole = (String) session.getAttribute("memRole");

    if (adminId == null || !"ADMIN".equals(adminRole)) {
%>
        <script>
            alert("관리자만 접근 가능합니다.");
            location.href = "<%= request.getContextPath() %>/member/login.jsp";
        </script>
<%
        return;
    }

    String orderIdStr = request.getParameter("orderId");
    String orderStatus = request.getParameter("orderStatus");
    String deliveryCompany = request.getParameter("deliveryCompany");
    String trackingNumber = request.getParameter("trackingNumber");

    if (orderIdStr == null || orderStatus == null ||
        orderIdStr.trim().equals("") || orderStatus.trim().equals("")) {
%>
        <script>
            alert("잘못된 요청입니다.");
            history.back();
        </script>
<%
        return;
    }

    if ("배송중".equals(orderStatus)) {
        if (deliveryCompany == null || deliveryCompany.trim().equals("") ||
            trackingNumber == null || trackingNumber.trim().equals("")) {
%>
            <script>
                alert("배송중으로 변경하려면 택배사와 송장번호를 입력해야 합니다.");
                history.back();
            </script>
<%
            return;
        }
    }

    PreparedStatement pstmt = null;

    try {
        int orderId = Integer.parseInt(orderIdStr);

        String sql =
            "UPDATE ORDERS " +
            "SET ORDER_STATUS = ?, DELIVERY_COMPANY = ?, TRACKING_NUMBER = ? " +
            "WHERE ORDER_ID = ?";

        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, orderStatus);
        pstmt.setString(2, deliveryCompany);
        pstmt.setString(3, trackingNumber);
        pstmt.setInt(4, orderId);

        int result = pstmt.executeUpdate();

        if (result > 0) {
%>
            <script>
                alert("주문 정보가 변경되었습니다.");
                location.href = "<%= request.getContextPath() %>/admin/orderManage.jsp";
            </script>
<%
        } else {
%>
            <script>
                alert("변경할 주문을 찾을 수 없습니다.");
                history.back();
            </script>
<%
        }

    } catch (NumberFormatException e) {
%>
        <script>
            alert("주문번호 형식이 올바르지 않습니다.");
            history.back();
        </script>
<%
    } catch (Exception e) {
%>
        <script>
            alert("주문 정보 변경 오류: <%= e.getMessage() %>");
            history.back();
        </script>
<%
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
    }
%>