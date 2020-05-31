import os
import sys

from scrapy.cmdline import execute

if __name__ == '__main__':

    execute(["scrapy", "crawl", "album", "-a", "upload_server=true"])
    # execute(["scrapy", "crawl", "album", "-a", "target=本科毕业聚会"])