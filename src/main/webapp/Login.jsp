<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>学生成绩管理系统</title>
<style>
*{
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif;
}

body {
    background-color: #f0f0f0;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    padding: 20px;
}

.login-container {
    background: white;
    padding: 40px;
    border-radius: 12px;
    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.25);
    width: 100%;
    max-width: 450px;
    transition: transform 0.3s ease;
    position: relative;
    overflow: hidden;
}

.login-container:hover {
    transform: translateY(-5px);
}

.login-container::before {
    content: '';
    position: absolute;
    top: -50%;
    left: -50%;
    width: 200%;
    height: 200%;
    background: linear-gradient(45deg, transparent, rgba(26, 115, 232, 0.1), transparent);
    transform: rotate(45deg);
    z-index: 0;
}

h1 {
    text-align: center;
    color: #1a73e8;
    margin-bottom: 30px;
    font-size: 28px;
    font-weight: 700;
    position: relative;
    z-index: 1;
}

h1::after {
    content: '';
    display: block;
    width: 60px;
    height: 3px;
    background: #1a73e8;
    margin: 10px auto 0;
    border-radius: 2px;
}

.form-group {
    margin-bottom: 22px;
    position: relative;
    z-index: 1;
}

label {
    display: block;
    margin-bottom: 8px;
    color: #333;
    font-weight: 500;
    font-size: 15px;
}

input[type="text"], input[type="password"] {
    width: 100%;
    padding: 12px 15px;
    border: 1px solid #ddd;
    border-radius: 6px;
    font-size: 15px;
    transition: all 0.3s ease;
    outline: none;
}

input[type="text"]:focus, input[type="password"]:focus {
    border-color: #1a73e8;
    box-shadow: 0 0 0 2px rgba(26, 115, 232, 0.2);
}

.role-select {
    display: flex;
    gap: 20px;
    margin: 18px 0;
    position: relative;
    z-index: 1;
}

.role-option {
    display: flex;
    align-items: center;
    cursor: pointer;
}

.role-option input[type="radio"] {
    margin-right: 8px;
    cursor: pointer;
}

.remember-container {
    display: flex;
    align-items: center;
    margin: 15px 0 25px;
    position: relative;
    z-index: 1;
}

.remember-container input {
    margin-right: 10px;
    cursor: pointer;
}

.button-group {
    display: flex;
    gap: 15px;
    margin-top: 10px;
    position: relative;
    z-index: 1;
}

button {
    flex: 1;
    padding: 14px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-weight: 600;
    font-size: 16px;
    transition: all 0.3s ease;
    box-shadow: 0 4px 6px rgba(50, 50, 93, 0.11), 0 1px 3px rgba(0, 0, 0, 0.08);
}

.login-btn {
    background: #1a73e8;
    color: white;
}

.login-btn:hover {
    background: #0d5cb6;
    transform: translateY(-2px);
    box-shadow: 0 7px 14px rgba(50, 50, 93, 0.1), 0 3px 6px rgba(0, 0, 0, 0.08);
}

.clear-btn {
    background: #f8f9fa;
    color: #666;
    border: 1px solid #e0e0e0;
}

.clear-btn:hover {
    background: #e9ecef;
    transform: translateY(-2px);
}

.copyright {
    text-align: center;
    margin-top: 35px;
    color: #777;
    font-size: 13px;
    position: relative;
    z-index: 1;
}

/* 消息盒子样式 */
.top-message {
    position: fixed;
    top: -80px; /* 初始位置隐藏 */
    left: 50%;
    transform: translateX(-50%);
    background: #fff;
    padding: 15px 25px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
    z-index: 1001;
    transition: top 0.4s ease;
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-radius: 30px;
    min-width: 100px;
    text-align: center;
}

.top-message.visible {
    top: 25px; /* 显示时下移 */
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

/* 装饰元素 */
.decoration {
    position: absolute;
    z-index: 0;
    opacity: 0.1;
}

.decoration.circle {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    background: #1a73e8;
    top: -30px;
    right: -30px;
}

.decoration.square {
    width: 80px;
    height: 80px;
    background: #34a853;
    bottom: -20px;
    left: -20px;
    transform: rotate(45deg);
}

@media (max-width: 480px) {
    .login-container {
        padding: 30px 20px;
    }
    
    .role-select {
        flex-direction: column;
        gap: 12px;
    }
    
    .button-group {
        flex-direction: column;
    }
    
    h1 {
        font-size: 24px;
    }
}
</style>
</head>
<body>
    <div class="login-container">
        <div class="decoration circle"></div>
        <div class="decoration square"></div>
        
        <h1>学生成绩管理系统</h1>

        <form id="loginForm" action="login" method="post">
            <div class="form-group">
                <label for="username">用户名</label>
                <input type="text" id="username" name="username" placeholder="请输入用户名"
                    value="${fn:escapeXml(param.username)}">
            </div>

            <div class="form-group">
                <label for="password">密码</label>
                <input type="password" id="password" name="password" placeholder="请输入密码">
            </div>

            <div class="role-select">
                <div class="role-option">
                    <input type="radio" name="role" id="teacher" value="teacher" 
                        <c:if test="${param.role == 'teacher' || empty param.role}">checked</c:if>>
                    <label for="teacher">教师</label>
                </div>
                <div class="role-option">
                    <input type="radio" name="role" id="student" value="student"
                        <c:if test="${param.role == 'student'}">checked</c:if>>
                    <label for="student">学生</label>
                </div>
                <div class="role-option">
                    <input type="radio" name="role" id="admin" value="admin"
                        <c:if test="${param.role == 'admin'}">checked</c:if>>
                    <label for="admin">管理员</label>
                </div>
            </div>
            
            <div class="remember-container">
                <input type="checkbox" id="remember" name="remember" 
                    <c:if test="${cookie.remember.value == 'true'}">checked</c:if>>
                <label for="remember">记住账号</label>
            </div>
            
            <div class="button-group">
                <button type="button" class="clear-btn" onclick="clearForm()">重置</button>
                <button type="submit" class="login-btn">登录</button>
            </div>
        </form>
        
        <div class="copyright">© 2025 学生成绩管理系统 | Q.S版权所有</div>
    </div>
    
    <!-- 消息弹窗 -->
    <div id="topMessage" class="top-message">
        <span id="messageContent"></span>
    </div>
    
    <script>
        // 页面加载时检查是否有保存的登录信息
        document.addEventListener('DOMContentLoaded', function() {
            // 检查Cookie中是否有保存的信息
            const savedUsername = getCookie("savedUsername");
            const savedRole = getCookie("savedRole");
            
            if (savedUsername) {
                document.getElementById('username').value = savedUsername;
                document.getElementById('remember').checked = true;
                
                if (savedRole) {
                    const radio = document.querySelector(`input[name="role"][value="${savedRole}"]`);
                    if (radio) radio.checked = true;
                }
            }
            
            // 初始化时检查消息
            <c:if test="${not empty message}">
                showTopMessage('success', '${fn:escapeXml(message)}');
            </c:if>
            <c:if test="${not empty error}">
                showTopMessage('error', '${fn:escapeXml(error)}');
            </c:if>
        });
        
        // 表单提交前的处理
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const remember = document.getElementById('remember').checked;
            const username = document.getElementById('username').value;
            const role = document.querySelector('input[name="role"]:checked').value;
            
            if (remember && username) {
                // 设置Cookie保存信息（30天有效期）
                setCookie("savedUsername", username, 30);
                setCookie("savedRole", role, 30);
                setCookie("remember", "true", 30);
            } else {
                // 清除保存的Cookie
                deleteCookie("savedUsername");
                deleteCookie("savedRole");
                deleteCookie("remember");
            }
        });
        
        // 重置表单
        function clearForm() {
            document.getElementById('loginForm').reset();
            showTopMessage('cancel', '表单已重置');
        }
        
        // Cookie操作函数
        function setCookie(name, value, days) {
            const d = new Date();
            d.setTime(d.getTime() + (days * 24 * 60 * 60 * 1000));
            const expires = "expires=" + d.toUTCString();
            document.cookie = name + "=" + value + ";" + expires + ";path=/";
        }
        
        function getCookie(name) {
            const cname = name + "=";
            const decodedCookie = decodeURIComponent(document.cookie);
            const ca = decodedCookie.split(';');
            for(let i = 0; i < ca.length; i++) {
                let c = ca[i];
                while (c.charAt(0) === ' ') {
                    c = c.substring(1);
                }
                if (c.indexOf(cname) === 0) {
                    return c.substring(cname.length, c.length);
                }
            }
            return "";
        }
        
        function deleteCookie(name) {
            document.cookie = name + "=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
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
            
            // 自动隐藏（3秒）
            messageTimer = setTimeout(() => {
                messageEl.classList.remove('visible');
            }, 1000);
        }
    </script>
</body>
</html>