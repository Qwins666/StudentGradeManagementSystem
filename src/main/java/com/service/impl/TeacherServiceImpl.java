package com.service.impl;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.springframework.stereotype.Service;

import com.dao.Course;
import com.dao.Score;
import com.dao.Teach;
import com.dao.Teacher;
import com.dao.User;
import com.service.TeacherService;

@Service
public class TeacherServiceImpl implements TeacherService{

	//查询教师是否存在
	@Override
	public Teacher findTeacherByUsername(String newusername) {
		SqlSession sql = null;
		Teacher result = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			result = sql.selectOne("com.mapper.TeacherMapper.selectTeacherByNo", newusername);
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

	@Override
	public List<Score> findTeacherByTid(String teacherid) {
		SqlSession sql = null;
		List<Score> resultlist = null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			resultlist = sql.selectList("com.mapper.TeacherMapper.selectAllCourseByTid", teacherid);
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("Mybatis配置加载失败", e);
		} finally {
			if (sql != null) {
				sql.close();
			}
		}
		return resultlist;
	}

	@Override
	public Integer resetPassword(User studentAccount) {
		SqlSession sql = null;
		int row=0;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			row= sql.update("com.mapper.TeacherMapper.resetPassword",studentAccount);
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

	//批量更新成绩
	@Override
	public void updateScore(Integer scoreid, Double score) {
	    SqlSession sql = null;
	    try {
	        InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
	        SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
	        sql = ssf.openSession();
	        
	        Map<String, Object> params = new HashMap<>();
	        params.put("scoreid", scoreid);
	        params.put("score", score);
	        
	        sql.update("com.mapper.TeacherMapper.updateScore", params);
	        sql.commit();
	    } catch (Exception e) {
	        if (sql != null) {
	            try {
	                sql.rollback();
	            } catch (Exception ex) {
	                ex.printStackTrace();
	            }
	        }
	        throw new RuntimeException("更新成绩失败", e);
	    } finally {
	        if (sql != null) {
	            sql.close();
	        }
	    }
	}

	//通过教师号查询教师
	@Override
	public Teacher findTeacherById(String teacherid) {
		SqlSession sql = null;
        Teacher teacher = null;
        try {
            InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
            SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
            sql = ssf.openSession();
            teacher = sql.selectOne("com.mapper.TeacherMapper.selectTeacherById", teacherid);
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException("查找教师失败", e);
        } finally {
            if (sql != null) {
                sql.close();
            }
        }
        return teacher;
    }

	@Override
	public List<Teach> getTeachingsByTeacherId(String username) {
		SqlSession sql = null;
		List<Teach> teachlist=null;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			teachlist= sql.selectList("com.mapper.TeacherMapper.selectAllTeach",username);
			if(teachlist!=null) {
				System.out.println("查询成功!!!");
			}else {
				System.out.println("查询失败!!!");
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
		return teachlist;
	}

	@Override
	public void deleteTeacher(String username) {
		SqlSession sql = null;
		Integer row=0;
		try {
			InputStream config = Resources.getResourceAsStream("mybatis-config.xml");
			SqlSessionFactory ssf = new SqlSessionFactoryBuilder().build(config);
			sql = ssf.openSession();
			row= sql.delete("com.mapper.TeacherMapper.deleteTeacher",username);
			if(row>0) {
				System.out.println("教师删除成功!!!");
			}else {
				System.out.println("教师删除失败!!!");
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
	}
}
