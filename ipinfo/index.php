<!doctype html>
<html class="no-js" lang="zh" dir="ltr">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IT小圈IP接口文档</title>
    <link rel="stylesheet" href="css/foundation.css">
    <link rel="stylesheet" href="css/app.css">
    <link rel="stylesheet" type="text/css" href="css/docco.min.css"/>
    <script src="js/highlight.min.js"></script>
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.3/jquery.js"></script>
  </head>
  <body>
    <script>
      function  useradd(a,b,c){
        var user_json_data = {"uemail":a,"web_url":b,"utype":c}
        $.ajax({
          type: "post",
          url: "./useradd.php",
          dataType: "json",
          data: JSON.stringify(user_json_data),
          success: function (data){
            var json_data = JSON.parse(JSON.stringify(data));
            alert(json_data.Datatime+'\n'+json_data.Msg);
          }
        });
      }
    </script>
    <div class="grid-container">
      <div class="grid-x grid-padding-x">
        <div class="large-12 cell">
          <h1>IT小圈IP接口说明</h1>
        </div>
      </div>

      <div class="grid-x grid-padding-x">
        <div class="large-12 cell">
          <div class="callout">
            <b>您当前的IP信息</b><br>
            <?php
              function getip() {
                $unknown = 'unknown';
                if (isset($_SERVER['HTTP_X_FORWARDED_FOR']) && $_SERVER['HTTP_X_FORWARDED_FOR'] && strcasecmp($_SERVER['HTTP_X_FORWARDED_FOR'], $unknown)) {
                  $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
                }
                elseif(isset($_SERVER['REMOTE_ADDR']) && $_SERVER['REMOTE_ADDR'] && strcasecmp($_SERVER['REMOTE_ADDR'], $unknown)) {
                  $ip = $_SERVER['REMOTE_ADDR'];
                }
            
                /*
                处理多层代理的情况
                或者使用正则方式：$ip = preg_match("/[\d\.]{7,15}/", $ip, $matches) ? $matches[0] : $unknown;
                */
                if (false !== strpos($ip, ',')) $ip = reset(explode(',', $ip));
                  return $ip;
              }
              $uip = getip();
              $dtime = date('Y-m-d H:i:s');
              $ukey = '655937c56f1aef933f01d3afdf7d15e4b810c718caad9009ad39cc546d25c836';
              $md5_str = md5($dtime.$ukey);
              $json_data = '{"dtime":"'.$dtime.'","ukey":"'.$ukey.'","ip":"'.$uip.'","md5":"'.$md5_str.'"}';
              $return_json = exec("bash scripts/main_check.sh '$json_data'");
              $new_json_data = json_decode($return_json);
	      if ($new_json_data->Code === 'Bad'){
	        header('HTTP/1.1 404 Not Found');
                header("status: 404 Not Found");
		echo json_encode($new_json_data,JSON_UNESCAPED_UNICODE);
		exit();
	      }
              echo '<b>IP  地址：<font color="blue">'.$new_json_data->ip.'</font></b><br>';
              if (empty($new_json_data->isp) || $new_json_data->isp == '0'){
                echo '<b>IP服务商：<font color="blue">未知</font></b><br>';
              } else {
                echo '<b>IP服务商：<font color="blue">'.$new_json_data->isp.'</font></b><br>';
              }
              echo '<b>IP  属地：<font color="blue">'.$new_json_data->ip_location.'</font></b><br>';
              if ($new_json_data->iptype == 'IPv4'){
                echo '<b>经纬信息：<font color="blue">'.$new_json_data->lat.'</font></b><br>';
              } else {
                echo '<b>经纬信息：<font color="red">IPv6 暂时不支持</font></b><br>';
              }
              echo '<b>备注：IP信息由 <font color="blue">'.$new_json_data->data_src.'</font> 提供</b>';
	      if ( ! empty($new_json_data->jzstr) ){ 
	        echo '<hr /><font color="blue"><marquee scrollamount="10">'.$new_json_data->jzstr.'</marquee></font>';
	      }
            ?>
          </div>
        </div>
      </div>
      <div class="grid-x grid-padding-x">
        <div class="large-12 cell">
          <div class="callout">
            <b>注意事项及说明</b><br>
            <ul>
              <li>接口仅支持用于测试和个人非经营性网站注册使用</li>
              <li>注册申请网站不得有违规相关法律法规且必须是https站点</li>
              <li>最终解释权归“IT小圈”所有，如发现违规使用小圈有权直接停用对应账户且无需进行告知</li>
              <li>IP信息为客户端互联网出口IP位置（有线或无线），经纬度信息仅大致位置</li>
              <li>IP 原始信息由高德等第三方接口提供</li>
            </ul>
          </div>
        </div>
      </div>
      <div class="grid-x grid-padding-x">
        <div class="large-12 cell">
          <div class="callout">
            <b>注册申请</b><br>
            <input type="email" class="input-group-field" id="uemail" name="uemail" required placeholder="请输入您的邮箱地址" />
            <input type="url" class="input-group-field" id="web_url" name="web_url" required placeholder="请输入您的网站地址" />
            <select id="utype" name="utype" >
              <option value="0">选择账户类型</option>
              <option value="1">测试</option>
              <option value="2">付费未开放</option>
            </select>
            <button class="button" onclick="useradd(uemail.value,web_url.value,utype.value)">申请注册</button>
            <hr />
            <div>
	      <b>联系交流</b><br>
              <div style="width: 210;height: 210;text-align:center;display: inline-block"><img src="imgs/qq.png" alt="QQ群" width="200" height="200" /><br>👆QQ沟通群👆<b></b></div>
              <div style="width: 210;height: 210;text-align:center;margin-left: 5%;display: inline-block"><img src="imgs/wx.png" alt="微信" width="200" height="200" /><br>👆微信联系👆<b></b></div>
            </div>
          </div>
        </div>
      </div>
      <div class="grid-x grid-padding-x">
        <div class="large-12 cell">
          <div class="callout">
            <b>Json 说明</b><br>
            <ul>
              <li>dtime：请求时间，格式 "yyyy-mm-dd hh:mm:ss"</li>
              <li>ukey：用户key，需申请</li>
              <li>ip：需要查询的IP地址，支持 IPv4/IPv6</li>
              <li>md5：dtime和ukey拼接后计算的MD5值（中间无拼接符）</li>
              <li>api url：<font color="blue">https://ip.iquan.fun/getip.php</font> </li>
              <li>请求 json</li>
                <pre><code class="language-json hljs">
                  {
                    "dtime": "2023-01-30 01:15:33",
                    "ukey": "643b4682ddc002b6aec7d178084bbad79bb5093b5b80246af3d43aacd4a57187",
                    "ip": "240e:34c:80:9340:2071:489f:f73c:1d0c",
                    "md5": "05f3dc8a944412ff7d5d692d35924548"
                  }
                </code></pre>
              <li>返回 json</li>
              <pre>
                <code class="language-json hljs">
                  返回参数说明
                  Code: 状态   Good / Bad
                  iptype：ip版本 "IPv4 / IPv6"
                  ip：查询的IP地址
                  isp：运营商相关
                  ip_location：ip地理位置
                  lat：经纬度信息
                  data_src：IP信息来源
                  jzstr：随机鸡汤语句
                  Datatime：数据返回时间
                  
                  IPv4 
                  {
                    "Code": "Good",
                    "iptype": "IPv4",
                    "ip": "42.243.58.129",
                    "isp": "电信",
                    "ip_location": "中国云南省昆明市五华区",
                    "lat": "102.712251,25.040609",
                    "data_src": "IT小圈API",
                    "jzstr": "星光不问赶路人,时光不负有心人", 
                    "Datatime": "2023-02-02 20:24:22"
                  }

                  IPv6
                  {
                    "Code": "Good",
                    "iptype": "IPv6",
                    "ip": "2409:8924:5266:116b:45f:8f2d:a32b:d92c",
                    "isp": "中国移动无线基站网络",
                    "ip_location": "中国江苏省苏州市常熟市",
                    "data_src": "IT小圈API",
                    "jzstr": "蓦然回首,几个春秋;凉风依旧,岁月不休",
                    "Datatime": "2023-02-08 02:33:17"
                  }
                </code>
              </pre>
            </ul>
          </div>
        </div>
      </div>
      <div class="grid-x grid-padding-x">
        <div class="large-12 cell">
          <div class="callout">
            <b>请求示例</b><br>
	          <ul>
              <li><font color="red">方法不唯一</font></li>
	            <li>JavaScript</li>
              <pre>
                <code class="language-shell hljs">
                  // 需要引用 jQuery ： https://jian.deyun.fun/js/jquery-3.5.1.js
		              // 计算md5，需要引用 md5 库： https://cdn.bootcss.com/blueimp-md5/2.10.0/js/md5.js
                  var dtime1 = '2023-02-02 15:01:54';
                  var ukey1 = '643b4682ddc002b6aec7d178084bbad79bb5093b5b80246af3d43aacd4a57187';
		              var ip1 = '42.243.58.129';
                  // md5(dtime1+ukey1) ==> aef974392fc21c03c25dd3e26c093536
                  var md5s = 'aef974392fc21c03c25dd3e26c093536';
                  var json_data = {"dtime":dtime1,"ukey":ukey1,"ip":ip1,"md5":md5s};
                  $.ajax({
                    type: "post",
                    url: "https://ip.iquan.fun/getip.php",
                    dataType: "json",
                    data: JSON.stringify(json_data),
		                success: function (data){
                       // 您处理返回 json 的代码
                       document.write(JSON.stringify(data));
                      }
                  });
                </code>
              </pre>
              <li>Bash</li>
              <pre>
                <code class="language-shell hljs">
                  curl -s -H "Content-Type: application/json;charset=UTF-8" -X POST -d '{"dtime": "2023-01-30 01:15:33","ukey": "643b4682ddc002b6aec7d178084bbad79bb5093b5b80246af3d43aacd4a57187","ip": "240e:34c:80:9340:2071:489f:f73c:1d0c","md5": "05f3dc8a944412ff7d5d692d35924548"}' https://ip.iquan.fun/getip.php
                </code>
              </pre>
              <li>PHP</li>
              <pre>
                <code class="language-php hljs">
                  $url = "https://ip.iquan.fun/getip.php";
                  $json_data = '{"dtime": "2023-01-30 01:15:33","ukey": "643b4682ddc002b6aec7d178084bbad79bb5093b5b80246af3d43aacd4a57187","ip": "240e:34c:80:9340:2071:489f:f73c:1d0c","md5": "05f3dc8a944412ff7d5d692d35924548"}';
                  $curl = curl_init($url);
                  curl_setopt($curl, CURLOPT_HEADER, false);
                  curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
                  curl_setopt($curl, CURLOPT_HTTPHEADER, array("Content-type: application/json"));
                  curl_setopt($curl, CURLOPT_POST, true);
                  curl_setopt($curl, CURLOPT_POSTFIELDS, $json_data);
                  $result = curl_exec($curl);
                  curl_close($curl);
                </code>
              </pre>
            </ul>
          </div>
        </div>
      </div>
      <div class="grid-x grid-padding-x">
        <div class="large-12 cell">
          <div class="callout">
            <b>友情链接</b>
            <div style="text-align:center">
            <a style="margin-right: 2rem" target="_blank" href="https://iquan.fun">IT小圈</a>
            <a style="margin-right: 2rem" target="_blank" href="https://deyun.fun">流年小站</a>
          </div>
          </div>
        </div>
      </div>
    </div>


    <script src="js/vendor/jquery.js"></script>
    <script src="js/vendor/what-input.js"></script>
    <script src="js/vendor/foundation.js"></script>
    <script src="js/app.js"></script>
    <script>
      hljs.initHighlightingOnLoad();
     </script>     
  </body>
</html>
