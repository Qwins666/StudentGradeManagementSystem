package com.controller;


import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.dao.Course;
import com.dao.Score;
import com.dao.Student;
import com.dao.User;
import com.service.StudentService;
import com.service.UserService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/student")
public class StudentController {
	@Autowired
	private StudentService studentService;
	
	@Autowired
	private UserService userService;

	//个人成绩
	@GetMapping("/studentlist")
	public String personScoreList(Model model,HttpSession session) {
		// 从session获取学生对象
        Student student = (Student) session.getAttribute("student");
        if (student == null) {
            // 如果未登录，重定向到登录页面
            return "redirect:/Login.jsp";
        }
		List<Score> resStudentScoreList = studentService.selectPersonScore(student.getStudentid());
		model.addAttribute("resStudentList", resStudentScoreList);
		return "student";
	}
	
	//查询课程名称
	@PostMapping("/findcourse")
	public String findCourse(@RequestParam("courseName") String coursename, RedirectAttributes redirectAttributes,Model model) {
		try {
			Score score=new Score();
//			score.setCoursename(coursename);
//			score.setSno(sno);
			List<Score> resStudentScoreList = studentService.findCourse(score);
			if (resStudentScoreList !=null) {
				model.addAttribute("resStudentList", resStudentScoreList);
				redirectAttributes.addFlashAttribute("message", "查询成功");
			} else {
				redirectAttributes.addFlashAttribute("error", "查询失败");
			}
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("error", "查询失败: " + e.getMessage());
		}
		return "student";
	}
	
	//获取课程信息
	@GetMapping("/courselist")
	public String courseList(Model model,HttpSession session) {
		// 从session获取学生对象
        Student student = (Student) session.getAttribute("student");
        if (student == null) {
            // 如果未登录，重定向到登录页面
            return "redirect:/Login.jsp";
        }
		List<Course> resCourseList = studentService.selectAllCourse(student.getStudentid());
		model.addAttribute("resCourseList", resCourseList);
		model.addAttribute("activeView", "course");
		return "student";
	}
	
	//修改学生密码
	@PostMapping("/resetpassword")
	public String resetPassword(@RequestParam("sno") String sno,@RequestParam("oldPassword") String oldpassword,@RequestParam("newPassword") String newpassword, RedirectAttributes redirectAttributes,Model model) {
		try {
			//检查该用户的旧密码是否正确
			User existUser=userService.findUserByName(sno, oldpassword);
			if(existUser!=null) {
				User studentAccount = new User();
				studentAccount.setUsername(sno);
				studentAccount.setPassword(newpassword);
				Integer row = studentService.resetPassword(studentAccount);
				if (row > 0) {
					redirectAttributes.addFlashAttribute("message", "修改成功");
					return "redirect:/Login.jsp";
				} else {
					redirectAttributes.addFlashAttribute("error", "修改失败");
				}
			}else {
				redirectAttributes.addFlashAttribute("error", "修改失败");
			}	
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("error", "修改失败: " + e.getMessage());
		}
		model.addAttribute("activeView", "password");
		return "student";
	}
}
