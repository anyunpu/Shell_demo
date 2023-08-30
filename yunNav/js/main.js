/*
 * ALL RIGHTS RESERVED.
 *
 * 作者：酷安@_小K同學
 * 项目开始日期：2020年01月26日
 * 上次修改时间：2022年02月25日
 * 开发日志：https://kksan.top/f5404b68deeb4634b39dac0bc67ec693
 *
 * 开源相关：
 * Github：https://github.com/Jackie1123/aNavigation
 * CSSFX：https://cssfx.netlify.com
 * jQuery：https://jquery.com
 * slideout：https://slideout.js.org
 * bootstrap：https://getbootstrap.com
 * font-awesome：https://fontawesome.com
 *
 * 版权所有，请勿删除！
 */

var storage = window.localStorage;
var data = storage.data;
var night = storage.night;
var bg = storage.bg;
var closealert = storage.closealert;
var li = $('.sidenav-btn');
var blockquote = $('.blockquote');

if (storage.data != undefined) {
    data = data.split(',');
    // console.log('已存在localStorage的数据：' + data); //已存在localStorage的数据
    $('#state a img').attr('src', data[0]); //头图
    $('.submitButton').css('background-color', data[1]); //按钮bgc
    $('#inputText').attr('placeholder', data[2]);
    $('#form').attr('action', data[3]);
    $('#inputText').attr('name', data[4]);
    $('#Select').css('color', data[1]);
    $('.span').css('background-color', data[1]);
}

if (storage.night != undefined) {
    night = night.split(',');
    console.log(night);
    $('#main').css('background-color', night[0]); //主界面
    $('#menu').css('background-color', night[1]); //侧栏
    document.getElementById("night").innerHTML = night[2];
    li.css('background-color', night[3]);
    li.css('color', night[4]);
    blockquote.css('color', night[5]);
}

if (storage.bg != undefined) {
    bg = bg.split(',');
    $('#main').css('background-image', bg[0]);
}

// 检查是否有新版本
if (storage.closealert != undefined) {
    closealert = closealert.split(',');
    if (closealert[0] == '4.1.2') {
        $('#alert').remove();
    }
}

// rgb to hex
function rgb2hex(rgb) {
    rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);

    function hex(x) {
        return ("0" + parseInt(x).toString(16)).slice(-2);
    }
    return "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3]);
}
// rgb to hex结束

// 添加书签
$(function() {
        var bookmark = {
            data: [{
                name: 'Todesk',
                link: 'https://www.todesk.com/',
                box_shadow: '#F18033',
                icon: 'img/todesk.png',
                desc: '一款牛逼的远程工具'
            }, {
                name: 'Ventoy',
                link: 'https://www.ventoy.net/cn/index.html',
                box_shadow: '#11B063',
                icon: 'img/ventoy.png',
                desc: '一款牛逼的启动引导制作工具'
            }, {
                name: '火绒安全',
                link: 'https://www.huorong.cn/',
                box_shadow: '#FA7199',
                icon: 'img/hr.png',
                desc: '一款安静的安全软件'
            }, {
                name: 'Potplayer',
                link: 'https://potplayer.tv/?lang=zh_CN',
                box_shadow: '#F2584A',
                icon: 'img/potplayer.png',
                desc: '一款强大的音视频播放工具'
            }, {
                name: 'Wallhaven',
                link: 'https://wallhaven.cc/',
                box_shadow: '#0078D8',
                icon: 'img/wall-haven.png',
                desc: '一个免费且高清的壁纸网站'
            }, {
                name: 'Anydesk',
                link: 'https://anydesk.com/zhs',
                box_shadow: '#F57923',
                icon: 'img/anydesk.png',
                desc: '一款小巧的远程工具'
            }, {
                name: 'phpipam',
                link: 'https://phpipam.net/',
                box_shadow: '#2C2C2C',
                icon: 'img/phpipam.png',
                desc: '一个好用的IP管理系统'
            }, {
                name: '矢量图标',
                link: 'https://www.iconfont.cn/',
                box_shadow: '#37bf4c',
                icon: 'img/aliava.png',
                desc: '阿里免费矢量图库'
            }, {
                name: 'wepe',
                link: 'https://www.wepe.com.cn/',
                box_shadow: '#c01d2f',
                icon: 'img/wepe.png',
                desc: '一款放心的PE工具'
            }, {
                name: 'Bandizip',
                link: 'https://www.bandisoft.com/bandizip/',
                box_shadow: '#fe7700',
                icon: 'img/bandizip.png',
                desc: '一款放心的解压缩工具'
            }, {
                name: 'VScode',
                link: 'https://code.visualstudio.com/',
                box_shadow: '#c5000a',
                icon: 'img/vscode.png',
                desc: '一款强大的IDE工具'
            }, {
                name: 'LNMP',
                link: 'https://www.lnmp.org/',
                box_shadow: '#AC6E2F',
                icon: 'img/lnmp.png',
                desc: '一个牛逼的LNMP脚本'
            }, {
                name: '少数派',
                link: 'https://sspai.com/',
                box_shadow: '#D7191A',
                icon: 'img/sspai.png',
                desc: '就是少数'
            }, {
                name: '小众软件',
                link: 'https://www.appinn.com/',
                box_shadow: '#3279ea',
                icon: 'img/xiaozhong.png',
                desc: '就是小众'
            }, {
                name: '数字尾巴',
                link: 'https://www.dgtle.com/',
                box_shadow: '#62677b',
                icon: 'img/shuziweiba.png',
                desc: '尾巴有点小'
            }, {
                name: 'geekuninstaller',
                link: 'https://geekuninstaller.com/',
                box_shadow: '#7C5DC7',
                icon: 'img/geek.png',
                desc: '卸载软件必备'
            }, {
                name: 'MobaXterm',
                link: 'https://mobaxterm.mobatek.net/',
                box_shadow: '#00A0E9',
                icon: 'img/mobax.png',
                desc: '牛逼的终端工具'
            }, {
              name: 'RockyLinux',
              link: 'https://rockylinux.org/',
              box_shadow: '#00A0E9',
              icon: 'img/rockylinux.png',
              desc: 'CentOS替代品'
          }, {
            name: 'itellyou',
            link: 'https://next.itellyou.cn',
            box_shadow: '#00A0E9',
            icon: 'img/itu.png',
            desc: 'Windows 必备站点'
        }, {
          name: 'Deepin',
          link: 'https://www.deepin.org/index/zh',
          box_shadow: '#00A0E9',
          icon: 'img/deepin.png',
          desc: '国产forLinux'
      }]
        }
        for (var i = 0; i < bookmark.data.length; i++) {
            var addList = '<li class="folder-item col-xs-3 col-sm-2"><a target="_blank" title="' + bookmark.data[i].desc + '" href="' + bookmark.data[i].link + '"><div class="folder-item-box"><img class="folder-item-img" style="box-shadow:' + bookmark.data[i].box_shadow + ' 0 14px 12px -8px" src="' + bookmark.data[i].icon + '" /><p>' + bookmark.data[i].name + '</p></div></a></li>'
            $('#folder ul').append(addList);
        }
    })
    // 添加书签结束

// 搜索相关
$(function() {
    var search = {
        data: [{
            name: 'baidu',
            icon: 'img/baidu-xs.png',
            searchlink: 'https://www.baidu.com/s',
            searchname: 'wd',
            color: '#3245df',
            placeholder: '百度一下 ...'
        }, {
            name: 'google',
            icon: 'img/google-xs.png',
            searchlink: 'https://www.google.com/search',
            searchname: 'q',
            color: '#4285f4',
            placeholder: '咕噜咕噜...'
        }, {
            name: 'bing',
            icon: 'img/bing-xs.png',
            searchlink: 'https://cn.bing.com/search',
            searchname: 'q',
            color: '#00868B',
            placeholder: 'Bing搜索...'
        }, {
            name: 'fsou',
            icon: 'img/fsou.png',
            searchlink: 'https://fsoufsou.com/',
            searchname: 'q',
            color: '#5f01d1',
            placeholder: 'F 搜索 ...'
        }, {
            name: 'pkgs',
            icon: 'img/pkgs.png',
            searchlink: 'https://pkgs.org/search/',
            searchname: 'q',
            color: 'black',
            placeholder: 'pkgs for linux ...'
        }, {
            name: 'yisou',
            icon: 'img/yisou.png',
            searchlink: 'https://yiso.fun/info',
            searchname: 'searchKey',
            color: '#f94c18',
            placeholder: '易搜,搜网盘 ...'
        }, {
            name: 'wechat',
            icon: 'img/wechat-xs.png',
            searchlink: 'https://weixin.sogou.com/weixin',
            searchname: 'query',
            color: '#2ca43a',
            placeholder: '搜微信文章 ...'
        }, {
            name: 'quark',
            icon: 'img/quark-xs.png',
            searchlink: 'https://quark.sm.cn/s',
            searchname: 'q',
            color: '#6182f6',
            placeholder: '夸克搜索 ...'
        }, {
            name: 'taobao',
            icon: 'img/taobao-xs.png',
            searchlink: 'https://s.taobao.com/search',
            searchname: 'q',
            color: '#FF5B00',
            placeholder: '淘，我喜欢 ...'
        }, {
            name: 'jingdong',
            icon: 'img/jingdong-xs.png',
            searchlink: 'https://search.jd.com/Search',
            searchname: 'keyword',
            color: '#F30213',
            placeholder: '多，快，好，省 ...'
        }, {
            name: 'bilibili',
            icon: 'img/bilibili-xs.png',
            searchlink: 'https://search.bilibili.com/all',
            searchname: 'keyword',
            color: '#e47494',
            placeholder: 'B站是一个学习网站 ...'
        }, {
            name: 'github',
            icon: 'img/github-xs.png',
            searchlink: 'https://github.com/search',
            searchname: 'q',
            color: '#24292e',
            placeholder: '全球最大的开源社区 ...'
        }, {
            name: 'maoliyun',
            icon: 'img/maoliyun.png',
            searchlink: 'https://www.maoliyun.com/search',
            searchname: 'q',
            color: '#ed2f28',
            placeholder: '猫哩云搜盘...'
        }, {
            name: 'stackoverflow',
            icon: 'img/stackoverflow.png',
            searchlink: 'https://stackoverflow.com/nocaptcha',
            searchname: 'q',
            color: '#e6162d',
            placeholder: '搜你想搜的 ...'
        }, {
            name: 'zhihu',
            icon: 'img/zhihu-xs.png',
            searchlink: 'https://www.zhihu.com/search',
            searchname: 'q',
            color: '#1087eb',
            placeholder: '我们都是有问题的人 ...'
        }, {
            name: 'kuaidi',
            icon: 'img/kuaidi-xs.png',
            searchlink: 'https://m.kuaidi100.com/result.jsp',
            searchname: 'nu',
            color: '#317EE7',
            placeholder: '搜快递 ...'
        }]
    }
    for (var i = 0; i < search.data.length; i++) { //添加搜索按钮
        var addList = '<li class="folder-item2 col-xs-3 col-sm-2"> <a title="' + search.data[i].placeholder + '"href="#"> <div class="folder-item-box2"> <img id="' + search.data[i].name + '" class="folder-item-img2" src="' + search.data[i].icon + '" /> </div> </a> </li> '
        $('.nav ul').append(addList);
    }

    // 切换搜索引擎
    $(document).click(function(e) {
            var id = e.target.id;
            for (var i = 0; i < search.data.length; i++) {
                if (id == search.data[i].name) {
                    document.getElementById("state").innerHTML = "<a href='folder://'><img style='width:300px;' src='img/" + search.data[i].name + ".png'></a>";
                    $('#submitButton').css('background-color', search.data[i].color); //按钮bg
                    $('#Select').css('color', search.data[i].color); //选择器
                    $('#nav').css('display', 'none');
                    $('#folder').css('display', 'block');
                    document.getElementById("Select").innerHTML = "<hr>书签 <img src='img/search-change.svg?v=2ae7ab8'>";
                    $("#inputText").attr("placeholder", search.data[i].placeholder);
                    $("#form").attr("action", search.data[i].searchlink);
                    $("#inputText").attr("name", search.data[i].searchname);

                    //存入用户数据
                    var searchPho = $('#state a img').attr("src"); //搜索引擎头图
                    var color = rgb2hex($('.submitButton').css('background-color')); //搜索按钮颜色和搜索框四边颜色
                    var searchL = $('#form').attr("action"); //searchlink
                    var searchN = $('#inputText').attr("name"); //searchname
                    var placeholder = $('#inputText').attr('placeholder');
                    storage.data = [searchPho, color, placeholder, searchL, searchN] //记录用户数据
                        // console.log('新存入localStorage的数据：' + storage.data); //新存入localStorage的数据
                    break;
                }
            }
        })
        // 搜索相关结束

    // 夜间模式
    $('#night').click(function() {
            if (rgb2hex($('#main').css('background-color')) == '#ffffff') {
                $('#main').css('background-color', '#2f2f33'); //主界面
                $('#menu').css('background-color', '#5C5C5C'); //侧栏
                document.getElementById("night").innerHTML = "日间模式";
                li.css({
                    "background-color": "#575757",
                    "color": "#DBDBDB"
                });
                blockquote.css('color', '#DBDBDB');
            } else if (rgb2hex($('#main').css('background-color')) == '#2f2f33') {
                $('#main').css('background-color', '#ffffff'); //主界面
                $('#menu').css('background-color', '#EDEDED'); //侧栏
                document.getElementById("night").innerHTML = "夜间模式";
                li.css({
                    "background-color": "#E3E3E3",
                    "color": "black"
                });
                blockquote.css('color', 'black');
            }
            var mainbg = rgb2hex($('#main').css('background-color'));
            var menubg = rgb2hex($('#menu').css('background-color'));
            var inner = document.getElementById("night").innerHTML;
            var libg = rgb2hex(li.css('background-color'));
            var lico = rgb2hex(li.css('color'));
            var blockquoteco = rgb2hex(blockquote.css('color'));
            // storage.night = [mainbg, menubg, inner, libg, lico, blockquoteco];
            // localStorage.clear()
        })
        // 夜间模式结束
})

// 显示/干掉壁纸
var width = $(document).width();
$('#bg').click(function() {
  if (width < 768 ){
    if ($('#main').css('background-image') == 'none'){
      $('#main').css('background-image', 'url(img/bg-xs.webp)');
      $('#folder p').css('color','white');
    } else {
      $('#folder p').css('color','blue');
      $('#main').css('background-image', 'none');
    }
  } else {
    if ($('#main').css('background-image') == 'none'){
      $('#main').css('background-image', 'url(img/bg.webp)');
      $('#folder p').css('color','white');
    } else {
      $('#folder p').css('color','blue');
      $('#main').css('background-image', 'none');
    }
  }
    var background = $('#main').css('background-image');
    storage.bg = [background];
})

//检查搜索框是否为空
function check() {
    var o = document.getElementById("inputText");
    var v = o.value;
    v = v.replace(/[ ]/g, "");
    if (v == '') {
        return false;
    }
}
//检查搜索框是否为空结束

//title问候语
var d = new Date();
var time = d.getHours();
if (time < 24) {
    document.getElementById("title").innerHTML = "云的导航 | Good evening";
}
if (time < 18) {
    document.getElementById("title").innerHTML = "云的导航 | Good afternoon";
}
if (time < 12) {
    document.getElementById("title").innerHTML = "云的导航 | Good morning";
}
if (time < 5) {
    document.getElementById("title").innerHTML = "云的导航 | Stay up late again";
}
//title问候语结束

//导航、引擎选择器
function select() {
    $('#folder').css('display') == 'block' ? ($('#folder').css('display', 'none'), $('#nav').css('display', 'block'), document.getElementById("Select").innerHTML = "<hr>搜索引擎 <img src='img/search-change.svg?v=2ae7ab8'>") : ($('#nav').css('display', 'none'), $('#folder').css('display', 'block'), document.getElementById("Select").innerHTML = "<hr>书签 <img src='img/search-change.svg?v=2ae7ab8'>");
}
//导航、引擎选择器结束

// 天气插件
(function(a, h, g, f, e, d, c, b) {
    b = function() {
        d = h.createElement(g);
        c = h.getElementsByTagName(g)[0];
        d.src = e;
        d.charset = "utf-8";
        d.async = 1;
        c.parentNode.insertBefore(d, c)
    };
    a["SeniverseWeatherWidgetObject"] = f;
    a[f] || (a[f] = function() {
        (a[f].q = a[f].q || []).push(arguments)
    });
    a[f].l = +new Date();
    if (a.attachEvent) {
        a.attachEvent("onload", b)
    } else {
        a.addEventListener("load", b, false)
    }
}(window, document, "script", "SeniverseWeatherWidget", "//cdn.sencdn.com/widget2/static/js/bundle.js?t=" + parseInt((new Date().getTime() / 100000000).toString(), 10)));
window.SeniverseWeatherWidget('show', {
    flavor: "bubble",
    location: "WX4FBXXFKE4F",
    geolocation: true,
    language: "auto",
    unit: "c",
    theme: "auto",
    token: "e14489a8-9a7e-477d-9c6c-b4b390175cca",
    hover: "enabled",
    container: "tp-weather-widget"
})

// 搜索提示词
class searchHint {
    constructor() {
        this.search = inputText;
        this.list = list;
        this.body = document.body;
        this.init();
    };
    init() {
        this.watchInput();
    };
    watchInput() {
        this.search.onkeyup = () => {
            if (this.search.value.length == 0) {
                this.list.innerHTML = '';
                return;
            }
            const script = document.createElement('script');
            script.src = "https://www.baidu.com/su?wd=" + this.search.value + "&cb=jsonp.showMsg";
            this.body.appendChild(script);
            this.body.removeChild(script);
        }
    };
    showMsg(msg) {
        var href = $('#form').attr('action');
        var name = $('#inputText').attr('name');
        var v = $('#inputText').val();
        var str = '';
        for (var i = 0; i < msg.s.length; i++) {
            var sk = new Array();
            sk[i] = msg.s[i].replace(/\s*/g, ''); //去掉关键字空格
            str += '<a href=' + href + '?' + name + '=' + sk[i] + '><li><span>' + (i + 1) + '</span>' + msg.s[i] + '</li></a>';
        }
        this.list.innerHTML = str;
        if (str) { //有返回才显示#searchlist
            $('#searchlist').css("display", "block");
        }
        document.onkeydown = function(event) {
            if (event.keyCode == 8 && v.length == 1) {
                $('#searchlist').css("display", "none");
            }
        };
        $(document).click(function() { //点击其他地方隐藏#searchlist
            $('#searchlist').css("display", "none");
        });
    }
}
const jsonp = new searchHint();

/*
 * ALL RIGHTS RESERVED.
 *
 * 作者：酷安@_小K同學
 * 项目开始日期：2020年01月26日
 * 上次修改时间：2022年02月25日
 * 开发日志：https://kksan.top/f5404b68deeb4634b39dac0bc67ec693
 *
 * 开源相关：
 * Github：https://github.com/Jackie1123/aNavigation
 * CSSFX：https://cssfx.netlify.com
 * jQuery：https://jquery.com
 * slideout：https://slideout.js.org
 * bootstrap：https://getbootstrap.com
 * font-awesome：https://fontawesome.com
 *
 * 版权所有，请勿删除！
 */
