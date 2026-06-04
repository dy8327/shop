package service;


import java.sql.Connection;
import dao.MemberDAO;

public class MemberService {
    public boolean isDuplicateId(Connection conn, String memId) throws Exception {

        if (memId == null || memId.trim().equals("")) {
            throw new IllegalArgumentException("아이디를 입력하세요.");
        }

        memId = memId.trim();

        MemberDAO memberDAO = new MemberDAO(conn);

        return memberDAO.existsById(memId);
    }
}
