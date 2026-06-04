<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="dao.OrderDAO" %>
<%@ page import="dto.OrderDTO" %>
<%@ page import="dto.OrderDetailDTO" %>
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

int orderId = 0;

    try {
        orderId = Integer.parseInt(orderIdStr);
    } catch (NumberFormatException e) {
%>
        <script>
            alert("주문번호 형식이 올바르지 않습니다.");
            location.href = "<%=request.getContextPath() %>/admin/orderManage.jsp";
        </script>
<%
        return;
    }

    int orderId = Integer.parseInt(orderIdStr);

    OrderDTO order = null;
    List<OrderDetailDTO> detailList = new ArrayList<>();

    try {
        OrderDAO orderDAO = new OrderDAO(conn);

        order = orderDAO.getOrderById(orderId);
        detailList = orderDAO.getOrderDetailsByOrderId(orderId);

        if (order == null) {
%>
            <script>
                alert("주문 정보를 찾을 수 없습니다.");
                location.href = "<%=request.getContextPath() %>/admin/orderManage.jsp";
            </script>
<%
            return;
        }

    } catch (Exception e) {
%>
        <script>
            alert("주문 상세 조회 오류가 발생했습니다.");
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
<link rel="stylesheet" href="<%=request.getContextPath() %>/css/style.css">
</head>
<body>

<%@ include file="/admin/adminMenu.jsp" %>

<div class="admin-wrap">

    <h1>주문 상세</h1>
    <h2>Order Detail</h2>

    <section class="panel">
        <h3>주문 정보</h3>

        <table class="admin-product-table">
            <tr>
                <th>주문번호</th>
                <td><%=order.getOrderId() %></td>
                <th>주문일</th>
                <td><%=order.getOrderDate() %></td>
            </tr>

            <tr>
                <th>회원명</th>
                <td><%=order.getMemName() %></td>
                <th>회원ID</th>
                <td><%=order.getMemId() %></td>
            </tr>

            <tr>
                <th>결제수단</th>
                <td><%=order.getPayment() %></td>
                <th>합계금액</th>
                <td><%=String.format("%,d", order.getTotalPrice()) %>원</td>
            </tr>

            <tr>
                <th>현재상태</th>
                <td colspan="3">
                    <span class="order-status">
                        <%=order.getOrderStatus() %>
                    </span>
                </td>
            </tr>
        </table>
    </section>

    <section class="panel" style="margin-top:24px;">
        <h3>배송 정보</h3>

        <table class="admin-product-table">
            <tr>
                <th>수령인</th>
                <td><%=order.getReceiverName() %></td>
                <th>연락처</th>
                <td><%=order.getReceiverPhone() %></td>
            </tr>

            <tr>
                <th>주소</th>
                <td colspan="3"><%=order.getReceiverAddr() %></td>
            </tr>

            <tr>
                <th>배송메모</th>
                <td colspan="3">
                    <%=order.getDeliveryMemo() == null ? "" : order.getDeliveryMemo() %>
                </td>
            </tr>

            <tr>
                <th>택배사</th>
                <td><%=order.getDeliveryCompany() == null ? "" : order.getDeliveryCompany() %></td>
                <th>송장번호</th>
                <td><%=order.getTrackingNumber() == null ? "" : order.getTrackingNumber() %></td>
            </tr>
        </table>
    </section>

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
                for (OrderDetailDTO detail : detailList) {
            %>
                <tr>
                    <td><%=detail.getProName() %></td>
                    <td><%=detail.getProSize() %></td>
                    <td><%=detail.getProColor() %></td>
                    <td><%=detail.getQuantity() %>개</td>
                    <td><%=String.format("%,d", detail.getProPrice()) %>원</td>
                    <td><%=String.format("%,d", detail.getSumPrice()) %>원</td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </section>

    <section class="panel" style="margin-top:24px;">
        <h3>주문 상태 변경</h3>

        <form action="<%=request.getContextPath() %>/admin/processUpdateOrderStatus.jsp"
              method="post"
              class="admin-form"
              onsubmit="return checkDeliveryInfo(this);">

            <input type="hidden" name="orderId" value="<%=order.getOrderId() %>">

            <div class="form-row">
                <label>주문 상태</label>
                <select name="orderStatus">
                    <option value="주문완료" <%="주문완료".equals(order.getOrderStatus()) ? "selected" : "" %>>
                        주문완료
                    </option>

                    <option value="배송준비중" <%="배송준비중".equals(order.getOrderStatus()) ? "selected" : "" %>>
                        배송준비중
                    </option>

                    <option value="배송중" <%="배송중".equals(order.getOrderStatus()) ? "selected" : "" %>>
                        배송중
                    </option>

                    <option value="배송완료" <%="배송완료".equals(order.getOrderStatus()) ? "selected" : "" %>>
                        배송완료
                    </option>

                    <option value="취소요청" <%="취소요청".equals(order.getOrderStatus()) ? "selected" : "" %>>
                        취소요청
                    </option>

                    <option value="주문취소" <%="주문취소".equals(order.getOrderStatus()) ? "selected" : "" %>>
                        주문취소
                    </option>
                </select>
            </div>

            <div class="form-row">
                <label>택배사</label>
                <select name="deliveryCompany">
                    <option value="">택배사 선택</option>

                    <option value="CJ대한통운" <%="CJ대한통운".equals(order.getDeliveryCompany()) ? "selected" : "" %>>
                        CJ대한통운
                    </option>

                    <option value="우체국택배" <%="우체국택배".equals(order.getDeliveryCompany()) ? "selected" : "" %>>
                        우체국택배
                    </option>

                    <option value="한진택배" <%="한진택배".equals(order.getDeliveryCompany()) ? "selected" : "" %>>
                        한진택배
                    </option>

                    <option value="롯데택배" <%="롯데택배".equals(order.getDeliveryCompany()) ? "selected" : "" %>>
                        롯데택배
                    </option>
                </select>
            </div>

            <div class="form-row">
                <label>송장번호</label>
                <input type="text"
                       name="trackingNumber"
                       value="<%=order.getTrackingNumber() == null ? "" : order.getTrackingNumber() %>"
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
<%
    if (conn != null) {
        try { conn.close(); } catch(Exception e) {}
    }
%>
<%@ include file="../footer.jsp" %>

</body>
</html>