<?php
  header('Content-Type:application/json; charset=utf-8');
  if ( $_SERVER['REQUEST_METHOD'] != 'POST' ){
    header('HTTP/1.1 404 Not Found');
    header("status: 404 Not Found");
    echo "当前页面仅支持 POST 访问";
    exit();
  }
  $json_input = file_get_contents('php://input');
  $result_data=exec("bash scripts/useradd.sh '$json_input'");
  $result_data = json_decode($result_data,true);
  echo json_encode($result_data,JSON_UNESCAPED_UNICODE);
?>
