<!DOCTYPE html>
<html lang="en">
<%@page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<head>
<script type="text/javascript"
src="https://code.jquery.com/jquery-3.6.1.js">
</script>
<script type="text/javascript" src="/resources/js/reply.js"></script>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>SB Admin 2 - Bootstrap Admin Theme</title>

    <!-- Bootstrap Core CSS -->
    <link href="/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- MetisMenu CSS -->
    <link href="/resources/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

    <!-- DataTables CSS -->
    <link href="/resources/vendor/datatables-plugins/dataTables.bootstrap.css" rel="stylesheet">

    <!-- DataTables Responsive CSS -->
    <link href="/resources/vendor/datatables-responsive/dataTables.responsive.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="/resources/dist/css/sb-admin-2.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="/resources/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body>
<script>
$(document).ready(function(){
      console.log("=============");
      console.log("JS TEST");
      var bnoValue = '<c:out value="${board.bno}"/>';
      /*{reply:"JS TEST", replyer:"tester",bno:bnoValue}
      ,
      function(result){
         alert("RESULT : " + result);
      });*/
      //for replyService add test
      /*replyService.add(
            {reply:"JS TEST", replyer:"tester",bno:bnoValue}
            ,
            function(result){
               alert("RESULT : " + result);
            });*/
      /*replyService.getList({bno:bnoValue, page:1}, function(list){
         for(var i=0, len=list.length||0; i<len;i++){
            console.log(list[i]);
         }
      });*/
      
      /*replyService.remove(30, function(count) {
           console.log(count);
           
           if(count === "success") {
              alert("REMOVED");
           }
        }, function(err) {
           alert("ERROR");
        });*/
      
      /*replyService.update({
         rno : 11, bno : bnoValue, reply : " 수정된 댓글"
      }, function(result) {
         alert("수정 완료...!!!");
      });
        
       replyService.get(11, function(data) {
          console.log(data);
      })*/
      
      var replyUL = $(".chat");
       showList(1);
       function showList(page) {
          replyService.getList(
                {bno:bnoValue, page:page||1}
                ,function(list){
                   var str="";
                   if(list == null || list.length == 0){
                      replyUL.html("");
                      return;
                   }
                for(var i =0, len=list.length ||0; i<len; i++){
                   str +="<li class = 'left clearfix' data-rno='"+list[i].rno+"'>";
                   str +="<div><div class='header'><strong class='primary-font'>"
                   +list[i].replyer+"</strong>";
                   str +="<small class='pull-right text-musted'>"+replyService.displayTime(list[i].replyDate)+"</small><div>";
                   str +="<p>"+list[i].reply+"</p><div></li>";
                }
                replyUL.html(str);
       }); //function call 
      } //showList
      console.log(replyService);
      var operForm = $("#operForm");
      $("button[data-oper='modify']").on("click",function(e){
         operForm.attr("action","/board/modify").submit();
      });
      
      $("button[data-oper='list']").on("click",function(e){
         
         operForm.find("#bno").remove();
         operForm.attr("action","/board/list")
         operForm.submit();
      });
      
      var modal = $(".modal");
      var modalInputReply = modal.find("input[name='reply']");
      var modalInputReplyer = modal.find("input[name='replyer']");
      var modalInputReplyDate = modal.find("input[name='replyDate']");
      
      var modalModBtn = $("#modalModBtn");
      var modalRemoveBtn = $("#modalRemoveBtn");
      var modalRegisterBtn = $("#modalRegisterBtn");
      
      $('#addReplyBtn').on("click", function(e) {
         modal.find("input").val("");
         modalInputReplyDate.closest("div").hide();
         modal.find("button[id!='modalCloseBtn']").hide();
         modalRegisterBtn.show();
         $(".modal").modal("show");
   })
   
   $(".chat").on("click", "li", function(e){
      
      var rno = $(this).data("rno");
      replyService.get(rno, function(reply){
          
          modalInputReply.val(reply.reply);
          modalInputReplyer.val(reply.replyer).attr("readonly","readonly");
          modalInputReplyDate.val(replyService.displayTime( reply.replyDate))
          .attr("readonly","readonly");
          modal.data("rno", reply.rno);
          
          modal.find("button[id!='modalCloseBtn']").hide();
          modalModBtn.show();
          modalRemoveBtn.show();
          
          $(".modal").modal("show");
              
        });
      });
      
      modalModBtn.on("click", function(e){
    	  
       	  var reply = {rno:modal.data("rno"), reply: modalInputReply.val()};
       	  
       	  replyService.update(reply, function(result){
       	        
       	    alert(result);
       	    modal.modal("hide");
       	    showList(1);
       	    
       	  });
       	  
       	}); //update end


       	modalRemoveBtn.on("click", function (e){
       		
       		alert('aaaa');
       	  
       	  var rno = modal.data("rno");
       	  
       	  replyService.remove(rno, function(result){
       	        
       	      alert(result);
       	      modal.modal("hide");
       	      showList(1);
       	      
       	  });
       	  
       	}); //remove end
       	

   /* 댓글이 정상적으로 추가되면 알림창을 통해 성공했다는 사실을 알려주고, 입력 항목을 비우고 모달창을 닫아줌 */
      modalRegisterBtn.on('click', function(e){
         var reply = {
            reply: modalInputReply.val(),
            replyer: modalInputReplyer.val(),
            bno:bnoValue
         };
         replyService.add(reply, function(result) {
            alert(result);//댓글 등록이 정상임을 팝업으로 알림
            modal.find("input").val("");//댓글 등록이 정상적으로 이뤄지면, 내용을 지움
            modal.modal("hide");//모달창 닫음
            showList(1);
         })
      })

});

</script>
<jsp:include page="../includes/header.jsp"></jsp:include>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board register</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            게시글 조회
                            <!-- 조회는 get방식 -->
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                               <div class="form-group">
                                  <label>Bno</label>
                                  <input class="form-control" name="bno" value='<c:out value="${board.bno}"/>' readonly="readonly"/>
                               </div>
                               <div class="form-group">
                                  <label>Title</label>
                                  <input class="form-control" name="title" value='<c:out value="${board.title}"/>'/>
                               </div>
                               <div class="form-group">
                                  <label>Content</label>
                                  <textarea class="form-control" rows="3" name="content"><c:out value="${board.content}"/></textarea>
                               </div>
                               <div class="form-group">
                                  <label>Writer</label>
                                  <input class="form-control" name="writer" value='<c:out value="${board.writer}"/>'>
                               </div>
                               <button data-oper="modify" class="btn btn-default">Modify</button>
                               <button data-oper="list" class="btn btn-default">list</button>
                               <form id="operForm" action="/board/modify" method="get">
                                  <input type="hidden" id="bno" name="bno" value='<c:out value="${board.bno}"/>'/>
                               </form>
                        </div>
                        <!-- end panel-body -->
                    </div>
                    <!-- end panel-body -->
                </div>
                <!-- end panel -->
           </div>
        <!-- /.row -->
        <div class="row">
           <div class="col-lg-12">
           <!-- /.panel -->
              <div class="panel panel-default">
                 <!-- <div class="panel-heading">
                    <i class="fa fa-comments fa-fw"></i> Reply
                 </div> -->
                 <!-- chat 영역에 댓글 list를 추가하는 방식으로 할 것임 -->
                 <!-- /.panel-heading -->
                 <div class="panel-heading">
                    <i class="fa fa-comments fa-fw"></i> Reply
                    <button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">New Reply</button>
                 </div>
                 <div class="panel-body">
                    <ul class="chat">
                       <!-- start reply -->
                       <li class="left clearfix" data-rno="12">
                          <div>
                             <div class="header">
                                <strong class="primary-font">user00</strong>
                                <small class="pull-right text-muted">2018-01-01 13:13 </small>
                             </div>
                             <p>Good job!</p>
                          </div>
                       </li>   
                       <!-- end reply -->
                    </ul>
                    <!-- /. end ul -->
                 </div>
                 <!-- /.panel .chat-panel -->
              </div>
           </div>
           <!-- ./end row -->
        </div>
        
        <!-- modal(new reply시 보일 화면 구성) -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog"
    aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
    <div class="modal-content">
    <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal"
    aria-hidden="true">&times;</button>
    <h4 class="modal-title" id="myModalLabel">REPLY Modal</h4>
    </div>
    <div class="modal-body">
       <div class="form-group">
          <label>Reply</label>
          <input class="form-control" name='reply' value='New Reply!!!!'>
       </div>
       <div class="form-group">
          <label>Replyer</label>
          <input class="form-control" name='replyer' value='replyer'>
       </div>
       <div class="form-group">
          <label>Reply Date</label>
          <input class="form-control" name='replyDate' value=''>
       </div>
    </div>
    <div class="modal-footer">
    <button type="button" class="btn btn-warning" id="modalModBtn">Modify</button>
    <button type="button" class="btn btn-danger" id="modalRemoveBtn">Remove</button>
    <button type="button" class="btn btn-primary" id="modalRegisterBtn">Register</button>
    <button type="button" class="btn btn-default" data-dismiss="modal" id="modalCloseBtn">Close</button>
    </div>    
    </div>
    <!--  /.modal-content -->
    </div>
    <!--  /.modal-dialog -->
    </div>
    <!--  /.modal -->
<jsp:include page="../includes/footer.jsp"></jsp:include>
</body>

</html>
