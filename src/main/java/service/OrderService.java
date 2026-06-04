package service;

import java.sql.Connection;
import java.util.List;

import dao.OrderDAO;
import dto.OrderDTO;

public class OrderService {
    public List<OrderDTO> getAdminOrderList(Connection conn) throws Exception {
        OrderDAO orderDAO = new OrderDAO(conn);
        return orderDAO.getAdminOrderList();
    }

    public void updateOrderStatus(
        Connection conn,
        int orderId,
        String orderStatus,
        String deliveryCompany,
        String trackingNumber
) throws Exception {

    if (orderId <= 0 ||
    orderStatus == null || orderStatus.trim().equals("")) {
        throw new IllegalArgumentException("잘못된 요청입니다.");
    }

    
    orderStatus = orderStatus.trim();

    if (deliveryCompany != null) {
        deliveryCompany = deliveryCompany.trim();
    } else {
        deliveryCompany = "";
    }

    if (trackingNumber != null) {
        trackingNumber = trackingNumber.trim();
    } else {
        trackingNumber = "";
    }

    if ("배송중".equals(orderStatus)) {
        if (deliveryCompany.equals("") || trackingNumber.equals("")) {
            throw new IllegalArgumentException("배송중으로 변경하려면 택배사와 송장번호가 필요합니다.");
        }
    }

    OrderDAO orderDAO = new OrderDAO(conn);

    String currentStatus = orderDAO.getOrderStatus(orderId);

    if (currentStatus == null) {
        throw new IllegalArgumentException("주문 정보를 찾을 수 없습니다.");
    }

    if ("주문취소".equals(currentStatus) && !"주문취소".equals(orderStatus)) {
        throw new IllegalArgumentException("취소된 주문은 다른 상태로 변경할 수 없습니다.");
    }

    conn.setAutoCommit(false);

    try {
        if ("주문취소".equals(orderStatus) && !"주문취소".equals(currentStatus)) {
            orderDAO.restoreStockByOrderId(orderId);
            deliveryCompany = "";
            trackingNumber = "";
        }

        int result = orderDAO.updateOrderStatus(orderId, orderStatus, deliveryCompany, trackingNumber);

        if (result == 0) {
            throw new Exception("주문 상태 변경에 실패했습니다.");
        }

        conn.commit();

    } catch (Exception e) {
        conn.rollback();
        throw e;

    } finally {
        conn.setAutoCommit(true);
    }
}
}
