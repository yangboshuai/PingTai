#!/usr/bin/ruby
# encoding: utf-8

require 'lib/function.rb'
require 'lib/variable.rb'

class TestModule03 <Test::Unit::TestCase

  include Function  

  @@modulename='TestModule03_organization'
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
################################
#        测试数据
################################
  TESTDATA_ORGNAME='OrganizationTest'
  TESTDATA_EDITORGNAME='EditOrganizationTest'
################################
   def setup
    super
    createBeginLog    
    openUrl
    login 
  end
  
  def test03_001
    
    @@testcase="Test03_001:Organization add"
    $logger.info(@@testcase)
    begin
    addOrganization(name=TESTDATA_ORGNAME)
    @@result,@@msg,@@expected,@@reality=validateOrganization(name=TESTDATA_ORGNAME)   #验证添加信息
    
    rescue Exception=>$e
      errorHandle
    end
  end
  
  def test03_002
    
    @@testcase="Test03_002:Organization delete"
    $logger.info(@@testcase)
    begin
    deleteOrganization(TESTDATA_ORGNAME)    #删除Organization  

    @@result,@@msg,@@expected,@@reality=validateDelOrg(TESTDATA_ORGNAME)
    
    rescue Exception=>$e
      errorHandle
    end
  end
  
  def dtest03_003
    
    @@testcase="Test03_003:Organization edit"
    $logger.info(@@testcase)
    begin
    
    addOrganization(name=TESTDATA_ORGNAME)
    editOrganization(keyword_orgnizationName=TESTDATA_ORGNAME,name=TESTDATA_EDITORGNAME)
    @@result,@@msg,@@expected,@@reality=validateOrganization(name=TESTDATA_EDITORGNAME,otherName='OrganizationTest222',email='cssca222@cssca.com',level='2222',insideTel='010234',
outsideTel='010234',attendanceTel='020234',fax='052234',postalCode='100234',officeNo='1234',address='北京海淀区学院路234号',description='test234')   #验证编辑信息

#    deleteOrganization('editOrganization222')
    
    rescue Exception=>$e
      errorHandle
    end
  end
  
  def dtest03_004
  
    @@testcase="Test03_004:Organization enable"
    $logger.info(@@testcase)
    begin
    
    enableOrganization(TESTDATA_EDITORGNAME)

    @@result,@@msg,@@expected,@@reality=validateEnableOrganization(TESTDATA_EDITORGNAME)   #验证编辑信息

    rescue Exception=>$e
      errorHandle
    end    
  end
  
  def dtest03_005
  
    @@testcase="Test03_005:Organization disable"
    $logger.info(@@testcase)
    begin
    
    disableOrganization(TESTDATA_EDITORGNAME)

    @@result,@@msg,@@expected,@@reality=validateDisableOrganization(TESTDATA_EDITORGNAME)   #验证编辑信息

    deleteOrganization(TESTDATA_EDITORGNAME)
    
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