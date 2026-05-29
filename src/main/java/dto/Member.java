package dto;

import java.io.Serializable;

public class Member implements Serializable{
    private String memId;
    private String memPw;
    private String memName;
    private String memPhone;
    private String memEmail;
    private String memAddress;
    private String memGrade;
    private String memRole;
    private String memJoinDate;
    public String getMemId() {
        return memId;
    }
    public void setMemId(String memId) {
        this.memId = memId;
    }
    public String getMemPw() {
        return memPw;
    }
    public void setMemPw(String memPw) {
        this.memPw = memPw;
    }
    public String getMemName() {
        return memName;
    }
    public void setMemName(String memName) {
        this.memName = memName;
    }
    public String getMemPhone() {
        return memPhone;
    }
    public void setMemPhone(String memPhone) {
        this.memPhone = memPhone;
    }
    public String getMemEmail() {
        return memEmail;
    }
    public void setMemEmail(String memEmail) {
        this.memEmail = memEmail;
    }
    public String getMemAddress() {
        return memAddress;
    }
    public void setMemAddress(String memAddress) {
        this.memAddress = memAddress;
    }
    public String getMemGrade() {
        return memGrade;
    }
    public void setMemGrade(String memGrade) {
        this.memGrade = memGrade;
    }
    public String getMemRole() {
        return memRole;
    }
    public void setMemRole(String memRole) {
        this.memRole = memRole;
    }
    public String getMemJoinDate() {
        return memJoinDate;
    }
    public void setMemJoinDate(String memJoinDate) {
        this.memJoinDate = memJoinDate;
    }

    
}
