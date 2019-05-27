import getpass
import json
import re
import time  # 用来延时
import tkinter
import tkinter as tk
import os
import urllib

import scrapy
from selenium import webdriver
from tkinter import filedialog

ua_header = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36'
    }

# 获取 web 驱动
def get_driver(type):
    # PhantomJS
    if type == 0:
        driver = webdriver.PhantomJS(
            executable_path='phantomjs/bin/phantomjs')
            # executable_path='/usr/local/software/phantomjs-2.1.1-linux-x86_64/bin/phantomjs')
    # Chrome
    if type == 1:
        driver = webdriver.Chrome('webdriver/chromedriver/chromedriver')
    return driver

# 解析一个页面的信息
def parse_one_page(html, pattern):
    pattern = re.compile(pattern)
    try:
        items = re.findall(pattern, html)
        for item in items:
            yield item
    except:
        yield ()

# 计算 g_tk
def calculate_g_tk(driver):
    time.sleep(6)
    g_tk = driver.execute_script("return document.getElementsByTagName('script')[3].src")
    if 'b.cnc.qzone.qq.com' not in g_tk:
        g_tk = driver.execute_script("return document.getElementsByTagName('script')[2].src")
    return g_tk.split('g_tk=')[1].split('&')[0]


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

albums = {}
path_main = ''

# 输入qq号和密码
account = input('请输入你的qq号：')
password = getpass.getpass('请输入你的密码：')

# 请求选择文件夹/目录
root = tkinter.Tk()  # 创建一个Tkinter.Tk()实例
root.withdraw()  # 将Tkinter.Tk()实例隐藏
path = tkinter.filedialog.askdirectory(title=u'请选择照片保存位置', initialdir=(os.path.defpath))
root.update()
path = path + '/' + account
path_main = path
# 创建文件夹
mkdir(path)

class AlbumSpider(scrapy.Spider):
    name = 'album'
    allowed_domains = ['https://i.qq.com/']
    start_urls = []

    driver = get_driver(1)
    driver.get("https://i.qq.com/")

    # 登陆
    driver.switch_to.frame('login_frame')  # 切换到登陆界面
    driver.find_element_by_id('switcher_plogin').click()  # 选择帐号密码登陆
    driver.find_element_by_name('u').clear()
    driver.find_element_by_name('u').send_keys(account)  # 此处输入你的QQ号
    driver.find_element_by_name('p').clear()
    driver.find_element_by_name('p').send_keys('weipeng185261')  # 此处输入你的QQ密码
    driver.find_element_by_id('login_button').click()  # 点击登陆按键
    time.sleep(12)

    # 获取相册列表
    driver.find_element_by_id('menuContainer').find_element_by_xpath('./div/ul/li[3]/a').click()  # 点击相册按钮
    g_tk = calculate_g_tk(driver)
    url = 'https://h5.qzone.qq.com/proxy/domain/photo.qzone.qq.com/fcgi-bin/fcg_list_album_v3?g_tk=' + g_tk + '&callback=shine5_Callback&t=922052151&hostUin=' + account + '&uin=' + account + '&appid=4&inCharset=utf-8&outCharset=utf-8&source=qzone&plat=qzone&format=jsonp&notice=0&filter=1&handset=4&pageNumModeSort=40&pageNumModeClass=15&needUserInfo=1&idcNum=4&mode=2&sortOrder=1&pageStart=0&pageNum=999999&callbackFun=shine5'
    driver.get(url)
    album_info_list = json.loads(
        driver.execute_script("return document.getElementsByTagName('pre')[0].textContent.split('(')[1].split(')')[0]"))
    print('相册列表')
    # 相册数量
    album_count = 0
    # 照片数量
    photo_count = 0
    for album_info in album_info_list['data']['albumList']:
        album_name = album_info['name']  # 相册名称
        album_id = album_info['id']  # 相册id
        album_path = path + '/' + album_name
        albums[album_id] = album_name
        mkdir(album_path)
        # 获取一个相册中的照片列表
        url = 'https://h5.qzone.qq.com/proxy/domain/photo.qzone.qq.com/fcgi-bin/cgi_list_photo?g_tk=' + g_tk + '&callback=shine0_Callback&mode=0&idcNum=4&hostUin=' + account + '&topicId=' + album_id + '&noTopic=0&uin=' + account + '&pageStart=0&pageNum=999999&skipCmtCount=0&singleurl=1&batchId=&notice=0&appid=4&inCharset=utf-8&outCharset=utf-8&source=qzone&plat=qzone&outstyle=json&format=jsonp&json_esc=1&question=&answer=&callbackFun=shine0'
        driver.get(url)
        photo_info_list = json.loads(driver.execute_script(
            "return document.getElementsByTagName('pre')[0].textContent.split('Callback(')[1].split(');')[0]"))
        for photo_info in photo_info_list['data']['photoList']:
            photo_url = photo_info['raw']  # 照片原图地址
            if photo_url == '':
                photo_url = photo_info['pre']  # 压缩后的照片地址
            start_urls.append(photo_url)
            photo_count += 1
        album_count += 1
    print('共下载 ' + (str)(album_count) + ' 个相册，' + (str)(photo_count) + ' 张照片')

    def parse(self, response):
        photo_url = response.url
        photo_name = photo_url.split('/')[5].split('!')[0] + '.jpeg'
        album_id = photo_url.split('psb?/')[1].split('/')[0]
        album_name = albums[album_id]
        album_path = path_main + '/' + album_name
        file_path = album_path + '/' + photo_name
        # 图片不存在时再下载
        if os.path.exists(file_path) == False:
            print('正在下载 -> ' + album_name + ' -> ' + photo_name)
            urllib.request.urlretrieve(photo_url, file_path)
            print(photo_name + ' -> 下载完成')
        else:
            print(photo_name + ' 已下载')
