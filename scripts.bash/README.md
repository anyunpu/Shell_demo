# 说明
- 直接调用 function_pub.sh 即可
- 欢迎喜欢shell的道友共同完善
- By anYun , deyun@deyun.fun
- https://deyun.fun , https://iquan.fun

---

# 用法
- function sql
    - 用于操作数据库，直接调用加上操作语句即可
    - 需要定义变量
        - db_host：数据库主机ip
        - db_port：数据库主机端口
        - db_user：用户
        - db_pass：密码

    - 调用方式：`sql "您的sql语句"`
- function ip_checking
    - 用于checking ip格式合规性，支持 IPv4 和 IPv6
    - 调用方式：`ip_checking "ip地址"`
    - 返回结果：iptype=4 or iptype=6

- function print_log
    - 用于打印日志，带时间戳
    - 调用方式：`print_log "打印的内容"`

- function convert_ip
    - 用于IPv4 to 整数，或 整数 to IPv4
    - 调用方式：`convert_ip "整数或点分制IP"`
    - 注意事项：整数型和点分制需要同时使用 convert_ip 转换，否则会因为算法不一导致异常

- function mkpassword
    - 用于随机创建密码
    - 调用方式：`mkpassword "密码长度"`
    - 依赖说明：此 function 依赖 openssl

- function url_encode
    - 用于对字符串进行 url 编码
    - 调用方式：
        - 大写编码：`url_encode -A "需要编码的字符"`
        - 小写编码：`url_encode "需要编码的字符"`

- function url_decode
    - 用于对于url编码过的字符串进行解码
    - 调用方式：`url_decode "URL编码过的字符串"`

- function dingtk_robot
    - 用于给钉钉机器人推送消息，webhup 方式
    - 使用前需要在对应的群聊里添加自定义机器人
    - 调用方式
        - 关键词方式：`dingtk_robot -w "access_token" "msg json data"`
        - 加签方式：`dingtk_robot -s "access_token" "secret" "msg json data"`

- function date_diff
    - 用于计算两个日期的差以及开始日期`N天以后`或`N天以前`
    - 调用方式：
        - 指定日期N天之前：`date_diff "开始日期" -N`
        - 指定日期N天之后：`date_diff "开始日期" +N`
        - 计算两个日期差： `date_diff "开始日期" "结束日期"`
     - 参数说明：日期格式必须为 `yyyy-mm-dd` 格式
