package dao;

import dto.Member;
import java.sql.*;

public class MemberDAO {
    //로그인
    private Connection conn;
    public MemberDAO(Connection conn){
        this.conn=conn;
    }

    public Member login(String memId, String memPw) throws SQLException{
        String sql = "SELECT MEM_ID, MEM_NAME, MEM_ROLE FROM MEMBERS "+
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
}