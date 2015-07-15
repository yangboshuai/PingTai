#!/usr/bin/ruby
# encoding: utf-8

require 'lib/function/public.rb'
require 'lib/function/login.rb'
require 'lib/function/roles.rb'
require 'lib/function/organization.rb'
require 'lib/function/user.rb'
require 'lib/variable.rb'
require 'test/unit'

class TestModule05 <Test::Unit::TestCase

  include Function::PublicFunction
  include Function::Login
  include Function::Organization
  include Function::User
  include Function::Roles

  @@modulename='TestModule05_role'
  @@testcase=''
  @@result=true
  @@msg=''
  @@expected=''
  @@reality=''
  
  #测试数据
  TESTDATA_ORGNAME='OrgTest'
  TESTDATA_USERNAME='UserTest'
  TESTDATA_ROLENAME='RoleTest'
  TESTDATA_EDITROLENAME='editRoleTest'  
  
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

  def setup
    super
    createBeginLog
  end
  
  def teardown  
    super
    gotoHomepage
    
    writeResult(@@modulename,@@testcase,@@result,@@msg,@@expected,@@reality)
    assert @@result,@@testcase+"failed"

    @@result=false
    @@msg='error raised.please check the log.'    
  end
  
  def test05_001
    
    @@testcase="Test05_001:Roles add"
    $logger.info(@@testcase)
    
    begin
    
    addRoles(TESTDATA_ROLENAME,'addRoleTest')
    logout
    
    #approve roles
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
    
    #approveDeleteRoles
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
    
    #-----------------准备测试数据----------------------------
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
    #--------------------------------------------------------
    
    linkRoleAndUser(TESTDATA_ROLENAME,TESTDATA_USERNAME)
    logout
    
    #approve link
    login('secadmin','123456')
    approvelinkRoleAndUser
    logout

    #validate
    login
    @@result,@@msg,@@expected,@@reality=validateLink(TESTDATA_ROLENAME,TESTDATA_USERNAME)

    #-----------------删除测试数据----------------------------
    deleteRoles(TESTDATA_ROLENAME)    
    logout    
    
    #approve delete roles
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
    #--------------------------------------------------------
   rescue Exception=>$e
      errorHandle
    end    
  end
  

  
end