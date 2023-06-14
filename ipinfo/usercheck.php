<?php
  if ( $_SERVER['REQUEST_METHOD'] != 'GET' ){
    header('HTTP/1.1 404 Not Found');
    header("status: 404 Not Found");
    echo "当前页面仅支持 GET 访问";
    exit();
  }
  $ukey = $_GET['ukey'];
  $dtime = $_GET['dtime'];
  if ( ! array_key_exists ('ukey',$_GET) || ! array_key_exists ('dtime',$_GET) ){
    header('HTTP/1.1 404 Not Found');
    header("status: 404 Not Found");
    exit();
  }
  $ukey = $_GET['ukey'];
  $dtime = $_GET['dtime'];
  $r_data = json_decode(exec("bash scripts/usercheck.sh '$ukey' '$dtime'"),true);
  echo '<script>alert("'.$r_data['Datatime'].'\n'.$r_data['Msg'].'");</script>';
?>
