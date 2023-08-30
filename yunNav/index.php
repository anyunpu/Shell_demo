<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title id="title"></title>
    <meta name="keywords" content="网页导航,安静的导航,极男专用">
    <meta name="description" content="云的导航，源于一个导航">
    <link rel="stylesheet icon" href="img/icon.ico" />
    <link rel="stylesheet" type="text/css" href="bootstrap/bootstrap.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <script type="text/javascript" src="js/jQuery.js"></script>
    <script type="text/javascript" src="bootstrap/bootstrap.min.js"></script>
    <script type="text/javascript" src="js/fish.js"></script>
    <script type="text/javascript" src="js/browser.js"></script>
    <link rel="stylesheet" href="css/slideout.css">
    <script>
      var now = new Date().getTime();
      document.write('<link href="css/style.css?v=' + now + '" rel="stylesheet" type="text/css"/>');
    </script>
  </head>
  <body>
    <div id="jsi-flying-fish-container" style="position: fixed;bottom: 0px;;z-index: 999;width:100%;height:50px;display:block;"></div>
    <script>
      var info = new Browser();
      window.onload = $(document).ready(function () { // IP解析
            $.post("./ipinfo.php", {
              // ip: returnCitySN['cip'],
              dev: info.device,
              os: info.os+" "+info.osVersion,
              bro: info.browser+" "+info.version,
            },
            function (data) { // 客户端信息打印出来
              var json_data = JSON.parse(data);
              $('#wecome').text("～Hi 来自 "+json_data.ip_location+json_data.isp);
              $('#jz').text(json_data.jzstr);
              $('#cinfo').text(info.os+" "+info.osVersion+" "+info.browser+" "+info.version+" "+info.language);
              if ( json_data.lat !== null && json_data.lat  !== undefined && json_data.lat !== '' ){
                $('#lat').text(json_data.lat);
              } else {
                $('#lat').text('0.00000,0.00000');
              }
              $("#info0").css('display','block');
            });
        });
        setTimeout (function(){
          $("#info0").css('display','none');
        },5000);
    </script>
    <div id="info0" style="display: none;text-align: center;width: 400px;height: 260px;border-radius: 10px;position: fixed;z-index: 9999;background-color: rgba(0,0,0,0.6);top: 0;bottom: 0;left: 0;right: 0;margin: auto;color: white;">
      <p id="wecome" style="margin-top: 10px" ></p>
      <p id="jz" style="color: yellow;"></p>
      <p id="cinfo"></p>
      <p id="dte" style="text-align: right;margin-right:1em"></p>
    </div>
    <nav id="menu" class="menu">
      <?php
        // 读取菜单文件  
        $main_line = file("list/main.list");
          if ($main_line){
            $nav_count = 0;
            foreach($main_line as $line){
              $count += 1;
              $nav_arr = explode(":",$line);
              echo '<blockquote class="blockquote">▎ '.$nav_arr[0].'</blockquote><ul>';
              // 读取 URL list 文件
              $url_line = file("list/".str_replace(array("\r\n","\r","\n"," ","\t"),'',$nav_arr[1]));
              if ($url_line){
                $url_count = 0;
                foreach($url_line as $v){
                  $url_count += 1;
                  $url_arr = explode(",",$v);
                  if ($url_arr[3] == '0'){
                    echo '<a target="_blank" href="'.$url_arr[2].'"><li class="sidenav-btn">'.$url_arr[0].'<p>'.$url_arr[1].'</p></li></a>';
                  }
                }
              }
              echo '</ul>';
            }
          }
      ?>
      <blockquote class="blockquote">▎ 设置</blockquote>
        <ul>
          <a href="#">
            <li class="sidenav-btn" id="night">夜间模式</li>
          </a>
          <a href="#">
            <li class="sidenav-btn" id="bg">隐藏/显示壁纸</li>
          </a>
      </ul>
      <p style="width:100%;text-align:center;margin:0 auto;font-size:14px;color:lightgray;">2019-2023 © <a style="color: lightgray;" href="https://deyun.fun">anYun</a><br>ALL RIGHTS RESERVED.</p>
    </nav>
    <!-- 主页面 -->
    <main id="main" class="panel">
      <!-- 天气 -->
      <div id="tp-weather-widget"></div>
      <!-- 主容器 -->
      <div class="container">
        <!-- 侧边栏按钮 -->
        <img class="slidebtn btn-hamburger js-slideout-toggle" src="img/menu.svg" />
        <!-- 搜索盒子 -->
        <div class="search-box">
          <!-- logo -->
          <div id="logo">
            <div id="state">
              <a href="folder://"><img id="img" src="img/bing.png" /></a>
            </div>
          </div>
          <!-- 搜索框 -->
          <div class="inputDiv">
            <form id="form" action="https://cn.bing.com/search" target="_blank" onsubmit="return check()">
              <input onmouseover="this.focus()" onfocus="this.select()" id="inputText" type="text" placeholder="Bing搜索..." name="q" size="30" />
              <button id="submitButton" class="submitButton" type="submit"></button>
            </form>
            <!-- 搜索提示词 -->
            <div id="searchlist">
              <ul id="list"></ul>
            </div>
          </div>

          <!-- 书签、引擎选择器 -->
          <div id="Select" class="Select" onclick="select()">
            <hr>书签
            <img src="img/search-change.svg?v=2ae7ab8" />
          </div>
          <!-- 书签 -->
          <div id="folder" class="folder">
            <ul></ul>
          </div>

          <!-- 导航引擎 -->
          <div id="nav" class="nav">
            <ul></ul>
          </div>
        </div>
    </main>
    <script type="text/javascript" src="js/slideout.min.js"></script>
    <script type="text/javascript">
      var slideout = new Slideout({
        'panel': document.getElementById('main'),
        'menu': document.getElementById('menu'),
        'padding': 290,
        'tolerance': 70
      });
      document.querySelector('.js-slideout-toggle').addEventListener('click',
        function() {
          slideout.toggle();
        });
      document.querySelector('.menu').addEventListener('click',
        function(eve) {
          if (eve.target.nodeName === 'A') {
            slideout.close();
          }
        });
      $(document).click(function(e) {
        var Class = $(e.target).attr("class");
        var Id = $(e.target).attr("id");
        if (Class == 'panel slideout-panel slideout-panel-left' || Class == 'folder-item col-xs-3 col-sm-2' || Class == 'search-box' || Id == 'inputText' || Id == 'logo') {
          slideout.close();
        }
      });
    </script>
  </body>
  <script type="text/javascript">
    document.write('<script src="js/main.js?v=' + now + '"><\/script\>');
  </script>
</html>
