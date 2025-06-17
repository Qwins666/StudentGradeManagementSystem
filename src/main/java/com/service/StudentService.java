package com.service;

import java.util.List;

import com.dao.Course;
import com.dao.Score;
import com.dao.Student;
import com.dao.User;

public interface StudentService {

	//获取个人成绩
	List<Score> selectPersonScore(String studentid);

	//查询学生是否存在
	Student findStudentByUsername(String username);

	//查询个人成绩的课程
	List<Score> findCourse(Score score);

	//查询课程
	List<Course> selectAllCourse(String studentid);

	//修改密码
	Integer resetPassword(User studentAccount);

}
