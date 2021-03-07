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

from QQAlbumDownloader.util.CommonUtils import *

curPath = os.path.abspath(os.path.dirname(__file__))
rootPath = os.path.split(curPath)[0]
sys.path.append(rootPath)

# 练习：设置单元格背景色
from openpyxl import Workbook
from openpyxl.styles import Font
from openpyxl.styles import NamedStyle, Font, Border, Side, PatternFill

if __name__ == '__main__':
    wb = Workbook()
    ws = wb.active

    highlight = NamedStyle(name="highlight")
    # highlight.font = Font(bold=True, size=20, color="ff8888")  # 设置字体颜色
    highlight.fill = PatternFill("solid", fgColor="00b050")  # 设置背景色
    # bd = Side(style='thin', color="444444")  # 设置边框thin是细，thick是粗
    # highlight.border = Border(left=bd, top=bd, right=bd, bottom=bd)  # 设置边框

    print(dir(ws["A1"]))
    ws["A1"].style = highlight

    # Save the file
    wb.save('./s2.xlsx')