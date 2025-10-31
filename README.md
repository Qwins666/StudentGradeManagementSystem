# 学生成绩管理系统

## 项目简介
这是一个基于Java Web技术栈开发的学生成绩管理系统，旨在为学校提供高效、便捷的学生信息和成绩管理解决方案。系统支持三种角色（管理员、教师、学生）登录，各角色拥有不同的权限和功能。

## 技术栈

- **后端框架**：Spring MVC + MyBatis
- **前端技术**：JSP + JavaScript + CSS + JSTL
- **数据库**：MySQL
- **开发工具**：Eclipse IDE
- **Web服务器**：支持Tomcat等Servlet容器

## 功能模块

### 1. 用户登录与权限管理
- 支持三种角色（学生、教师、管理员）登录
- 基于Session的身份认证
- 登录拦截器确保系统安全

### 2. 学生管理
- 学生信息的增删改查
- 学生成绩查询
- 学生选课管理

### 3. 教师管理
- 教师信息的增删改查
- 学生成绩录入与修改
- 课程管理

### 4. 班级管理
- 班级信息的增删改查
- 班级学生分配

### 5. 课程管理
- 课程信息的增删改查
- 教师授课管理

## 项目结构

```
src/
└── main/
    ├── java/
    │   ├── com/
    │   │   ├── controller/     # 控制器层
    │   │   │   ├── AdminController.java
    │   │   │   ├── StudentController.java
    │   │   │   ├── TeacherController.java
    │   │   │   └── UserController.java
    │   │   ├── dao/            # 数据模型层
    │   │   │   ├── Class.java
    │   │   │   ├── Course.java
    │   │   │   ├── Score.java
    │   │   │   ├── Student.java
    │   │   │   ├── Teach.java
    │   │   │   ├── Teacher.java
    │   │   │   └── User.java
    │   │   ├── interceptor/    # 拦截器
    │   │   │   └── LoginInterceptor.java
    │   │   ├── mapper/         # MyBatis映射文件
    │   │   │   ├── StudentMapper.xml
    │   │   │   ├── TeacherMapper.xml
    │   │   │   └── UserMapper.xml
    │   │   └── service/        # 业务逻辑层
    │   │       ├── StudentService.java
    │   │       ├── TeacherService.java
    │   │       ├── UserService.java
    │   │       └── impl/       # 业务逻辑实现
    │   │           ├── StudentServiceImpl.java
    │   │           ├── TeacherServiceImpl.java
    │   │           └── UserServiceImpl.java
    │   └── mybatis-config.xml  # MyBatis配置文件
    └── webapp/                 # Web资源
        ├── Login.jsp           # 登录页面
        ├── index.jsp           # 首页
        ├── WEB-INF/            # Web配置
        ├── META-INF/           # 元数据
        └── favicon.ico
```

## 数据库配置

系统使用MySQL数据库，配置信息如下：

- 数据库名：`student_score_manage`
- 用户名：`root`
- 密码：`123456`
- 驱动类：`com.mysql.cj.jdbc.Driver`
- 连接URL：`jdbc:mysql://127.0.0.1:3306/student_score_manage?useUnicode=true&characterEncoding=UTF-8&allowMultiQueries=true&serverTimezone=GMT%2B8`

## 安装与部署

### 前置条件
- JDK 1.8或更高版本
- MySQL 5.7或更高版本
- Tomcat 9.0或更高版本
- Eclipse IDE（推荐）

### 安装步骤

1. **克隆项目**
   ```bash
   git clone [项目仓库URL]
   ```

2. **数据库初始化**
   - 创建数据库：`CREATE DATABASE student_score_manage CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`
   - 导入数据库脚本：执行项目根目录下的`sql.txt`文件

3. **项目导入**
   - 打开Eclipse IDE
   - 选择`File > Import > Existing Maven Projects`
   - 选择项目根目录，点击`Finish`

4. **配置Tomcat**
   - 在Eclipse中配置Tomcat服务器
   - 将项目添加到Tomcat中

5. **启动项目**
   - 启动Tomcat服务器
   - 访问：`http://localhost:8080/StudentManageSystem`

## 使用说明

### 登录系统
- 访问系统首页，选择角色（学生/教师/管理员）
- 输入用户名和密码
- 点击登录按钮

### 各角色功能

#### 学生
- 查看个人信息
- 查询自己的成绩
- 查看课程信息

#### 教师
- 管理学生成绩（录入、修改）
- 查看所教授的课程
- 查看学生信息

#### 管理员
- 管理用户账户（学生、教师、管理员）
- 管理班级信息
- 管理课程信息
- 管理教师授课信息

####项目展示
该系统分为学生、教师、管理员端，学生能查询对应的课程、成绩、授课教师，老师能对所管理班级的学生进行成绩登记、标记、导出成绩表，管理员能够设置课程的授课教师、学生所属的班级、对用户进行CRUD维护，以及直观查看相应的成绩、课程、人员的图表等等功能

<img width="687" height="811" alt="{81BBBDDA-76B2-4AF7-84E0-48BB04E83DE8}" src="https://github.com/user-attachments/assets/60283974-3446-486f-bbd7-9b95bf236a13" />

<img width="1667" height="812" alt="image" src="https://github.com/user-attachments/assets/9a061d26-ba72-4406-bb56-321d5bb07b15" />

<img width="1580" height="759" alt="{24AD884B-7242-4E36-8324-3FAF75D5E0A1}" src="https://github.com/user-attachments/assets/fb6be797-2509-44d1-ae4e-73792aceeb7a" />

<img width="1685" height="807" alt="{0D35B83E-A054-44F1-BA9F-C4E7D6DDE165}" src="https://github.com/user-attachments/assets/d94e26a4-122b-4614-8210-911761fa1f14" />

<img width="1673" height="806" alt="{0ECC7924-D481-4483-9589-4DA9E36623A8}" src="https://github.com/user-attachments/assets/8a79d7a9-6237-4fc1-8cab-2c972f4ff288" />

<img width="1639" height="794" alt="{60D8850F-002E-418B-9E1A-895DDF327F38}" src="https://github.com/user-attachments/assets/e39a3960-c070-470d-a483-52b96d15e6c5" />

<img width="1569" height="756" alt="{FCFE32E1-60BD-4DFE-BDEC-B244AE5CDF13}" src="https://github.com/user-attachments/assets/95116919-cb63-4b86-a6ab-f7c642e2808c" />

<img width="1632" height="786" alt="{F12E387C-25FD-4778-BAEA-961582A910E5}" src="https://github.com/user-attachments/assets/8fee66b6-4e1c-4086-816e-5ea27144fff1" />

<img width="1577" height="752" alt="{A76B90C5-F12B-448B-BC75-7B4FDA12C0D6}" src="https://github.com/user-attachments/assets/b1da7985-7303-4499-a272-977c0f278d77" />

<img width="1650" height="795" alt="{49B536C3-26CC-4A66-9A2F-3BDBCA482C90}" src="https://github.com/user-attachments/assets/187c908a-ebf7-4d34-84b3-25e6a9bc9f14" />

<img width="1571" height="756" alt="{FE31EF1C-2C4F-4531-9F9C-E34A94E1B6D7}" src="https://github.com/user-attachments/assets/dd879f3a-e2a7-416b-9741-d89ccd4f8502" />

## 注意事项

1. 数据库配置信息位于`mybatis-config.xml`文件中，可根据实际环境修改
2. 系统使用Session进行身份认证，请确保浏览器支持Cookie
3. 建议在开发环境中使用Eclipse IDE进行开发和调试


## 联系方式

如有问题或建议，请联系负责人，QQ:2922891070，欢迎进行二次开发