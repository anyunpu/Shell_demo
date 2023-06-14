<?php
  header('Content-Type:application/json; charset=utf-8');
  header('Access-Control-Allow-Origin:*');
  if ( $_SERVER['REQUEST_METHOD'] != 'POST' ){
    header('HTTP/1.1 404 Not Found');
    header("status: 404 Not Found");
    echo "当前页面仅支持 POST 访问";
    exit();
  }
  $json_input = file_get_contents('php://input');
  if (empty($json_input) || is_numeric($json_input) || exec("echo '$json_input' | jq . > /dev/null 2>&1;echo $?") != '0'){
    $dtime = date('Y-m-d H:i:s');
    echo "{\"Code\":\"Bad\",\"Msg\":\"非法或空 json\",\"Datatime\":\"$dtime\"}";
    exit();
  }
  $json_input = json_decode($json_input);
  $json_data = json_encode($json_input);
  $return_json = exec("bash scripts/main_check.sh '$json_data'");
  $return_json_new = json_decode($return_json,true);
  echo json_encode($return_json_new,JSON_UNESCAPED_UNICODE);
?>
