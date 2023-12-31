### 云导航   yunNav

Ver: 4.0
------------
#### 这是什么

基于 “一个导航” 二开，由静态改为动态
市面上一直没有合适的导航，所以我自己在写自己的导航
之前写了个 简静导航 ，但比较 low

------------
#### 配置相关
- list/main.list
	- 菜单列表，一行一个菜单分类，最后一个为 `设置`
	- 书写规范：`分类名称:对应的URL list文件`
- list/\*.list (`main.list 除外`)
	- 对应的菜单分类下的 URL 列表文件
	- 书写规范：`URL名称,简短描述内容,URL,0|1` （0 为可达，1为不可达）
- scripts/url_check.sh
	- URL 检测脚本

#### 响应式

------------

**桌面端**

体验网址：[云的导航](https://jian.deyun.fun){target="_blank"}

![桌面端预览](img/d74872f40858945b6e831f3d360e2950.webp)

**移动端**

![移动端预览](img/15ec22b5647ceee8961f5f7cc7863c1e.webp)


#### 开源相关

------------

Bootstrap：[https://getbootstrap.com](https://getbootstrap.com "https://getbootstrap.com")

CSSFX：[https://cssfx.netlify.com](https://cssfx.netlify.com "https://cssfx.netlify.com")

jQuery：[https://jquery.com](https://jquery.com "https://jquery.com")

slideout：[https://slideout.js.org](https://slideout.js.org "https://slideout.js.org")

font-awesome：[https://fontawesome.com](https://fontawesome.com "https://fontawesome.com")

知心天气：[https://www.seniverse.com/](https://www.seniverse.com/ "https://www.seniverse.com/")

------------
#### 开发日志
- 2023-08-25  初遇 [一个导航 aNavigation](https://nav.kksan.top/)
- 2023-08-29  云的导航 4.0 上线测试
