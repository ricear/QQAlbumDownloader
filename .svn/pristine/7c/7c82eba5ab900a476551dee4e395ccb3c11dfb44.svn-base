import imaplib
import time
import email.message
import getpass

if __name__ == '__main__':
    imap_host = 'imap.163.com'
    mail_login = "weipengweibeibei@163.com"
    mail_pass = "Weipeng185261"

    M = imaplib.IMAP4(imap_host,int(143))
    print(M.welcome)
    M.login(mail_login, mail_pass)