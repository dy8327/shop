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
}
