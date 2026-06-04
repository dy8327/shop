package dao;

import dto.Member;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MemberDAO {
    //로그인
    private Connection conn;
    public MemberDAO(Connection conn){
        this.conn=conn;
    }

    public MemberDAO() {
    }

    public Member login(String memId, String memPw) throws SQLException{
        String sql = "SELECT MEM_ID, MEM_NAME, MEM_ROLE, MEM_GRADE FROM MEMBERS "+
        "WHERE MEM_ID = ? AND MEM_PW = ?"; 

        PreparedStatement pstmt = null; 
        ResultSet rs = null; 

        try{
            pstmt = conn.prepareStatement(sql); 
            pstmt.setString(1, memId); 
            pstmt.setString(2, memPw); 
            rs = pstmt.executeQuery(); 
            if (rs.next()) { 
                Member member = new Member();
                member.setMemId(rs.getString("MEM_ID"));
                member.setMemName(rs.getString("MEM_NAME"));
                member.setMemRole(rs.getString("MEM_ROLE"));
                member.setMemGrade(rs.getString("MEM_GRADE"));

                return member;
        }
        return null;
    } finally{
        if(rs!=null)
            rs.close();
        if(pstmt!=null)
            pstmt.close();
    }
}

public int join(Member member) throws SQLException{
    PreparedStatement pstmt = null;

    try{
        String sql = "INSERT INTO MEMBERS (MEM_ID, MEM_PW, MEM_NAME, MEM_PHONE, MEM_EMAIL, MEM_ROLE, MEM_GRADE, MEM_DATE) VALUES(?, ?, ?, ?, ?, 'USER', 'GREEN', SYSDATE)";
        pstmt = conn.prepareStatement(sql);

        pstmt.setString(1, member.getMemId());
        pstmt.setString(2, member.getMemPw());
        pstmt.setString(3, member.getMemName());
        pstmt.setString(4, member.getMemPhone());
        pstmt.setString(5, member.getMemEmail());

        return pstmt.executeUpdate();
} finally{
    if(pstmt!=null)
        pstmt.close();
}
}

public String getCustomerKey(String memId) throws SQLException {
    String customerKey = null;

    String sql = "SELECT CUSTOMER_KEY FROM MEMBERS WHERE MEM_ID = ?";

    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setString(1, memId);

        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                customerKey = rs.getString("CUSTOMER_KEY");
            }
        }
    }

    return customerKey;
}

 // 관리자 - 전체 회원 목록 조회
    public List<Member> getAllMembers() throws Exception {
        List<Member> memberList = new ArrayList<>();

        String sql = 
            "SELECT MEM_ID, MEM_NAME, MEM_GRADE, MEM_PHONE " +
            "FROM MEMBERS " +
            "ORDER BY MEM_ID DESC";

        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Member member = new Member();

                member.setMemId(rs.getString("MEM_ID"));
                member.setMemName(rs.getString("MEM_NAME"));
                member.setMemGrade(rs.getString("MEM_GRADE"));
                member.setMemPhone(rs.getString("MEM_PHONE"));

                memberList.add(member);
            }

        } finally {
            if (rs != null) 
                rs.close();
            if (pstmt != null) 
                pstmt.close();
        }
        return memberList;
    }
    //아이디 중복체크
    public boolean existsById(String memId) throws Exception {
        String sql = "SELECT COUNT(*) FROM MEMBERS WHERE MEM_ID = ?";

        try (
            PreparedStatement pstmt = conn.prepareStatement(sql)
        ) {
            pstmt.setString(1, memId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }

        return false;
    }
}