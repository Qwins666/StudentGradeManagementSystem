package com.service.impl;

import java.io.IOException;
import java.io.InputStream;
import java.lang.invoke.StringConcatFactory;
import java.util.List;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.springframework.stereotype.Service;
import com.dao.Course;
import com.dao.Score;
import com.dao.Student;
import com.dao.User;
import com.service.StudentService;

@Service
public class StudentServiceImpl implements StudentService{

	//获取个人成绩列表
	@Override
	public List<Score> selectPersonScore(String studentid) {
		SqlSession sql = null;
		List<Score> resultList = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			resultList = sql.selectList("com.mapper.StudentMapper.selectPersonScore",studentid);
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return resultList;
	}

	//查询学生是否存在
	@Override
	public Student findStudentByUsername(String username) {
		SqlSession sql = null;
		Student result = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			result = sql.selectOne("com.mapper.StudentMapper.selectStudentBySno", username);
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return result;
	}

	//查询课程
	@Override
	public List<Score> findCourse(Score score) {
		SqlSession sql = null;
		List<Score> resultList = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			resultList = sql.selectList("com.mapper.StudentMapper.findCourse", score);
			sql.commit(); // 向数据库提交事务
			if(resultList!=null) {
				System.out.println("课程查询成功！");
			}else {
				System.out.println("课程查询失败！");
			}
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return resultList;
	}

	//通过学号查询本人所有课程信息
	@Override
	public List<Course> selectAllCourse(String studentid) {
		SqlSession sql = null;
		List<Course> resultList = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			resultList = sql.selectList("com.mapper.StudentMapper.selectCourse",studentid);
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return resultList;
	}

	//修改密码
	@Override
	public Integer resetPassword(User studentAccount) {
		SqlSession sql = null;
		int row=0;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			row= sql.update("com.mapper.StudentMapper.resetPassword",studentAccount);
			if(row>0) {
				System.out.println("密码修改成功!!!");
			}else {
				System.out.println("密码修改失败!!!");
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

}
