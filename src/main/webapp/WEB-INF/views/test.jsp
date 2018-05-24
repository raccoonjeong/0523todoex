<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <style>
        .listDiv li{
            list-style: none;
        }

        a {
            color: #000;
        }

        .mask {
            width: 100%;
            height: 100%;
            position: fixed;
            left: 0;
            top: 0;
            z-index: 10;
            background: #000;
            opacity: .5;
            filter: alpha(opacity=50);
        }

        #modalLayer {
            display: none;
            position: relative;
        }

        #modalLayer .modalContent {
            width: 440px;
            height: 200px;
            padding: 20px;
            border: 1px solid #ccc;
            position: fixed;
            left: 50%;
            top: 50%;
            z-index: 11;
            background: #fff;
        }

        #modalLayer .modalContent .closebtn {
            position: absolute;
            right: 0;
            top: 0;
            cursor: pointer;
        }

    </style>
</head>
<body>

<div class="wrapper">
    <div class="inputDiv">
        <div><input type="text" name="content"/></div>
        <div>
            <button class="btn" data-type="register">Register</button>
        </div>
    </div>

    <div class="listDiv">
        <ul class="todoList">

        </ul>
    </div>
</div>
<!--
<a href="#modalLayer" class="modalLink">간단한 모달 창 만들기</a>-->
<div id="modalLayer">
    <div class="mask"></div>
    <div class="modalContent">
        <p></p>
        <button type="button" class="closebtn">닫기</button>
        <label>수정</label>
        <input type="text" name="modifycontent"/>
        <button class="mbtn">수정</button>
    </div>

</div>


<script src="https://code.jquery.com/jquery-3.3.1.min.js"
        integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
        crossorigin="anonymous"></script>

<script>

    /*Ajax부분*/
    $(document).ready(function () {
        var listUL = $(".listDiv");
        var inputContent = $("input[name='content']")
        var inputModify = $("input[name='modifycontent']")
        var btn = $(".btn");
        var mbtn = $(".mbtn")

        function loadList(page) {
            var page = page || 1;

            $.getJSON("http://localhost:8080/todo/list/" + page + ".json", function (data) {
                console.log(".................")
                console.log(data);

                var str = "";

                $(data).each(function (idx, data) {
                    str += "<li data-tno='" + data.tno + "'><div class='todo'>" +
                        "<div>" + data.tno + "번 글 :  " + data.content + "   날짜 : " + data.regdate +
                        "<button class='remove'> x </button></div>" +
                        "</div></li>";
                });
                listUL.html(str);
            });
        };
        function saveTodo(){
            var data = {
            content: inputContent.val()};

            $.ajax({
                type:'post',
                url:"http://localhost:8080/todo/new",
                headers:{
                    "Content-type": "application/json"
                },
                dataType:"text",
                data:JSON.stringify(data),
                success:function (result) {
                    console.log("reault: " + result);
                    loadList(1);
                }
            });
        }

        function readTodo(tno) {
            $.getJSON("http://localhost:8080/todo/"+tno+".json", function (data) {
                inputModify.val(data.title);

               /* btn.attr("data-type","modify");*/
                mbtn.attr("data-tno", tno);
            });
        }

        function modifyTodo(){
            var tno = mbtn.attr("data-tno");
            var data = {content: inputModify.val()};

            $.ajax({
                type:'put',
                url:"http://localhost:8080/todo/"+tno,
                headers:{

                    "Content-type": "application/json"
                },
                dataType:"text",
                data:JSON.stringify(data),
                success:function (result) {
                    console.log("result:" + result);
                    loadList(1);
                }
            });
        }
        function deleteTodo(tno){
            $.ajax({
                type:'delete',
                url:"http://localhost:8080/todo/"+tno,
                headers:{
                    "Content-type": "application/json"
                },
                dataType:"text",
                success:function (result) {
                    console.log("result: "+result);
                    loadList(1);
                }
            });
        }




        var modalLayer = $("#modalLayer");
        var modalLink = $(".modalLink");
        var modalCont = $(".modalContent");
        var marginLeft = modalCont.outerWidth() / 2;
        var marginTop = modalCont.outerHeight() / 2;

        $(".btn").on("click", function (e) {
           var type = $('.btn').attr("data-type");
           if(type === 'register'){
               saveTodo();

           }
        });

        $(".listDiv").on("click", "li", function (e) {
            var tno = $(this).attr("data-tno");
            console.dir(this);
            readTodo(tno);

            modalLayer.fadeIn("slow");
            modalCont.css({"margin-top": -marginTop, "margin-left": -marginLeft});
            $(this).blur();
            $(".modalContent > a").focus();

            $(".modalContent p").html($(this).text())


            $(".mbtn").on("click", function (e) {
                modifyTodo();
                modalLayer.fadeOut("slow");

            });
            return false;


        });

        $(".modalContent > .closebtn").click(function () {
            modalLayer.fadeOut("slow");

        });





        $(".listDiv").on("click",".remove", function(e){
            e.stopPropagation();
            e.preventDefault();

            var tno = $(this).closest("li").attr("data-tno");
            if(confirm("remove: " + tno)){
                deleteTodo(tno);
            }
        });

        loadList();

    });

        /*모달창 JS*/
        $(document).ready(function () {
            var modalLayer = $("#modalLayer");

            var modalCont = $(".modalContent");
            var marginLeft = modalCont.outerWidth() / 2;
            var marginTop = modalCont.outerHeight() / 2;

       /*     modalLink.click(function () {
                modalLayer.fadeIn("slow");
                modalCont.css({"margin-top": -marginTop, "margin-left": -marginLeft});
                $(this).blur();
                $(".modalContent > a").focus();
                return false;
            });

            $(".modalContent > button").click(function () {
                modalLayer.fadeOut("slow");
                modalLink.focus();
            });*/
        });


</script>


</body>
</html>
