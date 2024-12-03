<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 등록</title>
	<script type="text/javascript">
		function checkFun(){
			var f = document.registerForm;
			
			var sno=f.sno.value;
			var regExpSno = /^\d{8}$/;
			
			var password = f.password.value;
			var regExpPassword= /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

			
			var name=f.name.value;
			var regExpName=/^[가-힣]+$/;
			
			var major=f.major.value;
			var regExpMajor=/^[가-힣]+$/;
			
			var email=f.email.value;
			var regExpEmail= /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
		
			if(!regExpSno.test(sno)){
				alert("학번은 8자리 숫자만 허용됩니다.");
				f.sno.focus();
				return false;
			}
			if(!regExpPassword.test(password)){
				alert("비밀번호는 영어, 숫자, 특수문자를 포함한 8자리 이상의 조합만 허용됩니다.");
				f.password.focus();
				return false;
				
			}
			if(!regExpName.test(name)){
				alert("이름은 한글로만 입력해주세요");
				f.name.focus();
				return false;
			}
			if(!regExpMajor.test(major)){
				alert("학과는 한글로만 입력해주세요");
				f.major.focus();
				return false;
			}
			if(!regExpEmail.test(email)){
				alert("이메일 형식을 지켜주세요.");
				f.email.focus();
				return false;
			}
			else return true;
		
		
		}
	
	</script>
    <link rel="stylesheet" href="styles/register.css">
</head>
<body>
    <h1>회원 가입</h1>

    <form name="registerForm" action="registerProcess.jsp" method="post" onsubmit="return checkFun()">
        <label for="sno">학번 :</label>
        <input type="number" id="sno" name="sno" required>
		<br><br>
        <label for="password">비밀번호 :</label>
        <input type="password" id="password" name="password" required>
		<br><br>
        <label for="name">이름 :</label>
        <input type="text" id="name" name="name" required>
        <br><br>
        <label for="major">학과 :</label>
        <input type="text" id="major" name="major" required>
        <br><br>
        <label for="email">이메일 :</label>
        <input type="text" id="email" name="email" required>
		<br><br>
        <button type="submit">등록</button>
    </form>

    <p><a href="main.jsp">메인 페이지로 돌아가기</a></p>
</body>
</html>
