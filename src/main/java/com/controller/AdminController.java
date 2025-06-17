package com.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.dao.User;
import com.google.gson.Gson;
import com.service.TeacherService;
import com.service.UserService;
import com.dao.Class;
import com.dao.Course;
import com.dao.Score;
import com.dao.Student;
import com.dao.Teach;
import com.dao.Teacher;

@Controller
@RequestMapping("/admin")
public class AdminController {
	@Autowired
	private UserService userService;
	
	@Autowired
	private TeacherService teacherService;

	// 用户列表
	@GetMapping("/userlist")
	public String userList(Model model) {
		List<User> resList = userService.selectAllUsers();
		model.addAttribute("resList", resList);
		return "admin";
	}

	// 更新用户信息接口
	@PostMapping("/updateuser")
	public String updateUser(@ModelAttribute User user, RedirectAttributes redirectAttributes) {
		try {
			Integer row = userService.updateUser(user);
			if (row > 0) {
				redirectAttributes.addFlashAttribute("message", "更新成功");
			} else {
				redirectAttributes.addFlashAttribute("error", "更新失败");
			}
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("error", "更新失败: " + e.getMessage());
		}
		return "redirect:/admin/userlist"; // 重定向到用户管理页面
	}

	// 新增用户
	@PostMapping("/adduser")
	public String addUser(@ModelAttribute User user, @RequestParam("name") String name,
			RedirectAttributes redirectAttributes) {
		try {
			User existUser = userService.findUserByName(user.getUsername(), user.getPassword());
			if (existUser == null) {
				Integer row = userService.addUser(user, name);
				if (row > 0) {
					redirectAttributes.addFlashAttribute("message", "添加成功");
				} else {
					redirectAttributes.addFlashAttribute("error", "添加失败");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("error", "添加失败: " + e.getMessage());
		}
		return "redirect:/admin/userlist"; // 重定向到用户管理页面
	}

	// 删除用户
	@PostMapping("/deleteuser")
	public String deleteUser(@RequestParam("userId") Integer userId, RedirectAttributes redirectAttributes) {
		try {
			// 1. 先获取教师信息(如果是教师)
	        User user = userService.getUserById(userId);
	        if(user != null && "teacher".equals(user.getUserrole())) {
	            // 2. 获取该教师的所有授课关系
	            List<Teach> teachings = teacherService.getTeachingsByTeacherId(user.getUsername());
	            
	            // 4. 删除教师记录
	            teacherService.deleteTeacher(user.getUsername());
	        }
			Integer row = userService.deleteUser(userId);
			if (row > 0) {
				redirectAttributes.addFlashAttribute("message", "删除成功");
			} else {
				redirectAttributes.addFlashAttribute("error", "删除失败");
			}
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("error", "删除失败: " + e.getMessage());
		}
		return "redirect:/admin/userlist"; // 重定向到用户管理页面
	}

	// 重置密码
	@PostMapping("/resetpassword")
	public String resetPassword(@RequestParam("userid") Integer userId, RedirectAttributes redirectAttributes) {
		try {
			Integer row = userService.resetPassword(userId);
			if (row > 0) {
				redirectAttributes.addFlashAttribute("message", "重置成功");
			} else {
				redirectAttributes.addFlashAttribute("error", "重置失败");
			}
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("error", "重置失败: " + e.getMessage());
		}
		return "redirect:/admin/userlist"; // 重定向到用户管理页面
	}

	// 班级列表
	@GetMapping("/classlist")
	public String classList(Model model) {
		List<Class> resClassList = userService.selectAllClass();
		model.addAttribute("resClassList", resClassList);
		model.addAttribute("activeView", "class");
		return "admin";
	}

	// 班级管理中设置学生
	@PostMapping("/setstudent")
	public String setStudent(@ModelAttribute Student student, RedirectAttributes redirectAttributes) {
		try {
			// 查询学生是否存在
			Student stu = userService.findStudentByID(student);
			if (stu != null) {
				Integer row = userService.setStudentForClass(student);
				if (row > 0) {
					redirectAttributes.addFlashAttribute("message", "设置成功");
				} else {
					redirectAttributes.addFlashAttribute("error", "设置失败");
				}
			} else {
				redirectAttributes.addFlashAttribute("error", "学生不存在");
			}
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("error", "设置失败: " + e.getMessage());
		}
		return "redirect:/admin/classlist"; // 重定向到班级管理页面
	}

	// 班级编辑按钮-更新班级
	@PostMapping("/updateclass")
	public String updateClass(@ModelAttribute Class class1, RedirectAttributes redirectAttributes) {
		try {
			Integer row = userService.updateClass(class1);
			if (row > 0) {
				redirectAttributes.addFlashAttribute("message", "更新成功");
			} else {
				redirectAttributes.addFlashAttribute("error", "更新失败");
			}
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("error", "更新失败: " + e.getMessage());
		}
		return "redirect:/admin/classlist"; // 重定向到班级页面
	}

	// 班级删除按钮-删除班级
	@PostMapping("/deleteclass")
	public String deleteClass(@ModelAttribute Class class1, RedirectAttributes redirectAttributes) {
		try {
			Integer row = userService.deleteClass(class1);
			if (row > 0) {
				redirectAttributes.addFlashAttribute("message", "删除成功");
			} else {
				redirectAttributes.addFlashAttribute("error", "班级存在学生");
			}
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("error", "删除失败: " + e.getMessage());
		}
		return "redirect:/admin/classlist"; // 重定向到班级页面
	}

	// 班级添加按钮-添加班级
	@PostMapping("/addclass")
	public String addClass(@ModelAttribute Class class1, RedirectAttributes redirectAttributes) {
		try {
			// 查询是否有该班级
			Class newclass = userService.findClassByClassid(class1);
			if (newclass == null) {
				Integer row = userService.addClass(class1);
				if (row > 0) {
					redirectAttributes.addFlashAttribute("message", "添加成功");
				} else {
					redirectAttributes.addFlashAttribute("error", "添加失败");
				}
			} else {
				redirectAttributes.addFlashAttribute("error", "班级已存在");
			}

		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("error", "添加失败: " + e.getMessage());
		}
		return "redirect:/admin/classlist"; // 重定向到班级页面
	}

	// 课程管理列表
	@GetMapping("/courselist")
	public String courseList(Model model) {
		List<Course> resCourseList = userService.selectAllCourse();
		model.addAttribute("resCourseList", resCourseList);
		model.addAttribute("activeView", "course");
		return "admin";
	}

	// 课程添加按钮-添加课程
	@PostMapping("/addcourse")
	public String addCourse(@ModelAttribute Course course, RedirectAttributes redirectAttributes) {
		try {
			Integer row = userService.addCourse(course);
			if (row > 0) {
				redirectAttributes.addFlashAttribute("message", "添加成功");
			} else {
				redirectAttributes.addFlashAttribute("error", "添加失败");
			}
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("error", "添加失败: " + e.getMessage());
		}
		return "redirect:/admin/courselist"; // 重定向到课程页面
	}

	// 课程编辑按钮-更新课程
	@PostMapping("/updatecourse")
	public String updateCourse(@ModelAttribute Course course, RedirectAttributes redirectAttributes) {
		try {
			Integer row = userService.editupdateCourse(course);
			if (row > 0) {
				redirectAttributes.addFlashAttribute("message", "更新成功");
			} else {
				redirectAttributes.addFlashAttribute("error", "更新失败");
			}
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("error", "更新失败: " + e.getMessage());
		}
		return "redirect:/admin/courselist"; // 重定向到班级页面
	}

	// 课程删除按钮-删除课程
	@PostMapping("/deletecourse")
	public String deleteCourse(@RequestParam("courseid") Integer courseid, RedirectAttributes redirectAttributes) {
		try {
			Integer row = userService.deleteCourse(courseid);
			if (row > 0) {
				redirectAttributes.addFlashAttribute("message", "删除成功");
			} else {
				redirectAttributes.addFlashAttribute("error", "删除失败");
			}
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("error", "删除失败: " + e.getMessage());
		}
		return "redirect:/admin/courselist"; // 重定向到班级页面
	}

	// 课程管理中设置教师
	@PostMapping("/setteacher")
	public String setTeacher(@RequestParam String teacherid, @RequestParam Integer courseid,@RequestParam Integer classid, RedirectAttributes redirectAttributes) {
		try {
			Teacher teacher = teacherService.findTeacherById(teacherid);
			if (teacher == null) {
				redirectAttributes.addFlashAttribute("error", "教师不存在");
				return "redirect:/admin/courselist";
			}
			// 创建授课关系对象
			Teach teach = new Teach();
			teach.setTeacherid(teacherid);
			teach.setCourseid(courseid);
			teach.setClassid(classid);
			// 调用服务层设置教师
			userService.setTeacherForCourse(teach);
			redirectAttributes.addFlashAttribute("message", "设置成功");
		} catch (Exception e) {
			redirectAttributes.addFlashAttribute("error", "设置失败: " + e.getMessage());
		}
		return "redirect:/admin/courselist";
	}

	// 为课程设置学生
	@PostMapping("/setstudentforcourse")
	public String setStudentForCourse(@ModelAttribute Student courseStudent, @ModelAttribute Course course,
			RedirectAttributes redirectAttributes) {
		try {
			// 查询教师,班级是否存在
			Student stu = userService.findStudentByID(courseStudent);
//			System.out.println(courseStudent.getSno()+","+course.getCourseid()+"couname:"+course.getCoursename());
			if (stu != null) {
				Integer row = userService.updateCourseByStudent(courseStudent, course);
				System.out.println(row);
				if (row > 0) {
					redirectAttributes.addFlashAttribute("message", "设置成功");
				} else {
					redirectAttributes.addFlashAttribute("error", "设置失败");
				}
			} else {
				redirectAttributes.addFlashAttribute("error", "学生不存在");
			}
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("error", "设置失败: " + e.getMessage());
		}
		return "redirect:/admin/courselist"; // 重定向到班级管理页面
	}

	// 成绩管理列表
	@GetMapping("/scorelist")
	public String scoreList(@RequestParam(required = false) String classId,@RequestParam(required = false) String studentId,@RequestParam(required = false) String courseName,Model model) {
		// 添加搜索条件参数
	    Map<String, Object> params = new HashMap<>();
	    if (classId != null && !classId.isEmpty()) params.put("classid", classId);
	    if (studentId != null && !studentId.isEmpty()) params.put("studentid", studentId);
	    if (courseName != null && !courseName.isEmpty()) params.put("coursename", courseName);
	    List<Score> resScoreList = userService.getScoresByCondition(params);
	    model.addAttribute("resScoreList", resScoreList);
	    model.addAttribute("activeView", "score");
	    return "admin";
	}

	// 更新审核状态
	@PostMapping("/updateremark")
	public String setRemark(@RequestParam("scoreid") Integer scoreid,@RequestParam("remark") String remark,RedirectAttributes redirectAttributes) {
		try {
			// 创建Score对象并设置值
	        Score score = new Score();
	        score.setScoreid(scoreid);
	        score.setRemark(remark);
	        Integer row = userService.updateRemark(score);
	        if (row > 0) {
	            redirectAttributes.addFlashAttribute("message", "更新成功");
	        } else {
	            redirectAttributes.addFlashAttribute("error", "更新失败");
	        }
	    } catch (Exception e) {
	        redirectAttributes.addFlashAttribute("error", "更新失败: " + e.getMessage());
	    }
	    return "redirect:/admin/scorelist";
	}

	// 获取数据信息
	@GetMapping("/datainfo")
	public String dataInfo(Model model) {
		// 总数据信息
		Integer totalStudents = userService.selectStudentNum();
		Integer totalTeachers = userService.selectTeacherNum();
		Integer totalCourses = userService.selectCourseNum();
		Integer totalScores = userService.selectScoreNum();
		model.addAttribute("totalStudents", totalStudents);
		model.addAttribute("totalTeachers", totalTeachers);
		model.addAttribute("totalCourses", totalCourses);
		model.addAttribute("totalScores", totalScores);

		// 各专业人数分布
		Map<String, Integer> majorStudentCount = userService.getMajorStudentCount();
		System.out.println("各专业人数:" + majorStudentCount);
		model.addAttribute("majorStudentCount", majorStudentCount);
		model.addAttribute("activeView", "data");

		// 成绩分布比例
		Map<String, Integer> scoreStudentCount = userService.getScoreStudentCount();
		System.out.println("成绩分布比例:" + scoreStudentCount);
		model.addAttribute("scoreStudentCount", scoreStudentCount);
		model.addAttribute("activeView", "data");

		// 课程成绩分析
		Map<String, Map<String, Double>> courseStudentCount = userService.getCourseStudentCount();
		System.out.println("成绩分布比例:" + courseStudentCount);
		model.addAttribute("courseStudentCount", courseStudentCount);
		model.addAttribute("activeView", "data");
		return "admin";
	}
}
