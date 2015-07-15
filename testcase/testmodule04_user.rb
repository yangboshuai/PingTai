#!/usr/bin/ruby
# encoding: utf-8

require 'lib/function/public.rb'
require 'lib/function/login.rb'
require 'lib/function/user.rb'
require 'lib/function/organization.rb'
require 'lib/variable.rb'
require 'test/unit'

class TestModule04<Test::Unit::TestCase

  include Function::PublicFunction
  include Function::Login
  include Function::User

  @@modulename='TestModule04_user'
  @@testcase=''
  @@result=true
  @@msg=''
  @@expected=''
  @@reality=''  
  
  #测试数据
  TESTDATA_ORGNAME='OrganizationTest'
  TESTDATA_LOGINNAME='userTest'
  TESTDATA_EDITUSERNAME='editUserTest'
  
  class << self
  
    include Function::PublicFunction
    include Function::Login
    include Function::Organization
    
    def startup
    
      $logger.info(@@modulename+"Started>>>>>>>>>>>>>>>>>>>") 
      p @@modulename+"Started>>>>>>>>>>>>>>>>>>>"
          
      createExcel
      openUrl
      login
      #------------准备测试数据----------------
      addOrganization
      #------------------------------------
    end

    def shutdown
      #----------------删除测试数据----------------
      #删除organization
      deleteOrganization
      #---------------------------------------    
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
  
  def test04_001
  
    @@testcase="Test04_001:User add"  
    $logger.info(@@testcase)
    
    begin

    #submit userinfo
    addUser(organizationName=TESTDATA_ORGNAME,name=TESTDATA_LOGINNAME,loginName=TESTDATA_LOGINNAME)
    logout
    
    #approve user
    login('secadmin','123456')
    approveUser
    logout
    
    sleep 5
    @@result,@@msg,@@expected,@@reality=validateUseradd(TESTDATA_LOGINNAME)
    
    quit
    openUrl
    login
    
    rescue Exception=>$e
      errorHandle
    end
  end

  def test04_002
  
    @@testcase="Test04_003:User edit"
    $logger.info(@@testcase)  
    
    begin
    
    editUser(organizationName=TESTDATA_ORGNAME,username=TESTDATA_LOGINNAME,name=TESTDATA_EDITUSERNAME)
    
    @@result,@@msg,@@expected,@@reality=validateUserInfo(organizationName=TESTDATA_ORGNAME,username=TESTDATA_EDITUSERNAME,\
        name=TESTDATA_EDITUSERNAME,firstName='editfirstName',middleName='editmiddleName',lastName='editlastName',\
        gender='Male',dofbirth='23-07-1984',postalCode='1111111',homeFax='1111111',residentialAddress='北京海淀区学院路1111111号',\
        homeTel='1111111',email='1111111test@sina.com',mobile='1111111',degree='High school ',graduatedInstitution='1111Changversity',\
        major='1111111Doctor',hintQuestion='1111111888888',answer='1111111888888')

    rescue Exception=>$e
      errorHandle
    end
  end
  
  def test04_003
  
    @@testcase="Test04_002:User delete"
    $logger.info(@@testcase)
        
    begin
    
    #delete user
    deleteUser(organizationName=TESTDATA_ORGNAME,name=TESTDATA_EDITUSERNAME)
    logout
    
    #approve delete user
    login('secadmin','123456')
    approveDeleteUser
    logout
    
    sleep(5)
    @@result,@@msg,@@expected,@@reality=validateUserDelete(TESTDATA_ORGNAME,TESTDATA_EDITUSERNAME) 

    rescue Exception=>$e
      errorHandle
    end
  end

#  def test04_004
#    @@testcase="Test04_004:User disable"
#    $logger.info(@@testcase)     
#     begin     
#        disableUser(organizationName=TESTDATA_ORGNAME,name=TESTDATA_EDITUSERNAME)
#        logout
#        @@result,@@msg,@@expected,@@reality=validateDisableUser(organizationName=TESTDATA_ORGNAME,name=TESTDATA_EDITUSERNAME)
#        
#     end
#     
#  end

  def teardown  
    super
    gotoHomepage
    
    writeResult(@@modulename,@@testcase,@@result,@@msg,@@expected,@@reality)
    assert @@result,@@testcase+"failed"
    
    @@result=false
    @@msg='error raised.please check the log.'        
  end
  
end