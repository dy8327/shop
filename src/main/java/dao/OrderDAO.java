package dao;

import dto.OrderDTO;
import dto.OrderDetailDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    private Connection conn;

    public OrderDAO(Connection conn) {
        this.conn = conn;
    }

    // 토스 결제용 주문번호 생성
    public String createTossOrderId() {
        return "TEST_" + System.currentTimeMillis();
    }

    // 주문번호 시퀀스 먼저 가져오기
    public int getNextOrderId() throws SQLException {
        String sql = "SELECT ORDER_SEQ.NEXTVAL FROM DUAL";

        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        throw new SQLException("ORDER_ID 생성 실패");
    }

    // 장바구니 기준 주문 상세 목록 생성
    public List<OrderDetailDTO> getOrderDetailsFromCart(String memId) throws SQLException {
        List<OrderDetailDTO> detailList = new ArrayList<>();

        String sql =
            "SELECT C.PRO_ID, C.OPTION_ID, C.CART_QTY, P.PRO_PRICE " +
            "FROM CART C " +
            "JOIN PRODUCTS P ON C.PRO_ID = P.PRO_ID " +
            "WHERE C.MEM_ID = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, memId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    int qty = rs.getInt("CART_QTY");
                    int price = rs.getInt("PRO_PRICE");

                    OrderDetailDTO detail = new OrderDetailDTO();
                    detail.setProId(rs.getInt("PRO_ID"));
                    detail.setProOpId(rs.getInt("OPTION_ID"));
                    detail.setQuantity(qty);
                    detail.setProPrice(price);
                    detail.setSumPrice(qty * price);

                    detailList.add(detail);
                }
            }
        }

        return detailList;
    }

    // 주문 총 상품금액 계산
    public int calculateTotalPrice(List<OrderDetailDTO> detailList) {
        int totalPrice = 0;

        for (OrderDetailDTO detail : detailList) {
            totalPrice += detail.getSumPrice();
        }

        return totalPrice;
    }

    // ORDERS 저장
    public void insertReadyOrder(OrderDTO order) throws SQLException {
        String sql =
            "INSERT INTO ORDERS ( " +
            "ORDER_ID, MEM_ID, RECEIVER_NAME, RECEIVER_PHONE, RECEIVER_ADDR, DELIVERY_MEMO, " +
            "PAYMENT, TOTAL_PRICE, DELIVERY_FEE, FINAL_PRICE, ORDER_STATUS, " +
            "PAYMENT_STATUS, ORDER_ID_TOSS, PAID_AMOUNT, ORDER_DATE " +
            ") VALUES ( " +
            "?, ?, ?, ?, ?, ?, " +
            "?, ?, ?, ?, ?, " +
            "?, ?, ?, SYSDATE " +
            ")";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, order.getOrderId());
            pstmt.setString(2, order.getMemId());
            pstmt.setString(3, order.getReceiverName());
            pstmt.setString(4, order.getReceiverPhone());
            pstmt.setString(5, order.getReceiverAddr());
            pstmt.setString(6, order.getDeliveryMemo());
            pstmt.setString(7, order.getPayment());
            pstmt.setInt(8, order.getTotalPrice());
            pstmt.setInt(9, order.getDeliveryFee());
            pstmt.setInt(10, order.getFinalPrice());
            pstmt.setString(11, order.getOrderStatus());
            pstmt.setString(12, order.getPaymentStatus());
            pstmt.setString(13, order.getTossOrderId());
            pstmt.setInt(14, order.getPaidAmount());

            pstmt.executeUpdate();
        }
    }

    // ORDER_DETAIL 저장
    public void insertOrderDetails(int orderId, List<OrderDetailDTO> detailList) throws SQLException {
        String sql =
            "INSERT INTO ORDER_DETAIL ( " +
            "ORDER_DETAIL_ID, ORDER_ID, PRO_ID, PRO_OP_ID, QUANTITY, PRO_PRICE, SUM_PRICE " +
            ") VALUES ( " +
            "ORDER_DETAIL_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ? " +
            ")";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (OrderDetailDTO detail : detailList) {
                pstmt.setInt(1, orderId);
                pstmt.setInt(2, detail.getProId());
                pstmt.setInt(3, detail.getProOpId());
                pstmt.setInt(4, detail.getQuantity());
                pstmt.setInt(5, detail.getProPrice());
                pstmt.setInt(6, detail.getSumPrice());

                pstmt.addBatch();
            }

            pstmt.executeBatch();
        }
    }

    // 결제대기 주문 생성 전체 처리
    public int createReadyOrder(OrderDTO order) throws SQLException {
        List<OrderDetailDTO> detailList = getOrderDetailsFromCart(order.getMemId());

        if (detailList == null || detailList.isEmpty()) {
            throw new SQLException("장바구니가 비어 있습니다.");
        }

        int orderId = getNextOrderId();
        int deliveryFee = 3000;
        int totalPrice = calculateTotalPrice(detailList);
        int finalPrice = totalPrice + deliveryFee;

        order.setOrderId(orderId);
        order.setTotalPrice(totalPrice);
        order.setDeliveryFee(deliveryFee);
        order.setFinalPrice(finalPrice);

        insertReadyOrder(order);
        insertOrderDetails(orderId, detailList);

        return orderId;
    }
}
