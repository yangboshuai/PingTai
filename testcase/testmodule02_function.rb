#!/usr/bin/ruby
# encoding: utf-8

require 'lib/function.rb'
require 'lib/variable.rb'

class TestModule02<Test::Unit::TestCase

  include Function

  @@modulename='TestModule02_function'
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
    login 
  end

  def test02_001
    #Add and delete Function test
   
    @@testcase="test02_001-Add Function test"
    $logger.info(@@testcase)
    begin
    
      addFunction
      @@result,@@msg,@@expected,@@reality=validateFunction    #验证添加信息
      deleteFunction      #删除添加的信息  

    rescue Exception=>e
      puts e.message
      errorHandle
    end
  end

  def test02_002
  #delete Function test 
  
    @@testcase="test02_002-delete Function test"
    $logger.info(@@testcase)     
    begin    
      addFunction
      #删除添加的信息
      deleteFunction
      @@result,@@msg,@@expected,@@reality=validateDeleteFunction  

    rescue Exception=>e
      puts e.message
      errorHandle
    end
  end

  def test02_003
    #add edit delete Function test  
    
    @@testcase="test02_003-edit Function test"
    $logger.info(@@testcase)
    begin    
      addFunction
      editFunction
      @@result,@@msg,@@expected,@@reality=validateFunction(name='Functiontest2',code='Functiontest2',sOrh='hide',pageTarget='Workspace',pageUrl='2apex.menu.test,iconUrl',iconUrl='2apex.menu.test',iconX='2',iconY='2',description='2')
      deleteFunction(name='Functiontest2')      
    rescue Exception=>e
        puts e.message
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