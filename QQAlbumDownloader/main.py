import os
import sys

from scrapy.cmdline import execute

if __name__ == '__main__':
    # 下载所有相册
    execute(["scrapy", "crawl", "album", "-a", "upload_server=true"])
    # 下载【我的家人】相册
    # execute(["scrapy", "crawl", "album", "-a", "target=我的家人", "-a", "upload_server=false"])
