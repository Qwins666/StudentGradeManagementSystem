package com.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.dao.Student;
import com.dao.Teacher;
import com.dao.User;
import com.service.StudentService;
import com.service.TeacherService;
import com.service.UserService;
import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private StudentService studentService;
	
	@Autowired
	private TeacherService teacherService;
	
	//用户登录功能
	@PostMapping("/login")
	public String login(@RequestParam String username,@RequestParam String password,@RequestParam String role,HttpSession session,HttpSession session2,RedirectAttributes redirectAttributes) {
		if ("student".equals(role)) {
		    // 查询学生信息
		    Student student = studentService.findStudentByUsername(username);
		    if (student != null) {
		        session.setAttribute("student", student); // 将学生对象存入session
		    }
		}
		if ("teacher".equals(role)) {
		    // 查询教师信息
		    Teacher teacher = teacherService.findTeacherByUsername(username);
		    if (teacher != null) {
		        session.setAttribute("teacher", teacher); // 将教师对象存入session
		    }
		}
		User user = userService.findUserByName(username,password);  //通过数据库查询是否存在用户
		if(user!=null) {
			if(user.getUserrole().equals(role)) {
				//登录成功，将用户保存到session对象中
				session.setAttribute("user",user);
				session.setAttribute("role", role);
				redirectAttributes.addFlashAttribute("message", "登录成功");
				System.out.println("登录成功！！！");
				switch(role) {
				case "student":return "redirect:/student/studentlist";
				case "teacher":return "redirect:/teacher/teacherlist";
				case "admin":return "redirect:/admin/userlist";	//重定向到admin中的请求路径
				}
			}else {
				redirectAttributes.addFlashAttribute("error", "角色错误");
				System.out.println("角色错误！！！");
			}
		}else {
			redirectAttributes.addFlashAttribute("error", "用户名错误");
			System.out.println("用户名或密码错误！！！");
		}
		return "redirect:/Login.jsp";
	}
	
	@GetMapping("/logout")
	public String logout(HttpSession session) {
	    session.invalidate(); // 销毁session
	    System.out.println("退出登录！！！");
	    return "redirect:/Login.jsp"; // 重定向到登录页
	}
}
