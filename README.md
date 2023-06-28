<p align='center'>
    <a href="https://github.com/ricear/QQAlbumDownloader/blob/master/LICENSE"><img alt="GitHub"
            src="https://img.shields.io/github/license/ricear/QQAlbumDownloader?label=License" /></a>
    <img src="https://img.shields.io/badge/build-passing-brightgreen.svg" />
    <img src="https://img.shields.io/badge/platform-%20iOS | Android | Mac | Web%20-ff69b4.svg" />
    <img src="https://img.shields.io/badge/language-Java-orange.svg" />
    <img src="https://img.shields.io/badge/made%20with-=1-blue.svg" />
    <a href="https://github.com/ricear/QQAlbumDownloader/pulls"><img
            src="https://img.shields.io/badge/PR-Welcome-brightgreen.svg" /></a>
    <img src="https://img.shields.io/github/stars/ricear/QQAlbumDownloader?style=social" />
    <img src="https://img.shields.io/github/forks/ricear/QQAlbumDownloader?style=social" />
    <a href="https://github.com/ricear/QQAlbumDownloader"><img
            src="https://visitor-badge.laobi.icu/badge?page_id=ricear.QQAlbumDownloader" /></a>
    <a href="https://github.com/ricear/QQAlbumDownloader/releases"><img
            src="https://img.shields.io/github/v/release/ricear/QQAlbumDownloader" /></a>
    <a href="https://github.com/ricear/QQAlbumDownloader"><img
            src="https://img.shields.io/github/repo-size/ricear/QQAlbumDownloader" /></a>
</p>
<p align='center'>
    <a href="https://ricear.com"><img src="https://img.shields.io/badge/Blog-Ricear-80d4f9.svg?style=flat" /></a>
    <a href="https://unsplash.com/@ricear"><img src="https://img.shields.io/badge/Unsplash-Ricear-success.svg" /></a>
    <a href="https://twitter.com/ricear1996"><img
            src="https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Ftwitter.com%2Fricear1996" /></a>
</p>

## 简介

QQAlbumDownloader 主要用于下载 QQ 相册中的照片（原图）视频。作为一个 QQ 相册的重度用户，已累计上传近 9000 张照片，这些照片承载了我从幼年到成年的所有记忆，重要性不言而喻。即使现在微信朋友圈几乎普及到了每个国人，我依然热衷于将照片分类存放到 QQ 相册中。然而随着 QQ 空间更新逐渐放缓，一种担忧也油然而生：假如有一天 QQ 空间停止运行了怎么办？由于 QQ 相册并不提供批量下载，有朝一日 QQ 空间真的停止运行，所有存到 QQ 相册中的照片可能都会丢失，这对于我来说可能是灾难性的。因此，QQAlbumDownloader 就诞生了。

QQAlbumDownloader 支持单个相册或全部相册下载。致力于用作 QQ 相册的备份，在 QQ 空间因为不可抗力停服时，可以快速从 QQ 相册下载自己的照片，减少损失，为自己的数据保驾护航。

## 环境准备

### 环境依赖

| 名称    | 版本   |
| ------- | ------ |
| Python  | 3.6.13 |
| MongoDB | 6.0.6  |

### 环境安装

1. 下载并安装 [Python](https://www.python.org/downloads)；

2. 下载、安装并启动 [MongoDB](https://www.mongodb.com/docs/manual/installation)；

3. 下载 [谷歌浏览器](https://www.google.com/chrome)；

4. 下载 [PhantomJS](https://phantomjs.org/download.html)，删除 `QQAlbumDownloader/phantomjs` 文件夹，将解压后的 PhantomJS 文件移动到 `QQAlbumDownloader/` 目录；

5. 下载 [ChromeDriver](https://chromedriver.chromium.org/downloads)：

   - 查看谷歌浏览器版本；

     ![image-20230627204357023](https://notebook.ricear.com/media/202306/2023-06-27_204318_4974110.07006254798523104.png)

   - 下载对应版本的 ChromeDriver；

     ![image-20230627204632424](https://notebook.ricear.com/media/202306/2023-06-27_204536_9199730.8323508731940538.png)

   - 将解压后文件中的 chromedriver 移动到 `QQAlbumDownloader/webdriver/chromedriver` 替换原有的 chromedriver；

6. 安装 Python 依赖：`pip3 install -r requirements.txt`；

## 快速上手

1. 在 `QQAlbumDownloader/spiders/album.py` 中修改 QQ 用户名和密码；

   ```python
   # 输入qq号和密码
   # account = input('请输入你的qq号：')
   account = '******'
   # password = getpass.getpass('请输入你的密码：')
   password = '******'
   ```

2. 修改 `QQAlbumDownloader/main.py` 文件；

   ```python
   # 下载所有相册
   execute(["scrapy", "crawl", "album", "-a", "upload_server=true"])
   # 下载【我的家人】相册
   # execute(["scrapy", "crawl", "album", "-a", "target=我的家人", "-a", "upload_server=false"])

3. 运行 `QQAlbumDownloader/main.py` 文件。

![QQAlbumDownloader快速入手](https://notebook.ricear.com/media/202306/2023-06-28_173952_1140180.03740891710405325.gif)

## 常见问题

### ChromeDriver 版本不对

```
/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/OpenSSL/_util.py:6: CryptographyDeprecationWarning: Python 3.6 is no longer supported by the Python core team. Therefore, support for it is deprecated in cryptography. The next release of cryptography will remove support for Python 3.6.
  from cryptography.hazmat.bindings.openssl.binding import Binding
/Users/weipeng/projects/study/QQAlbumDownloader/QQAlbumDownloader/****** 创建成功
Traceback (most recent call last):
  File "main.py", line 8, in <module>
    execute(["scrapy", "crawl", "album", "-a", "upload_server=true"])
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/cmdline.py", line 149, in execute
    cmd.crawler_process = CrawlerProcess(settings)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/crawler.py", line 251, in __init__
    super(CrawlerProcess, self).__init__(settings)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/crawler.py", line 137, in __init__
    self.spider_loader = _get_spider_loader(settings)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/crawler.py", line 338, in _get_spider_loader
    return loader_cls.from_settings(settings.frozencopy())
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/spiderloader.py", line 61, in from_settings
    return cls(settings)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/spiderloader.py", line 25, in __init__
    self._load_all_spiders()
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/spiderloader.py", line 47, in _load_all_spiders
    for module in walk_modules(name):
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/utils/misc.py", line 71, in walk_modules
    submod = import_module(fullpath)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/importlib/__init__.py", line 126, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
  File "<frozen importlib._bootstrap>", line 994, in _gcd_import
  File "<frozen importlib._bootstrap>", line 971, in _find_and_load
  File "<frozen importlib._bootstrap>", line 955, in _find_and_load_unlocked
  File "<frozen importlib._bootstrap>", line 665, in _load_unlocked
  File "<frozen importlib._bootstrap_external>", line 678, in exec_module
  File "<frozen importlib._bootstrap>", line 219, in _call_with_frames_removed
  File "/Users/weipeng/projects/study/QQAlbumDownloader/QQAlbumDownloader/spiders/album.py", line 75, in <module>
    class AlbumSpider(scrapy.Spider):
  File "/Users/weipeng/projects/study/QQAlbumDownloader/QQAlbumDownloader/spiders/album.py", line 80, in AlbumSpider
    driver = get_driver(1)
  File "/Users/weipeng/projects/study/QQAlbumDownloader/QQAlbumDownloader/util/CommonUtils.py", line 1460, in get_driver
    driver = webdriver.Chrome(abspath + '/webdriver/chromedriver/chromedriver', chrome_options=options)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/selenium/webdriver/chrome/webdriver.py", line 81, in __init__
    desired_capabilities=desired_capabilities)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/selenium/webdriver/remote/webdriver.py", line 157, in __init__
    self.start_session(capabilities, browser_profile)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/selenium/webdriver/remote/webdriver.py", line 252, in start_session
    response = self.execute(Command.NEW_SESSION, parameters)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/selenium/webdriver/remote/webdriver.py", line 321, in execute
    self.error_handler.check_response(response)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/selenium/webdriver/remote/errorhandler.py", line 242, in check_response
    raise exception_class(message, screen, stacktrace)
selenium.common.exceptions.SessionNotCreatedException: Message: session not created: This version of ChromeDriver only supports Chrome version 112
Current browser version is 114.0.5735.133 with binary path /Applications/Google Chrome.app/Contents/MacOS/Google Chrome
```

解决方法：下载和 Google Chrome 版本一致的 ChromeDriver 并放到指定目录。

### 无法导入 HTTPClientFactory

```
2023-06-28 11:10:07 [scrapy.core.downloader.handlers] ERROR: Loading "scrapy.core.downloader.handlers.http.HTTPDownloadHandler" for scheme "http"
Traceback (most recent call last):
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/__init__.py", line 48, in _load_handler
    dhcls = load_object(path)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/utils/misc.py", line 44, in load_object
    mod = import_module(module)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/importlib/__init__.py", line 126, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
  File "<frozen importlib._bootstrap>", line 994, in _gcd_import
  File "<frozen importlib._bootstrap>", line 971, in _find_and_load
  File "<frozen importlib._bootstrap>", line 955, in _find_and_load_unlocked
  File "<frozen importlib._bootstrap>", line 665, in _load_unlocked
  File "<frozen importlib._bootstrap_external>", line 678, in exec_module
  File "<frozen importlib._bootstrap>", line 219, in _call_with_frames_removed
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/http.py", line 3, in <module>
    from .http11 import HTTP11DownloadHandler as HTTPDownloadHandler
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/http11.py", line 26, in <module>
    from scrapy.core.downloader.webclient import _parse
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/webclient.py", line 4, in <module>
    from twisted.web.client import HTTPClientFactory
ImportError: cannot import name 'HTTPClientFactory'
2023-06-28 11:10:07 [scrapy.core.downloader.handlers] ERROR: Loading "scrapy.core.downloader.handlers.http.HTTPDownloadHandler" for scheme "https"
Traceback (most recent call last):
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/__init__.py", line 48, in _load_handler
    dhcls = load_object(path)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/utils/misc.py", line 44, in load_object
    mod = import_module(module)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/importlib/__init__.py", line 126, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
  File "<frozen importlib._bootstrap>", line 994, in _gcd_import
  File "<frozen importlib._bootstrap>", line 971, in _find_and_load
  File "<frozen importlib._bootstrap>", line 955, in _find_and_load_unlocked
  File "<frozen importlib._bootstrap>", line 665, in _load_unlocked
  File "<frozen importlib._bootstrap_external>", line 678, in exec_module
  File "<frozen importlib._bootstrap>", line 219, in _call_with_frames_removed
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/http.py", line 3, in <module>
    from .http11 import HTTP11DownloadHandler as HTTPDownloadHandler
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/http11.py", line 26, in <module>
    from scrapy.core.downloader.webclient import _parse
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/webclient.py", line 4, in <module>
    from twisted.web.client import HTTPClientFactory
ImportError: cannot import name 'HTTPClientFactory'
2023-06-28 11:10:07 [scrapy.core.downloader.handlers] ERROR: Loading "scrapy.core.downloader.handlers.s3.S3DownloadHandler" for scheme "s3"
Traceback (most recent call last):
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/__init__.py", line 48, in _load_handler
    dhcls = load_object(path)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/utils/misc.py", line 44, in load_object
    mod = import_module(module)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/importlib/__init__.py", line 126, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
  File "<frozen importlib._bootstrap>", line 994, in _gcd_import
  File "<frozen importlib._bootstrap>", line 971, in _find_and_load
  File "<frozen importlib._bootstrap>", line 955, in _find_and_load_unlocked
  File "<frozen importlib._bootstrap>", line 665, in _load_unlocked
  File "<frozen importlib._bootstrap_external>", line 678, in exec_module
  File "<frozen importlib._bootstrap>", line 219, in _call_with_frames_removed
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/s3.py", line 6, in <module>
    from .http import HTTPDownloadHandler
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/http.py", line 3, in <module>
    from .http11 import HTTP11DownloadHandler as HTTPDownloadHandler
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/http11.py", line 26, in <module>
    from scrapy.core.downloader.webclient import _parse
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/webclient.py", line 4, in <module>
    from twisted.web.client import HTTPClientFactory
ImportError: cannot import name 'HTTPClientFactory'
Unhandled error in Deferred:
2023-06-28 11:10:07 [twisted] CRITICAL: Unhandled error in Deferred:

Traceback (most recent call last):
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/crawler.py", line 172, in crawl
    return self._crawl(crawler, *args, **kwargs)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/crawler.py", line 176, in _crawl
    d = crawler.crawl(*args, **kwargs)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/twisted/internet/defer.py", line 1905, in unwindGenerator
    return _cancellableInlineCallbacks(gen)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/twisted/internet/defer.py", line 1815, in _cancellableInlineCallbacks
    _inlineCallbacks(None, gen, status)
--- <exception caught here> ---
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/twisted/internet/defer.py", line 1660, in _inlineCallbacks
    result = current_context.run(gen.send, result)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/twisted/internet/defer.py", line 62, in run
    return f(*args, **kwargs)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/crawler.py", line 80, in crawl
    self.engine = self._create_engine()
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/crawler.py", line 105, in _create_engine
    return ExecutionEngine(self, lambda _: self.stop())
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/engine.py", line 69, in __init__
    self.downloader = downloader_cls(crawler)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/__init__.py", line 88, in __init__
    self.middleware = DownloaderMiddlewareManager.from_crawler(crawler)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/middleware.py", line 53, in from_crawler
    return cls.from_settings(crawler.settings, crawler)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/middleware.py", line 34, in from_settings
    mwcls = load_object(clspath)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/utils/misc.py", line 44, in load_object
    mod = import_module(module)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/importlib/__init__.py", line 126, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
  File "<frozen importlib._bootstrap>", line 994, in _gcd_import

  File "<frozen importlib._bootstrap>", line 971, in _find_and_load

  File "<frozen importlib._bootstrap>", line 955, in _find_and_load_unlocked

  File "<frozen importlib._bootstrap>", line 665, in _load_unlocked

  File "<frozen importlib._bootstrap_external>", line 678, in exec_module

  File "<frozen importlib._bootstrap>", line 219, in _call_with_frames_removed

  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/downloadermiddlewares/retry.py", line 24, in <module>
    from scrapy.core.downloader.handlers.http11 import TunnelError
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/http11.py", line 26, in <module>
    from scrapy.core.downloader.webclient import _parse
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/webclient.py", line 4, in <module>
    from twisted.web.client import HTTPClientFactory
builtins.ImportError: cannot import name 'HTTPClientFactory'

2023-06-28 11:10:07 [twisted] CRITICAL:
Traceback (most recent call last):
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/twisted/internet/defer.py", line 1660, in _inlineCallbacks
    result = current_context.run(gen.send, result)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/twisted/internet/defer.py", line 62, in run
    return f(*args, **kwargs)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/crawler.py", line 80, in crawl
    self.engine = self._create_engine()
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/crawler.py", line 105, in _create_engine
    return ExecutionEngine(self, lambda _: self.stop())
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/engine.py", line 69, in __init__
    self.downloader = downloader_cls(crawler)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/__init__.py", line 88, in __init__
    self.middleware = DownloaderMiddlewareManager.from_crawler(crawler)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/middleware.py", line 53, in from_crawler
    return cls.from_settings(crawler.settings, crawler)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/middleware.py", line 34, in from_settings
    mwcls = load_object(clspath)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/utils/misc.py", line 44, in load_object
    mod = import_module(module)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/importlib/__init__.py", line 126, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
  File "<frozen importlib._bootstrap>", line 994, in _gcd_import
  File "<frozen importlib._bootstrap>", line 971, in _find_and_load
  File "<frozen importlib._bootstrap>", line 955, in _find_and_load_unlocked
  File "<frozen importlib._bootstrap>", line 665, in _load_unlocked
  File "<frozen importlib._bootstrap_external>", line 678, in exec_module
  File "<frozen importlib._bootstrap>", line 219, in _call_with_frames_removed
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/downloadermiddlewares/retry.py", line 24, in <module>
    from scrapy.core.downloader.handlers.http11 import TunnelError
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/http11.py", line 26, in <module>
    from scrapy.core.downloader.webclient import _parse
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/webclient.py", line 4, in <module>
    from twisted.web.client import HTTPClientFactory
ImportError: cannot import name 'HTTPClientFactory'
```

 解决方法：将 `twisted` 版本从 `22.4.0` 改为 `21.7.0`，命令为 `pip3 install twisted==21.7.0`。

### OpenSSL.SSL 模块找不到 SSLv3_METHOD 属性

```
2023-06-28 11:16:46 [scrapy.core.downloader.handlers] ERROR: Loading "scrapy.core.downloader.handlers.http.HTTPDownloadHandler" for scheme "http"
Traceback (most recent call last):
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/__init__.py", line 48, in _load_handler
    dhcls = load_object(path)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/utils/misc.py", line 44, in load_object
    mod = import_module(module)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/importlib/__init__.py", line 126, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
  File "<frozen importlib._bootstrap>", line 994, in _gcd_import
  File "<frozen importlib._bootstrap>", line 971, in _find_and_load
  File "<frozen importlib._bootstrap>", line 955, in _find_and_load_unlocked
  File "<frozen importlib._bootstrap>", line 665, in _load_unlocked
  File "<frozen importlib._bootstrap_external>", line 678, in exec_module
  File "<frozen importlib._bootstrap>", line 219, in _call_with_frames_removed
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/http.py", line 3, in <module>
    from .http11 import HTTP11DownloadHandler as HTTPDownloadHandler
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/http11.py", line 27, in <module>
    from scrapy.core.downloader.tls import openssl_methods
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/tls.py", line 17, in <module>
    METHOD_SSLv3:  SSL.SSLv3_METHOD,                    # SSL 3 (NOT recommended)
AttributeError: module 'OpenSSL.SSL' has no attribute 'SSLv3_METHOD'
2023-06-28 11:16:46 [scrapy.core.downloader.handlers] ERROR: Loading "scrapy.core.downloader.handlers.http.HTTPDownloadHandler" for scheme "https"
Traceback (most recent call last):
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/__init__.py", line 48, in _load_handler
    dhcls = load_object(path)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/utils/misc.py", line 44, in load_object
    mod = import_module(module)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/importlib/__init__.py", line 126, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
  File "<frozen importlib._bootstrap>", line 994, in _gcd_import
  File "<frozen importlib._bootstrap>", line 971, in _find_and_load
  File "<frozen importlib._bootstrap>", line 955, in _find_and_load_unlocked
  File "<frozen importlib._bootstrap>", line 665, in _load_unlocked
  File "<frozen importlib._bootstrap_external>", line 678, in exec_module
  File "<frozen importlib._bootstrap>", line 219, in _call_with_frames_removed
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/http.py", line 3, in <module>
    from .http11 import HTTP11DownloadHandler as HTTPDownloadHandler
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/http11.py", line 27, in <module>
    from scrapy.core.downloader.tls import openssl_methods
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/tls.py", line 17, in <module>
    METHOD_SSLv3:  SSL.SSLv3_METHOD,                    # SSL 3 (NOT recommended)
AttributeError: module 'OpenSSL.SSL' has no attribute 'SSLv3_METHOD'
2023-06-28 11:16:46 [scrapy.core.downloader.handlers] ERROR: Loading "scrapy.core.downloader.handlers.s3.S3DownloadHandler" for scheme "s3"
Traceback (most recent call last):
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/__init__.py", line 48, in _load_handler
    dhcls = load_object(path)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/utils/misc.py", line 44, in load_object
    mod = import_module(module)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/importlib/__init__.py", line 126, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
  File "<frozen importlib._bootstrap>", line 994, in _gcd_import
  File "<frozen importlib._bootstrap>", line 971, in _find_and_load
  File "<frozen importlib._bootstrap>", line 955, in _find_and_load_unlocked
  File "<frozen importlib._bootstrap>", line 665, in _load_unlocked
  File "<frozen importlib._bootstrap_external>", line 678, in exec_module
  File "<frozen importlib._bootstrap>", line 219, in _call_with_frames_removed
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/s3.py", line 6, in <module>
    from .http import HTTPDownloadHandler
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/http.py", line 3, in <module>
    from .http11 import HTTP11DownloadHandler as HTTPDownloadHandler
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/http11.py", line 27, in <module>
    from scrapy.core.downloader.tls import openssl_methods
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/tls.py", line 17, in <module>
    METHOD_SSLv3:  SSL.SSLv3_METHOD,                    # SSL 3 (NOT recommended)
AttributeError: module 'OpenSSL.SSL' has no attribute 'SSLv3_METHOD'
Unhandled error in Deferred:
2023-06-28 11:16:46 [twisted] CRITICAL: Unhandled error in Deferred:

Traceback (most recent call last):
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/crawler.py", line 172, in crawl
    return self._crawl(crawler, *args, **kwargs)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/crawler.py", line 176, in _crawl
    d = crawler.crawl(*args, **kwargs)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/twisted/internet/defer.py", line 1909, in unwindGenerator
    return _cancellableInlineCallbacks(gen)  # type: ignore[unreachable]
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/twisted/internet/defer.py", line 1816, in _cancellableInlineCallbacks
    _inlineCallbacks(None, gen, status)
--- <exception caught here> ---
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/twisted/internet/defer.py", line 1661, in _inlineCallbacks
    result = current_context.run(gen.send, result)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/twisted/internet/defer.py", line 63, in run
    return f(*args, **kwargs)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/crawler.py", line 80, in crawl
    self.engine = self._create_engine()
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/crawler.py", line 105, in _create_engine
    return ExecutionEngine(self, lambda _: self.stop())
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/engine.py", line 69, in __init__
    self.downloader = downloader_cls(crawler)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/__init__.py", line 88, in __init__
    self.middleware = DownloaderMiddlewareManager.from_crawler(crawler)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/middleware.py", line 53, in from_crawler
    return cls.from_settings(crawler.settings, crawler)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/middleware.py", line 34, in from_settings
    mwcls = load_object(clspath)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/utils/misc.py", line 44, in load_object
    mod = import_module(module)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/importlib/__init__.py", line 126, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
  File "<frozen importlib._bootstrap>", line 994, in _gcd_import

  File "<frozen importlib._bootstrap>", line 971, in _find_and_load

  File "<frozen importlib._bootstrap>", line 955, in _find_and_load_unlocked

  File "<frozen importlib._bootstrap>", line 665, in _load_unlocked

  File "<frozen importlib._bootstrap_external>", line 678, in exec_module

  File "<frozen importlib._bootstrap>", line 219, in _call_with_frames_removed

  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/downloadermiddlewares/retry.py", line 24, in <module>
    from scrapy.core.downloader.handlers.http11 import TunnelError
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/http11.py", line 27, in <module>
    from scrapy.core.downloader.tls import openssl_methods
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/tls.py", line 17, in <module>
    METHOD_SSLv3:  SSL.SSLv3_METHOD,                    # SSL 3 (NOT recommended)
builtins.AttributeError: module 'OpenSSL.SSL' has no attribute 'SSLv3_METHOD'

2023-06-28 11:16:46 [twisted] CRITICAL:
Traceback (most recent call last):
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/twisted/internet/defer.py", line 1661, in _inlineCallbacks
    result = current_context.run(gen.send, result)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/twisted/internet/defer.py", line 63, in run
    return f(*args, **kwargs)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/crawler.py", line 80, in crawl
    self.engine = self._create_engine()
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/crawler.py", line 105, in _create_engine
    return ExecutionEngine(self, lambda _: self.stop())
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/engine.py", line 69, in __init__
    self.downloader = downloader_cls(crawler)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/__init__.py", line 88, in __init__
    self.middleware = DownloaderMiddlewareManager.from_crawler(crawler)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/middleware.py", line 53, in from_crawler
    return cls.from_settings(crawler.settings, crawler)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/middleware.py", line 34, in from_settings
    mwcls = load_object(clspath)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/utils/misc.py", line 44, in load_object
    mod = import_module(module)
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/importlib/__init__.py", line 126, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
  File "<frozen importlib._bootstrap>", line 994, in _gcd_import
  File "<frozen importlib._bootstrap>", line 971, in _find_and_load
  File "<frozen importlib._bootstrap>", line 955, in _find_and_load_unlocked
  File "<frozen importlib._bootstrap>", line 665, in _load_unlocked
  File "<frozen importlib._bootstrap_external>", line 678, in exec_module
  File "<frozen importlib._bootstrap>", line 219, in _call_with_frames_removed
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/downloadermiddlewares/retry.py", line 24, in <module>
    from scrapy.core.downloader.handlers.http11 import TunnelError
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/handlers/http11.py", line 27, in <module>
    from scrapy.core.downloader.tls import openssl_methods
  File "/Users/weipeng/anaconda3/envs/QQAlbumDownloader-test/lib/python3.6/site-packages/scrapy/core/downloader/tls.py", line 17, in <module>
    METHOD_SSLv3:  SSL.SSLv3_METHOD,                    # SSL 3 (NOT recommended)
AttributeError: module 'OpenSSL.SSL' has no attribute 'SSLv3_METHOD'
```

 解决方法：将 `pyopenssl` 版本改为 `22.0.0`，命令为 `pip3 install pyopenssl==22.0.0`。

## 互动与反馈

如果您在使用过程中有任何问题，或者有好的建议，欢迎[提交 issue](https://github.com/ricear/QQAlbumDownloader/issues/new)或者通过[i@ricear.com](mailto:i@ricear.com)与取得联系，感谢您的支持与帮助。

