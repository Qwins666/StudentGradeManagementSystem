package com.interceptor;


import org.springframework.web.servlet.HandlerInterceptor;
import com.dao.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LoginInterceptor implements HandlerInterceptor{
	//拦截器权限校验
	@Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		//获取Session
        HttpSession session=request.getSession();
        HttpSession session2=request.getSession();
        User user=(User) session.getAttribute("user");
        String role=(String) session2.getAttribute("role");
        //未登录用户
        if (user == null) {
            response.sendRedirect("/login.jsp");
            return false;
        }
        //已登录用户
        if(!user.getUserrole().equals(role)) {
            response.sendError(403, "无权访问");
            return false;
        }
        return true;
    }
}
