<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="dto.Shop" %>
<%@ page import="dao.ShopDAO" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ include file="../dbconn.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

int proId = 0;
int proPrice = 0;
int proStock = 0;
int proOpId = 0;

try{
    proId = Integer.parseInt(request.getParameter("proId"));
    proPrice = Integer.parseInt(request.getParameter("proPrice"));
    proStock = Integer.parseInt(request.getParameter("proStock"));
    proOpId = Integer.parseInt(request.getParameter("proOpId"));
}catch(NumberFormatException e){
%>
    <script>
        alert("상품 정보의 숫자 형식이 올바르지 않습니다.");
        history.back();
    </script>
<%
    return;
}

String proName = request.getParameter("proName");
String proSize = request.getParameter("proSize");
String proColor = request.getParameter("proColor");
String proCont = request.getParameter("proCont");
String proCategory = request.getParameter("proCategory");
String oldFilename = request.getParameter("oldFilename");

    String filename=oldFilename;

    Part filePart=request.getPart("filename");

    if(filePart!=null && filePart.getSize()>0){
        String newFilename=filePart.getSubmittedFileName();

        if(newFilename!=null && !newFilename.equals("")){
            filename=newFilename;

            String uploadPath=request.getServletContext().getRealPath("/images");
        
            File uploadDir=new File(uploadPath);
            if(!uploadDir.exists()){
                uploadDir.mkdirs();
            }
            filePart.write(uploadPath+File.separator+filename);
        }
    }

     //DB 정보저장
    Shop shop = new Shop();
    shop.setProId(proId);
    shop.setProName(proName);
    shop.setProPrice(proPrice);
    shop.setProSize(proSize);
    shop.setProStock(proStock);
    shop.setProColor(proColor);
    shop.setProCont(proCont);
    shop.setProCategory(proCategory);
    shop.setProImg(filename);
    shop.setProOpId(proOpId);

    try{
        ShopDAO dao = new ShopDAO();
        dao.updateProduct(conn, shop);
        response.sendRedirect("adminMain.jsp");
    } catch (Exception e){
            out.println("상품수정 오류: "+e.getMessage());
        } 
        finally{
            if(conn!=null)
                conn.close();
        }

%>