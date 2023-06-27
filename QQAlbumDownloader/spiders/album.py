import json
from six.moves import urllib

from QQAlbumDownloader.util.CommonUtils import *
from QQAlbumDownloader.util.SlideVerfication import SlideVerificationCode

ua_header = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36'
    }

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
    # g_tk = driver.execute_script("return document.getElementsByTagName('script')[3].src")
    # if 'b.cnc.qzone.qq.com' not in g_tk:
    #     g_tk = driver.execute_script("return document.getElementsByTagName('script')[2].src")
    return (str)(driver.execute_script('return QZONE.FP.getACSRFToken()'))


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
# account = input('请输入你的qq号：')
account = '1093579950'
# password = getpass.getpass('请输入你的密码：')
password = 'WEipeng185261'

# 请求选择文件夹/目录
# root = tkinter.Tk()  # 创建一个Tkinter.Tk()实例
# root.withdraw()  # 将Tkinter.Tk()实例隐藏
# path = tkinter.filedialog.askdirectory(title=u'请选择照片保存位置', initialdir=(os.path.defpath))
# root.update()
# path = '/mnt/hgfs/Personal/Pictures'
# path = 'D:/Pictures'
path = '/Users/weipeng/Downloads'
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

    # 登录
    driver.switch_to.frame('login_frame')  # 切换到登陆界面
    driver.find_element_by_id('switcher_plogin').click()  # 选择帐号密码登陆
    driver.find_element_by_name('u').clear()
    driver.find_element_by_name('u').send_keys(account)  # 此处输入你的QQ号
    driver.find_element_by_name('p').clear()
    driver.find_element_by_name('p').send_keys(password)  # 此处输入你的QQ密码
    driver.find_element_by_id('login_button').click()  # 点击登陆按键
    time.sleep(21)

    # # 第三步：进行滑动验证
    # # 3.1定位验证码所在的iframe,并进行切换
    # v_frame = driver.find_element_by_id('tcaptcha_iframe')
    # driver.switch_to.frame(v_frame)
    # # 3.2获取验证码滑块图元素
    # sli_ele = driver.find_element_by_id('slideBlock')
    # # 3.3获取验证码背景图的元素
    # bg_ele = driver.find_element_by_id('slideBg')
    # # 3.4 识别滑块需要滑动的距离
    # # 3.4.1识别背景缺口位置
    # sv = SlideVerificationCode(save_image=True)
    # distance = sv.get_element_slide_distance(sli_ele, bg_ele)
    # # 3.4.2 根据页面的缩放比列调整滑动距离
    # dis = (distance * 280 / 680) - 30
    # # 3.5 获取滑块按钮
    # sli_btn = driver.find_element_by_id('tcaptcha_drag_thumb')
    #
    # # 3.6拖动滑块进行验证
    # sv.slide_verification(driver, sli_btn, dis)
    # time.sleep(21)

    # 获取相册列表
    driver.find_element_by_id('menuContainer').find_element_by_xpath('./div/ul/li[3]/a').click()  # 点击相册按钮
    g_tk = calculate_g_tk(driver)
    url = 'https://h5.qzone.qq.com/proxy/domain/photo.qzone.qq.com/fcgi-bin/fcg_list_album_v3?g_tk=' + g_tk + '&callback=shine5_Callback&t=922052151&hostUin=' + account + '&uin=' + account + '&appid=4&inCharset=utf-8&outCharset=utf-8&source=qzone&plat=qzone&format=jsonp&notice=0&filter=1&handset=4&pageNumModeSort=40&pageNumModeClass=15&needUserInfo=1&idcNum=4&mode=2&sortOrder=1&pageStart=0&pageNum=999999&callbackFun=shine5'
    driver.get(url)
    album_info_list = json.loads(
        driver.execute_script("return document.getElementsByTagName('pre')[0].textContent.split('(')[1].split(')')[0]"))
    print('相册列表')
    # 相册数量
    album_count = 1
    total_album_count = len(album_info_list['data']['albumList'])
    # 照片数量
    photo_count = 1
    total_photo_count = 1

    # 是否需要上传到服务器
    upload_server = None

    def __init__(self, target=None, upload_server=None, name=None, **kwargs):
        super(AlbumSpider, self).__init__(name, **kwargs)
        self.upload_server = upload_server
        for album_info in self.album_info_list['data']['albumList']:
            album_name = album_info['name']  # 相册名称
            if (target is not None and target != album_name):
                continue
            album_id = album_info['id']  # 相册id
            album_path = path + '/' + album_name
            albums[album_id] = album_name
            # 获取一个相册中的照片列表
            url = 'https://h5.qzone.qq.com/proxy/domain/photo.qzone.qq.com/fcgi-bin/cgi_list_photo?g_tk=' + self.g_tk + '&callback=shine0_Callback&mode=0&idcNum=4&hostUin=' + account + '&topicId=' + album_id + '&noTopic=0&uin=' + account + '&pageStart=0&pageNum=999999&skipCmtCount=0&singleurl=1&batchId=&notice=0&appid=4&inCharset=utf-8&outCharset=utf-8&source=qzone&plat=qzone&outstyle=json&format=jsonp&json_esc=1&question=&answer=&callbackFun=shine0'
            self.start_urls.append(url)

    def parse(self, response):
        collection = 'album'
        db_utils = MongoDbUtils(collection)
        url = response.url
        self.driver.get(url)
        photo_info_list = json.loads(self.driver.execute_script(
            "return document.getElementsByTagName('pre')[0].textContent.split('Callback(')[1].split(');')[0]"))
        current_photo_count = len(photo_info_list['data']['photoList'])
        current_photo_index = 1
        for photo_info in photo_info_list['data']['photoList']:
            is_video = photo_info['is_video']
            photo_url = photo_info['raw']  # 照片原图地址
            print(photo_url)
            if photo_url == '':
                photo_url = photo_info['url']  # 压缩后的照片地址
            photo_id = photo_url.split('/')[5].split('!')[0]
            album_id = photo_url.split('?/')[1].split('/')[0]
            album_name = albums[album_id]
            album_path = path_main + '/' + album_name
            mkdir(album_path)
            if is_video == True:
                # 视频
                photo_id = photo_info['lloc']
                url2 = 'https://h5.qzone.qq.com/proxy/domain/photo.qzone.qq.com/fcgi-bin/cgi_floatview_photo_list_v2?g_tk=' + self.g_tk + '&callback=viewer_Callback&topicId=' + album_id + '&picKey='+photo_id+'&shootTime=&cmtOrder=1&fupdate=1&plat=qzone&source=qzone&cmtNum=10&likeNum=5&inCharset=utf-8&outCharset=utf-8&callbackFun=viewer&offset=0&number=15&uin=' + account + '&hostUin=' + account + '&appid=4&isFirst=1&sortOrder=1&showMode=1&need_private_comment=1&prevNum=9&postNum=18&_=1578815582309'
                self.driver.get(url2)
                photo_info_list2 = json.loads(self.driver.execute_script(
                    "return document.getElementsByTagName('pre')[0].textContent.split('Callback(')[1].split(');')[0]"))
                for photo_info2 in photo_info_list2['data']['photos']:
                    if photo_info2['lloc'] == photo_id:
                        photo_url = photo_info2['video_info']['video_url']
                        photo_name = photo_id + '.mp4'
            else:
                # 照片
                photo_name = photo_id + '.jpeg'
            photo_name = photo_name.replace("*", "")
            file_path = album_path + '/' + photo_name
            # 图片不存在时再下载
            dic = {'image_name': photo_name}
            if db_utils.find(dic).count() > 0:
                print(f'照片 %s %s 已上传到服务器' % (album_path, photo_name))
            else:
                if os.path.exists(file_path) == False:
                    print('正在下载' + (str)(self.album_count) + '/'+(str)(self.total_album_count)+' 个相册，' + (str)(current_photo_index) + '/'+(str)(current_photo_count)+' 张照片，共下载'+(str)(self.total_photo_count)+'张照片 ' ' -> ' + album_name + ' -> ' + photo_name)
                    urllib.request.urlretrieve(photo_url, file_path.replace("*", ""))
                    # if (self.upload_server is not None and self.upload_server == 'true'):
                    #     upload_image_single(path_main, album_name, False, photo_name=photo_name)
                    print(photo_name + ' -> 下载完成')
                else:
                    print(photo_name + ' 已下载')
            self.photo_count += 1
            current_photo_index += 1
        self.album_count += 1
        # print(f'正在删除本地文件夹 %s' % (album_path))
        #try:
            # os.rmdir(album_path)
        #except:
        #    pass
