#!/usr/bin/ruby
# encoding: utf-8

require 'lib/function/public.rb'
require 'lib/function/login.rb'
require 'lib/function/ffunction.rb'
require 'lib/variable.rb'
require 'test/unit'

class TestModule02 <Test::Unit::TestCase
  
  include Function::PublicFunction
  include Function::Login
  include Function::FFunction
  
  #类变量
  @@modulename='TestModule02_function'
  @@testcase=''
  @@result=true
  @@msg=''
  @@expected=''
  @@reality=''
  
  #测试数据
  TESTDATA_FUNCTIONNAME='FunctionTest'
  TESTDATA_EDITFUNCTIONNAME='EditFunctionTest'

  class << self
      
    include Function::PublicFunction
    include Function::Login
    
    def startup
    
      $logger.info(@@modulename+"Started>>>>>>>>>>>>>>>>>>>") 
      p @@modulename+"Started>>>>>>>>>>>>>>>>>>>"
          
      createExcel
      openUrl
      login
    end

    def shutdown
      closeExcel
      quit
      
      $logger.info(@@modulename+"Over<<<<<<<<<<<<<<<<<<<") 
      p @@modulename+"Over<<<<<<<<<<<<<<<<<<<"        
    end
  end

  def setup #调用父类的setup方法，每次运行测试用例时运行的方法
    super
    createBeginLog     
  end

  def test02_001   #Add Function test   
   
    @@testcase="test02_001-Add Function test"
    $logger.info @@testcase #记录日志
    
    begin    

      addFunction(TESTDATA_FUNCTIONNAME)
      
      @@result,@@msg,@@expected,@@reality=validateFunction(name=TESTDATA_FUNCTIONNAME)    #验证添加信息
      
    rescue Exception=>$e
      errorHandle
    end    
  end

  def test02_002  #edit Function test  
    
    
    @@testcase="test02_003-edit Function test"
    $logger.info(@@testcase)
    
    begin    
      
      editFunction(keyword_functionName=TESTDATA_FUNCTIONNAME,name=TESTDATA_EDITFUNCTIONNAME)
      
      @@result,@@msg,@@expected,@@reality=validateFunction(name=TESTDATA_EDITFUNCTIONNAME,code='Functiontest2',sOrh='hide',\
                  pageTarget='Workspace',pageUrl='2apex.menu.test,iconUrl',iconUrl='2apex.menu.test',iconX='2',iconY='2',description='2')

    rescue Exception=>$e
        errorHandle
    end    
  end
  
  def test02_003  #delete Function test 

  
    @@testcase="test02_002-delete Function test"
    $logger.info(@@testcase)    
     
    begin    

      deleteFunction(TESTDATA_EDITFUNCTIONNAME)  #删除添加的信息
      @@result,@@msg,@@expected,@@reality=validateDeleteFunction(TESTDATA_EDITFUNCTIONNAME)   

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