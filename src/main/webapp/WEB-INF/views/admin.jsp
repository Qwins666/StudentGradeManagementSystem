<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>学生成绩管理系统</title>
<style>
/* 确保页面主体使用 flex 布局 */
body {
	display: flex;
	min-height: 100vh;
	background-color: #f5f5f5;
	margin: 0;
	padding: 0;
	overflow: hidden; /* 隐藏整体滚动条 */
}

/* 确保对话框在固定位置 */
.dialog-overlay, .delete-confirmation-dialog, .class-form-dialog,
	.student-dialog, .course-form-dialog, .teacher-dialog {
	position: fixed; /* 确保对话框在滚动时位置正确 */
	z-index: 1000;
}

* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	font-family: 'Microsoft YaHei', sans-serif;
}

body {
	display: flex;
	min-height: 100vh;
	background-color: #f5f5f5;
}

/* 侧边栏样式 */
.sidebar {
	width: 200px;
	background-color: #2c3e50;
	color: white;
	padding: 20px;
	position: fixed; /* 改为固定定位 */
	height: 100vh; /* 全屏高度 */
	top: 0;
	left: 0;
	overflow-y: auto; /* 如果侧边栏内容过多，允许滚动 */
}

.sidebar h2 {
	margin-bottom: 30px;
	text-align: center;
}

.nav-menu {
	list-style: none;
}

.nav-menu li {
	padding: 12px;
	margin: 8px 0;
	cursor: pointer;
	border-radius: 4px;
	transition: background 0.3s;
}

.nav-menu li:hover {
	background-color: #34495e;
}

/* 主内容区 */
.main-content {
	flex: 1;
	padding: 30px;
	margin-left: 200px; /* 等于侧边栏宽度 */
	width: calc(100% - 200px); /* 减去侧边栏宽度 */
	overflow-y: auto; /* 允许垂直滚动 */
	height: 100vh; /* 全屏高度 */
}

/* 操作面板 */
.action-panel {
	display: flex;
	justify-content: space-between;
	margin-bottom: 20px;
}

.search-box {
	display: flex;
	gap: 10px;
}

input[type="text"] {
	padding: 8px 12px;
	border: 1px solid #ddd;
	border-radius: 4px;
	width: 300px;
}

button {
	padding: 8px 16px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	transition: background 0.3s;
}

/* 数据表格 */
.data-table {
	width: 100%;
	border-collapse: collapse;
	background-color: white;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.data-table th, .data-table td {
	padding: 12px 15px;
	text-align: left;
	border-bottom: 1px solid #ddd;
}

.data-table th {
	background-color: #f8f9fa;
}

.action-buttons button {
	margin: 0 4px;
	padding: 6px 12px;
	font-size: 14px;
}

.edit-btn {
	background-color: #27ae60;
	color: white;
}

.delete-btn {
	background-color: #e74c3c;
	color: white;
}

.logout-btn {
	position: absolute;
	bottom: 20px;
	left: 20px;
	background-color: #3498db;
}

.dialog-overlay {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5);
	display: none;
	justify-content: center;
	align-items: center;
	z-index: 1000;
}

.dialog-box {
	background: white;
	padding: 20px;
	border-radius: 8px;
	width: 400px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
}

.dialog-buttons {
	margin-top: 20px;
	text-align: right;
}
/*删除按钮样式*/
.delete-confirmation-dialog {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5);
	display: none;
	justify-content: center;
	align-items: center;
	z-index: 1000;
}

.confirmation-box {
	background: white;
	padding: 20px;
	border-radius: 8px;
	width: 400px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
}

.confirmation-buttons {
	margin-top: 20px;
	display: flex;
	justify-content: flex-end;
	gap: 10px;
}

/* 新增顶部消息样式 */
.top-message {
	position: fixed;
	top: -60px; /* 初始位置隐藏 */
	left: 690px;
	right: 690px;
	background: #fff;
	padding: 15px 20px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
	z-index: 1001;
	transition: top 0.3s ease;
	display: flex;
	justify-content: space-between;
	align-items: center;
	border-radius: 20px;
}

.top-message.visible {
	top: 15px; /* 显示时下移 */
}
/* 成功状态 */
.top-message.success {
	background: #dff0d8;
	color: #3c763d;
}
/* 失败状态 */
.top-message.error {
	background: #f2dede;
	color: #a94442;
}
/* 取消状态 */
.top-message.cancel {
	background: #f8f9fa;
	color: #6c757d;
}

/*视图切换*/
.view {
	display: none;
}

.view.active {
	display: block;
}

/* 新增班级管理相关样式 */
.class-form-dialog {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5);
	justify-content: center;
	align-items: center;
	z-index: 1000;
}

.class-form-container {
	background: white;
	padding: 25px;
	border-radius: 8px;
	width: 450px;
	box-shadow: 0 3px 15px rgba(0, 0, 0, 0.2);
}

.class-form-title {
	font-size: 20px;
	margin-bottom: 20px;
	color: #1a73e8;
	border-bottom: 1px solid #eee;
	padding-bottom: 10px;
}

.class-form-group {
	margin-bottom: 18px;
}

.class-form-group label {
	display: block;
	margin-bottom: 8px;
	font-weight: 500;
}

.class-form-group input, .class-form-group select {
	width: 100%;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 4px;
	font-size: 15px;
}

.class-form-buttons {
	display: flex;
	justify-content: flex-end;
	gap: 15px;
	margin-top: 25px;
}

.class-form-buttons button {
	padding: 10px 20px;
	border-radius: 4px;
	cursor: pointer;
	font-weight: 500;
}

.class-form-cancel {
	background: #f0f2f5;
	color: #555;
	border: 1px solid #ddd;
}

.class-form-submit {
	background: #1a73e8;
	color: white;
	border: none;
}

.class-id-field {
	display: block; /* 默认显示 */
}

/* 侧边栏活动状态指示 */
.nav-menu li.active {
	background-color: #34495e;
	position: relative;
}

.nav-menu li.active::after {
	content: '';
	position: absolute;
	right: 10px;
	top: 50%;
	transform: translateY(-50%);
	width: 8px;
	height: 8px;
	background: #1a73e8;
	border-radius: 50%;
}

/* 新增设置学生对话框样式 */
.student-dialog {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5);
	justify-content: center;
	align-items: center;
	z-index: 1000;
}

.student-form-container {
	background: white;
	padding: 25px;
	border-radius: 8px;
	width: 450px;
	box-shadow: 0 3px 15px rgba(0, 0, 0, 0.2);
}

.student-form-title {
	font-size: 20px;
	margin-bottom: 20px;
	color: #1a73e8;
	border-bottom: 1px solid #eee;
	padding-bottom: 10px;
}

.student-form-group {
	margin-bottom: 18px;
}

.student-form-group label {
	display: block;
	margin-bottom: 8px;
	font-weight: 500;
}

.student-form-group input {
	width: 100%;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 4px;
	font-size: 15px;
}

.student-form-group input[readonly] {
	background-color: #f5f5f5;
	cursor: not-allowed;
}

.student-form-buttons {
	display: flex;
	justify-content: flex-end;
	gap: 15px;
	margin-top: 25px;
}

.student-form-buttons button {
	padding: 10px 20px;
	border-radius: 4px;
	cursor: pointer;
	font-weight: 500;
}

.student-form-cancel {
	background: #f0f2f5;
	color: #555;
	border: 1px solid #ddd;
}

.student-form-submit {
	background: #1a73e8;
	color: white;
	border: none;
}

/* 新增班级管理相关样式 */
.course-form-dialog {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5);
	justify-content: center;
	align-items: center;
	z-index: 1000;
}

.course-form-container {
	background: white;
	padding: 25px;
	border-radius: 8px;
	width: 450px;
	box-shadow: 0 3px 15px rgba(0, 0, 0, 0.2);
}

.course-form-title {
	font-size: 20px;
	margin-bottom: 20px;
	color: #1a73e8;
	border-bottom: 1px solid #eee;
	padding-bottom: 10px;
}

.course-form-group {
	margin-bottom: 18px;
}

.course-form-group label {
	display: block;
	margin-bottom: 8px;
	font-weight: 500;
}

.course-form-group input, .course-form-group select {
	width: 100%;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 4px;
	font-size: 15px;
}

.course-form-buttons {
	display: flex;
	justify-content: flex-end;
	gap: 15px;
	margin-top: 25px;
}

.course-form-buttons button {
	padding: 10px 20px;
	border-radius: 4px;
	cursor: pointer;
	font-weight: 500;
}

.course-form-cancel {
	background: #f0f2f5;
	color: #555;
	border: 1px solid #ddd;
}

.course-form-submit {
	background: #1a73e8;
	color: white;
	border: none;
}

.course-id-field {
	display: block; /* 默认显示 */
}

/* 新增设置教师对话框样式 */
.teacher-dialog {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5);
	justify-content: center;
	align-items: center;
	z-index: 1000;
}

.teacher-form-container {
	background: white;
	padding: 25px;
	border-radius: 8px;
	width: 450px;
	box-shadow: 0 3px 15px rgba(0, 0, 0, 0.2);
}

.teacher-form-title {
	font-size: 20px;
	margin-bottom: 20px;
	color: #1a73e8;
	border-bottom: 1px solid #eee;
	padding-bottom: 10px;
}

.teacher-form-group {
	margin-bottom: 18px;
}

.teacher-form-group label {
	display: block;
	margin-bottom: 8px;
	font-weight: 500;
}

.teacher-form-group input {
	width: 100%;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 4px;
	font-size: 15px;
}

.teacher-form-group input[readonly] {
	background-color: #f5f5f5;
	cursor: not-allowed;
}

.teacher-form-buttons {
	display: flex;
	justify-content: flex-end;
	gap: 15px;
	margin-top: 25px;
}

.teacher-form-buttons button {
	padding: 10px 20px;
	border-radius: 4px;
	cursor: pointer;
	font-weight: 500;
}

.teacher-form-cancel {
	background: #f0f2f5;
	color: #555;
	border: 1px solid #ddd;
}

.teacher-form-submit {
	background: #1a73e8;
	color: white;
	border: none;
}

/*版权样式*/
.copyright {
	text-align: center;
	margin-top: 35px;
	color: #777;
	font-size: 13px;
	position: relative;
	z-index: 1;
}

/* 成绩审核状态选择框样式 */
.remark-select {
	padding: 6px 10px;
	border: 1px solid #ddd;
	border-radius: 4px;
	background: white;
	cursor: pointer;
	width: 100px;
}

.remark-select:focus {
	outline: none;
	border-color: #3498db;
	box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
}

/* 审核状态标签样式 */
.status-label {
	display: inline-block;
	padding: 2px 8px;
	border-radius: 4px;
	font-size: 12px;
	font-weight: 500;
}

.status-ok {
	background-color: #dff0d8;
	color: #3c763d;
}

.status-no {
	background-color: #f2dede;
	color: #a94442;
}

/*数据信息样式*/
.page-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 30px;
}

.page-header h1 {
	font-size: 1.8rem;
	color: #2c3e50;
	font-weight: 600;
}

/* 指标卡片样式 */
.metrics-container {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(80px, 1fr));
	gap: 20px;
	margin-bottom: 30px;
}

.metric-card {
	background: white;
	border-radius: 12px;
	padding: 25px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
	transition: all 0.3s ease;
	position: relative;
	overflow: hidden;
	max-width: 150px;
}

.metric-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

.metric-card::before {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	width: 5px;
	height: 100%;
}

.metric-title {
	font-size: 18px;
	font-weight: 600;
	color: #2c3e50;
	margin-bottom: 10px;
	display: flex;
	align-items: center;
}

.metric-value {
	font-size: 26px;
	font-weight: 600;
	margin-bottom: 5px;
	color: #2c3e50;
	text-align: center;
}

.metric-change {
	font-size: 16px;
	display: flex;
	align-items: center;
	color: #27ae60;
}

.metric-change.negative {
	color: #e74c3c;
}

/* 图表区域 */
.charts-container {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
	/*gap: 5px;卡片之间间距*/
	margin-bottom: 30px;
}

.chart-card {
	background: white;
	border-radius: 12px;
	padding: 25px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
	height: 310px;
}

/* 图表容器样式 */
.chart-card {
	background: white;
	border-radius: 12px;
	padding: 25px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
	height: 320px; /* 增加图表卡片高度 */
	display: flex;
	flex-direction: column;
}

.chart-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.chart-title {
	font-size: 18px;
	font-weight: 600;
	color: #2c3e50;
}

.chart-container {
	margin-top: -10px;
	width: 550px;
	height: 270px; /* 设置图表的高度 */
	flex: 1;
}

/* 底部版权 */
.copyright {
	text-align: center;
	margin-top: 35px;
	color: #7f8c8d;
	font-size: 14px;
	padding-top: 20px;
	border-top: 1px solid #eee;
}

/* 响应式调整 */
@media ( max-width : 1200px) {
	.charts-container {
		grid-template-columns: 1fr;
	}
}

@media ( max-width : 768px) {
	.sidebar {
		width: 70px;
	}
	.sidebar h2, .nav-menu li span {
		display: none;
	}
	.main-content {
		margin-left: 70px;
	}
}
</style>
</head>
<body>
	<!-- 侧边栏 -->
	<div class="sidebar">
		<h2>学生成绩管理系统</h2>
		<ul class="nav-menu">
			<li data-view="user" class="active" onclick="userManage()">用户管理</li>
			<li data-view="class" onclick="classManage()">班级管理</li>
			<li data-view="course" onclick="courseManage()">课程管理</li>
			<li data-view="score" onclick="gradesManage()">成绩管理</li>
			<li data-view="data" onclick="dataManage()">数据信息</li>
		</ul>
		<div
			style="position: absolute; bottom: 20px; left: 20px; width: 160px">
			<button class="logout-btn" onclick="logout()">退出登录</button>
		</div>
	</div>

	<!-- 主内容区 -->
	<div class="main-content">
		<!-- 用户管理界面 -->
		<div id="user-view" class="view active">
			<div class="action-panel">
				<h3>管理员界面</h3>
				<div class="search-box">
					<input type="text" placeholder="请输入用户名" id="searchInput">
					<button onclick="searchStudents()">搜索</button>
					<button onclick="showAddDialog()"
						style="background-color: #3498db; color: white; margin-left: 10px;">添加用户</button>
				</div>
			</div>

			<!-- 用户数据表格 -->
			<table class="data-table">
				<thead>
					<tr>
						<th width="200px">ID</th>
						<th width="250px">用户名</th>
						<th width="250px">角色</th>
						<th width="300px" style="padding-left: 50px;">操作</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${resList}" var="reslist">
						<tr>
							<td>${reslist.userid}</td>
							<td>${reslist.username}</td>
							<td>${reslist.userrole}</td>
							<td class="action-buttons">
								<button class="edit-btn"
									onclick="editUser('${reslist.userid}','${reslist.username}','${reslist.userrole}')">编辑</button>
								<button class="delete-btn"
									onclick="deleteUser('${reslist.userid}')">删除</button>
								<button style="background-color: #3498db; color: white;"
									onclick="ResetPassword('${reslist.userid}')">重置密码</button>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>

		<!-- 班级管理界面 -->
		<div id="class-view" class="view">
			<div class="action-panel">
				<h3>管理员界面</h3>
				<div class="search-box">
					<input type="text" placeholder="请输入班级名称" id="classSearchInput">
					<button onclick="searchClasses()">搜索</button>
					<button onclick="showAddClassDialog()"
						style="background-color: #3498db; color: white; margin-left: 10px;">
						添加班级</button>
				</div>
			</div>

			<!-- 班级数据表格 -->
			<table class="data-table">
				<thead>
					<tr>
						<th width="200px">班级号</th>
						<th width="250px">班级名称</th>
						<th width="250px">所属年级</th>
						<th width="300px">专业</th>
						<th width="300px" style="padding-left: 90px;">操作</th>
					</tr>
				</thead>
				<tbody id="classTableBody">
					<c:forEach items="${resClassList}" var="clazz">
						<tr>
							<td>${clazz.classid}</td>
							<td>${clazz.classname}</td>
							<td>${clazz.grade}</td>
							<td>${clazz.major}</td>
							<td class="action-buttons">
								<button class="edit-btn"
									onclick="editClass('${clazz.classid}','${clazz.classname}','${clazz.grade}','${clazz.major}')">
									编辑</button>
								<button class="delete-btn" onclick="deleteClass('${clazz.classid}')">删除</button>
								<button style="background-color: #3498db; color: white;"
									onclick="setStudent('${clazz.classid}','${clazz.classname}','${clazz.grade}','${clazz.major}')">设置学生</button>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>

		<!-- 课程管理界面 -->
		<div id="course-view" class="view">
			<div class="action-panel">
				<h3>管理员界面</h3>
				<div class="search-box">
					<input type="text" placeholder="请输入课程名称" id="courseSearchInput">
					<button onclick="searchCourses()">搜索</button>
					<button onclick="showAddCourseDialog()"
						style="background-color: #3498db; color: white; margin-left: 10px;">
						添加课程</button>
				</div>
			</div>

			<!-- 课程数据表格 -->
			<table class="data-table">
				<thead>
					<tr>
						<th width="200px">课程号</th>
						<th width="250px">课程名称</th>
						<th width="200px">学分</th>
						<th width="200px">学时</th>
						<th width="200px">授课教师</th>
						<th width="350px" style="padding-left: 90px;">操作</th>
					</tr>
				</thead>
				<tbody id="courseTableBody">
					<c:forEach items="${resCourseList}" var="course">
						<tr>
							<td>${course.courseid}</td>
							<td>${course.coursename}</td>
							<td>${course.credit}</td>
							<td>${course.hour}</td>
							<td>${not empty course.courseteacher ? course.courseteacher : '未分配'}</td>
							<td class="action-buttons">
								<button class="edit-btn"
									onclick="editCourse('${course.courseid}','${course.coursename}','${course.credit}','${course.hour}')">
									编辑</button>
								<button class="delete-btn"
									onclick="deleteCourse('${course.courseid}')">删除</button>
								<button style="background-color: #3498db; color: white;"
									onclick="setTeacher('${course.courseid}','${course.coursename}','${course.credit}','${course.hour}','${course.courseteacher}')">设置教师</button>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>

		<!-- 成绩管理界面 -->
		<div id="score-view" class="view">
			<div class="action-panel">
				<h3>管理员界面</h3>
				<div class="search-box">
					<input type="text" style="width: 220px;" placeholder="班级号"
						id="classIdSearch"> <input type="text"
						style="width: 220px;" placeholder="学生学号" id="studentIdSearch">
					<input type="text" style="width: 220px;" placeholder="课程名"
						id="courseNameSearch">
					<button onclick="searchScore()"
						style="background-color: #3498db; color: white; margin-left: 10px;">搜索</button>
				</div>
			</div>

			<!-- 成绩数据表格 -->
			<table class="data-table">
				<thead>
					<tr>
						<th width="200px">学号</th>
						<th width="250px">姓名</th>
						<th width="250px">班级号</th>
						<th width="250px">班级名称</th>
						<th width="300px">课程名称</th>
						<th width="250px">分数</th>
						<th width="250px" style="padding-left: 28px;">审核状态</th>
						<th width="250px" style="padding-left: 28px;">操作</th>
					</tr>
				</thead>
				<tbody id="courseTableBody">
					<c:forEach items="${resScoreList}" var="score">
						<tr>
							<td>${score.studentid}</td>
							<td>${score.studentname}</td>
							<td>${score.classid}</td>
							<td>${score.classname}</td>
							<td>${score.coursename}</td>
							<td>${score.score}</td>
							<td>
								<!-- 移除ID，使用类选择器 --> <select class="remark-select"
								data-scoreid="${score.scoreid}">
									<option value="OK" ${score.remark == 'OK' ? 'selected' : ''}>正常</option>
									<option value="NO" ${score.remark == 'NO' ? 'selected' : ''}>异常</option>
							</select>
							</td>
							<td>
								<!-- 传递事件对象和行数据 -->
								<button style="background-color: #3498db; color: white;"
									onclick="saveRemark(this)">保存</button>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>

		<div id="data-view" class="view">
			<!-- 数据信息管理页面 -->
			<div class="action-panel">
				<h3>管理员界面</h3>
				<button
					style="background-color: #3498db; color: white; margin-left: 10px;"
					onclick="refreshData()">刷新数据</button>
			</div>

			<!-- 图表区域 -->
			<div class="charts-container">
				<div class="chart-card">
					<div class="chart-header">
						<div class="chart-title">总数据信息</div>
					</div>
					<div class="metrics-container" style="display: flex; gap: 15px;">
						<div class="metric-card" style="max-width: 25%;">
							<div class="metric-title">总学生数</div>
							<div class="metric-value">
								<c:out value="${totalStudents}" />
							</div>
						</div>
						<div class="metric-card" style="max-width: 25%;">
							<div class="metric-title">总教师数</div>
							<div class="metric-value">
								<c:out value="${totalTeachers}" />
							</div>
						</div>
						<div class="metric-card" style="max-width: 25%;">
							<div class="metric-title">总课程数</div>
							<div class="metric-value">
								<c:out value="${totalCourses}" />
							</div>
						</div>
						<div class="metric-card" style="max-width: 25%;">
							<div class="metric-title">总成绩数</div>
							<div class="metric-value">
								<c:out value="${totalScores}" />
							</div>
						</div>
					</div>
				</div>
				<div class="chart-card">
					<div class="chart-header">
						<div class="chart-title">各专业学生分布</div>
					</div>
					<div class="chart-container" id="majorChart"></div>
				</div>
				<div class="chart-card">
					<div class="chart-header">
						<div class="chart-title">成绩分布比例</div>
					</div>
					<div class="chart-container" id="scoreChart"></div>
				</div>
				<div class="chart-card">
					<div class="chart-header">
						<div class="chart-title">课程成绩分析</div>
					</div>
					<div class="chart-container" id="courseChart"></div>
				</div>
			</div>
		</div>
		<div class="copyright">© 2025 学生成绩管理系统 | Q.S版权所有</div>
	</div>

	<!-- 用户编辑对话框 -->
	<div class="dialog-overlay" id="editDialog">
		<div class="dialog-box">
			<h3 style="margin-bottom: 15px;">用户信息</h3>
			<form id="editForm" method="post">
				<input type="hidden" id="editUserId" name="userid">
				<div style="margin-bottom: 15px;">
					<label>职工号/学号：</label> <input type="text" id="editUserName"
						name="username"
						style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
				</div>
				<!-- 新增密码字段 -->
				<div style="margin-bottom: 15px; display: none;" id="passwordField">
					<label>密码：</label> <input type="password" id="editPassword"
						name="password"
						style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
				</div>
				<div style="margin-bottom: 15px; display: block;" id="nameField">
					<label>姓名：</label> <input type="text" id="name"
						name="name"
						style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
				</div>
				<div style="margin-bottom: 15px;">
					<label>角色：</label> <select id="editUserRole" name="userrole"
						style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;"
						required>
						<option value="student">学生</option>
						<option value="teacher">教师</option>
						<option value="admin">管理员</option>
					</select>
				</div>
				<div class="dialog-buttons">
					<button type="button" onclick="closeEditDialogWithMessage()"
						style="margin-right: 10px; background: #ddd;">取消</button>
					<button type="submit" style="background: #27ae60; color: white;">确认</button>
				</div>
			</form>
		</div>
	</div>

	<!-- 删除确认对话框 -->
	<div class="delete-confirmation-dialog" id="deleteConfirmationDialog">
		<div class="confirmation-box">
			<form id="deleteForm" action="/StudentSystem/admin/deleteuser"
				method="post">
				<input type="hidden" id="deleteUserId" name="userId" value="">
				<h3 style="margin-bottom: 15px;">确认删除？</h3>
				<p id="deleteConfirmationMessage">确定要删除这个用户吗？</p>
				<div class="confirmation-buttons">
					<button type="button" onclick="cancelDelete()">取消</button>
					<button type="submit" class="delete-btn">删除</button>
				</div>
			</form>
		</div>
	</div>

	<!-- 添加/编辑班级对话框 -->
	<div class="class-form-dialog" id="classDialog">
		<div class="class-form-container">
			<h3 class="class-form-title" id="classDialogTitle">添加班级</h3>
			<form id="classForm" method="post">
				<div class="class-form-group class-id-field" id="classIdField">
					<label for="editClassId">班级号</label> <input type="text"
						id="editClassId" name="classid" placeholder="请输入班级号" required>
				</div>
				<div class="class-form-group">
					<label for="className">班级名称</label> <input type="text"
						id="className" name="classname" placeholder="请输入班级名称" required>
				</div>
				<div class="class-form-group">
					<label for="grade">所属年级</label> <input type="text" id="grade"
						name="grade" placeholder="请输入所属年级" required>
				</div>
				<div class="class-form-group">
					<label for="major">专业</label> <input type="text" id="major"
						name="major" placeholder="请输入专业名称" required>
				</div>
				<div class="class-form-buttons">
					<button type="button" class="class-form-cancel"
						onclick="closeClassDialog()">取消</button>
					<button type="submit" class="class-form-submit">确认</button>
				</div>
			</form>
		</div>
	</div>

	<!-- 删除确认对话框 -->
	<div class="delete-confirmation-dialog" id="deleteClassDialog">
		<div class="confirmation-box">
			<form id="deleteClassForm" method="post">
				<input type="hidden" id="deleteClassId" name="classid">
				<h3 style="margin-bottom: 15px;">确认删除班级？</h3>
				<p id="deleteClassMessage">确定要删除这个班级吗？</p>
				<div class="confirmation-buttons">
					<button type="button" onclick="cancelDeleteClass()">取消</button>
					<button type="submit" class="delete-btn">删除</button>
				</div>
			</form>
		</div>
	</div>

	<!-- 设置学生对话框 -->
	<div class="student-dialog" id="setStudentDialog">
		<div class="student-form-container">
			<h3 class="student-form-title">设置学生</h3>
			<form id="setStudentForm" action="/StudentSystem/admin/setstudent"
				method="post">
				<input type="hidden" id="classId" name="classid">
				<div class="student-form-group">
					<label for="studentId">学号</label> <input type="text" id="studentId"
						name="studentid" placeholder="请输入学生学号" required>
				</div>
				<div class="student-form-group">
					<label for="classNameDisplay">班级名称</label> <input type="text"
						id="classNameDisplay" name="classname" readonly>
				</div>
				<div class="student-form-group">
					<label for="gradeDisplay">年级</label> <input type="text"
						id="gradeDisplay" name="grade" readonly>
				</div>
				<div class="student-form-group">
					<label for="majorDisplay">专业</label> <input type="text"
						id="majorDisplay" name="major" readonly>
				</div>
				<div class="student-form-buttons">
					<button type="button" class="student-form-cancel"
						onclick="closeSetStudentDialog()">取消</button>
					<button type="submit" class="student-form-submit">确认</button>
				</div>
			</form>
		</div>
	</div>

	<!-- 添加/编辑课程对话框 -->
	<div class="course-form-dialog" id="courseDialog">
		<div class="course-form-container">
			<h3 class="course-form-title" id="courseDialogTitle">添加课程</h3>
			<form id="courseForm" method="post">
				<div class="course-form-group course-id-field" id="courseIdField">
					<label for="editCourseId">课程号</label> <input type="text"
						id="editCourseId" name="courseid" placeholder="请输入课程号" required>
				</div>
				<div class="course-form-group">
					<label for="courseName">课程名称</label> <input type="text"
						id="courseName" name="coursename" placeholder="请输入课程名称" required>
				</div>
				<div class="course-form-group">
					<label for="credit">学分</label> <input type="text" id="credit"
						name="credit" placeholder="请输入学分" required>
				</div>
				<div class="course-form-group">
					<label for="hour">学时</label> <input type="text" id="hour"
						name="hour" placeholder="请输入学时" required>
				</div>
				<div class="course-form-buttons">
					<button type="button" class="course-form-cancel"
						onclick="closeCourseDialog()">取消</button>
					<button type="submit" class="course-form-submit">确认</button>
				</div>
			</form>
		</div>
	</div>

	<!-- 删除课程确认对话框 -->
	<div class="delete-confirmation-dialog" id="deleteCourseDialog">
		<div class="confirmation-box">
			<form id="deleteCourseForm" method="post">
				<input type="hidden" id="deleteCourseId" name="courseid">
				<h3 style="margin-bottom: 15px;">确认删除此课程吗？</h3>
				<p id="deleteCourseMessage">确定要删除这个班级吗？</p>
				<div class="confirmation-buttons">
					<button type="button" onclick="cancelDeleteCourse()">取消</button>
					<button type="submit" class="delete-btn">删除</button>
				</div>
			</form>
		</div>
	</div>

	<!-- 设置教师对话框 -->
	<div class="teacher-dialog" id="setTeacherDialog">
		<div class="teacher-form-container">
			<h3 class="teacher-form-title">设置课程班级与教师</h3>
			<form id="setTeacherForm" action="/StudentSystem/admin/setteacher"
				method="post">
				<input type="hidden" id="courseId" name="courseid">
				<div class="teacher-form-group">
					<label for="courseClassId">课程班级号</label> <input type="text"
						id="courseClassId" name="classid" placeholder="请输入班级号"
						required>
				</div>
				<div class="teacher-form-group">
					<label for="teacherId">授课教师号</label> <input type="text"
						id="teacherId" name="teacherid" placeholder="请输入教职工号"
						required>
				</div>
				<div class="teacher-form-group">
					<label for="courseNameDisplay">课程名称</label> <input type="text"
						id="courseNameDisplay" name="coursename" readonly>
				</div>
				<div class="teacher-form-group">
					<label for="creditsDisplay">学分</label> <input type="text"
						id="creditDisplay" name="credit" readonly>
				</div>
				<div class="teacher-form-group">
					<label for="hourDisplay">学时</label> <input type="text"
						id="hourDisplay" name="hour" readonly>
				</div>
				<div class="teacher-form-buttons">
					<button type="button" class="teacher-form-cancel"
						onclick="closeSetTeacherDialog()">取消</button>
					<button type="submit" class="teacher-form-submit">确认</button>
				</div>
			</form>
		</div>
	</div>

	<!-- 消息弹窗 -->
	<div id="topMessage" class="top-message">
		<span id="messageContent"></span>
	</div>

	<!-- 替换本地echarts.js为CDN -->
	<script
		src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
	<script>
        // 搜索功能
        function searchStudents() {
            const searchValue = document.getElementById('searchInput').value.toLowerCase();
            document.querySelectorAll('.data-table tbody tr').forEach(row => {
            	const shouldShow = 
		            row.cells[0].textContent.toLowerCase().includes(searchValue) || 
		            row.cells[1].textContent.toLowerCase().includes(searchValue)||
		            row.cells[2].textContent.toLowerCase().includes(searchValue);
		        row.style.display = shouldShow ? '' : 'none';
		    });
            showTopMessage('success', '查询成功');
        }

        // 编辑功能
        function editUser(userId, userName, userRole) {
    document.getElementById('editUserId').value = userId;
    document.getElementById('editUserName').value = userName;
    document.getElementById('editUserRole').value = userRole;
    
    // 隐藏密码字段
    document.getElementById('passwordField').style.display = 'none';
    document.getElementById('editPassword').removeAttribute('required');
    
    // 设置表单动作为更新
    document.getElementById('editForm').action = "/StudentSystem/admin/updateuser";
    document.getElementById('editDialog').style.display = 'flex';
}

        // 关闭对话框
        function closeEditDialogWithMessage() {
            document.getElementById('editDialog').style.display = 'none';
            //显示弹窗
            showTopMessage('cancel', '编辑取消');
        }

        // 添加用户
        function showAddDialog() {
    document.getElementById('editForm').reset();
    document.getElementById('editUserId').value = '';
    
    // 显示密码字段并设置必填
    document.getElementById('passwordField').style.display = 'block';
    document.getElementById('editPassword').required = true;
    
    // 设置表单动作为添加
    document.getElementById('editForm').action = "/StudentSystem/admin/adduser";
    document.getElementById('editDialog').style.display = 'flex';
}

        // 删除功能
        let currentDeleteUserId = null;
        function deleteUser(userid) {
        	const userId = parseInt(userid);
            document.getElementById('deleteUserId').value = userId;
            //显示对话框
            document.getElementById('deleteConfirmationDialog').style.display = 'flex';
        }

        function cancelDelete() {
            document.getElementById('deleteConfirmationDialog').style.display = 'none';
            showTopMessage('cancel', '删除取消');
        }
        
        //退出登录功能
        function logout() {
    		fetch('/StudentSystem/logout', {
        	method: 'GET'
    		}).then(() => {
        		window.location.href = '/StudentSystem/Login.jsp';	
    		});
		}
        
        //重置密码功能
        function ResetPassword(userid) {
			// 创建表单并提交
			const form = document.createElement('form');
			form.method = 'POST';
			form.action = '/StudentSystem/admin/resetpassword';
			form.style.display = 'none';
			// 添加 userid 到表单
		    const userIdInput = document.createElement('input');
		    userIdInput.type = 'hidden';
		    userIdInput.name = 'userid';
		    userIdInput.value = userid;
		    form.appendChild(userIdInput);
			document.body.appendChild(form);
			form.submit();
		}
        
     // 消息弹窗控制
       let messageTimer;

	function showTopMessage(type, message) {
    const messageEl = document.getElementById('topMessage');
    const contentEl = document.getElementById('messageContent');
    
    // 清除现有计时器和样式
    clearTimeout(messageTimer);
    messageEl.className = 'top-message';
    
    // 设置内容和样式
    contentEl.textContent = message;
    messageEl.classList.add(type, 'visible');
    
    // 自动隐藏（1秒）
    messageTimer = setTimeout(() => {
        messageEl.classList.remove('visible');
    }, 1000);
}

// 初始化时检查消息
window.onload = function() {
    <c:if test="${not empty message}">
        showTopMessage('success', '${fn:escapeXml(message)}');
    </c:if>
    <c:if test="${not empty error}">
        showTopMessage('error', '${fn:escapeXml(error)}');
    </c:if>
    
    
 	//根据服务器返回的activeView设置活动视图
    <c:if test="${not empty activeView}">
        const activeView = '${activeView}';
        document.querySelector(`.nav-menu li[data-view="${activeView}"]`).classList.add('active');
        document.querySelectorAll('.view').forEach(view => {
            view.classList.remove('active');
        });
        document.getElementById(`${activeView}-view`).classList.add('active');
        currentActiveView = activeView;
    </c:if>
};


//当前活动视图
let currentActiveView = 'user';
//初始化视图切换
document.querySelectorAll('.nav-menu li').forEach(item => {
	item.addEventListener('click', function() {
		// 更新活动状态
		document.querySelector('.nav-menu li.active').classList.remove('active');
		this.classList.add('active');
		
		// 切换视图
		const viewId = this.dataset.view + '-view';
		document.querySelectorAll('.view').forEach(view => {
			view.classList.remove('active');
		});
		document.getElementById(viewId).classList.add('active');
		
		currentActiveView = this.dataset.view;
	});
});
 
//加载班级数据 - 通过表单提交
function classManage() {
	// 创建表单并提交
	const form = document.createElement('form');
	form.method = 'GET';
	form.action = '/StudentSystem/admin/classlist';
	form.style.display = 'none';
	document.body.appendChild(form);
	form.submit();
}

//加载用户数据 - 通过表单提交
function userManage() {
	// 创建表单并提交
	const form = document.createElement('form');
	form.method = 'GET';
	form.action = '/StudentSystem/admin/userlist';
	form.style.display = 'none';
	document.body.appendChild(form);
	form.submit();
}

//加载课程数据 - 通过表单提交
function courseManage() {
	// 创建表单并提交
	const form = document.createElement('form');
	form.method = 'GET';
	form.action = '/StudentSystem/admin/courselist';
	form.style.display = 'none';
	document.body.appendChild(form);
	form.submit();
}

//加载成绩数据 - 通过表单提交
function gradesManage() {
	// 创建表单并提交
	const form = document.createElement('form');
	form.method = 'GET';
	form.action = '/StudentSystem/admin/scorelist';
	form.style.display = 'none';
	document.body.appendChild(form);
	form.submit();
}

//加载数据信息
function dataManage() {
	// 创建表单并提交
	const form = document.createElement('form');
	form.method = 'GET';
	form.action = '/StudentSystem/admin/datainfo';
	form.style.display = 'none';
	document.body.appendChild(form);
	form.submit();

}

//显示添加班级对话框
function showAddClassDialog() {
	document.getElementById('classDialogTitle').textContent = '添加班级';
	document.getElementById('classForm').reset();
	document.getElementById('editClassId').value = '';
	document.getElementById('classForm').action = '/StudentSystem/admin/addclass';
	// 显示班级号输入框
	document.getElementById('classIdField').style.display = 'block';
	document.getElementById('editClassId').required = true;
	
	document.getElementById('classDialog').style.display = 'flex';
}

// 班级搜索功能
		function searchClasses() {
			const searchValue = document.getElementById('classSearchInput').value.toLowerCase();
			document.querySelectorAll('#classTableBody tr').forEach(row => {
				const shouldShow = 
		            row.cells[0].textContent.toLowerCase().includes(searchValue) || 
		            row.cells[1].textContent.toLowerCase().includes(searchValue)||
		            row.cells[2].textContent.toLowerCase().includes(searchValue)||
		            row.cells[3].textContent.toLowerCase().includes(searchValue);
		        row.style.display = shouldShow ? '' : 'none';
		    });
			showTopMessage('success', '查询成功');
		}

//编辑班级
function editClass(classid, classname, grade, major) {
	document.getElementById('classDialogTitle').textContent = '编辑班级';
	document.getElementById('editClassId').value = classid;
	document.getElementById('className').value = classname;
	document.getElementById('grade').value = grade;
	document.getElementById('major').value = major;
	// 隐藏班级号输入框（因为编辑时班级号不可修改）
	document.getElementById('classIdField').style.display = 'none';
	document.getElementById('editClassId').required = false;
	
	document.getElementById('classForm').action = '/StudentSystem/admin/updateclass';
	document.getElementById('classDialog').style.display = 'flex';
}

//关闭班级对话框
function closeClassDialog() {
	document.getElementById('classDialog').style.display = 'none';
	showTopMessage('cancel', '操作取消');
}

//删除班级
function deleteClass(classid) {
	document.getElementById('deleteClassId').value = classid;
	document.getElementById('deleteClassMessage').textContent = 
		`确定要删除班级吗？`;
	document.getElementById('deleteClassForm').action = '/StudentSystem/admin/deleteclass';
	document.getElementById('deleteClassDialog').style.display = 'flex';
}

// 取消删除班级
function cancelDeleteClass() {
	document.getElementById('deleteClassDialog').style.display = 'none';
	showTopMessage('cancel', '删除取消');
}

//显示设置学生对话框
function setStudent(classid, classname, grade, major) {
    document.getElementById('classId').value = classid;
    document.getElementById('classNameDisplay').value = classname;
    document.getElementById('gradeDisplay').value = grade;
    document.getElementById('majorDisplay').value = major;
    document.getElementById('studentId').value = '';
    document.getElementById('setStudentDialog').style.display = 'flex';
}

// 关闭设置学生对话框
function closeSetStudentDialog() {
    document.getElementById('setStudentDialog').style.display = 'none';
    showTopMessage('cancel', '操作取消');
}

//课程搜索功能
function searchCourses() {
	const searchValue = document.getElementById('courseSearchInput').value.toLowerCase();
	document.querySelectorAll('#courseTableBody tr').forEach(row => {
        // 检查课程号(第0列) OR 课程名称(第1列)
        const shouldShow = 
            row.cells[0].textContent.toLowerCase().includes(searchValue) || 
            row.cells[1].textContent.toLowerCase().includes(searchValue)||
            row.cells[2].textContent.toLowerCase().includes(searchValue)||
            row.cells[3].textContent.toLowerCase().includes(searchValue)||
            row.cells[4].textContent.toLowerCase().includes(searchValue);
        row.style.display = shouldShow ? '' : 'none';
    });
	showTopMessage('success', '查询成功');
}

//显示添加课程对话框
function showAddCourseDialog() {
	document.getElementById('courseDialogTitle').textContent = '添加课程';
	document.getElementById('courseForm').reset();
	document.getElementById('editCourseId').value = '';
	document.getElementById('courseForm').action = '/StudentSystem/admin/addcourse';
	// 显示课程号输入框
	document.getElementById('courseIdField').style.display = 'block';
	document.getElementById('editCourseId').required = true;
	
	document.getElementById('courseDialog').style.display = 'flex';
}

//编辑课程
function editCourse(courseid, coursename, credit, hour) {
	document.getElementById('courseDialogTitle').textContent = '编辑课程';
	document.getElementById('editCourseId').value = courseid;
	document.getElementById('courseName').value = coursename;
	document.getElementById('credit').value = credit;
	document.getElementById('hour').value = hour;
	// 隐藏课程号输入框（因为编辑时课程号不可修改）
	document.getElementById('courseIdField').style.display = 'none';
	document.getElementById('editCourseId').required = false;
	
	document.getElementById('courseForm').action = '/StudentSystem/admin/updatecourse';
	document.getElementById('courseDialog').style.display = 'flex';
}

//关闭课程对话框
function closeCourseDialog() {
	document.getElementById('courseDialog').style.display = 'none';
	showTopMessage('cancel', '操作取消');
}

//删除课程
function deleteCourse(courseid) {
	document.getElementById('deleteCourseId').value = courseid;
	document.getElementById('deleteCourseMessage').textContent = 
		`确定要删除班级吗？`;
	document.getElementById('deleteCourseForm').action = '/StudentSystem/admin/deletecourse';
	document.getElementById('deleteCourseDialog').style.display = 'flex';
}

// 取消删除课程
function cancelDeleteCourse() {
	document.getElementById('deleteCourseDialog').style.display = 'none';
	showTopMessage('cancel', '删除取消');
}

//显示设置教师对话框
function setTeacher(courseid,coursename,credit,hour) {
    document.getElementById('courseId').value = courseid;
    document.getElementById('courseNameDisplay').value = coursename;
    document.getElementById('creditDisplay').value = credit;
    document.getElementById('hourDisplay').value = hour;
    document.getElementById('teacherId').value='';
    document.getElementById('courseClassId').value='';
    document.getElementById('setTeacherDialog').style.display = 'flex';
}

// 关闭设置教师对话框
function closeSetTeacherDialog() {
    document.getElementById('setTeacherDialog').style.display = 'none';
    showTopMessage('cancel', '操作取消');
}

//保存审核状态
function saveRemark(button) {
    const row = button.closest('tr');
    const select = row.querySelector('.remark-select');
    const scoreid = select.dataset.scoreid;
    const remarkValue = select.value;
    
    // 创建并提交表单
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '/StudentSystem/admin/updateremark';
    form.style.display = 'none';
    
    // 添加必须字段
    const scoreidInput = document.createElement('input');
    scoreidInput.type = 'hidden';
    scoreidInput.name = 'scoreid';
    scoreidInput.value = scoreid;
    form.appendChild(scoreidInput);
    
    const remarkInput = document.createElement('input');
    remarkInput.type = 'hidden';
    remarkInput.name = 'remark';
    remarkInput.value = remarkValue;
    form.appendChild(remarkInput);
    
    document.body.appendChild(form);
    form.submit();
}
// 成绩搜索功能
function searchScore() {
    const classIdValue = document.getElementById('classIdSearch').value.toLowerCase();
    const studentIdValue = document.getElementById('studentIdSearch').value.toLowerCase();
    const courseNameValue = document.getElementById('courseNameSearch').value.toLowerCase();
    
    document.querySelectorAll('#score-view .data-table tbody tr').forEach(row => {
        const classCell = row.cells[2].textContent.toLowerCase(); 
        const studentIdCell = row.cells[0].textContent.toLowerCase(); 
        const courseCell = row.cells[4].textContent.toLowerCase(); 
        
        // 检查所有条件是否匹配（如果输入为空则视为匹配）
        const classMatch = !classIdValue || classCell.includes(classIdValue);
        const studentMatch = !studentIdValue || studentIdCell.includes(studentIdValue);
        const courseMatch = !courseNameValue || courseCell.includes(courseNameValue);
        
        row.style.display = (classMatch && studentMatch && courseMatch) ? '' : 'none';
    });
    showTopMessage('success', '查询成功');
}

//刷新图表数据信息
function refreshData(){
	//调用获取图表数据函数
	dataManage();
}

  // 专业分布柱状图
  // 确保在文档加载完成后初始化图表
        document.addEventListener('DOMContentLoaded', function() {
        	//各专业学生人数数据
        	//安全构建JS对象
        	const majorData = {};
            <c:forEach items="${majorStudentCount}" var="entry">
                majorData["${fn:escapeXml(entry.key)}"] = ${entry.value};
            </c:forEach>
            const majors = Object.keys(majorData);
            const studentCounts = majors.map(major => majorData[major]);
            /*console.log(majorData);
        	console.log(majors);
        	console.log(studentCounts);*/
            // 初始化各专业学生分布图表
            var chardom1 = document.getElementById("majorChart");
            var mychart = echarts.init(chardom1);
            var option;
            option = {
                tooltip: {
                    trigger: 'axis',
                    formatter: '{b}: {c}人'
                },
                grid: {
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    containLabel: true
                },
                xAxis: {
                    type: 'category',
                    data: majors,
                    axisLabel: {
                        rotate: 30 // 如果专业名太长可旋转
                    }
                },
                yAxis: {
                    type: 'value',
                    name: '学生人数'
                },
                series: [{
                    name: '学生数',
                    type: 'bar',
                    data: studentCounts,
                    itemStyle: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                            { offset: 0, color: '#3498db' },
                            { offset: 1, color: '#2c3e50' }
                        ])
                    }
                }]
            };
            option && mychart.setOption(option);
            
            //成绩分布饼图
      		// 构建成绩分布数据对象
    		const scoreData = {};
    		<c:forEach items="${scoreStudentCount}" var="entry">
        		scoreData["${fn:escapeXml(entry.key)}"] = ${entry.value};
    		</c:forEach>
            var chardom2 = document.getElementById("scoreChart");
            var scoreChart = echarts.init(chardom2);
            var option2;
         	// 定义成绩分段顺序和颜色
            const scoreRanges = ['90-100分', '80-89分', '70-79分', '60-69分', '不及格'];
            const colorMap = {
                '90-100分': '#2ecc71',
                '80-89分': '#3498db',
                '70-79分': '#f39c12',
                '60-69分': '#e67e22',
                '不及格': '#e74c3c'
            };
         	// 构建饼图数据
            const pieData = scoreRanges.map(range => ({
                value: scoreData[range] || 0,
                name: range,
                itemStyle: { color: colorMap[range] }
            }));
            option2 = {
                    tooltip: {
                        trigger: 'item',
                        formatter: '{a} <br/>{b}: {c}人 ({d}%)'
                    },
                    legend: {
                        orient: 'horizontal',
                        bottom: 10,
                        data: scoreRanges
                    },
                    series: [
                        {
                            name: '成绩分布',
                            type: 'pie',
                            radius: ['40%', '70%'],
                            avoidLabelOverlap: false,
                            itemStyle: {
                                borderRadius: 10,
                                borderColor: '#fff',
                                borderWidth: 2
                            },
                            label: {
                                show: false,
                                position: 'center'
                            },
                            emphasis: {
                                label: {
                                    show: true,
                                    fontSize: '18',
                                    fontWeight: 'bold'
                                }
                            },
                            labelLine: {
                                show: false
                            },
                            data: pieData  // 使用后端数据
                        }
                    ]
                };
                option2 && scoreChart.setOption(option2);
            
                
                const courseData = {
             			<c:forEach items="${courseStudentCount}" var="entry" varStatus="loop">
                 			"${fn:escapeXml(entry.key)}": {
                     			max: ${entry.value.max},
                     			min: ${entry.value.min},
                     			avg: ${entry.value.avg}
                 			}${!loop.last ? ',' : ''}
             			</c:forEach>
         			};
              // 提取课程名称并排序
                 const courseNames = Object.keys(courseData).sort();
                 console.log(courseNames);
              // 构建图表数据
                 const maxScores = [];
                 const minScores = [];
                 const avgScores = [];
                 courseNames.forEach(courseName => {
             	    maxScores.push(courseData[courseName].max);
             	    minScores.push(courseData[courseName].min);
             	    avgScores.push(courseData[courseName].avg);
             	});
             // 课程成绩分析图
             var chardom3 = document.getElementById("courseChart");
             var courseChart = echarts.init(chardom3);
             var option3;
             option3 = {
            		    tooltip: {
            		        trigger: 'axis',
            		        axisPointer: {
            		            type: 'shadow'
            		        }
            		    },
            		    legend: {
            		        data: ['平均分', '最高分', '最低分'],
            		        bottom: 10
            		    },
            		    grid: {
            		        left: '3%',
            		        right: '4%',
            		        bottom: '15%',
            		        containLabel: true
            		    },
            		    xAxis: {
            		        type: 'category',
            		        data: courseNames, // 使用实际课程名称
            		        axisLine: {
            		            rotate: 30
            		        }
            		    },
            		    yAxis: {
            		        type: 'value',
            		        name: '分数',
            		        min: 0,
            		        max: 100,
            		        axisLine: {
            		            lineStyle: {
            		                color: '#ccc'
            		            }
            		        },
            		        splitLine: {
            		            lineStyle: {
            		                color: '#f0f0f0'
            		            }
            		        }
            		    },
            		    series: [
            		        {
            		            name: '平均分',
            		            type: 'bar',
            		            data: avgScores,
            		            itemStyle: {
            		                color: '#3498db'
            		            }
            		        },
            		        {
            		            name: '最高分',
            		            type: 'bar',
            		            data: maxScores,
            		            itemStyle: {
            		                color: '#2ecc71'
            		            }
            		        },
            		        {
            		            name: '最低分',
            		            type: 'bar',
            		            data: minScores,
            		            itemStyle: {
            		                color: '#e74c3c'
            		            }
            		        }
            		    ]
            		};

            		option3 && courseChart.setOption(option3); 
        });
    </script>
</body>
</html>