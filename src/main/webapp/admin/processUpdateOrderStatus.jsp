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

    if (orderIdStr == null || orderIdStr.trim().equals("") ||
        orderStatus == null || orderStatus.trim().equals("")) {
%>
        <script>
            alert("잘못된 요청입니다.");
            history.back();
        </script>
<%
        return;
    }

    orderStatus = orderStatus.trim();

    if (deliveryCompany != null) {
        deliveryCompany = deliveryCompany.trim();
    }

    if (trackingNumber != null) {
        trackingNumber = trackingNumber.trim();
    }

    // 배송중일 때만 택배사/송장번호 필수
    if ("배송중".equals(orderStatus)) {
        if (deliveryCompany == null || deliveryCompany.equals("") ||
            trackingNumber == null || trackingNumber.equals("")) {
%>
            <script>
                alert("배송중으로 변경하려면 택배사와 송장번호가 필요합니다.");
                history.back();
            </script>
<%
            return;
        }
    }

    PreparedStatement statusPstmt = null;
    PreparedStatement detailPstmt = null;
    PreparedStatement stockPstmt = null;
    PreparedStatement updatePstmt = null;

    ResultSet statusRs = null;
    ResultSet detailRs = null;

    try {
        int orderId = Integer.parseInt(orderIdStr);

        conn.setAutoCommit(false);

        // 1. 현재 주문 상태 조회
        String statusSql =
            "SELECT TRIM(ORDER_STATUS) AS ORDER_STATUS " +
            "FROM ORDERS " +
            "WHERE ORDER_ID = ?";

        statusPstmt = conn.prepareStatement(statusSql);
        statusPstmt.setInt(1, orderId);
        statusRs = statusPstmt.executeQuery();

        if (!statusRs.next()) {
            conn.rollback();
%>
            <script>
                alert("주문 정보를 찾을 수 없습니다.");
                history.back();
            </script>
<%
            return;
        }

        String currentStatus = statusRs.getString("ORDER_STATUS");

        // 2. 이미 취소된 주문은 다른 상태로 변경 불가
        if ("주문취소".equals(currentStatus) && !"주문취소".equals(orderStatus)) {
            conn.rollback();
%>
            <script>
                alert("취소된 주문은 다른 상태로 변경할 수 없습니다.");
                history.back();
            </script>
<%
            return;
        }

        // 3. 주문취소로 처음 변경하는 경우만 재고 롤백
        if ("주문취소".equals(orderStatus) && !"주문취소".equals(currentStatus)) {

            String detailSql =
                "SELECT PRO_OP_ID, QUANTITY " +
                "FROM ORDER_DETAIL " +
                "WHERE ORDER_ID = ?";

            detailPstmt = conn.prepareStatement(detailSql);
            detailPstmt.setInt(1, orderId);
            detailRs = detailPstmt.executeQuery();

            String stockSql =
                "UPDATE PRO_OPTION " +
                "SET PRO_STOCK = PRO_STOCK + ? " +
                "WHERE OPTION_ID = ?";

            stockPstmt = conn.prepareStatement(stockSql);

            while (detailRs.next()) {
                int optionId = detailRs.getInt("PRO_OP_ID");
                int quantity = detailRs.getInt("QUANTITY");

                stockPstmt.setInt(1, quantity);
                stockPstmt.setInt(2, optionId);
                stockPstmt.executeUpdate();
            }

            // 주문취소면 배송정보는 비워도 됨
            deliveryCompany = "";
            trackingNumber = "";
        }

        // 4. 주문 상태 업데이트
        String updateSql =
            "UPDATE ORDERS " +
            "SET ORDER_STATUS = ?, DELIVERY_COMPANY = ?, TRACKING_NUMBER = ? " +
            "WHERE ORDER_ID = ?";

        updatePstmt = conn.prepareStatement(updateSql);
        updatePstmt.setString(1, orderStatus);
        updatePstmt.setString(2, deliveryCompany);
        updatePstmt.setString(3, trackingNumber);
        updatePstmt.setInt(4, orderId);

        int result = updatePstmt.executeUpdate();

        if (result > 0) {
            conn.commit();
%>
            <script>
                alert("주문 상태가 변경되었습니다.");
                location.href = "<%= request.getContextPath() %>/admin/orderDetail.jsp?orderId=<%= orderId %>";
            </script>
<%
        } else {
            conn.rollback();
%>
            <script>
                alert("주문 상태 변경에 실패했습니다.");
                history.back();
            </script>
<%
        }

    } catch (NumberFormatException e) {
        try {
            conn.rollback();
        } catch (Exception rollbackEx) {}

        e.printStackTrace();
%>
        <script>
            alert("주문번호 형식이 올바르지 않습니다.");
            history.back();
        </script>
<%
    } catch (Exception e) {
        try {
            conn.rollback();
        } catch (Exception rollbackEx) {}

        e.printStackTrace();
%>
        <script>
            alert("주문 상태 변경 오류가 발생했습니다.");
            history.back();
        </script>
<%
    } finally {
        try {
            conn.setAutoCommit(true);
        } catch (Exception e) {}

        if (detailRs != null) try { detailRs.close(); } catch(Exception e) {}
        if (statusRs != null) try { statusRs.close(); } catch(Exception e) {}

        if (updatePstmt != null) try { updatePstmt.close(); } catch(Exception e) {}
        if (stockPstmt != null) try { stockPstmt.close(); } catch(Exception e) {}
        if (detailPstmt != null) try { detailPstmt.close(); } catch(Exception e) {}
        if (statusPstmt != null) try { statusPstmt.close(); } catch(Exception e) {}
    }
%>