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
</head>
<body>
	<!-- 学号隐藏字段 -->
	<input type="hidden" id="teacherSno"
		value="${sessionScope.teacher.teacherid}">
	<!-- 侧边栏 -->
	<div class="sidebar">
		<h2>学生成绩管理系统</h2>
		<ul class="nav-menu">
			<li data-view="course" class="active" onclick="courseInfo()">课程信息</li>
			<li data-view="password" onclick="resetPasswordForm()">修改密码</li>
		</ul>
		<div
			style="position: absolute; bottom: 20px; left: 20px; width: 160px">
			<button class="logout-btn" onclick="logout()">退出登录</button>
		</div>
	</div>

	<!-- 主内容区 -->
	<div class="main-content">
		<!-- 课程成绩管理界面 -->
		<div id="course-view" class="view active">
			<div class="action-panel">
				<div
					style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
					<h3>您好，${sessionScope.teacher.teacherid}教师！</h3>
					<div>
						<button
							style="background-color: #f18f48; color: white; margin-right: 5px;"
							onclick="exportScores('excel')">导出Excel</button>
						<button style="background-color: #f18f48; color: white;"
							onclick="exportScores('pdf')">导出PDF</button>
					</div>
				</div>
				<div class="search-box">
					<input type="text" placeholder="班级号" id="classIdSearch"> <input
						type="text" placeholder="学生学号" id="studentIdSearch"> <input
						type="text" placeholder="课程名" id="courseNameSearch"><input
						type="text" placeholder="成绩状态" id="scoreStateSearch">
					<button onclick="searchScore()">搜索</button>
					<button onclick="saveScore()"
						style="background-color: #3498db; color: white; margin-left: 10px;">保存</button>
				</div>
			</div>

			<!-- 用户数据表格 -->
			<table class="data-table">
				<thead>
					<tr>
						<th width="200px">学号</th>
						<th width="200px">姓名</th>
						<th width="250px">班级号</th>
						<th width="250px">课程号</th>
						<th width="250px">课程名</th>
						<th width="250px">课程成绩</th>
						<th width="250px">成绩状态</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${resTeacherList}" var="courseScore">
						<tr>
							<td>${courseScore.studentid}</td>
							<td>${courseScore.studentname}</td>
							<td>${courseScore.classid}</td>
							<td>${courseScore.courseid}</td>
							<td>${courseScore.coursename}</td>
							<td><input type="hidden" name="scoreid"
								value="${courseScore.scoreid}"> <input type="text"
								style="width: 80px;" name="score" value="${courseScore.score}"
								class="score-input"></td>
							<td>${courseScore.remark}</td>
						</tr>
					</c:forEach>
				</tbody>
				<!-- 在表格下方添加表单 -->
				<form id="scoreForm" method="POST" action="/StudentSystem/teacher/updateScore" style="display: none;">
					<!-- 表单内容将通过JS动态填充 -->
				</form>
			</table>
		</div>

		<!-- 密码修改界面 -->
		<div id="password-view" class="view">
			<div class="action-panel">
				<h3>您好，${sessionScope.teacher.teacherid}教师！</h3>
			</div>
			<div class="password-form">
				<div class="form-group">
					<label for="account">账号：</label> <input type="text" id="account"
						value="${sessionScope.teacher.teacherid}" readonly>
				</div>
				<div class="form-group">
					<label for="oldPassword">旧密码：</label> <input type="password"
						id="oldPassword" placeholder="请输入当前密码" required>
				</div>
				<div class="form-group">
					<label for="newPassword">新密码：</label> <input type="password"
						id="newPassword" placeholder="请输入新密码（至少8位）" required>
				</div>
				<div class="form-group">
					<label for="confirmPassword">确认密码：</label> <input type="password"
						id="confirmPassword" placeholder="请再次输入新密码" required>
				</div>
				<div class="form-buttons">
					<button type="button" onclick="resetPasswordForm()">重置</button>
					<button type="button" onclick="updatePassword()">修改</button>
				</div>
			</div>
		</div>
		<div class="copyright">© 2025 学生成绩管理系统 | Q.S版权所有</div>
	</div>

	<!-- 消息弹窗 -->
	<div id="topMessage" class="top-message">
		<span id="messageContent"></span>
	</div>
	<script>
//退出登录功能
function logout() {
	fetch('/StudentSystem/logout', {
	method: 'GET'
	}).then(() => {
		window.location.href = '/StudentSystem/Login.jsp';	
	});
}

//初始化时检查消息
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

//消息弹窗控制
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

//当前活动视图
let currentActiveView = 'course';
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

//获取职工号
const teacherSno = document.getElementById('teacherSno').value;
//加载个人成绩数据 - 通过表单提交
function courseInfo() {
	// 创建表单并提交
	const form = document.createElement('form');
	form.method = 'GET';
	form.action = '/StudentSystem/teacher/teacherlist';
	form.style.display = 'none';
	document.body.appendChild(form);
	form.submit();
}

//表单验证和重置功能
function resetPasswordForm() {
    document.getElementById('oldPassword').value = '';
    document.getElementById('newPassword').value = '';
    document.getElementById('confirmPassword').value = '';
}

function updatePassword() {
    const oldPassword = document.getElementById('oldPassword').value;
    const newPassword = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    if(newPassword !== confirmPassword) {
    	resetPasswordForm();
    	showTopMessage('error', '密码不一致');
    }else{
    	// 创建表单
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '/StudentSystem/teacher/resetpassword';
        form.style.display = 'none';

        // 添加职工号参数
        const snoInput = document.createElement('input');
        snoInput.type = 'hidden';
        snoInput.name = 'teacherId';
        snoInput.value = document.getElementById('teacherSno').value;
        form.appendChild(snoInput);

        // 添加旧密码参数
        const oldPasswordInput = document.createElement('input');
        oldPasswordInput.type = 'hidden';
        oldPasswordInput.name = 'oldPassword';
        oldPasswordInput.value = oldPassword;
        form.appendChild(oldPasswordInput);

        // 添加新密码参数
        const newPasswordInput = document.createElement('input');
        newPasswordInput.type = 'hidden';
        newPasswordInput.name = 'newPassword';
        newPasswordInput.value = newPassword;
        form.appendChild(newPasswordInput);

        // 提交表单
        document.body.appendChild(form);    
        form.submit();
    }
}

//查询成绩
function searchScore() {
    const classIdValue = document.getElementById('classIdSearch').value.toLowerCase();
    const studentIdValue = document.getElementById('studentIdSearch').value.toLowerCase();
    const courseNameValue = document.getElementById('courseNameSearch').value.toLowerCase();
    const scoreStateValue = document.getElementById('scoreStateSearch').value.toLowerCase();
    
    document.querySelectorAll('#course-view .data-table tbody tr').forEach(row => {
        const classCell = row.cells[2].textContent.toLowerCase(); 
        const studentIdCell = row.cells[0].textContent.toLowerCase(); 
        const courseCell = row.cells[4].textContent.toLowerCase(); 
        const stateCell = row.cells[6].textContent.toLowerCase(); 
        
        // 检查所有条件是否匹配（如果输入为空则视为匹配）
        const classMatch = !classIdValue || classCell.includes(classIdValue);
        const studentMatch = !studentIdValue || studentIdCell.includes(studentIdValue);
        const courseMatch = !courseNameValue || courseCell.includes(courseNameValue);
        const stateMatch = !scoreStateValue || stateCell.includes(scoreStateValue);
        
        row.style.display = (classMatch && studentMatch && courseMatch && stateMatch) ? '' : 'none';
    });
    showTopMessage('success', '查询成功');
}

//保存成绩
function saveScore() {
    const form = document.getElementById('scoreForm');
    form.innerHTML = ''; // 清空表单
    
    // 收集所有成绩输入
    const inputs = document.querySelectorAll('.score-input');
    let isValid = true;
    
    inputs.forEach(input => {
        const scoreValue = input.value.trim();
        const scoreId = input.previousElementSibling.value; // 获取对应的scoreid
        
        // 验证成绩格式
        if (scoreValue === '') {
            showTopMessage('error', '不能为空');
            isValid = false;
            return;
        }
        if (isNaN(scoreValue)) {
            showTopMessage('error', '必须为数字');
            isValid = false;
            return;
        }
        if (parseFloat(scoreValue) < 0 || parseFloat(scoreValue) > 100) {
            showTopMessage('error', '成绩无效');
            isValid = false;
            return;
        }
        
        // 创建隐藏输入字段
        const scoreidInput = document.createElement('input');
        scoreidInput.type = 'hidden';
        scoreidInput.name = 'scoreid';
        scoreidInput.value = scoreId;
        form.appendChild(scoreidInput);
        
        const scoreInput = document.createElement('input');
        scoreInput.type = 'hidden';
        scoreInput.name = 'score';
        scoreInput.value = scoreValue;
        form.appendChild(scoreInput);
    });
    
    if (isValid) {
        form.submit();
    }
}
</script>
</body>
</html>