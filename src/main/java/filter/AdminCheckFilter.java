package filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminCheckFilter implements Filter{
    public void init(FilterConfig config) throws ServletException{
    }
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        String memRole = null;

        if (session != null) {
            memRole = (String) session.getAttribute("memRole");
        }

        if (memRole == null || !"ADMIN".equalsIgnoreCase(memRole)) {
            res.sendRedirect(req.getContextPath() + "/member/login.jsp?error=admin");
            return;
        }

        chain.doFilter(request, response);
    }
    @Override
    public void destroy() {
        // 필터 종료 코드가 필요 없으면 비워둠
    }
}
