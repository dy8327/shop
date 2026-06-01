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
            location.href = "<%=request.getContextPath() %>/member/login.jsp";
        </script>
<%
        return;
    }

    String orderIdStr = request.getParameter("orderId");

    if (orderIdStr == null || orderIdStr.trim().equals("")) {
%>
        <script>
            alert("잘못된 접근입니다.");
            location.href = "<%=request.getContextPath() %>/admin/orderManage.jsp";
        </script>
<%
        return;
    }

    int orderId = Integer.parseInt(orderIdStr);

    PreparedStatement orderPstmt = null;
    PreparedStatement detailPstmt = null;
    ResultSet orderRs = null;
    ResultSet detailRs = null;

    String orderSql =
        "SELECT " +
        "o.ORDER_ID, o.MEM_ID, o.RECEIVER_NAME, o.RECEIVER_PHONE, o.RECEIVER_ADDR, o.DELIVERY_MEMO, " +
        "o.PAYMENT, o.TOTAL_PRICE, o.ORDER_STATUS, o.ORDER_DATE, o.DELIVERY_COMPANY, o.TRACKING_NUMBER, m.MEM_NAME " +
        "FROM ORDERS o " +
        "JOIN MEMBERS m ON o.MEM_ID = m.MEM_ID " +
        "WHERE o.ORDER_ID = ?";

    String detailSql =
        "SELECT " +
        "PRO_NAME, PRO_SIZE, PRO_COLOR, QUANTITY, PRO_PRICE " +
        "FROM ORDER_DETAIL " +
        "WHERE ORDER_ID = ?";

    try {
        orderPstmt = conn.prepareStatement(orderSql);
        orderPstmt.setInt(1, orderId);
        orderRs = orderPstmt.executeQuery();

        if (!orderRs.next()) {
%>
            <script>
                alert("주문 정보를 찾을 수 없습니다.");
                location.href = "<%=request.getContextPath() %>/admin/orderManage.jsp";
            </script>
<%
            return;
        }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 상세</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<%@ include file="/admin/adminMenu.jsp" %>

<div class="admin-wrap">

    <h1>주문 상세</h1>
    <h2>Order Detail</h2>

    <!-- 주문 기본 정보 -->
    <section class="panel">
        <h3>주문 정보</h3>

        <table class="admin-product-table">
            <tr>
                <th>주문번호</th>
                <td><%=orderRs.getInt("ORDER_ID") %></td>
                <th>주문일</th>
                <td><%=orderRs.getDate("ORDER_DATE") %></td>
            </tr>

            <tr>
                <th>회원명</th>
                <td><%=orderRs.getString("MEM_NAME") %></td>
                <th>회원ID</th>
                <td><%=orderRs.getString("MEM_ID") %></td>
            </tr>

            <tr>
                <th>결제수단</th>
                <td><%=orderRs.getString("PAYMENT") %></td>
                <th>합계금액</th>
                <td><%=String.format("%,d", orderRs.getInt("TOTAL_PRICE")) %>원</td>
            </tr>

            <tr>
                <th>현재상태</th>
                <td colspan="3">
                    <span class="order-status">
                        <%=orderRs.getString("ORDER_STATUS") %>
                    </span>
                </td>
            </tr>
        </table>
    </section>

    <!-- 배송 정보 -->
    <section class="panel" style="margin-top:24px;">
        <h3>배송 정보</h3>

        <table class="admin-product-table">
            <tr>
                <th>수령인</th>
                <td><%=orderRs.getString("RECEIVER_NAME") %></td>
                <th>연락처</th>
                <td><%=orderRs.getString("RECEIVER_PHONE") %></td>
            </tr>

            <tr>
                <th>주소</th>
                <td colspan="3"><%=orderRs.getString("RECEIVER_ADDR") %></td>
            </tr>

            <tr>
                <th>배송메모</th>
                <td colspan="3">
                    <%=orderRs.getString("DELIVERY_MEMO") == null ? "" : orderRs.getString("DELIVERY_MEMO") %>
                </td>
            </tr>

            <tr>
                <th>택배사</th>
                <td><%=orderRs.getString("DELIVERY_COMPANY") == null ? "" : orderRs.getString("DELIVERY_COMPANY") %></td>
                <th>송장번호</th>
                <td><%=orderRs.getString("TRACKING_NUMBER") == null ? "" : orderRs.getString("TRACKING_NUMBER") %></td>
            </tr>
        </table>
    </section>

    <!-- 주문 상품 정보 -->
    <section class="panel" style="margin-top:24px;">
        <h3>주문 상품</h3>

        <table class="admin-product-table">
            <thead>
                <tr>
                    <th>상품명</th>
                    <th>사이즈</th>
                    <th>색상</th>
                    <th>수량</th>
                    <th>상품금액</th>
                    <th>소계</th>
                </tr>
            </thead>

            <tbody>
            <%
                detailPstmt = conn.prepareStatement(detailSql);
                detailPstmt.setInt(1, orderId);
                detailRs = detailPstmt.executeQuery();

                while (detailRs.next()) {
                    int qty = detailRs.getInt("QUANTITY");
                    int price = detailRs.getInt("PRO_PRICE");
                    int subtotal = qty * price;
            %>
                <tr>
                    <td><%=detailRs.getString("PRO_NAME") %></td>
                    <td><%=detailRs.getString("PRO_SIZE") %></td>
                    <td><%=detailRs.getString("PRO_COLOR") %></td>
                    <td><%=qty %>개</td>
                    <td><%=String.format("%,d", price) %>원</td>
                    <td><%=String.format("%,d", subtotal) %>원</td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </section>

    <!-- 관리자 주문 처리 -->
    <section class="panel" style="margin-top:24px;">
        <h3>주문 상태 변경</h3>

        <form action="<%=request.getContextPath() %>/admin/processUpdateOrderStatus.jsp"
              method="post"
              class="admin-form"
              onsubmit="return checkDeliveryInfo(this);">

            <input type="hidden" name="orderId" value="<%=orderRs.getInt("ORDER_ID") %>">

            <div class="form-row">
                <label>주문 상태</label>
                <select name="orderStatus">
                    <option value="주문완료"
                        <%="주문완료".equals(orderRs.getString("ORDER_STATUS")) ? "selected" : "" %>>
                        주문완료
                    </option>

                    <option value="배송준비"
                        <%="배송준비".equals(orderRs.getString("ORDER_STATUS")) ? "selected" : "" %>>
                        배송준비
                    </option>

                    <option value="배송중"
                        <%="배송중".equals(orderRs.getString("ORDER_STATUS")) ? "selected" : "" %>>
                        배송중
                    </option>

                    <option value="배송완료"
                        <%="배송완료".equals(orderRs.getString("ORDER_STATUS")) ? "selected" : "" %>>
                        배송완료
                    </option>

                    <option value="주문취소"
                        <%="주문취소".equals(orderRs.getString("ORDER_STATUS")) ? "selected" : "" %>>
                        주문취소
                    </option>
                </select>
            </div>

            <div class="form-row">
                <label>택배사</label>
                <select name="deliveryCompany">
                    <option value="">택배사 선택</option>

                    <option value="CJ대한통운"
                        <%="CJ대한통운".equals(orderRs.getString("DELIVERY_COMPANY")) ? "selected" : "" %>>
                        CJ대한통운
                    </option>

                    <option value="우체국택배"
                        <%="우체국택배".equals(orderRs.getString("DELIVERY_COMPANY")) ? "selected" : "" %>>
                        우체국택배
                    </option>
                </select>
            </div>

            <div class="form-row">
                <label>송장번호</label>
                <input type="text"
                       name="trackingNumber"
                       value="<%=orderRs.getString("TRACKING_NUMBER") == null ? "" : orderRs.getString("TRACKING_NUMBER") %>"
                       placeholder="송장번호를 입력하세요">
            </div>

            <div class="form-btn-area">
                <button type="submit" class="admin-btn">상태 변경</button>
                <a href="<%=request.getContextPath() %>/admin/orderManage.jsp" class="outline">
                    목록으로
                </a>
            </div>
        </form>
    </section>

</div>

<script>
function checkDeliveryInfo(form) {
    const status = form.orderStatus.value;
    const company = form.deliveryCompany.value;
    const tracking = form.trackingNumber.value.trim();

    if (status === "배송중") {
        if (company === "") {
            alert("배송중으로 변경하려면 택배사를 선택해야 합니다.");
            form.deliveryCompany.focus();
            return false;
        }

        if (tracking === "") {
            alert("배송중으로 변경하려면 송장번호를 입력해야 합니다.");
            form.trackingNumber.focus();
            return false;
        }
    }

    return confirm("주문 상태를 변경하시겠습니까?");
}
</script>

<%@ include file="../footer.jsp" %>

</body>
</html>

<%
    } catch (Exception e) {
%>
        <script>
            alert("주문 상세 조회 오류: <%=e.getMessage() %>");
            location.href = "<%=request.getContextPath() %>/admin/orderManage.jsp";
        </script>
<%
    } finally {
        if (detailRs != null) 
            detailRs.close();
        if (detailPstmt != null)
            detailPstmt.close();
        if (orderRs != null) 
            orderRs.close();
        if (orderPstmt != null)
            orderPstmt.close();
    }
%>