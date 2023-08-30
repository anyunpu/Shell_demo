<?php
  // 防护措施，禁止跨域盗用
  header('Access-Control-Allow-Origin:https://deyun.fun');
  $refer = $_SERVER['HTTP_REFERER'];
  if ($refer){
    $url = parse_url($refer);
    $host = explode('.',$url['host']);
    $count = count($host);
    $domainstr = $host[$count-2].'.'.$host[$count-1];
    if ($domainstr != 'deyun.fun'){
      echo '{"info":"禁止非法调用"}';
      exit();
    }
  }
  // 获取客户端 IP
  function getip() {
    $unknown = 'unknown';
    if (isset($_SERVER['HTTP_X_FORWARDED_FOR']) && $_SERVER['HTTP_X_FORWARDED_FOR'] && strcasecmp($_SERVER['HTTP_X_FORWARDED_FOR'], $unknown)) {
      $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
    }
    elseif(isset($_SERVER['REMOTE_ADDR']) && $_SERVER['REMOTE_ADDR'] && strcasecmp($_SERVER['REMOTE_ADDR'], $unknown)) {
      $ip = $_SERVER['REMOTE_ADDR'];
    }
    if (false !== strpos($ip, ',')) $ip = reset(explode(',', $ip));
      return $ip;
  }
  $userIP = getip();

  $ip_data = exec("bash scripts/ipinfo.sh '$userIP'");
  $ip_obj_data = json_decode($ip_data,true);
  echo json_encode($ip_obj_data,JSON_UNESCAPED_UNICODE);
?>
