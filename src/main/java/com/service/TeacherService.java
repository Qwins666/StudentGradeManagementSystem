package com.service;

import java.util.List;

import com.dao.Course;
import com.dao.Score;
import com.dao.Teach;
import com.dao.Teacher;
import com.dao.User;

public interface TeacherService {

	//查询教师是否存在
	Teacher findTeacherByUsername(String  username);
	

	//获取教师教授课程信息
	List<Score> findTeacherByTid(String teacherid);

	//修改教师密码
	Integer resetPassword(User studentAccount);

	//批量修改成绩
	void updateScore(Integer scoreid, Double score);


	Teacher findTeacherById(String teacherid);

	//通过教师id获取所有授课关系
	List<Teach> getTeachingsByTeacherId(String username);


	//删除教师数据
	void deleteTeacher(String username);

}
