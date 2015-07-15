#!/usr/bin/ruby
# encoding: utf-8

require 'watir-webdriver'
require 'lib/ui.rb'
require 'lib/variable.rb'

module Function
  module Login
  
    include Control::PublicControl
    include Control::LoginControl

    def inputUsername(username) #输入用户名

       $logger.info("输入用户名"+username+"...")
      
       $a.text_field(TEXTFIELD_USERNAME).set username
       
       sleep $waittime
    end
    
    def inputPasswd(passwd) #输入密码

       $logger.info("输入密码"+passwd+"...")
       
       $a.text_field(TEXTFIELD_PASSWD).set passwd
       
       sleep $waittime
    end 
    
    def clickLogin  #点击登录按钮

      $logger.info("点击登录按钮...")
      
      $a.button(BUTTON_LOGIN).click
      
      sleep $waittime
    end
    
    def validateLogin(expected='login successful')  #验证登录结果

      $logger.info("===>>开始验证登录信息：")      
      
      result=false  #初始化result为false
      
      if $a.span(:text,"The entered password is not correct.").exists? #3次以内输入用户名登录失败
        msg='username or passwd wrong'
      elsif $a.text_field(:id=>"jcaptchaCode").exists? #3次以上输入用户名登录失败
        msg='username or passwd wrong'
      elsif $a.button(:text,"Yes").exists?  #出现强制登录弹出框
        $a.button(:text,"Yes").click        
        sleep $waittime*2       
        if $a.div(:class,"pull-right").exists? #直接登录成功
          msg='login successful'
        elsif $a.span(:text,"The entered password is not correct.").exists? #登录失败
          msg='username or passwd wrong'
        else
          msg='login failed'
        end
      elsif $a.div(:class,"pull-right").exists?
        msg='login successful'
      else
        msg='login failed' 
      end    

      if expected==msg
        result=true
      else  
        result=false
      end
      
      $logger.info("<<===验证结果:"+result.to_s+','+msg+','+expected+','+msg)
      
      return result,msg,expected,msg      
    end
    
    def login(username='sysadmin',passwd='123456')  #登录输入用户名、密码
      
      inputUsername(username)
      inputPasswd(passwd)
      clickLogin
      validateLogin
    end
    
    
    def logout  #退出系统  
      $logger.info("退出系统...")  
      
      $a.goto $homepage
      $a.link(LINK_DROPDOWNTOGGLE).click
      sleep $waittime
      $a.link(LINK_LOGOUT).click
      $a.button(:text,"OK").click 
      sleep $waittime
       
    end
    
  end
end