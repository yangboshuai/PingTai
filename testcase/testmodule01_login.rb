#!/usr/bin/ruby
# encoding: utf-8

require 'lib/function.rb'
require 'lib/variable.rb'
 
class TestModule01<Test::Unit::TestCase

  include Function

  @@modulename='TestModule01_login'
  @@testcase=''
  @@result=true
  @@msg=''
  @@expected=''
  @@reality=''

  class << self
    include Function
    def startup      
      createExcel
    end

    def shutdown
      closeExcel
    end
    
  end

  def setup
    super
    createBeginLog
    openUrl    
  end
  
  def test01_001
    @@testcase="Test01_001:wrong passwd."
    $logger.info(@@testcase)
    begin
      
      inputUsername "sysadmin"
      inputPasswd "123451"
      clickLogin
      @@result,@@msg,@@expected,@@reality=validateLogin("passwd wrong")      
      
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
      @@result,@@msg,@@expected,@@reality=validateLogin("username wrong")

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
    quit
    writeResult(@@modulename,@@testcase,@@result,@@msg,@@expected,@@reality)
    @@result=false
    @@msg='error raised.please check the log.'   
  end
  
end