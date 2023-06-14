<?php
  use PHPMailer\PHPMailer\PHPMailer;
  use PHPMailer\PHPMailer\Exception;
  include 'tools/PHPMailer/src/Exception.php';
  include 'tools/PHPMailer/src/PHPMailer.php';
  include 'tools/PHPMailer/src/SMTP.php';
  function maileto($to,$title,$content,$f_path = ''){
    $mail = new PHPMailer(true);
    try {
        //Server settings
        $mail->SMTPDebug = 0; // 是否开启smtp的debug进行调试 ，0关闭，1开启
        $mail->isSMTP(); // 启用SMTP
        $mail->CharSet='utf-8'; //设置字符编码
        $mail->Host       = 'smtp.exmail.qq.com';// SMTP服务器，这里是qq邮箱
        $mail->SMTPAuth   = true;// 启用SMTP认证
        $mail->Username   = 'deyun@deyun.fun';// 发送邮件的邮箱，即自己的邮箱
        $mail->Password   = 'Ab123456';// 授权码
        $mail->SMTPSecure = 'ssl';// 加密方式为tls或者ssl，根据需求自己改
        $mail->Port       = 465;// 端口号
        //Recipients
        $mail->setFrom('deyun@deyun.fun', 'anYun'); //从哪发送的邮件，和上面的$mail->Username一样，后面是发送者的昵称，可以改
        $mail->addAddress($to);// 增加一个接受者的邮箱，这里用变量
        $mail->isHTML(true);                                  // Set email format to HTML
        $mail->Subject = $title;//标题
        $mail->Body    = $content;//正文
	if (! empty($f_path)){
	  $mail->AddAttachment($f_path); // 附件
	}
        //$mail->AltBody = 'This is the body in plain text for non-HTML mail clients';////当邮件不支持html时备用显示，可省略
        $mail->send();//发送邮件
    } catch (Exception $e) {
        echo '邮件发送失败: ', $mail->ErrorInfo;
    }
  }
  $uemail = $argv[1];
  $titles = $argv[2];
  $contents = $argv[3];
  $f = $argv[4];
  maileto($uemail,$titles,$contents,$f);
?>
