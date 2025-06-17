package com.service.impl;

import java.io.IOException;
import java.io.InputStream;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.springframework.stereotype.Service;

import com.dao.Class;
import com.dao.Course;
import com.dao.Score;
import com.dao.Student;
import com.dao.Teach;
import com.dao.Teacher;
import com.dao.User;
import com.service.UserService;

@Service
public class UserServiceImpl implements UserService {
	// 查询用户是否存在
	public User findUserByName(String username, String password) {
		SqlSession sql = null;
		User resultName = null;
		try {
			// 读取配置文件mybatis-config.xml
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			// 根据配置文件构建SqlSessionFactory
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			// 通过SqlSessionFactory创建SqlSession
			sql = ssf.openSession();

			// 通常Mybatis的selectOne和selectList方法只接收一个参数对象或Map,所以这里封装到Map中去
//			resultName = un.selectOne("com.mapper.UserMapper.selectUserByName",username);

			// 将参数封装为Map
			Map<String, Object> params = new HashMap<>();
			params.put("username", username);
			params.put("password", password);
			resultName = sql.selectOne("com.mapper.UserMapper.selectUserByName", params);
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return resultName;
	}

	// 查询所有用户
	@Override
	public List<User> selectAllUsers() {
		SqlSession sql = null;
		List<User> resultName = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			resultName = sql.selectList("com.mapper.UserMapper.selectAllUsers");
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return resultName;
	}

	// 更新用户信息
	@Override
	public Integer updateUser(User user) {
		SqlSession sql = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			Integer rows = sql.update("com.mapper.UserMapper.updateUser", user);

			sql.commit(); // 向数据库提交事务
			if (rows > 0) {
				System.out.println("用户更新成功！");
			} else {
				System.out.println("用户更新失败！");
			}
			return rows;
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
	}

	// 添加用户
	@Override
	public Integer addUser(User user, String name) {
		SqlSession sql = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			Integer rows = sql.insert("com.mapper.UserMapper.addUser", user);
			if (user.getUserrole().equals("student")) {
				Student student = new Student();
				student.setStudentid(user.getUsername());
				student.setStudentname(name);
				sql.insert("com.mapper.StudentMapper.addStudentByAdmin", student);
			} else if (user.getUserrole().equals("teacher")) {
				Teacher teacher = new Teacher();
				teacher.setTeacherid(user.getUsername());
				teacher.setTeachername(name);
				sql.insert("com.mapper.TeacherMapper.addTeacherByAdmin", teacher);
			}
			sql.commit();
			if (rows > 0) {
				System.out.println("用户添加成功！");
			} else {
				System.out.println("用户添加失败！");
			}
			return rows;
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
	}

	// 删除用户
	@Override
	public Integer deleteUser(Integer userId) {
		SqlSession sql = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			Integer rows = sql.delete("com.mapper.UserMapper.deleteUser", userId);
			sql.commit();
			if (rows > 0) {
				System.out.println("用户删除成功！");
			} else {
				System.out.println("用户删除失败！");
			}
			return rows;
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
	}

	// 查询班级列表
	@Override
	public List<Class> selectAllClass() {
		SqlSession sql = null;
		List<Class> resultClassList = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			resultClassList = sql.selectList("com.mapper.UserMapper.selectAllClass");
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return resultClassList;
	}

	// 为班级设置学生
	@Override
	public Integer setStudentForClass(Student student) {
		SqlSession sql = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			Integer rows = sql.update("com.mapper.UserMapper.updateStudentForClass", student);
			// 通过学号查询学生所在的班级，在查询出该班级所有的courseid，将courseid更新到该学生的score表中
			if (rows > 0) {
				System.out.println("班级学生设置成功！");

				// 通过学号查询学生所在的班级
				Student updatedStudent = sql.selectOne("com.mapper.UserMapper.selectStudentById", student);
				if (updatedStudent != null && updatedStudent.getClassid() != null) {
					// 查询该班级所有的courseid
					List<Integer> courseIds = sql.selectList("com.mapper.UserMapper.selectCourseIdsByClassId",
							updatedStudent.getClassid());

					if (courseIds != null && !courseIds.isEmpty()) {
						// 将每个courseid更新到该学生的score表中
						for (Integer courseId : courseIds) {
							Map<String, Object> params = new HashMap<>();
							params.put("studentid", student.getStudentid());
							params.put("courseid", courseId);

							// 检查是否已存在记录
							Integer count = sql.selectOne("com.mapper.UserMapper.countScoreByStudentAndCourse", params);
							if (count == null || count == 0) {
								// 插入新记录
								sql.insert("com.mapper.UserMapper.insertScoreRecord", params);
							}
						}
					}
				}
			} else {
				System.out.println("班级学生设置失败！");
			}

			sql.commit(); // 提交事务
			return rows;
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
	}

	// 根据学号查询学生
	@Override
	public Student findStudentByID(Student student) {
		SqlSession sql = null;
		Student resultStu = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			resultStu = sql.selectOne("com.mapper.UserMapper.selectStudentById", student);
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return resultStu;
	}

	// 获取所有课程
	@Override
	public List<Course> selectAllCourse() {
		SqlSession sql = null;
		List<Course> resultCourseList = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			resultCourseList = sql.selectList("com.mapper.UserMapper.selectAllCourse");
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return resultCourseList;
	}

	// 更新班级
	@Override
	public Integer updateClass(Class class1) {
		SqlSession sql = null;
		int row = 0;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			row = sql.update("com.mapper.UserMapper.updateClass", class1);
			if (row > 0) {
				System.out.println("班级更新成功!!!");
			} else {
				System.out.println("班级更新失败!!!");
			}
			sql.commit();
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return row;
	}

	// 删除班级
	@Override
	public Integer deleteClass(Class class1) {
		SqlSession sql = null;
		int row = 0;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			// 查询班级中是否有学生
			Integer studentCount = sql.selectOne("com.mapper.UserMapper.countStudentsByClassId",
					class1.getClassid());
			if (studentCount > 0) {
				row = 0;
			} else {
				row = sql.delete("com.mapper.UserMapper.deleteClass", class1);
			}
			if (row > 0) {
				System.out.println("班级删除成功!!!");
			} else {
				System.out.println("班级删除失败!!!");
			}
			sql.commit();
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return row;
	}

	// 添加班级
	@Override
	public Integer addClass(Class class1) {
		SqlSession sql = null;
		int row = 0;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			row = sql.insert("com.mapper.UserMapper.addClass", class1);
			if (row > 0) {
				System.out.println("班级添加成功!!!");
			} else {
				System.out.println("班级添加失败!!!");
			}
			sql.commit();
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return row;
	}

	// 添加课程
	@Override
	public Integer addCourse(Course course) {
		SqlSession sql = null;
		int row = 0;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			row = sql.insert("com.mapper.UserMapper.addCourse", course);
			if (row > 0) {
				System.out.println("课程添加成功!!!");
			} else {
				System.out.println("课程添加失败!!!");
			}
			sql.commit();
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return row;
	}

	// 查询班级是否存在
	@Override
	public Class findClassByClassid(Class class1) {
		SqlSession sql = null;
		Class existClass = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			existClass = sql.selectOne("com.mapper.UserMapper.selectClassByID", class1);
			if (existClass != null) {
				System.out.println("班级查询成功!!!");
			} else {
				System.out.println("班级查询失败!!!");
			}
			sql.commit();
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return existClass;
	}

	// 更新课程&课程设置教师
	@Override
	public Integer updateCourse(Course course, String teacherid, Integer classid) {
		SqlSession sql = null;
		int row = 0;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			Teach teach = new Teach();
			teach.setClassid(classid);
			teach.setCourseid(course.getCourseid());
			teach.setTeacherid(teacherid);
			row = sql.update("com.mapper.UserMapper.updateTeach", teach);
			if (row > 0) {
				System.out.println("课程更新成功!!!");
			} else {
				System.out.println("课程更新失败!!!");
			}
			sql.commit();
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return row;
	}

	// 删除课程
	@Override
	public Integer deleteCourse(Integer courseid) {
		SqlSession sql = null;
		int row = 0;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			row = sql.delete("com.mapper.UserMapper.deleteCourse", courseid);
			if (row > 0) {
				System.out.println("课程删除成功!!!");
			} else {
				System.out.println("课程删除失败!!!");
			}
			sql.commit();
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return row;
	}

	// 查询教师
	@Override
	public Teacher findTeacherByName(String teacherid) {
		SqlSession sql = null;
		Teacher resultTea = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			resultTea = sql.selectOne("com.mapper.UserMapper.selectTeacherByName", teacherid);
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return resultTea;
	}

	// 获取所有课程
	@Override
	public List<Score> getScoresByCondition(Map<String, Object> params) {
		SqlSession sql = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			return sql.selectList("com.mapper.UserMapper.getScoresByCondition", params);
		} catch (IOException e) {
			// 错误处理
		} finally {
			if (sql != null)
				sql.close();
		}
		return Collections.emptyList();
	}

	// 更新审核状态
	@Override
	public Integer updateRemark(Score score) {
		SqlSession sql = null;
		int row = 0;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			row = sql.update("com.mapper.UserMapper.updateRemark", score);
			if (row > 0) {
				System.out.println("审核状态更新成功!!!");
			} else {
				System.out.println("审核状态更新失败!!!");
			}
			sql.commit();
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return row;
	}

	// 查询总学生数量
	@Override
	public Integer selectStudentNum() {
		SqlSession sql = null;
		Integer studentNum = 0;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			studentNum = sql.selectOne("com.mapper.UserMapper.selectStudentNum");
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return studentNum;
	}

	// 查询总教师数量
	@Override
	public Integer selectTeacherNum() {
		SqlSession sql = null;
		Integer teacherNum = 0;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			teacherNum = sql.selectOne("com.mapper.UserMapper.selectTeacherNum");
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return teacherNum;
	}

	// 查询课程数量
	@Override
	public Integer selectCourseNum() {
		SqlSession sql = null;
		Integer courseNum = 0;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			courseNum = sql.selectOne("com.mapper.UserMapper.selectCourseNum");
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return courseNum;
	}

	// 查询成绩记录数
	@Override
	public Integer selectScoreNum() {
		SqlSession sql = null;
		Integer ScoreNum = 0;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			ScoreNum = sql.selectOne("com.mapper.UserMapper.selectScoreNum");
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return ScoreNum;
	}

	// 统计各专业学生人数
	@Override
	public Map<String, Integer> getMajorStudentCount() {
		SqlSession sql = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			// 执行查询
			List<Map<String, Object>> result = sql.selectList("com.mapper.UserMapper.getMajorStudentCount");
			// 转换为Map<专业名, 人数>
			Map<String, Integer> majorCountMap = new HashMap<>();
			for (Map<String, Object> row : result) {
				String major = (String) row.get("major");
				Long count = (Long) row.get("student_count");
				majorCountMap.put(major, count.intValue());
			}
			return majorCountMap;
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
	}

	// 统计成绩分布比列
	@Override
	public Map<String, Integer> getScoreStudentCount() {
		SqlSession sql = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			List<Map<String, Object>> result = sql.selectList("com.mapper.UserMapper.getScoreStudentCount");

			// 转换为Map<成绩段, 人数>
			Map<String, Integer> scoreCountMap = new HashMap<>();
			for (Map<String, Object> row : result) {
				String scoreRange = (String) row.get("score_range");
				Long count = (Long) row.get("count");
				scoreCountMap.put(scoreRange, count.intValue());
			}
			return scoreCountMap;
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
	}

	// 成绩最高分最低分平均分获取
	@Override
	public Map<String, Map<String, Double>> getCourseStudentCount() {
		SqlSession sql = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			List<Map<String, Object>> result = sql.selectList("com.mapper.UserMapper.getCourseStudentCount");

			// 转换为 Map<课程名, Map<分数类型, 分数值>>
			Map<String, Map<String, Double>> courseScoreMap = new HashMap<>();
			for (Map<String, Object> row : result) {
				String courseName = (String) row.get("coursename");
				Map<String, Double> scores = new HashMap<>();
				scores.put("max", ((Number) row.get("max_score")).doubleValue());
				scores.put("min", ((Number) row.get("min_score")).doubleValue());
				scores.put("avg", ((Number) row.get("avg_score")).doubleValue());
				courseScoreMap.put(courseName, scores);
			}
			return courseScoreMap;
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
	}

	// 编辑按钮更新课程
	@Override
	public Integer editupdateCourse(Course course) {
		SqlSession sql = null;
		int row = 0;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			row = sql.update("com.mapper.UserMapper.updateCourse", course);
			if (row > 0) {
				System.out.println("课程更新成功!!!");
			} else {
				System.out.println("课程更新失败!!!");
			}
			sql.commit();
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return row;
	}

	// 用户重置密码
	@Override
	public Integer resetPassword(Integer userid) {
		SqlSession sql = null;
		int row = 0;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			row = sql.update("com.mapper.UserMapper.resetPassword", userid);
			if (row > 0) {
				System.out.println("密码重置成功!!!");
			} else {
				System.out.println("密码重置失败!!!");
			}
			sql.commit();
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return row;
	}

	@Override
	public void setTeacherForCourse(Teach teach) {
		SqlSession sql = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			Map<String, Object> params = new HashMap<>();
			params.put("courseid", teach.getCourseid());
			params.put("classid", teach.getClassid());
			// 先删除该课程在该班级的原有授课关系
			sql.delete("com.mapper.UserMapper.deleteTeachByCourseAndClass", params);
			// 插入新的授课关系
			sql.insert("com.mapper.UserMapper.insertTeach", teach);
			//当为课程设置班级与教师之后，查询班级中是否存在学生，如果有学生，就为所有学生更新成绩表的课程号
			//查询班级中是否存在学生
	        Map<String, Object> classParams = new HashMap<>();
	        classParams.put("classid", teach.getClassid());
	        List<Student> students = sql.selectList("com.mapper.UserMapper.selectStudentsByClassId", classParams); 
	        // 如果有学生，为所有学生更新成绩表的课程号
	        if (students != null && !students.isEmpty()) {
	            for (Student student : students) {
	                Map<String, Object> scoreParams = new HashMap<>();
	                scoreParams.put("studentid", student.getStudentid());
	                scoreParams.put("courseid", teach.getCourseid());
	                // 检查是否已存在记录
	                Integer count = sql.selectOne("com.mapper.UserMapper.countScoreByStudentAndCourse", scoreParams);
	                if (count == null || count == 0) {
	                    // 插入新记录
	                    sql.insert("com.mapper.UserMapper.insertScoreRecord", scoreParams);
	                }
	            }
	        }
			sql.commit();
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("设置教师失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
	}

	@Override
	public Integer updateCourseByStudent(Student courseStudent, Course course) {
		// TODO 自动生成的方法存根
		return null;
	}

	@Override
	public User getUserById(Integer userId) {
		SqlSession sql = null;
		User resultUser = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			resultUser = sql.selectOne("com.mapper.UserMapper.selectUserById", userId);
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return resultUser;
	}
}
