## JSON 配置文件
这是一种 Nginx 配置文件的替代语法，每个片段对应一个站点，理论上支持 Nginx 的所有指令。

### 示例

    {
        "listen": 80,
        "is_enable": true,
        "server_name": [
            "domain1.com",
            "domain2.net"
        ],
        "auto_index": false,
        "index": [
            "index.php",
            "index.html"
        ],
        "root": "/home/user/web",
        "location": {
            "/": {
                "try_files": ["$uri", "$uri/", "/index.php?$args"]
            },
            "~ \\.php$": {
                "fastcgi_pass": "unix:///home/user/phpfpm.sock",
                "fastcgi_index": ["index.php"],
                "include": "fastcgi_params"
            }
        }
    }

### 元素释义

* Home 下的路径

    即如果你的用户名为 user, 那么必须是以 `/home/user` 开头的路径，且其中不能含有相对路径(如 `..`).
    
* 路径

    必须为绝对路径。
    
* 域名

    类似于 `xxoo.net`, `sub-domain.xxoo.com`, `localhost` 等；不能有连续的符号(如 `sub..domain.net`), 不能有中文等特殊符号。
    
* 文件名

    类似于 `file`, `index.html` 等；不能有斜杠，不能有除了点、连字符和下划线之外的特殊字符。
    
* 布尔值

    true 和 false, 而不是字符串形式的 `"true"` 和 `"false"`.
    
* Unix Socket

    类似于 `unix:///home/user/phpfpm.sock`, 必须以 `unix://` 开头，后面是一个路径。
    
### 指令

* listen

    * 该站点监听的端口号
    * 数字，必须指令
    * 只能为 80
    
* is_enable

    * 是否启用该站点，RP 主机特有功能
    * 布尔值，默认 false
    
* server_name
    
    * 该站点的域名
    * 字符串数组，必须指令
    * 每一项需为合法的域名，且未被其他站点使用
    
* auto_index

    * 在没有首页文件时，是否显示文件列表
    * 布尔值，默认 false
    
* index

    * 首页文件名
    * 字符串数组，默认 `["index.html"]`
    * 每一项必须为文件名
    
* root

    * 站点根目录
    * 字符串，可选参数
    * 必须为 Home 下的路径
    
* location

    * 站点路径匹配规则
    * 对象，默认 `{}`
    * 键名目前支持 `/`, `~ \.php$`
    
* location - try_files
    
    * 尝试文件列表
    * 字符串数组，可选指令
    * 值目前支持 `$uri`, `$uri/`, `/index.php?$args`

* location - include

    * 包含 Nginx 的默认配置文件
    * 字符串，可选指令
    * 值只能为 `fastcgi_params`, `uwsgi_params`
    
* location - fastcgi_pass

    * 转发请求至 factcgi 服务器
    * 字符串，可选指令
    * 值必须是一个 Home 下的 Unix Socket
    
* location - fastcgi_index

    * 设置 factcgi 的首页文件
    * 字符串数组，当出现 fastcgi_pass 时，默认为 `["index.php"]`
    * 每一项必须为文件名

* location - uwsgi_pass

    * 转发请求至 uwsgi 服务器
    * 字符串，可选指令
    * 值必须是一个 Home 下的 Unix Socket
    
* location - proxy_pass

    * 转发请求至 http 服务器
    * 字符串，可选指令
    * 值为一个 Home 下的 Unix Socket 或一个 URL
    
* location - `proxy_set_header`

    * 在转发至 http 服务器时设置 HTTP 头
    * 对象，可选指令
    * 键名为 `Host` 时，值为一个域名或 `$host`
    
* location - proxy_redirect

    * 在转发至 http 服务器时是否跟随 HTTP 重定向
    * 布尔值，当出现 fastcgi_pass 时默认 false
