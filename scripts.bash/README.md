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
    - 调用方式：`mkpassword "密码长度" "密码类型"`
    - 参数说明
        - 密码长度：大于0的整数
        - 密码类型
            - 0 ：大小写+数字+符号
            - 1 ：仅大小写
            - 2 ：小写 + 数字
            - 3 ：小写 + 符号
            - 4 ：大写 + 数字
            - 5 ：大写 + 符号
            - 6 ：大小写 + 数字
            - 7 ：大写 + 数字 + 符号
            - 8 ：仅小写
            - 9 ：仅大写
            - 10 ：仅数字
            - 11 ：仅符号

- function url_encode
    - 用于对字符串进行 url 编码
    - 调用方式：
        - 大写编码：`url_encode -A "需要编码的字符"`
        - 小写编码：`url_encode "需要编码的字符"`

- function url_decode
    - 用于对于url编码过的字符串进行解码
    - 调用方式：`url_decode "URL编码过的字符串"`
