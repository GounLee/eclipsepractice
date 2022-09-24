<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
.uploadResult {
	width: 100%;
	background-color: gray;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
}

.uploadResult ul li img {
	width: 100px;
}
</style>
<script type="text/javascript"
		src="https://code.jquery.com/jquery-3.6.1.js"></script>
</head>
<body>

<h1>Upload with Ajax</h1>

	<div class='uploadDiv'>
		<input type='file' name='uploadFile' multiple>
	</div>
	<div class='uploadResult'>
		<ul>
		</ul>
	</div>
	<button id='uploadBtn'>Upload</button>

	
	<script>
		$(document).ready(function() {
			let regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$")
			let maxSize = 5242880;

			function checkExtension(fileName, fileSize) {
				if (fileSize >= maxSize) {
					alert("파일 크기 초과");
					return false;
				}
				if (regex.test(fileName)) {
					/* 정규식에 적합하지 않을경우 */
					alert("해당 종류의 파일은 업로드 할 수 없음");
					return false;
				}
				return true;
			}

			var cloneObj = $(".uploadDiv").clone();
		}

							$("#uploadBtn")
									.on(
											'click',
											function() {
												let formData = new FormData();
												/* 가상의 form */
												let inputFile = $("input[name='uploadFile']");
												let files = inputFile[0].files;

												/* 파일 업로드에 대한 정규식으로 제한 */

												for (let i = 0; i < files.length; i++) {
													// 크기나 형식을 정해둔 checkExtension에 부합하지 않을경우
													if (!checkExtension(
															files[i].name,
															files[i].size)) {
														return false;
													}

													formData.append(
															"uploadFile",
															files[i]);
												}

												$.ajax({
															url : "/uploadAjaxAction",
															processData : false,
															contentType : false,
															data : formData,
															type : "POST",
															dataType : 'json',
															success : function(
																	result) {
																console
																		.log(result);
																showUploadedFile(result);
																$(".uploadDiv")
																		.html(
																				cloneObj
																						.html());
															}
														})
											})

							 var uploadResult = $(".uploadResult ul");

								function showUploadedFile(uploadResultArr) {

								 var str = "";

								 $(uploadResultArr).each(function(i, obj) {

								 str += "<li>" + obj.fileName + "</li>";

								 });

								 uploadResult.append(str);
								 }

							function showUploadedFile(uploadResultArr) {

								var str = "";

								$(uploadResultArr)
										.each(
												function(i, obj) {

													if (!obj.fileType) {
														str += "<li><img src='/resources/img/attach.png'>"
																+ obj.fileName
																+ "</li>";
													} else {
														//								str += "<li>" + obj.fileName + "</li>";
														var fileCallPath = encodeURIComponent(obj.uploadPath
																+ "/s_"
																+ obj.uuid
																+ "_"
																+ obj.fileName);

														str += "<li><img src='/display?fileName="
																+ fileCallPath
																+ "'><li>";
													}
												});

								uploadResult.append(str);
							}

						})
	</script>

</body>
</html>