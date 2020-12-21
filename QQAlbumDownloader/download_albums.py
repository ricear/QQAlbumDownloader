# -*- encoding=utf-8 -*-
'''''
author: orangleliu
pil处理图片，验证，处理
大小，格式 过滤
压缩，截图，转换

图片库最好用Pillow
还有一个测试图片test.jpg, 一个log图片，一个字体文件
'''

import sys
import os
import datetime


curPath = os.path.abspath(os.path.dirname(__file__))
rootPath = os.path.split(curPath)[0]
sys.path.append(rootPath)

from QQAlbumDownloader.util.CommonUtils import *

if __name__ == "__main__":
    if (len(sys.argv) != 2):
        print('参数有误')
        exit(0)
    albums = sys.argv[1].split('|')
    download_albums(albums)