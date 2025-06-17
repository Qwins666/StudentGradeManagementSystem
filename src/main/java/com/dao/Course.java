package com.dao;

public class Course {
	Integer courseid;		//课程号
	String coursename;		//课程名
	Double credit;			//学分
	Integer hour;			//学时
	String courseteacher;   //授课教师
	public String getCourseteacher() {
		return courseteacher;
	}
	public void setCourseteacher(String courseteacher) {
		this.courseteacher = courseteacher;
	}
	public Double getCredit() {
		return credit;
	}
	public void setCredit(Double credit) {
		this.credit = credit;
	}
	public Integer getCourseid() {
		return courseid;
	}
	public void setCourseid(Integer courseid) {
		this.courseid = courseid;
	}
	public String getCoursename() {
		return coursename;
	}
	public void setCoursename(String coursename) {
		this.coursename = coursename;
	}
	public Integer getHour() {
		return hour;
	}
	public void setHour(Integer hour) {
		this.hour = hour;
	}
}
