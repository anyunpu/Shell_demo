# 部署说明
- 本demo 完全由shell 脚本完成（前端除外）
- 仅供学习参考，不作为最佳的生产替代品
- 从无到有，应该说是shell脚本练习比较初级的一个demo
- 作者是一枚90后的IT男，目前居住云南昆明，由于非科班出身，所以代码逻辑比较糟糕
- 但目前 anYun 自己在积极维护，同时也开发demo供参考 https://ip.iquan.fun

## 环境要求
- PHP 环境
- Web 服务
- MySQL
- Linux 环境
- 第三方库
	- jq ： json处理工具
	- PHPMailer ：发邮件脚本

---

## 部署步骤
- 按需修改 conf/config.conf 文件
	- 数据库信息
	- api 信息
	
- 运行 install.sh 文件
- 如果需要index.php 提供服务，请根据实际情况修改

---

## 逻辑套路
- 本地创建一个IP库
- 外部请求后，优先查找本地，如果有则返回ip信息，如果没有则请求第三方，并记录到本地库中
- IPv4 调用的是高德
- IPv6 调用的第三方临时
- 如果使用的外部接口和我一样，那么基本不用修改脚本

---

## 目录说明
- css ：index.php 样式
- js ：JavaScript 脚本
- scripts ：一些shell脚本
- tools ：第三方库或工具
- temp ： 临时文件存放目录

---

## 脚本说明
### PHP 脚本
- index.php ：主页文件（接口说明、注册申请）
- getip.php ：对外请求（IP位置信息）处理脚本
- useradd.php : 用户注册脚本
- usercheck.php ：用户注册后邮箱验证脚本

---

### Shell 脚本
- main_check.sh ：ip接口处理脚本（getip.php 调用）
- ip_check.sh ：ip信息处理（main_check.sh 调用）
- public.sh ：公共 function
- useradd.sh ：用户注册脚本（useradd.php 调用）
- usercheck.sh ：用户验证脚本（usercheck.php 调用）
- instll.sh ：安装脚本
- cron.sh ：计划任务（清理数据）

---

### SQL 脚本
- default.sql.0 ：初始化 SQL

---

### 邮件设置
- 根据 tools/PHPMailer/sendmail.php 注释信息，改成自己的邮箱信息
- 在需要发送邮件时调用 sendmail.php 即可 ： `php tools/PHPMailer/sendmail.php '收件人邮箱' '邮箱主题' '邮箱内容（支持HTML标签）'`
- 邮件内容及格式涉及下列两个脚本
	- scripts/useradd.sh
	- scripts/usercheck.sh

---

## 补充说明
- 仅使用ip数据库功能，所以 web服务和PHP非必选
- IPv4 存储使用整型存储
- IPv6 原样存储
