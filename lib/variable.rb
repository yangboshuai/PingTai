#!/usr/bin/ruby
# encoding: utf-8
require 'logger'
require 'win32ole'

#webdriver
$a

#打开网页的url
$url='http://10.10.12.10:8080/apex/login'
#主页面
$homepage="http://10.10.12.10:8080/apex/apexIndex"

#waittime
$waittime=1

#日志输出路径
file = File.open("./log/"+Time.new.strftime("%Y%m%d-%H-%M-%S")+'log.txt', File::WRONLY | File::APPEND | File::CREAT)
$logger = Logger.new(file)
$logger.level = Logger::INFO

#登录用户名
$username='sysadmin'

#登录密码
$passwd='123456'

#语言
$language='english'

#excel
$path='F:\WatirWebdriverDemo\PingTaiTest\file\测试用例及报告.xls'
$worksheet
$reportName
$i=9  #excel开始行
$new=true #新建报表?

#count
$passCount=0
$failCount=0