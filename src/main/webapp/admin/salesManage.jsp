<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");

    if (startDate == null) startDate = "";
    if (endDate == null) endDate = "";

    PreparedStatement summaryPstmt = null;
    PreparedStatement listPstmt = null;
    ResultSet summaryRs = null;
    ResultSet listRs = null;

    int totalOrderCount = 0;
    int normalOrderCount = 0;
    int cancelOrderCount = 0;
    int totalSales = 0;
    int todaySales = 0;

    try {
        String summarySql =
            "SELECT " +
            " COUNT(*) AS TOTAL_ORDER_COUNT, " +
            " SUM(CASE WHEN ORDER_STATUS <> '주문취소' THEN 1 ELSE 0 END) AS NORMAL_ORDER_COUNT, " +
            " SUM(CASE WHEN ORDER_STATUS = '주문취소' THEN 1 ELSE 0 END) AS CANCEL_ORDER_COUNT, " +
            " NVL(SUM(CASE WHEN ORDER_STATUS <> '주문취소' THEN TOTAL_PRICE ELSE 0 END), 0) AS TOTAL_SALES, " +
            " NVL(SUM(CASE WHEN ORDER_STATUS <> '주문취소' AND TRUNC(ORDER_DATE) = TRUNC(SYSDATE) THEN TOTAL_PRICE ELSE 0 END), 0) AS TODAY_SALES " +
            " FROM ORDERS ";

        summaryPstmt = conn.prepareStatement(summarySql);
        summaryRs = summaryPstmt.executeQuery();

        if (summaryRs.next()) {
            totalOrderCount = summaryRs.getInt("TOTAL_ORDER_COUNT");
            normalOrderCount = summaryRs.getInt("NORMAL_ORDER_COUNT");
            cancelOrderCount = summaryRs.getInt("CANCEL_ORDER_COUNT");
            totalSales = summaryRs.getInt("TOTAL_SALES");
            todaySales = summaryRs.getInt("TODAY_SALES");
        }

        StringBuilder listSql = new StringBuilder();
        listSql.append("SELECT ORDER_ID, MEM_ID, RECEIVER_NAME, TOTAL_PRICE, PAYMENT, ORDER_STATUS, ORDER_DATE ");
        listSql.append("FROM ORDERS ");
        listSql.append("WHERE 1=1 ");

        if (!startDate.equals("")) {
            listSql.append("AND ORDER_DATE >= TO_DATE(?, 'YYYY-MM-DD') ");
        }

        if (!endDate.equals("")) {
            listSql.append("AND ORDER_DATE < TO_DATE(?, 'YYYY-MM-DD') + 1 ");
        }

        listSql.append("ORDER BY ORDER_DATE DESC");

        listPstmt = conn.prepareStatement(listSql.toString());

        int paramIndex = 1;

        if (!startDate.equals("")) {
            listPstmt.setString(paramIndex++, startDate);
        }

        if (!endDate.equals("")) {
            listPstmt.setString(paramIndex++, endDate);
        }

        listRs = listPstmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 매출관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

<%@ include file="/admin/adminMenu.jsp" %>

<div class="admin-wrap">

    <h1>매출관리</h1>
    <p class="admin-subtitle">Sales Management</p>

    <div class="sales-summary-grid">
        <div class="sales-card">
            <span>전체 주문</span>
            <strong><%= totalOrderCount %>건</strong>
        </div>

        <div class="sales-card">
            <span>정상 주문</span>
            <strong><%= normalOrderCount %>건</strong>
        </div>

        <div class="sales-card">
            <span>취소 주문</span>
            <strong><%= cancelOrderCount %>건</strong>
        </div>

        <div class="sales-card">
            <span>오늘 매출</span>
            <strong><%= String.format("%,d", todaySales) %>원</strong>
        </div>

        <div class="sales-card total">
            <span>총 매출</span>
            <strong><%= String.format("%,d", totalSales) %>원</strong>
        </div>
    </div>

    <form method="get" action="salesManage.jsp" class="sales-search-form">
        <div>
            <label>시작일</label>
            <input type="date" name="startDate" value="<%= startDate %>">
        </div>

        <div>
            <label>종료일</label>
            <input type="date" name="endDate" value="<%= endDate %>">
        </div>

        <button type="submit" class="admin-btn">조회</button>
        <a href="salesManage.jsp" class="admin-btn reset">초기화</a>
    </form>

    <h2>주문별 매출 내역</h2>

    <table class="admin-product-table">
        <thead>
            <tr>
                <th>주문번호</th>
                <th>회원ID</th>
                <th>수령인</th>
                <th>결제수단</th>
                <th>주문상태</th>
                <th>결제금액</th>
                <th>주문일</th>
            </tr>
        </thead>

        <tbody>
        <%
            boolean hasData = false;

            while (listRs.next()) {
                hasData = true;

                String orderStatus = listRs.getString("ORDER_STATUS");
                String statusClass = "normal";

                if ("주문취소".equals(orderStatus)) {
                    statusClass = "cancel";
                } else if ("배송완료".equals(orderStatus)) {
                    statusClass = "dvcomplete";
                }
        %>
            <tr>
                <td><%= listRs.getInt("ORDER_ID") %></td>
                <td><%= listRs.getString("MEM_ID") %></td>
                <td><%= listRs.getString("RECEIVER_NAME") %></td>
                <td><%= listRs.getString("PAYMENT") %></td>
                <td>
                    <span class="order-status <%=statusClass %>">
                        <%=orderStatus %>
                    </span>
                </td>
                <td><%= String.format("%,d", listRs.getInt("TOTAL_PRICE")) %>원</td>
                <td><%= listRs.getTimestamp("ORDER_DATE") %></td>
            </tr>
        <%
            }

            if (!hasData) {
        %>
            <tr>
                <td colspan="7" style="text-align:center;">조회된 매출 내역이 없습니다.</td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>

</div>

</body>
</html>

<%
    } catch (Exception e) {
        out.println("매출관리 페이지 오류: " + e.getMessage());
    } finally {
        if (listRs != null) try { listRs.close(); } catch(Exception e) {}
        if (summaryRs != null) try { summaryRs.close(); } catch(Exception e) {}
        if (listPstmt != null) try { listPstmt.close(); } catch(Exception e) {}
        if (summaryPstmt != null) try { summaryPstmt.close(); } catch(Exception e) {}
    }
%>