#!/usr/bin/ruby
# encoding: utf-8

require 'lib/function/login.rb'
require 'lib/function/public.rb'
require 'lib/variable.rb'
require 'test/unit'
 
class TestModule01 <Test::Unit::TestCase

  include Function::PublicFunction
  include Function::Login

  @@modulename='TestModule01_login'
  @@testcase=''
  @@result=true
  @@msg=''
  @@expected=''
  @@reality=''

  class << self
  
    include Function::PublicFunction
    
    def startup
    
      $logger.info(@@modulename+"Started>>>>>>>>>>>>>>>>>>>") 
      p @@modulename+"Started>>>>>>>>>>>>>>>>>>>"
      
      createExcel
      openUrl
    end

    def shutdown
      closeExcel
      quit
      
      $logger.info(@@modulename+"Over<<<<<<<<<<<<<<<<<<<") 
      p @@modulename+"Over<<<<<<<<<<<<<<<<<<<"      
    end
    
  end

  def setup
  
    super    
    createBeginLog    
  end
  
  def test01_001
  
    @@testcase="Test01_001:wrong passwd."
    $logger.info(@@testcase)
    
    begin
      
      inputUsername "sysadmin"
      inputPasswd "123451"
      clickLogin
      @@result,@@msg,@@expected,@@reality=validateLogin("username or passwd wrong")      
      
    rescue Exception=>$e
        errorHandle
    end
    
  end
  
  def test01_002  
  
    @@testcase="Test01_002:wrong username."
    $logger.info(@@testcase)
    
    begin

      inputUsername "sysadmin1"
      inputPasswd "123451"
      clickLogin
      @@result,@@msg,@@expected,@@reality=validateLogin("username or passwd wrong")

    rescue Exception=>$e
        errorHandle      
    end
  end  

  def test01_003   
    @@testcase="Test01_3:right username,right passwd."
    $logger.info(@@testcase)
    begin

      inputUsername "sysadmin"
      inputPasswd "123456"
      clickLogin
      @@result,@@msg,@@expected,@@reality=validateLogin("login successful")
      
      rescue Exception=>$e
        errorHandle
    end
  end

  def teardown  
  
    super
    
    gotoHomepage
    
    writeResult(@@modulename,@@testcase,@@result,@@msg,@@expected,@@reality)
    assert @@result,@@testcase+"failed"
    
    @@result=false
    @@msg='error raised.please check the log.'   
  end
  
end