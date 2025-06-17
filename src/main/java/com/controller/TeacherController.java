package com.controller;

import java.io.IOException;
import java.util.List;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.service.TeacherService;
import com.service.UserService;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.dao.Score;
import com.dao.Course;
import com.dao.Teacher;
import com.dao.User;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

@Controller
@RequestMapping("/teacher")
public class TeacherController {
	@Autowired
	private TeacherService teacherService;

	@Autowired
	UserService userService;

	// 教师课程信息列表
	@GetMapping("/teacherlist")
	public String courseInfoList(Model model, HttpSession session) {
		// 从session获取教师对象
		Teacher teacher = (Teacher) session.getAttribute("teacher");
		if (teacher == null) {
			// 如果未登录，重定向到登录页面
			return "redirect:/Login.jsp";
		}
		List<Score> resTeacherCourseList = teacherService.findTeacherByTid(teacher.getTeacherid());
		System.out.println("===== 成绩列表信息 =====");
		for (Score score : resTeacherCourseList) {
		    System.out.println(
		    	"成绩号: " + score.getScoreid() + ", " +
		        "学号: " + score.getStudentid() + ", " +
		        "姓名: " + score.getStudentname() + ", " +
		        "班级号: " + score.getClassid() + ", " +
		        "课程号: " + score.getCourseid() + ", " +
		        "课程名: " + score.getCoursename() + ", " +
		        "成绩: " + score.getScore() + ", " +
		        "状态: " + score.getRemark()
		    );
		}
		System.out.println("===== 共 " + resTeacherCourseList.size() + " 条记录 =====");
		model.addAttribute("resTeacherList", resTeacherCourseList);
		return "teacher";
	}

	// 修改教师密码
	@PostMapping("/resetpassword")
	public String resetPassword(@RequestParam("teacherId") String teacherid,
			@RequestParam("oldPassword") String oldpassword, @RequestParam("newPassword") String newpassword,
			RedirectAttributes redirectAttributes, Model model) {
		try {
			// 检查该用户的旧密码是否正确
			User existUser = userService.findUserByName(teacherid, oldpassword);
			if (existUser != null) {
				User studentAccount = new User();
				studentAccount.setUsername(teacherid);
				studentAccount.setPassword(newpassword);
				Integer row = teacherService.resetPassword(studentAccount);
				if (row > 0) {
					redirectAttributes.addFlashAttribute("message", "修改成功");
					return "redirect:/Login.jsp";
				} else {
					redirectAttributes.addFlashAttribute("error", "修改失败");
				}
			} else {
				redirectAttributes.addFlashAttribute("error", "修改失败");
			}
		} catch (Exception e) {
			e.printStackTrace();
			redirectAttributes.addFlashAttribute("error", "修改失败: " + e.getMessage());
		}
		model.addAttribute("activeView", "password");
		return "student";
	}
	
	// 批量更新成绩
	@PostMapping("/updateScore")
	public String updateScore(@RequestParam("scoreid") List<Integer> scoreids,@RequestParam("score") List<Double> scores,HttpSession session,RedirectAttributes redirectAttributes) {
	    Teacher teacher = (Teacher) session.getAttribute("teacher");
	    System.out.println(scoreids);
	    System.out.println(teacher);
	    if (teacher == null) {
	        return "redirect:/Login.jsp";
	    } 
	    try {
	        for (int i = 0; i < scoreids.size(); i++) {
	            teacherService.updateScore(scoreids.get(i), scores.get(i));
	        }
	        redirectAttributes.addFlashAttribute("message", "更新成功");
	    } catch (Exception e) {
	        redirectAttributes.addFlashAttribute("error", "更新失败: " + e.getMessage());
	    }
	    
	    return "redirect:/teacher/teacherlist";
	}
	
	//导出pdf或者Excel格式的成绩
	@PostMapping("/exportScores")
	public void exportScores(HttpServletResponse response,
	                       @RequestParam("format") String format,
	                       HttpSession session) throws IOException, DocumentException {
	    Teacher teacher = (Teacher) session.getAttribute("teacher");
	    if (teacher == null) {
	        return;
	    }
	    
	    // 获取当前教师的所有成绩数据
	    List<Score> scores = teacherService.findTeacherByTid(teacher.getTeacherid());
	    
	    //日志输出
	    System.out.println("===== 导出数据检查 =====");
	    for (Score score : scores) {
	        System.out.println(
	            "学号:" + score.getStudentid() + 
	            ", 姓名:" + score.getStudentname() + 
	            ", 班级号:" + score.getClassid() + 
	            ", 课程号:" + score.getCourseid() + 
	            ", 课程名:" + score.getCoursename() + 
	            ", 成绩:" + score.getScore() + 
	            ", 状态:" + score.getRemark()
	        );
	    }
	    
	    if ("pdf".equalsIgnoreCase(format)) {
	        exportToPDF(response, scores);
	    }else if ("excel".equalsIgnoreCase(format)) {
	        exportToExcel(response, scores);
	    }
	}

	private void exportToPDF(HttpServletResponse response, List<Score> scores) throws DocumentException, IOException {
		// 设置系统中文字体(windows宋体)
		String fontPath="C:/Windows/Fonts/simsun.ttc,0";
	    BaseFont bfChinese = BaseFont.createFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
	    Font titleFont = new Font(bfChinese, 18, Font.BOLD);
	    Font headerFont = new Font(bfChinese, 12, Font.BOLD);
	    Font contentFont = new Font(bfChinese, 10);
		
		// 设置响应头
	    response.setContentType("application/pdf");
	    response.setHeader("Content-Disposition", "attachment; filename=scores.pdf");
	    
	    // 创建PDF文档
	    Document document = new Document(PageSize.A4.rotate()); // 横向页面以容纳更多列
	    PdfWriter.getInstance(document, response.getOutputStream());
	    document.open();
	    
	    // 添加标题
//	    Font titleFont = new Font(bfChinese, 18, Font.BOLD);
	    Paragraph title = new Paragraph("学生成绩表", titleFont);
	    title.setAlignment(Element.ALIGN_CENTER);
	    document.add(title);
	    
	    // 添加空行
	    document.add(new Paragraph(" "));
	    
	    // 添加表格
	    PdfPTable table = new PdfPTable(7); // 7列
	    table.setWidthPercentage(100);
	    table.setSpacingBefore(10f);
	    table.setSpacingAfter(10f);
	    
	    // 设置列宽
	    float[] columnWidths = {1.5f, 1.5f, 2f, 2f, 2f, 2f, 2f};
	    table.setWidths(columnWidths);
	    
	    // 表头
//	    Font headerFont = new Font(bfChinese, 12, Font.BOLD);
	    String[] headers = {"学号", "姓名", "班级号", "课程号", "课程名", "课程成绩", "成绩状态"};
	    for (String header : headers) {
	        PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
	        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
	        cell.setBackgroundColor(new BaseColor(211, 211, 211)); // 灰色背景
	        cell.setPadding(5);
	        table.addCell(cell);
	    }
	    
	    // 表格内容
//	    Font contentFont = new Font(bfChinese, 10);
	    for (Score score : scores) {
	        addCell(table, score.getStudentid(), contentFont);
	        addCell(table, score.getStudentname(), contentFont);
	        addCell(table, score.getClassid().toString(), contentFont);
	        addCell(table, score.getCourseid().toString(), contentFont);
	        addCell(table, score.getCoursename(), contentFont);
	        addCell(table, score.getScore() != null ? score.getScore().toString() : "", contentFont);
	        addCell(table, score.getRemark() != null ? score.getRemark() : "", contentFont);
	    }
	    
	    document.add(table);
	    document.close();
	}
	
	//Excel格式代码
	private void exportToExcel(HttpServletResponse response, List<Score> scores) throws IOException {
	    // 创建工作簿
	    Workbook workbook = new XSSFWorkbook();
	    Sheet sheet = workbook.createSheet("学生成绩表");
	    
	    // 创建标题行样式
	    org.apache.poi.ss.usermodel.Font headerFont = workbook.createFont();
	    headerFont.setBold(true);
	    headerFont.setFontName("宋体");

	    //创建单元格样式（用于表头）
	    CellStyle headerStyle = workbook.createCellStyle();
	    headerStyle.setFont(headerFont); // 绑定字体
	    headerStyle.setAlignment(HorizontalAlignment.CENTER);
	    
	    // 创建标题行
	    Row headerRow = sheet.createRow(0);
	    String[] headers = {"学号", "姓名", "班级号", "课程号", "课程名", "课程成绩", "成绩状态"};
	    for (int i = 0; i < headers.length; i++) {
	        Cell cell = headerRow.createCell(i);
	        cell.setCellValue(headers[i]);
	        cell.setCellStyle(headerStyle);
	    }
	    
	    // 填充数据
	    int rowNum = 1;
	    for (Score score : scores) {
	        Row row = sheet.createRow(rowNum++);
	        row.createCell(0).setCellValue(score.getStudentid());
	        row.createCell(1).setCellValue(score.getStudentname());
	        row.createCell(2).setCellValue(score.getClassid().toString());
	        row.createCell(3).setCellValue(score.getCourseid().toString());
	        row.createCell(4).setCellValue(score.getCoursename());
	        row.createCell(5).setCellValue(score.getScore() != null ? score.getScore().toString() : "");
	        row.createCell(6).setCellValue(score.getRemark() != null ? score.getRemark() : "");
	    }
	    
	    // 自动调整列宽
	    for (int i = 0; i < headers.length; i++) {
	        sheet.autoSizeColumn(i);
	    }
	    
	    // 设置响应头
	    response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	    response.setHeader("Content-Disposition", "attachment; filename=scores.xlsx");
	    
	    // 写入输出流
	    workbook.write(response.getOutputStream());
	    workbook.close();
	}

	private void addCell(PdfPTable table, String text, Font font) {
	    PdfPCell cell = new PdfPCell(new Phrase(text, font));
	    cell.setPadding(5);
	    cell.setHorizontalAlignment(Element.ALIGN_CENTER);
	    table.addCell(cell);
	}
	
}
