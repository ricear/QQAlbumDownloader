import os
import sys

from scrapy.cmdline import execute

if __name__ == '__main__':

    # execute(["scrapy", "crawl", "album", "-a", "upload_server=true"])
    execute(["scrapy", "crawl", "album", "-a", "target=我的家人", "-a", "upload_server=false"])
