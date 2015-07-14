#!/usr/bin/ruby
# encoding: utf-8

require 'lib/function.rb'
require 'lib/variable.rb'

class TestModule05 <Test::Unit::TestCase

  include Function  

  @@modulename='TestModule05_role'
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
  TESTDATA_ORGNAME='OrgTest'
  TESTDATA_USERNAME='UserTest'
  TESTDATA_ROLENAME='RoleTest'
  TESTDATA_EDITROLENAME='editRoleTest'
################################

   def setup
    super
    createBeginLog    
    openUrl
    login 
  end
  
  def test05_001
    
    @@testcase="Test05_001:Roles add"
    $logger.info(@@testcase)
    begin
    addRoles(TESTDATA_ROLENAME,'addRoleTest')
    logout
    
    #approve user
    login('secadmin','123456')
    approveRoles
    logout
    
    login
    completeRoles
    @@result,@@msg,@@expected,@@reality=validteAddRoles(TESTDATA_ROLENAME)   #验证添加信息
    
    rescue Exception=>$e
      errorHandle
    end
  end
  
  def test05_002
    
    @@testcase="Test05_002:Roles edit"
    $logger.info(@@testcase)    
    begin
    
    editRoles(TESTDATA_ROLENAME,TESTDATA_EDITROLENAME,'editRoleTest')    #删除Organization
     
    @@result,@@msg,@@expected,@@reality=validateRoles(roleName=TESTDATA_EDITROLENAME,roleDescription='editRoleTest')
    
    rescue Exception=>$e
      errorHandle
    end
  end
  
  def test05_003
    
    @@testcase="Test05_003:Roles delete"
    $logger.info(@@testcase)
    begin
    
    deleteRoles(TESTDATA_EDITROLENAME)
    logout
    
    #approve roles
    login('secadmin','123456')
    approveDeleteRoles
    logout
    
    login
    
    @@result,@@msg,@@expected,@@reality=validateDeleteRoles(roleName=TESTDATA_EDITROLENAME)
    
    rescue Exception=>$e
      errorHandle
    end
  end
  
  def test05_004
  
    @@testcase="Test05_004:Roles and user connect"
    $logger.info(@@testcase)
    begin
    
    ###############准备测试数据#################
    addOrganization(name=TESTDATA_ORGNAME)
    
    addUser(organizationName=TESTDATA_ORGNAME,name=TESTDATA_USERNAME,loginName=TESTDATA_USERNAME)
    logout
    #approve user
    login('secadmin','123456')
    approveUser
    logout
    
    login    
    addRoles(TESTDATA_ROLENAME)
    logout    
    #approve Roles
    login('secadmin','123456')
    approveRoles
    logout
    
    login
    completeRoles
    ########################################
    
    linkRoleAndUser(TESTDATA_ROLENAME,TESTDATA_USERNAME)
    logout
    
    #approve link
    login('secadmin','123456')
    approvelinkRoleAndUser
    logout

    #validate
    login
    @@result,@@msg,@@expected,@@reality=validateLink(TESTDATA_ROLENAME,TESTDATA_USERNAME)

    ###############删除测试数据#################
    deleteRoles(TESTDATA_ROLENAME)    
    logout
    
    
    #approve 
    login('secadmin','123456')    
    approveDeleteRoles
    logout
    
    login
    deleteUser(TESTDATA_ORGNAME,TESTDATA_USERNAME)
    logout
    
    #approve delete user
    login('secadmin','123456')
    approveDeleteUser
    logout
    login
    deleteOrganization(TESTDATA_ORGNAME)
    ########################################
#    rescue Exception=>$e
#      errorHandle
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