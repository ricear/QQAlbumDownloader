import pandas as pd

import cv2
import os
import queue
import random
import stat
import threading
import time
import urllib
import uuid
from shutil import copyfile

import exifread
import pymongo
import qrcode as qrcode
import requests
import re
import datetime

from bson import ObjectId
from elasticsearch import Elasticsearch, helpers
from openpyxl import load_workbook, Workbook
from openpyxl.styles import NamedStyle, Font, PatternFill, Alignment
from requests.adapters import HTTPAdapter
from tqdm import tqdm

import urllib3
from PIL import Image
from lxml import etree
from selenium import webdriver
import csv
from elasticsearch import Elasticsearch

from QQAlbumDownloader.items import *
from QQAlbumDownloader.util import Configs
from QQAlbumDownloader.util.Configs import *
from QQAlbumDownloader.util.MongoDbUtils import MongoDbUtils
from QQAlbumDownloader.util.WaterMarkUtils import text_watermark
from QQAlbumDownloader.util.YDMHTTPDemo3 import YDMHttp

abspath = os.getcwd()
# 警用requests中的警告
urllib3.disable_warnings()

# 获取字符串宽度
def get_string_width(str):
    width = 0
    for char in str:
        width += get_character_width(ord(char))
    return width

# 获取字符宽度
def get_character_width( o ):
  widths = [
        (126, 1), (159, 0), (687, 1), (710, 0), (711, 1),
        (727, 0), (733, 1), (879, 0), (1154, 1), (1161, 0),
        (4347, 1), (4447, 2), (7467, 1), (7521, 0), (8369, 1),
        (8426, 0), (9000, 1), (9002, 2), (11021, 1), (12350, 2),
        (12351, 1), (12438, 2), (12442, 0), (19893, 2), (19967, 1),
        (55203, 2), (63743, 1), (64106, 2), (65039, 1), (65059, 0),
        (65131, 2), (65279, 1), (65376, 2), (65500, 1), (65510, 2),
        (120831, 1), (262141, 2), (1114109, 1),
    ]
  if o == 0xe or o == 0xf:
    return 0
  for num, wid in widths:
    if o <= num:
      return wid
  return 1

# 将数据以csv格式写入文件
def write_table_ddl_to_csv(base_path='/Users/weipeng/Personal/Work/昆山华信/外派公司/星环科技/国家电网/文档/玖天和航天宏图'):
    # base_path = '/Users/weipeng/Personal/Projects/QQAlbumDownloader/documentations'
    ddl_path = base_path + '/DDL'
    for file2 in os.listdir(ddl_path):
        if ('.DS_Store' == file2):
            continue
        print(f'正在解析sql，当前ddl文件名：%s' % (file2.split('.sql')[0]))
        with open(ddl_path + '/' + file2, 'r', encoding='GBK') as f:
            tables = []
            columns = []
            while True:
                line = f.readline()  # 整行读取数据
                if not line:
                    break
                if ('--' in line):
                    columns = []
                    table = {'name': '', 'columns': [], 'partitioned': 'NO', 'partition_key': '',
                             'partition_key_type': '', 'field_delim': '', 'location': ''}
                    continue
                if ('CREATE' in line):
                    table_name = line.split('TABLE ')[1].split('(')[0]
                    if ('`' in table_name):
                        table_name = table_name.split('`')[1]
                    table['name'] = table_name
                    continue
                if ('PARTITIONED BY' in line):
                    splits = f.readline().split(')')[0].split(' ')
                    table['partitioned'] = 'YES'
                    table['partition_key'] = name
                    table['partition_key_type'] = splits[1]
                    continue
                if ('field.delim' in line):
                    table['field_delim'] = line.split("='")[1].split("'")[0]
                    if ('\\t' == table['field_delim']):
                        table['field_delim'] = '\t'
                    continue
                if ('LOCATION' in line):
                    table['columns'] = columns
                    table['location'] = f.readline().split('\n')[0].split("'")[1]
                    tables.append(table)
                    continue
                if ('COMMENT' not in line):
                    if ('`' not in line):
                        if ('DEFAULT' not in line):
                            continue
                splits = line.split(' ')
                if ('COMMENT' not in line.upper() not in line):
                    comment = ''
                else:
                    if (len(splits) == 6):
                        comment = splits[len(splits) - 1]
                    elif (len(splits) == 7):
                        comment = splits[len(splits) - 2].split("'")[1]
                    else:
                        comment = splits[len(splits) - 3]
                    if (',' in comment):
                        comment = comment.split(',')[0].split("'")[1]
                    if ('\n' in comment):
                        comment = comment.split('\n')
                is_null = 'YES'
                if ('DEFAULT NULL' not in line):
                    is_null = 'NO'
                type = splits[1]
                if ('(' not in type and ',' in type):
                    type = type.split(',')[0]
                if ('(' not in type and ')' in type):
                    type = type.split(')')[0]
                width = ''
                if ('decimal' in type):
                    width = type.split('decimal')[1]
                    type = type.split('(')[0]
                name = splits[0]
                if ('`' in name):
                    name = name.split('`')[1]
                column = {
                    'name': name,
                    'type': type,
                    'width': width,
                    'is_null': is_null,
                    'comment': comment
                }
                columns.append(column)
        dir_name = file2.split('.sql')[0]
        if ('(' in dir_name):
            dir_name_tmp = dir_name.split('(')[0] + '-' + dir_name.split('(')[1].split(')')[0]
        else:
            dir_name_tmp = dir_name
        mkdir(base_path + '/数据字典')
        file_path = base_path + '/数据字典/数据字典(' + dir_name_tmp + ').xlsx'
        if (os.path.exists(file_path)):
            os.remove(file_path)
        wb = Workbook()
        for table in tables:
            # 创建一个新的sheet
            print('正在导入数据 -> %s %s' % (dir_name_tmp, table['name']))
            wb.create_sheet(title=table['name'])
            ws = wb[table['name']]
            count = 0
            row_names = ["字段名称", "字段含义", "数据类型", "宽度", "NULL", "Partitioned", "分区字段", "分隔符", "外表路径"]
            ws.append(row_names)
            for column in table['columns']:
                count += 1
                row = []
                row.append(column['name'])
                comment = column['comment']
                if (isinstance(column['comment'], list) and len(column['comment']) == 2):
                    comment = column['comment'][0]
                if ("'" in comment):
                    comment = comment.split("'")[1]
                if ('DEFAULT' == comment):
                    comment = ''
                row.append(comment)
                row.append(column['type'])
                row.append(column['width'])
                row.append(column['is_null'])
                if (count == 1):
                    row.append(table['partitioned'])
                    row.append(table['partition_key'])
                    if ('\t' == table['field_delim']):
                        table['field_delim'] = '\\t'
                    row.append(table['field_delim'])
                    row.append(table['location'])
                print(row)
                ws.append(row)

        # 设置表格内容字体
        font_songti = NamedStyle(name="font_songti")
        font_songti.font = Font(name='宋体', size=12)  # 设置字体颜色
        # 设置标题背景颜色
        highlight = NamedStyle(name="highlight")
        highlight.font = Font(name='宋体', size=12)  # 设置字体颜色
        highlight.alignment = Alignment(horizontal='center', vertical='center')
        highlight.fill = PatternFill("solid", fgColor="00b050")  # 设置背景色
        # 设置表格内的字体居中
        align_center = NamedStyle(name="align_center")
        align_center.font = Font(name='宋体', size=12)  # 设置字体颜色
        align_center.alignment = Alignment(vertical='center')
        # 获取每一列的最大宽度
        for sheetname in wb.sheetnames:
            ws = wb[sheetname]
            if ('Sheet' == sheetname):
                wb.remove(ws)
                continue
            columns_max_length = []
            for column_index in range(0, ws.max_column):
                max_length = 0
                for row_index in range(1, ws.max_row + 1):
                    if (ws[row_index][column_index].value == None):
                        continue
                    width = get_string_width(ws[row_index][column_index].value)
                    if (width > max_length):
                        max_length = width
                if (max_length > 40):
                    max_length = 40
                columns_max_length.append(max_length)
            # 设置表格样式
            for row_index in range(1, ws.max_row+1):
                for column_index in range(0, ws.max_column):
                    if (row_index == 1):
                        ws[row_index][column_index].style = highlight
                    else:
                        ws[row_index][column_index].style = font_songti
                    ws.column_dimensions[(chr)(ord('A') + column_index)].width = columns_max_length[column_index] + 4
            # 合并Partitioned、分区字段、分隔符、外表路径
            for column_index in range(5, ws.max_column):
                ws.merge_cells((chr)(ord('A') + column_index) + '2:' + (chr)(ord('A') + column_index) + (str)(ws.max_row))
                ws[2][column_index].style = align_center
        wb.save(file_path)

# 生成视频封面
def generate_video_poster(source_base_path, target_base_path, video_name):
    vidcap = cv2.VideoCapture(source_base_path + '/' + video_name)
    success, image = vidcap.read()
    n = 1
    while n < 30:
        success, image = vidcap.read()
        n += 1
    uuid = generate_uuid()
    poster = uuid + '.jpg'
    imag = cv2.imwrite(target_base_path + '/' + poster, image)
    if imag == True:
        print('视频封面生成成功')
        return poster
    else:
        return None

# 下载所有相册
def download_all_albums(exclude_album_names=[]):
    collection = 'album_type'
    db_utils = MongoDbUtils(collection)
    dic = {}
    albums = db_utils.find(dic)
    album_names = []
    for album in albums:
        album_name = album['name']
        if (album_name in exclude_album_names):
            continue
        album_names.append(album_name)
    download_albums(album_names)

# 下载相册中的照片
def download_albums(album_names, save_path="/Users/weipeng/Personal/Pictures"):
    collection = 'album'
    db_utils = MongoDbUtils(collection)
    total_album = len(album_names)
    album_count = 0
    for album_name in album_names:
        album_count = album_count + 1
        dic = {'album_name': album_name}
        photos = []
        total_photo = db_utils.find(dic).count()
        photo_count = 0
        for photo in db_utils.find(dic):
            photos.append(photo)
        for photo in photos:
            photo_count = photo_count + 1
            url = photo['image_without_watermark_url']
            res = get_requests().get(url, stream=True, verify=False, timeout=60)
            if res.status_code == 200:
                target_save_path = save_path + '/' + album_name
                mkdir(target_save_path)
                target_save_path = target_save_path + '/%s' % photo['image_name']
                if (os.path.exists(target_save_path)):
                    print(f'照片 %s 已存在' % photo['image_name'])
                    continue
                print(f'正在下载照片 第%s个相册，共%s个相册，第%s张，共%s张 %s' % (album_count, total_album, photo_count, total_photo, photo['image_name']))
                # 保存下载的图片
                with open(target_save_path, 'wb') as fs:
                    for chunk in res.iter_content(1024):
                        fs.write(chunk)
            time.sleep(1)

# 修改相册封面
def modify_album_cover():
    collection = 'album_type'
    db_utils = MongoDbUtils(collection)
    collection2 = 'album'
    db_utils2 = MongoDbUtils(collection2)
    dic = {}
    albums = db_utils.find(dic)
    count = 1
    total_count = albums.count()
    for album in albums:
        dic2 = {'album_name': album['name']}
        photo = db_utils2.find(dic2).sort('upload_time', pymongo.DESCENDING).__getitem__(0)
        print(photo)
        print(f'第 %s 个，当前照片 共 %s 个 %s' % (total_count, count, album['name']))
        dic = {'_id': ObjectId(album['_id'])}
        new_dic = {'$set': {'cover': photo['image_url']}}
        db_utils.update(dic, new_dic)
        count = count + 1

# 修改照片中的地址后缀
def change_photo_suffix():
    collection = 'album'
    db_utils = MongoDbUtils(collection)
    dic = {'image_url': {'$regex': '.jpg'}}
    photos = db_utils.find(dic)
    count = 1
    total_count = photos.count()
    for photo in photos:
        print(f'当前照片 ，第 %s 张，共 %s 张 %s %s' % (total_count, count, photo['album_name'], photo['image_name']))
        dic = {'_id': ObjectId(photo['_id'])}
        new_dic = {'$set': {'image_url': photo['image_url'].split('.jpg')[0] + '.jpeg'}}
        db_utils.update(dic, new_dic)
        count = count + 1

# 上传单个文件夹中的图片
def upload_image_single(source_base_path, album_name, delete_dir=True, target_base_path=IMAGES_PATH, photo_name=None):
    collection = 'album'
    db_utils = MongoDbUtils(collection)
    collection2 = 'album_type'
    db_utils2 = MongoDbUtils(collection2)
    f = album_name
    print('当前相册：' + f)
    source_base2_path = source_base_path + '/' + f
    # 判断相册类型是否存在
    dic2 = {'name': f}
    count2 = db_utils2.find(dic2).count()
    if (count2 == 0):
        # 如果相册类型不存在，则新增相册类型
        db_utils2.insert({'name': f, 'description': '', 'cover': '', 'is_private': 'false', 'create_time': get_current_time(), 'update_time': get_current_time()})
    for f2 in os.listdir(source_base2_path):
        if (f2 == '.DS_Store' or f2 != photo_name):
            continue
        image_item = ImageItem()
        source_file = source_base2_path + '/' + f2
        print('正在获取照片信息 ' + f + ' -> ' + f2)
        image_item = get_image_info(image_item, source_file)
        uuid = generate_uuid()
        dic3 = {'image_name': f2}
        if db_utils.find(dic3).count() > 0:
            print(f'照片 %s %s 已上传到服务器' %(f, f2))
            #print(f'正在删除本地照片 %s' % (source_file))
            #os.remove(source_file)
            return
        print('正在复制照片 ' + f + ' -> ' + f2)
        splits = f2.split('.')
        image_suffix = splits[len(splits) - 1].lower()
        target_file = target_base_path + '/' + uuid + '.' + image_suffix
        print('Copying file from %s to %s!' % (source_file, target_file))
        copyfile(source_file, target_file)
        image_item['album_name'] = f
        image_item['image_id'] = uuid
        image_item['image_name'] = f2
        image_item['image_without_watermark_url'] = Configs.IMAGES_HOST + '/%s.%s' % (uuid, image_suffix)
        image_item['image_type'] = image_suffix
        image_item['upload_time'] = get_current_time()
        image_item['is_private'] = 'false'
        if (image_suffix != 'mp4'):
            # 为图片添加水印
            print('正在为照片添加水印 ' + f + ' -> ' + f2)
            watermark_uuid = text_watermark(target_file, target_base_path)
            image_item['image_with_watermark_url'] = Configs.IMAGES_HOST + '/%s.%s' % (watermark_uuid, image_suffix)
        else:
            # 生成视频封面
            print('正在生成视频封面 ' + f + ' -> ' + f2)
            poster = generate_video_poster(source_base2_path, target_base_path, f2)
            splits = poster.split('.')
            image_suffix = splits[len(splits) - 1].lower()
            print('正在为视频封面添加水印 ' + f + ' -> ' + poster)
            target_file = target_base_path + '/' + poster
            watermark_uuid = text_watermark(target_file, target_base_path)
            image_item['image_with_watermark_url'] = Configs.IMAGES_HOST + '/%s.%s' % (watermark_uuid, image_suffix)
        print(image_item)
        image_item = (dict)(image_item)
        db_utils.insert(image_item)
        # print(f'正在删除本地照片 %s' %(source_file))
        # os.remove(source_file)
        dic = {'name': f}
        dic4 = {'album_name': f}
        album_photo_count = (str)(db_utils.find(dic4).count())
        newdic = {'$set': {'cover': image_item['image_with_watermark_url'], 'update_time': get_current_time(), 'count': album_photo_count}}
        db_utils2.update(dic, newdic)
    if (delete_dir == True):
        print(f'正在删除本地文件夹 %s' % (source_base2_path))
        os.rmdir(source_base2_path)

# 上传多个文件夹中的图片
def upload_image_list(source_base_path='/Volumes/MyPassport/MyPictures/Qzone', target_base_path=IMAGES_PATH):
    collection = 'album'
    db_utils = MongoDbUtils(collection)
    collection2 = 'album_type'
    db_utils2 = MongoDbUtils(collection2)
    files = os.listdir(source_base_path)
    for f in files:
        if (f == '.DS_Store'):
            continue
        print('当前相册：' + f)
        source_base2_path = source_base_path + '/' + f
        # 判断相册类型是否存在
        dic2 = {'name': f}
        count2 = db_utils2.find(dic2).count()
        if (count2 == 0):
            # 如果相册类型不存在，则新增相册类型
            db_utils2.insert({'name': f, 'description': '', 'cover': '', 'is_private': 'false', 'create_time': get_current_time(), 'update_time': get_current_time()})
        for f2 in os.listdir(source_base2_path):
            if (f2 == '.DS_Store'):
                continue
            image_item = ImageItem()
            source_file = source_base2_path + '/' + f2
            print('正在获取照片信息 ' + f + ' -> ' + f2)
            image_item = get_image_info(image_item, source_file)
            uuid = generate_uuid()
            dic3 = {'image_name': f2}
            if db_utils.find(dic3).count() > 0:
                print(f'照片 %s %s 已上传到服务器' %(f, f2))
                #print(f'正在删除本地照片 %s' % (source_file))
                #os.remove(source_file)
                continue
            print('正在复制照片 ' + f + ' -> ' + f2)
            splits = f2.split('.')
            image_suffix = splits[len(splits) - 1].lower()
            target_file = target_base_path + '/' + uuid + '.' + image_suffix
            copyfile(source_file, target_file)
            image_item['album_name'] = f
            image_item['image_id'] = uuid
            image_item['image_name'] = f2
            image_item['image_without_watermark_url'] = Configs.IMAGES_HOST + '/%s.%s' % (uuid, image_suffix)
            image_item['image_type'] = image_suffix
            image_item['upload_time'] = get_current_time()
            image_item['is_private'] = 'false'
            if (image_suffix != 'mp4'):
                # 为图片添加水印
                print('正在为照片添加水印 ' + f + ' -> ' + f2)
                watermark_uuid = text_watermark(target_file, target_base_path)
                image_item['image_with_watermark_url'] = Configs.IMAGES_HOST + '/%s.%s' % (watermark_uuid, image_suffix)
            else:
                # 生成视频封面
                print('正在生成视频封面 ' + f + ' -> ' + f2)
                poster = generate_video_poster(source_base_path, f2)
                print('正在为视频封面添加水印 ' + f + ' -> ' + poster)
                target_file = target_base_path + '/' + poster
                watermark_uuid = text_watermark(target_file, target_base_path, target_base_path)
                image_item['image_with_watermark_url'] = Configs.IMAGES_HOST + '/%s.%s' % (watermark_uuid, image_suffix)
            print(image_item)
            image_item = (dict)(image_item)
            db_utils.insert(image_item)
            #print(f'正在删除本地照片 %s' %(source_file))
            #os.remove(source_file)
            dic = {'name': f}
            dic4 = {'album_name': f}
            album_photo_count = (str)(db_utils.find(dic4).count())
            if (image_suffix != 'mp4'):
                newdic = {'$set': {'cover': image_item['image_with_watermark_url'], 'update_time': get_current_time(), 'count': album_photo_count}}
            else:
                newdic = {'$set': {'cover': image_item['image_with_watermark_url'], 'update_time': get_current_time(),
                                   'count': album_photo_count}}
            db_utils2.update(dic, newdic)
        #print(f'正在删除本地文件夹 %s' % (source_base2_path))
        #os.rmdir(source_base2_path)


# 获取照片信息
def get_image_info(image_item, path):
    f = open(path, 'rb')
    try:
        tags = exifread.process_file(f)
    except:
        return image_item
    if (len(tags) == 0):
        return image_item
    try:
        image_item['image_make'] = (str)(tags['Image Make'])
    except:
        pass
    try:
        image_item['image_model'] = (str)(tags['Image Model'])
    except:
        pass
    try:
        image_item['image_date_time'] = (str)(tags['Image DateTime'])
    except:
        pass
    try:
        image_item['image_artist'] = (str)(tags['Image Artist'])
    except:
        pass
    try:
        image_item['thumbnail_compression'] = (str)(tags['Thumbnail Compression'])
    except:
        pass
    try:
        image_item['thumbnail_resolution_unit'] = (str)(tags['Thumbnail ResolutionUnit'])
    except:
        pass
    try:
        image_item['exif_exposure_time'] = (str)(tags['EXIF ExposureTime'])
    except:
        pass
    try:
        image_item['exif_f_number'] = (str)(tags['EXIF FNumber'])
    except:
        pass
    try:
        image_item['exif_iso_speed_ratings'] = (str)(tags['EXIF ISOSpeedRatings'])
    except:
        pass
    try:
        image_item['exif_exif_image_width'] = (str)(tags['EXIF ExifImageWidth'])
    except:
        pass
    try:
        image_item['exif_exif_image_length'] = (str)(tags['EXIF ExifImageLength'])
    except:
        pass
    return image_item

# 下载图片到本地
def download_images(url):
    res = get_requests().get(url, stream=True, verify=False, timeout=60)
    if res.status_code == 200:
        uuid = generate_uuid()
        save_img_path = Configs.IMAGES_PATH + '/%s.jpg' % uuid
        # 保存下载的图片
        with open(save_img_path, 'wb') as fs:
            for chunk in res.iter_content(1024):
                fs.write(chunk)
        return Configs.IMAGES_HOST + '/%s.jpg' % uuid

# 获取mongodb的字段名称列表
def get_field_list(file_path, file_name):
    return read_file(file_path, file_name)

# 将数据以csv格式写入文件
def write_data_to_csv(file_path, file_name, field_list, data_list, date, has_row_name = False, row_names=[]):
    # 一次同步的数据量，批量同步
    syncCountPer = 1000
    # 1. 创建文件对象
    f = open(file_path + '/' + file_name + '.csv', 'w', encoding='utf-8', newline='')
    # 2. 基于文件对象构建 csv写入对象
    csv_writer = csv.writer(f)
    # 3. 构建列表头
    if (has_row_name == True):
        csv_writer.writerow(row_names)
    # 4. 写入csv文件内容
    # csv_writer.writerow(["l", '18', '男'])
    count = 0
    collection = file_name.split('.')[0]
    for data in data_list:
        count += 1
        row = []
        for field in field_list:
            row.append(data[field])
        csv_writer.writerow(row)
        if (count % syncCountPer == 0):
            print(f"{collection} for {date} -> Had sync {count} records at {datetime.datetime.now()}")
    print(f"{collection} for {date} -> Had sync {count} records at {datetime.datetime.now()}")
    # 5. 关闭文件
    f.close()

# 将mongodb中的数据下载到本地(csv)
def mongo_to_local(day_delta=0, hour_delta=0, minute_delta=0, second_delta=0, format=format, target_date=None):
    # mongod 需要同步的数据库名
    DB = 'pocket'
    # mongod 需要同步的表名
    COLLECTION_LIST = ['movie', 'tv', 'drama', 'piece']
    for COLLECTION in COLLECTION_LIST:
        db_utils = MongoDbUtils(COLLECTION)
        today_yyyy_mm_dd = get_time_by_delta(day_delta=day_delta, hour_delta=hour_delta, minute_delta=minute_delta, second_delta=second_delta, format=format)
        if (target_date != None):
            today_yyyy_mm_dd = get_date_str_from_date_str(target_date, DATE_FORMAT_YEARMONTHDAY, DATE_FORMAT_YEAR_MONTH_DAY)
        today_yyyymmdd = get_date_str_from_date_str(today_yyyy_mm_dd, source_format=DATE_FORMAT_YEAR_MONTH_DAY, dest_format=DATE_FORMAT_YEARMONTHDAY)
        dict = {'acquisition_time': re.compile(today_yyyy_mm_dd)}
        # dict = {}
        field_list = get_field_list(FIELD_PATH, COLLECTION + '.txt')
        mongoRecordRes = db_utils.find(dict)
        dest_path = EXPORT_PATH + '/' + today_yyyymmdd
        mkdir(dest_path)
        write_data_to_csv(dest_path, COLLECTION, field_list, mongoRecordRes, today_yyyymmdd)

# 获取requests对象
def get_requests():
    session = requests.Session()
    # 超时自动重试3次
    session.mount('http://', HTTPAdapter(max_retries=3))
    session.mount('https://', HTTPAdapter(max_retries=3))
    return session

# 将unicode字符串解析成指定格式的字符串
def parse_unicode(unicode_str, encoding='utf-8'):
    str = urllib.parse.unquote(unicode_str)
    return str.replace('%', '\\').encode(encoding).decode('unicode_escape')

# 对video_info_list进行处理，返回相应的资源列表(xunleiyy)
def handle_with_video_info_list(video_info_list):
    sources = []
    index = 0
    types = []
    source = {'name': '', 'types': []}
    for video_info in video_info_list.split('#'):
        splits = video_info.split('$')
        if (len(splits) == 5):
            source['name'] = splits[0]
            type = {'name': splits[2], 'url': splits[3]}
            types.append(type)
        elif (len(splits) == 3):
            type = {'name': splits[0], 'url': splits[1]}
            types.append(type)
        elif (len(splits) == 10):
            type = {'name': splits[0], 'url': splits[1]}
            types.append(type)
            source['types'] = types
            sources.append(source)
            types = []
            source = {'name': '', 'types': []}
            source['name'] = splits[5]
            type = {'name': splits[7], 'url': splits[8]}
            types.append(type)
        elif (len(splits) == 12):
            source['name'] = splits[0]
            type = {'name': splits[2], 'url': splits[3]}
            types.append(type)
            source['types'] = types
            sources.append(source)
            types = []
            source = {'name': '', 'types': []}
            source['name'] = splits[7]
            type = {'name': splits[9], 'url': splits[10]}
            types.append(type)
    source['types'] = types
    sources.append(source)
    return sources

# 对mac_url进行处理，返回相应的资源列表(ziyuan88ys)
def handle_with_mac_url(source_name_list, mac_url):
    sources = []
    index = 0
    source = {'name': source_name_list[index], 'types': []}
    types = []
    for url in mac_url.split('#'):
        splits = url.split('$')
        type = {'name': splits[0], 'url': splits[1]}
        types.append(type)
        if ('$$$' in url):
            source['types'] = types
            sources.append(source)
            index = index + 1
            source = {'name': source_name_list[index], 'types': []}
            type = {'name': splits[4], 'url': splits[5]}
            types = [type]
        source['types'] = types
    sources.append(source)
    return sources

# 将mongodb中的数据同步到elasticsearch
def mongo_to_es(day_delta=0, hour_delta=0, minute_delta=0, second_delta=0, format=format, target_date=None):
    # 一次同步的数据量，批量同步
    syncCountPer = 1000

    # mongod 需要同步的数据库名
    DB = 'pocket'
    # mongod 需要同步的表名
    COLLECTION_LIST = ['movie', 'tv', 'drama', 'piece']
    for COLLECTION in COLLECTION_LIST:
        count = 0
        db_utils = MongoDbUtils(COLLECTION)
        es = Elasticsearch(ES_URL)
        syncDataLst = []
        today = get_time_by_delta(day_delta=day_delta, hour_delta=hour_delta, minute_delta=minute_delta, second_delta=second_delta, format=format)
        if (target_date != None):
            today = get_date_str_from_date_str(target_date, DATE_FORMAT_YEARMONTHDAY, DATE_FORMAT_YEAR_MONTH_DAY)
        print(f'Current collection is {COLLECTION} for {today}：')
        dict = {'acquisition_time': re.compile(today)}
        # dict = {}
        mongoRecordRes = db_utils.find(dict)
        for record in mongoRecordRes:
            count += 1
            # 因为mongodb和Es中，对于数据类型的支持是有些差异的，所以在数据同步时，需要对某些数据类型和数据做一些加工
            record['acquisition_time_yyyyMMddHHmmss'] = get_date_str_from_date_str(record['acquisition_time'])
            syncDataLst.append({
                "_index": f'{DB}-{COLLECTION}',  # mongod数据库 == Es的index
                "_type": COLLECTION,  # mongod表名 == Es的type
                "_id": (str)(record.pop('_id')),
                "_source": record,
            })
            if len(syncDataLst) == syncCountPer:
                # 批量同步到Es中，就是发送http请求一样，数据量越大request_timeout越要拉长
                helpers.bulk(es,
                             syncDataLst,
                             request_timeout=180)
                # 清空数据列表
                syncDataLst[:] = []
                print(f"{COLLECTION} for {today} -> Had sync {count} records at {datetime.datetime.now()}")
        # 同步剩余部分
        if syncDataLst:
            helpers.bulk(es,
                         syncDataLst,
                         request_timeout=180)
            print(f"{COLLECTION} for {today} -> Had sync {count} records rest at {datetime.datetime.now()}")

# 修改图片地址(将包含/public...的地址修改为images.grayson.top的形式)
def modify_src():
    collections = ['movie', 'tv', 'drama', 'piece']
    for collection in collections:
        db_utils = MongoDbUtils(collection)
        dic = [{'src': {'$regex': '/public/'}}, {'_id': 0, 'src': 1}]
        url_list = []
        for src in db_utils.find(dic):
            url = src['src']
            url_list.append(url)
        download_image(db_utils, url_list)

# 生成uuid
def generate_uuid():
    uid = str(uuid.uuid4())
    suid = ''.join(uid.split('-'))
    return suid

# 下载影视图片
def download_film_image():
    collections = ['movie', 'tv', 'drama', 'piece']
    for collection in collections:
        db_utils = MongoDbUtils(collection)
        # 查询图片地址中不包含images.grayson.top的数据，然后下载图片并修改图片地址
        dic = [{'src': {'$regex': '^((?!images.grayson.top).)*$'}}, {'_id': 0, 'src': 1}]
        url_list = []
        for src in db_utils.find(dic):
            url = src['src']
            url_list.append(url)
        download_image(db_utils, url_list)

# 多线程下载图片
def download_image(db_utils, url_list, thread_num=10):
    start = time.time()
    for index,url in enumerate(url_list):
        origin_url = url
        if ('http' not in url and 'https' not in url):
            url = 'https:' + url
        print(url)
        try:
            res = get_requests().get(url, stream=True, timeout=60)
        except:
            continue
        print(res.status_code)
        if res.status_code == 200:
            uuid = generate_uuid()
            save_img_path = Configs.IMAGES_PATH + '/%s.jpg' % uuid
            # 保存下载的图片
            print('正在下载第%s张图片，共%s张图片' %(index,len(url_list)))
            with open(save_img_path, 'wb') as fs:
                for chunk in res.iter_content(1024):
                    fs.write(chunk)
            print('正在下载第%s张图片，共%s张图片' %(index,len(url_list)))
            print(url)
            dic = {'src': origin_url}
            new_dic = {'$set': {'src': Configs.IMAGES_HOST + '/' + uuid + '.jpg'}}
            db_utils.update(dic, new_dic)
            print('修改完成')
    print('用时：' + (str)(time.time() - start))

# 合并名称播放地址的小品
def combine_piece():
    collection = 'piece'
    db_utils = MongoDbUtils(collection)
    aggregate = [{ "$group": {"_id": {"url": "$url"},"count": {"$sum": 1}}},{ "$project" : {"_id": 0, "url" : "$_id.url", "count" : 1}},{"$match":{"count": {"$gt" : 1}}},{"$sort":{"count" : -1}}]
    aggregate_movies = db_utils.aggregate(aggregate)
    count = 0
    index = 1
    for aggregate_movie in aggregate_movies:
        count = count + 1
    aggregate_movies = db_utils.aggregate(aggregate)
    for aggregate_movie in aggregate_movies:
        try:
            dic = {'url': aggregate_movie['url']}
            movie_server = db_utils.find(dic).__getitem__(0)
            delete_dic = {'url': aggregate_movie['url'], 'drama_url': {'$ne': movie_server['drama_url']}}
            db_utils.delete(delete_dic)
            print('共 '+(str)(count)+' 个，当前第 '+(str)(index)+' 个 -> ' + aggregate_movie['url'])
            index = index + 1
        except:
            continue


# 修改小品的类型
def modify_piece_type(type, type2):
    collection = 'piece_type'
    db_utils = MongoDbUtils(collection)
    dic = {'name': type}
    piece_type = {'name': '', 'types': []}
    types = []
    try:
        if db_utils.find(dic).count() == 0:
            piece_type['name'] = type
            if (type2 != ''):
                types.append(type2)
            piece_type['types'] = types
            db_utils.insert(piece_type)
        else:
            types_server = db_utils.find(dic).__getitem__(0)['types']
            types = types_server
            flag = 0
            if (type2 != '' and type2 not in types_server):
                types.append(type2)
                flag = 1
            if (flag == 1):
                new_dic = {'$set': {'types': types}}
                db_utils.update(dic, new_dic)
    except:
        modify_piece_type(type, type2)

# 将一个日期字符串转换为指定格式的日期字符串
def get_date_str_from_date_str(date_str,source_format=DATE_FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND, dest_format=DATE_FORMAT_YEARMONTHDAYHOURMINUTESECOND):
    date = datetime.datetime.strptime(date_str, source_format)
    return date.strftime(dest_format)

# 获取今天的日期
def get_today():
    today=datetime.date.today()
    return (str)(today)

# 获取昨天的日期
def get_yesterday():
    today=datetime.date.today()
    oneday=datetime.timedelta(days=1)
    yesterday=today-oneday
    return (str)(yesterday)

# 修改影视的评分
def modify_score():
    collection = 'movie'
    db_utils = MongoDbUtils(collection)
    dic = {'score': '0.0'}
    new_dic = {'$set': {'score': get_random_str()}}
    db_utils.update(dic, new_dic)

# 修改影视的更新状态
def modify_update_status():
    collection = 'movie'
    db_utils = MongoDbUtils(collection)
    dic = {'$or': [{'update_status': ''}, {'update_status': None}]}
    index = 1
    movies = db_utils.find(dic)
    total = movies.count()
    for movie in movies:
        print((str)(index) + '/' + (str)(total) + ' ' +  movie['id'] + ' ' + movie['name'])
        dic = {'id': movie['id']}
        new_dic = {'$set': {'update_status': movie['sources'][0]['name']}}
        print(dic)
        print(new_dic)
        db_utils.update(dic, new_dic)
        index += 1

# 转换影视资源类型名称，例如将1转换为01
def reverse_type_name(type_name):
    if (len(type_name) == 1):
        type_name = '0' + type_name
    return type_name

# 从影视资源类型名称中获取年份
def get_year_from_name(name):
    if (len(name.split(' ')[0].split('')) >= 4):
        return name.split(' ')[0][4:]
    else:
        return name.split(' ')[1][4:]

# 生成下载掌上影视APP二维码
def generate_app_qrcode_image():
    url = 'http://api.grayson.top/public/apks/PocketFilm.apk'
    generate_qrcode_image(url)

# 根据url生成二维码
def generate_qrcode_image(url):
    qr = qrcode.QRCode(
        version=2,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=5.1,
        border=1
    )  # 设置二维码的大小
    qr.add_data(url)
    qr.make(fit=True)
    img = qr.make_image()
    img.save("image/qrcode.png")

# 修改图片中的地址后缀
def change_src_suffix(old_suffix, new_suffix):
    collection = 'movie'
    db_utils = MongoDbUtils(collection)
    dic = {'src': {'$regex': '/.'+old_suffix+'/'}}
    for movie in db_utils.find({'src': {'$regex': ".*webp"}}):
        dic = {'id': movie['id']}
        new_dic = {'$set': {'src': movie['src'].replace(old_suffix, new_suffix)}}
        db_utils.update(dic, new_dic)

# 获取排除在外的影视第二类型列表
def get_exclude_type2_list():
    exclude_type2_list = ['儿童片', '短片片', '奇幻片', '魔幻片', '励志片', '剧情片', '剧情片', '西部片', '戏曲片', '黑色片', '少儿片', '西部片', '电影节目片',
                          '校园片', '恋爱片', '歌舞片', '记录片', '院线片', '枪战片', '印度片', '华语片', '网络大电影片', '亲情片', '伦理片', '音乐片', '公益片',
                          '搞笑片', '美少女片', '益智片', '推理片', '格斗片', '竞技片', '真人片', '美食片', '同性片', '杜比音效片', '内地片', '吸血鬼片', '社会片',
                          '教育片', '亲子片', '魔法片', '同人片', '忍者片', '热血片', '普通话片', '漫画改编片', '闽南语片', '原创片', '日语片', '中国大陆片',
                          '7-10岁片', '0-3岁片', '合家欢片', '早教益智片', '轻小说改编片', '数学片', '真人特摄片', '布袋戏片', '动漫冒险片', '综艺真人秀片',
                          '综艺真人秀音乐片', '欧美动漫片', '综艺脱口秀片', '综艺音乐片', '国产动漫片', '内地综艺片', '港台综艺片', '日韩动漫片', '日韩综艺片', '欧美综艺片',
                          '海外动漫片', '港台动漫片', '少儿综艺片', '国产剧预告片', '近代片', '综艺脱口秀真人秀片', '4K片', '综艺真人秀 音乐片', '综艺脱口秀 真人秀片',
                          '喜剧剧', '奇幻剧', '抗日剧', '魔幻剧', '腾讯出品剧', '校园剧', '搞笑剧', '玄幻剧', '时装剧', '职场剧', '经侦剧', '罪案剧', '医疗剧', '歌舞剧',
                          '内地剧', '日剧', '韩剧', '台剧', '港剧', '连续剧', '韩国喜剧', '国产喜剧', '欧美喜剧', '台湾喜剧', '欧美剧家庭 喜剧', '日剧喜剧', '泰剧喜剧',
                          '泰剧家庭 喜剧', '港剧喜剧', '日剧家庭 喜剧', '越南剧', '优酷出品剧', '港剧家庭 喜剧', '近代剧', '侦探剧', '儿童综艺片', '美术片', '机战片',
                          '故事片', '公主片', '悲剧片', '文艺片', 'OLI片', '国学片', '学英语片', '识字片', '百科片', '漫改片', '漫画改编剧', '动画剧', '原创剧', '院线剧',
                          '自制剧', '言情剧', '商战剧', '伦理类', '轻改片', '经典片', '舞蹈片', '手工片', '诗词片', '催泪片', '港台综艺片', '日韩动漫片', '国产动漫片', '欧美动漫片']
    return exclude_type2_list

# 修改影视第二类型
def modify_movie_type2(type2_list):
    # 更新影视中相关的影视类型
    collection = 'movie'
    db_utils = MongoDbUtils(collection)
    for type2 in type2_list:
        dic = {'type2': type2}
        new_dic = {'$set': {'type2': reverse_type2(type2)}}
        db_utils.update(dic, new_dic)

    # 删除影视类型中相关类型
    collection = 'movie_type'
    db_utils = MongoDbUtils(collection)
    dic = {'type': '分类'}
    tmp_type_list = []
    for type2 in db_utils.find(dic).__getitem__(0)['names']:
        if (type2 not in type2_list):
            tmp_type_list.append(type2)
    # 将新的影视类型更新到数据库
    new_dic = {'$set': {'names': tmp_type_list}}
    db_utils.update(dic, new_dic)

# 合并名称相同的影视
def combine_movie():
    collection = 'movie'
    db_utils = MongoDbUtils(collection)
    aggregate = [{ "$group": {"_id": {"name": "$name", "type": "$type"},"count": {"$sum": 1}}},{ "$project" : {"_id": 0, "name" : "$_id.name", "type" : "$_id.type", "count" : 1}},{"$match":{"count": {"$gt" : 1}}},{"$sort":{"count" : -1}}]
    aggregate_movies = db_utils.aggregate(aggregate)
    count = 0
    index = 1
    for aggregate_movie in aggregate_movies:
        count = count + 1
    aggregate_movies = db_utils.aggregate(aggregate)
    for aggregate_movie in aggregate_movies:
        dic = {'name': aggregate_movie['name']}
        tmp_sources = []
        # 最近更新的一个视频
        movies = db_utils.find(dic).sort('update_time', -1)
        tmp_movie = movies[0]
        for movie in movies:
            for source in movie['sources']:
                if (source in tmp_sources):
                    continue
                tmp_sources.append(source)
            # 删除已经获取资源的视频
            if (movie['id'] != tmp_movie['id']):
                delete_dic = {'id': movie['id']}
                db_utils.delete(delete_dic)
        # 将名称相同的视频资源更新到最近更新的一个视频上
        dic = {'id': tmp_movie['id']}
        update_dic = {'$set': {'sources': tmp_sources}}
        db_utils.update(dic, update_dic)
        print('共 '+(str)(count)+' 个，当前第 '+(str)(index)+' 个 -> ' + tmp_movie['id'] + ' ' + tmp_movie['name'])
        index = index + 1


# 判断小品类型是否在被排除的类型里面
def exclude_piece_type2(type2):
    exclude_type2_list = [
        '床戏',
        '吻戏'
    ]
    if (type2 in exclude_type2_list):
        return True
    return False

# 转换更新日期
def reverse_update_time(update_time):
    if (
            update_time == ''
    ):
        release_date = '0'
    return update_time

# 转换发布日期
def reverse_release_date(release_date):
    if (
            release_date == '' or
            release_date == '未知'
    ):
        release_date = '0'
    return release_date

# 删除不正确播放地址的戏曲视频
def delete_drama_with_url_invalid():
    collection = 'drama'
    db_utils = MongoDbUtils(collection)
    dict = {}
    data = db_utils.find(dict)
    total = data.count()
    index = 1
    invalid_index = 1
    for drama in data:
        for source in drama['sources']:
            for type in source['types']:
                if (type['url'].split('id_')[1].split('==')[0] == ''):
                    dic = {'id': drama['id']}
                    db_utils.delete(dic)
                    print('共'+(str)(total)+'个视频，正在查找第'+(str)(index)+'个视频，已删除'+(str)(invalid_index)+'个视频 -> ' + drama['id'] + ' ' + drama['name'])
                    invalid_index = invalid_index + 1
                index = index + 1

# 判断影视第二类型是否需要排除
def is_exclude_type2(type2):
    if (
            type2.find('福利片') != -1 or
            type2.find('伦理片') != -1 or
            type2.find('伦理类') != -1 or
            type2.find('音乐片') != -1 or
            type2.find('美女视频秀') != -1 or
            type2.find('嫩妹写真') != -1 or
            type2.find('VIP视频秀') != -1 or
            type2.find('高跟赤足视频') != -1 or
            type2.find('美女热舞写真') != -1 or
            type2.find('视讯美女') != -1 or
            type2.find('腿模写真') != -1 or
            type2.find('街拍系列') != -1 or
            type2.find('街拍美女视频') != -1 or
            type2.find('激情写真') != -1 or
            type2.find('美女') != -1 or
            type2.find('爆笑') != -1 or
            type2.find('神曲') != -1
    ):
        return True
    return False

# 判断当前资源是否需要爬取
def is_need_source(item, collection):
    db_utils = MongoDbUtils(collection)
    dic = {'name': item['name'], 'type': item['type']}
    movie_server = db_utils.find(dic)
    if (movie_server.count() == 0):
        return True
    item_source = item['sources'][0]
    for source in movie_server.__getitem__(0)['sources']:
        if (source['name'] == item_source['name'] and len(source['types']) == len(item_source['types'])):
            return False
    return True

# 根据影视第二类型type2获取第一类型type
def get_type_from_type2(type2):
    type = ''
    if type2.find('综艺') != -1:
        type = '综艺'
    elif type2.find('动漫') != -1:
        type = '动漫'
    elif type2.find('片') != -1:
        type = '电影'
    elif type2.find('剧') != -1:
        type = '电视剧'
    return type

# 批量修改电视中的图片地址
def update_src_batch(old_suffix, new_suffix):
    collection = 'tv'
    db_utils = MongoDbUtils(collection)
    dic = {'src': {'$regex': '/'+old_suffix+'/'}}
    for item in db_utils.find(dic):
        dic = {'_id': item['_id']}
        splits = item['src'].split(old_suffix)
        new_dic = {'$set': {'src': splits[0] + new_suffix + splits[1]}}
        db_utils.update(dic, new_dic)

# 对数组中的元素去空格
def strip_arr(arr):
    new_arr = []
    for item in arr:
        new_arr.append(item.strip(' '))
    return new_arr

# 将一个数组逆序排列
def reverse_arr(arr):
    new_arr = []
    for i in reversed(arr):
        new_arr.append(i)
    return new_arr

# 向字典中添加新的元素
def insert_item_to_dic(dic, key, new_key, new_value):
    arr = dic.get(key)
    arr[new_key] = new_value
    dic[key] = arr
    return dic

# 转换电视中的类型
def reverse_tv_type(type):
    if (type == 'CCTV频道'): type = '央视台'
    elif (type == '卫视频道'): type = '卫视台'
    elif (type == '港澳台频道'): type = '港澳台'
    elif (type == '国外电视台'): type = '海外台'
    return type

# 转换地区
def reverse_region(region):
    if (region == '内地' or region == '中国' or region == '中国大陆' or region == '华语'):
        region = '大陆'
    elif (region == '美国' or region == '英国' or region == '法国' or region == '德国' or region == '意大利'):
        region = '欧美'
    elif (region == '中国香港' or region == '香港地区'):
        region = '香港'
    elif (region == '中国台湾'):
        region = '台湾'
    elif (region == '其它'):
        region = '其他'
    return region


# 转换影视第二类型
def reverse_type2(type2):
    if (type2 == '内地'):
        type2 = '国产剧'
    elif (type2 == '美国' or type2 == '英国'):
        type2 = '欧美剧'
    elif (type2 == '韩国'):
        type2 = '韩国剧'
    elif (type2 == '泰国'):
        type2 = '海外剧'
    elif (type2 == '日本'):
        type2 = '日本剧'
    elif (type2 == '中国香港'):
        type2 = '香港剧'
    elif (type2 == '中国台湾'):
        type2 = '台湾剧'
    elif (type2 == '其他'):
        type2 = '海外剧'
    elif (type2 == '儿童片'):
        type2 = '动画片'
    elif (type2 == '短片片'):
        type2 = '短片'
    elif (type2 == '奇幻片'):
        type2 = '科幻片'
    elif (type2 == '魔幻片'):
        type2 = '科幻片'
    elif (type2 == '励志片'):
        type2 = '剧情片'
    elif (type2 == '公益片'):
        type2 = '剧情片'
    elif (type2 == '西部片'):
        type2 = '其他片'
    elif (type2 == '戏曲片'):
        type2 = '其他片'
    elif (type2 == '黑色片'):
        type2 = '其他片'
    elif (type2 == '少儿片'):
        type2 = '动画片'
    elif (type2 == '西部片'):
        type2 = '其他片'
    elif (type2 == '电影节目片'):
        type2 = '纪录片'
    elif (type2 == '校园片'):
        type2 = '青春片'
    elif (type2 == '恋爱片'):
        type2 = '青春片'
    elif (type2 == '歌舞片'):
        type2 = '剧情片'
    elif (type2 == '记录片'):
        type2 = '纪录片'
    elif (type2 == '院线片'):
        type2 = '其他片'
    elif (type2 == '枪战片'):
        type2 = '动作片'
    elif (type2 == '印度片'):
        type2 = '其他片'
    elif (type2 == '华语片'):
        type2 = '其他片'
    elif (type2 == '儿童综艺片'):
        type2 = '其他片'
    elif (type2 == '美术片'):
        type2 = '其他片'
    elif (type2 == '机战片'):
        type2 = '其他片'
    elif (type2 == '故事片'):
        type2 = '其他片'
    elif (type2 == '公主片'):
        type2 = '其他片'
    elif (type2 == '悲剧片'):
        type2 = '其他片'
    elif (type2 == '文艺片'):
        type2 = '其他片'
    elif (type2 == 'LOLI片'):
        type2 = '其他片'
    elif (type2 == '国学片'):
        type2 = '其他片'
    elif (type2 == '学英语片'):
        type2 = '其他片'
    elif (type2 == '识字片'):
        type2 = '其他片'
    elif (type2 == '百科片'):
        type2 = '其他片'
    elif (type2 == '漫改片'):
        type2 = '其他片'
    elif (type2 == '网络大电影片'):
        type2 = '短片'
    elif (type2 == '亲情片'):
        type2 = '家庭片'
    elif (type2 == '喜剧剧'):
        type2 = '喜剧'
    elif (type2 == '奇幻剧'):
        type2 = '科幻剧'
    elif (type2 == '抗日剧'):
        type2 = '谍战剧'
    elif (type2 == '魔幻剧'):
        type2 = '科幻剧'
    elif (type2 == '校园剧'):
        type2 = '青春剧'
    elif (type2 == '搞笑剧'):
        type2 = '喜剧'
    elif (type2 == '玄幻剧'):
        type2 = '古装剧'
    elif (type2 == '时装剧'):
        type2 = '其他剧'
    elif (type2 == '职场剧'):
        type2 = '其他剧'
    elif (type2 == '经侦剧'):
        type2 = '刑侦剧'
    elif (type2 == '罪案剧'):
        type2 = '刑侦剧'
    elif (type2 == '医疗剧'):
        type2 = '其他剧'
    elif (type2 == '歌舞剧'):
        type2 = '其他剧'
    elif (type2 == '内地剧'):
        type2 = '国产剧'
    elif (type2 == '日剧'):
        type2 = '日本剧'
    elif (type2 == '韩剧'):
        type2 = '韩国剧'
    elif (type2 == '台剧'):
        type2 = '台湾剧'
    elif (type2 == '港剧'):
        type2 = '香港剧'
    elif (type2 == '连续剧'):
        type2 = '其他剧'
    elif (type2 == '韩国喜剧'):
        type2 = '喜剧'
    elif (type2 == '国产喜剧'):
        type2 = '喜剧'
    elif (type2 == '欧美喜剧'):
        type2 = '喜剧'
    elif (type2 == '台湾喜剧'):
        type2 = '喜剧'
    elif (type2 == '欧美剧家庭 喜剧'):
        type2 = '喜剧'
    elif (type2 == '日剧喜剧'):
        type2 = '喜剧'
    elif (type2 == '泰剧喜剧'):
        type2 = '喜剧'
    elif (type2 == '泰剧家庭 喜剧'):
        type2 = '喜剧'
    elif (type2 == '港剧喜剧'):
        type2 = '喜剧'
    elif (type2 == '日剧家庭 喜剧'):
        type2 = '喜剧'
    elif (type2 == '越南剧'):
        type2 = '海外剧'
    elif (type2 == '优酷出品剧'):
        type2 = '其他剧'
    elif (type2 == '港剧家庭 喜剧'):
        type2 = '喜剧'
    elif (type2 == '近代剧'):
        type2 = '其他剧'
    elif (type2 == '漫画改编剧'):
        type2 = '其他剧'
    elif (type2 == '动画剧'):
        type2 = '儿童剧'
    elif (type2 == '原创剧'):
        type2 = '其他剧'
    elif (type2 == '院线剧'):
        type2 = '其他剧'
    elif (type2 == '自制剧'):
        type2 = '其他剧'
    elif (type2 == '言情剧'):
        type2 = '剧情剧'
    elif (type2 == '商战剧'):
        type2 = '剧情剧'
    elif (type2 == '侦探剧'):
        type2 = '刑侦剧'
    return type2


# 获取年份
def get_year():
    # 优化格式化化版本
    format = '%Y'
    return time.strftime(format, time.localtime(time.time()))

# 获取与当前日期相差delta的日期
def get_time_by_delta(day_delta=0, hour_delta=0, minute_delta=0, second_delta=0, format='%Y-%m-%d %H:%M:%S'):
    return (datetime.datetime.now() + datetime.timedelta(days=day_delta, hours=hour_delta, minutes=minute_delta, seconds=second_delta)).strftime(format)

# 获取当前时间
def get_current_time(format='%Y-%m-%d %H:%M:%S'):
    # 优化格式化化版本
    return get_time_by_delta(format=format)

# 产生指定范围的随机数，小数的范围m ~ n，小数的精度p
def get_random_str(m=5, n=10, p=1):
    a = random.uniform(m, n)
    return (str)(round(a, p))


# 从xpath中获取数组
def get_arr_from_xpath(xpath):
    if len(xpath) == 0:
        return []
    else:
        return (str)(xpath[0]).split(',')


# 从xpath中获取字符串
def get_str_from_xpath(xpath):
    if len(xpath) == 0:
        return ''
    else:
        return (str)(xpath[0]).strip()


# 下载文件
def downloadFile(url, path, name):
    resp = get_requests().get(url=url, stream=True, verify=False, timeout=60)
    # stream=True的作用是仅让响应头被下载，连接保持打开状态，
    content_size = int(resp.headers['Content-Length']) / 1024  # 确定整个安装包的大小
    with open(path + '/' + name, "wb") as f:
        print("整个文件大小是是：", content_size / 1024, 'M')
        for data in tqdm(iterable=resp.iter_content(1024), total=content_size, unit='k', desc=name):
            # 调用iter_content，一块一块的遍历要下载的内容，搭配stream=True，此时才开始真正的下载
            # iterable：可迭代的进度条 total：总的迭代次数 desc：进度条的前缀
            f.write(data)


# g_tk算法
def get_g_tk(p_skey):
    hashes = 5381
    for letter in p_skey:
        hashes += (hashes << 5) + ord(letter)  # ord()是用来返回字符的ascii码
    return (str)(hashes & 0x7fffffff)


# 创建文件夹
def mkdir(path):
    # 引入模块
    import os
    # 去除首位空格
    path = path.strip()
    # 去除尾部 \ 符号
    path = path.rstrip("\\")
    # 判断路径是否存在
    # 存在     True
    # 不存在   False
    isExists = os.path.exists(path)
    # 判断结果
    if not isExists:
        # 如果不存在则创建目录
        # 创建目录操作函数
        os.makedirs(path)
        print(path + ' 创建成功')
    else:
        # 如果目录存在则不创建，并提示目录已存在
        print(path + ' 目录已存在')
    return True


# 滑动到页面最低端
def scrollToBottom(driver, frame_name):
    driver.switch_to.frame(frame_name)
    source1 = driver.page_source
    driver.switch_to.parent_frame()
    driver.execute_script("window.scrollTo(0,document.body.scrollHeight)");
    time.sleep(4)
    driver.switch_to.frame(frame_name)
    source2 = driver.page_source
    while source1 != source2:
        source1 = source2
        driver.switch_to.parent_frame()
        driver.execute_script("window.scrollTo(0,document.body.scrollHeight)");
        time.sleep(4)
        driver.switch_to.frame(frame_name)
        source2 = driver.page_source


# 判断数据是否爬取
def check_spider_history(type, url, text='爬取'):
    if os.path.exists(abspath + '/documentations/history/' + type + '.txt') == False:
        return False
    histories = get_spider_history(type)
    if url + '\n' in histories:
        print(type + ' -> ' + url + ' 已' + text)
        return True
    else:
        print(type + ' -> ' + url + ' 未' + text)
        return False
    return url in histories


# 读取数据爬取的历史
def get_spider_history(type):
    file_path = abspath + '/documentations/history'
    file_name = type + '.txt'
    return read_file(file_path, file_name)

# 读取文件数据
def read_file(file_path, file_name):
    with open(file_path + '/' + file_name, 'r') as f:
        list = []
        while True:
            line = f.readline().split('\n')[0]  # 整行读取数据
            if not line:
                break
            list.append(line)
    return list


# 写入数据爬取的历史
def write_spider_history(type, url, text='写入成功'):
    if (check_spider_history(type, url) == False):
        with open(abspath + '/documentations/history/' + type + '.txt', 'a') as f:
            f.write(url)
            f.write('\n')
            print(type + ' -> ' + url + ' ' + text)
        f.close()


# 更新视频解析网站的哈希值
def update_parsevideo_hash():
    html = get_one_page('https://pocket.mynatapp.cc')
    pattern = '[\s\S]*?var hash = "([\s\S]*?)"[\s\S]*?'
    old_hash = ''
    for tmp_hash in parse_one_page(html, pattern):
        old_hash = tmp_hash
    html = get_one_page('https://www.parsevideo.com/')
    pattern = '[\s\S]*?var hash = "([\s\S]*?)"[\s\S]*?'
    new_hash = ''
    for tmp_hash in parse_one_page(html, pattern):
        new_hash = tmp_hash
    html = get_one_page('https://pocket.mynatapp.cc')
    html = html.replace('var hash = "' + old_hash + '";', 'var hash = "' + new_hash + '";')
    with open('../../../Web/PocketFilm/views/index.html', 'w') as f:
        f.write(html)


# 解决视频解析时的验证码问题
def solve_parsevideo_captche(url='https://pocket.mynatapp.cc/#https://v.youku.com/v_show/id_XMzc5OTM0OTAyMA==.html'):
    driver = get_driver(1)
    driver.maximize_window()
    driver.get(url)
    html = driver.page_source
    if 'style="margin-bottom: 15px;display: none"' in html:
        driver.find_element_by_id('url_submit_button').click()
        time.sleep(2)
        element = driver.find_element_by_id('captcha_img')
        capture(driver, element)
        code = captcha()
        driver.find_element_by_id('captcha_code').send_keys(code)
        driver.find_element_by_id('captcha_sbumit').click()
        time.sleep(2)
        driver.refresh()
    else:
        print('当前不用输入验证码')
    driver.quit()


# 裁剪指定元素
def capture(driver, element, image_path=abspath + '/image', image_name='captcha'):
    """
    截图,指定元素图片
    :param element: 元素对象
    :return: 无
    """
    """图片路径"""
    timestrmap = time.strftime('%Y%m%d_%H.%M.%S')
    imgPath = os.path.join(image_path, '%s.png' % image_name)

    """截图，获取元素坐标"""
    driver.save_screenshot(imgPath)
    left = element.location['x'] + 66
    top = element.location['y'] + 417
    elementWidth = left + element.size['width'] + 60
    elementHeight = top + element.size['height'] + 20

    picture = Image.open(imgPath)
    picture = picture.crop((left, top, elementWidth, elementHeight))
    timestrmap = time.strftime('%Y%m%d_%H.%M.%S')
    imgPath = os.path.join(image_path, '%s.png' % image_name)
    picture.save(imgPath)
    print('元素图标保存位置 -> ' + image_path + '/' + image_name)


# 识别验证码
def captcha(image_path=abspath + '/image/captcha.png'):
    # 用户名
    username = 'Grayson_WP'
    # 密码
    password = 'weipeng185261'
    # 软件ＩＤ，开发者分成必要参数。登录开发者后台【我的软件】获得！
    appid = 7961
    # 软件密钥，开发者分成必要参数。登录开发者后台【我的软件】获得！
    appkey = 'f8c23d784f261f08f028ada4c07fa36b'
    # 图片文件
    filename = image_path
    # 验证码类型，# 例：1004表示4位字母数字，不同类型收费不同。请准确填写，否则影响识别率。在此查询所有类型 http://www.yundama.com/price.html
    codetype = 1004
    # 超时时间，秒
    timeout = 60
    # 检查
    if (username == 'username'):
        return None
        print('请设置好相关参数再测试')
    else:
        # 初始化
        yundama = YDMHttp(username, password, appid, appkey)
        # 登陆云打码
        uid = yundama.login();
        print('uid: %s' % uid)
        # 查询余额
        balance = yundama.balance();
        print('balance: %s' % balance)
        # 开始识别，图片路径，验证码类型ID，超时时间（秒），识别结果
        cid, result = yundama.decode(filename, codetype, timeout);
        print('cid: %s, result: %s' % (cid, result))
        return result


# 获取一个页面的源代码
def get_one_page(url, encode='utf-8'):
    if encode == None:
        encode = 'utf-8'
    response = get_response(url)
    response.encoding = encode
    if response.status_code == 200:
        return response.text
    return None


# 根据 url 获取响应数据
def get_response(url):
    ua_header = {
        'User-Agent': 'Opera/9.80 (Windows NT 6.0) Presto/2.12.388 Version/12.14'
    }
    return get_requests().get(url, headers=ua_header, verify=False, timeout=60)


# 解析一个页面的信息
def parse_one_page(html, pattern):
    pattern = re.compile(pattern)
    try:
        items = re.findall(pattern, html)
        for item in items:
            yield item
    except:
        yield ()


# 通过xpath解析一个页面的信息
def parse_one_page_with_xpath(html, xpath_pattern):
    return etree.HTML(html)


# 获取视频解析后的地址
def get_movie_parse_url(url):
    driver = get_driver()
    driver.get(url)
    data = driver.execute_script('return parent.now')
    return data


# 获取 web 驱动
def get_driver(type=0):
    # PhantomJS
    if type == 0:
        driver = webdriver.PhantomJS(
            executable_path=abspath + '/phantomjs/bin/phantomjs')
        # executable_path='/usr/local/software/phantomjs-2.1.1-linux-x86_64/bin/phantomjs')
    # Chrome
    if type == 1:
        # 加启动配置
        options = webdriver.ChromeOptions()
        # 隐藏Chrome浏览器
        # options.add_argument('--headless')
        # 禁用GPU
        options.add_argument('--disable-gpu')
        # 解决centos上启动失败的问题
        options.add_argument('--no-sandbox')
        options.add_argument('--disable-dev-shm-usage')
        # 开启实验性功能参数
        options.add_experimental_option('excludeSwitches', ['enable-automation'])
        options.add_experimental_option("prefs", {
            # 设置默认下载路径
            "download.default_directory": "/Users/weipeng/Personal/Projects/YoutubeVideoDownloader/YoutubeVideoDownloader/",
            "download.prompt_for_download": True,
            "download.directory_upgrade": True,
            "safebrowsing.enabled": True,
            # 设置自动加载flash
            "profile.managed_default_content_settings.images": 1,
            "profile.content_settings.plugin_whitelist.adobe-flash-player": 1,
            "profile.content_settings.exceptions.plugins.*,*.per_resource.adobe-flash-player": 1,
        })
        # 打开Chrome浏览器
        # driver = webdriver.Chrome(abspath + '/webdriver/chromedriver/chromedriver', chrome_options=options)
        driver = webdriver.Chrome('/Users/weipeng/Personal/Projects/QQAlbumDownloader/QQAlbumDownloader/webdriver/chromedriver/chromedriver', chrome_options=options)
    # 设置超时时间
    # driver.set_page_load_timeout(60)
    # driver.set_script_timeout(60)
    return driver


# 获取数组中的第一个元素
def get_first_item(arr):
    count = 0
    for item in arr:
        if count == 0:
            return item
        count += 1
