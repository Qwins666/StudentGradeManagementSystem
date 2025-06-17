package com.service;

import java.util.List;
import java.util.Map;

import com.dao.Class;
import com.dao.Course;
import com.dao.Score;
import com.dao.Student;
import com.dao.Teach;
import com.dao.Teacher;
import com.dao.User;

public interface UserService {
	//查询用户名
	User findUserByName(String username, String password);
	
	//查询所有用户
	List<User> selectAllUsers();
	
	//更新用户信息
	Integer updateUser(User user);

	//添加用户信息
	Integer addUser(User user, String name);

	//删除用户信息
	Integer deleteUser(Integer userId);

	//查询所有班级
	List<Class> selectAllClass();

	//为班级设置学生
	Integer setStudentForClass(Student student);

	//获取所有课程
	List<Course> selectAllCourse();

	//查询学生是否存在
	Student findStudentByID(Student student);

	//更新班级
	Integer updateClass(Class class1);

	//删除班级
	Integer deleteClass(Class class1);
	
	//增加班级
	Integer addClass(Class class1);

	//增加课程
	Integer addCourse(Course course);

	//查询班级是否存在
	Class findClassByClassid(Class class1);
	
	//更新课程,设置教师更新课程
	Integer updateCourse(Course course,String teacherid,Integer classid);

	//删除课程
	Integer deleteCourse(Integer courseid);

	//课程管理中查询教师是否存在
	Teacher findTeacherByName(String teacherid);

	//成绩列表
	List<Score> getScoresByCondition(Map<String, Object> params);

	//更新审核状态
	Integer updateRemark(Score score);

	//查询总学生人数
	Integer selectStudentNum();

	//查询总教师人数
	Integer selectTeacherNum();

	//查询总课程数
	Integer selectCourseNum();

	//查询总成绩记录数
	Integer selectScoreNum();

	//统计各专业学生人数
	Map<String, Integer> getMajorStudentCount();

	//成绩分布比例
	Map<String, Integer> getScoreStudentCount();

	// 课程成绩分析
	Map<String, Map<String, Double>> getCourseStudentCount();

	//更新课程
	Integer editupdateCourse(Course course);

	//为课程设置学生
	Integer updateCourseByStudent(Student courseStudent ,Course course);

	//重置密码
	Integer resetPassword(Integer userId);

	//为课程设置教师
	void setTeacherForCourse(Teach teach);

	//获取用户信息
	User getUserById(Integer userId);
}
