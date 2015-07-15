#!/usr/bin/ruby
# encoding: utf-8

require 'watir-webdriver'
require 'lib/ui.rb'
require 'lib/variable.rb'

module Function
  module Roles

    include Control::PublicControl
    include Control::RolesControl
    
    def clickMenu_Roles #点击Organization主目录
    
      $logger.info("点击Roles主目录...")  
      
      $a.link(LINK_Roles).click
      
      sleep $waittime  
    end
    
    def addRoles(roleName="roleTest01",roleDescription="test")  #新加Roles
    
      clickMenu_Roles
      
      $logger.info("addRoles输入Roles信息...")
      
      $a.iframe(FRAME_MAINFRAME).button(Button_Add).when_present.click  
      
      #roleName
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_ROLENAME).set roleName
      #roleDescription
      $a.iframe(FRAME_MAINFRAME).textarea(TEXTAREA_DESCRIPTION).set roleDescription
    
      #submit按钮
      $a.iframe(FRAME_MAINFRAME).button(BUTTON_SUBMIT).click
      
      sleep $waittime*2  
      gotoHomepage      
    end
    
    
    def approveRoles  #审批通过的Roles
    
      $logger.info("审批新加的Roles...") 
      
      if $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).exist?
        $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).click 
      end
      
      $a.iframe(FRAME_MAINFRAME).table(TABLE_TODOLISTTABLE).[](1).[](0).link(LINK_TASKINFO).click
      sleep $waittime*2
      $a.button(BUTTON_CLOSE).click
      sleep $waittime*2
      
      $a.iframe(FRAME_MAINFRAME).link(LINK_HANDLEBTN).when_present.click
      sleep $waittime
      $a.iframe(FRAME_MAINFRAME).button(BUTTON_APPROVE).when_present.click
      
      sleep $waittime  
    end
    
    def completeRoles #确认Roles
    
      $logger.info("确认新加的Roles...") 
      
      if $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).exist?
        $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).click 
      end
      
      $a.iframe(FRAME_MAINFRAME).link(LINK_HANDLEBTN).when_present.click
      $a.iframe(FRAME_MAINFRAME).button(BUTTON_COMPLETE).when_present.click
      
      sleep $waittime  
    end
    
    
    def searchRoles(keyword_RoleName) #检索Roles信息
   
      $a.goto $homepage
      clickMenu_Roles
      
      $logger.info("查找Roles...") 
       
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_SEARCH).set keyword_RoleName
      $a.iframe(FRAME_MAINFRAME).button(BUTTON_SEARCH).click
      
      sleep $waittime  
    end
    
    
    def validteAddRoles(roleName="roleTest01")
    
      result=false
      expected='Enable'
      
      searchRoles(roleName)
      status=$a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](3).text
      reality=status
      
      if expected==reality
        result=true
        msg='Add Roles successfuly'    
      else
        result=false
        msg='the status of the role is wrong.'
      end
      
      return result,msg,expected,reality
    end
    
    def editRoles(keyword_RoleName,roleName='editRoleTest',roleDescription='editRoleTest')
    
      searchRoles(keyword_RoleName)
      $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](7).link(LINK_EDIT).click
      
      $logger.info("编辑角色信息...")  
      
      sleep $waittime
      
      #roleName
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_ROLENAME).set roleName
      #roleDescription
      $a.iframe(FRAME_MAINFRAME).textarea(TEXTAREA_DESCRIPTION).set roleDescription
      
      #save按钮
      $a.iframe(FRAME_MAINFRAME).button(Button_Save).when_present.click
    
      sleep $waittime      
    end
    
    def validateRoles(roleName=TESTDATA_EDITROLENAME,roleDescription='editRoleTest')
      
      result=false  
      expected=''
      reality='' 
      
      searchRoles(roleName)
      $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](7).link(LINK_EDIT).click
      
      $logger.info("===>>开始验证Roles信息：")
      
      #roleName
      rroleName=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_ROLENAME).value
      #roleDescription
      rroleDescription=$a.iframe(FRAME_MAINFRAME).textarea(TEXTAREA_DESCRIPTION).value
      
      
      if rroleName!=roleName
        msg='Role name wrong!'
        expected=roleName
        reality=rroleName
      elsif rroleDescription!=roleDescription
        msg='Role Description wrong'
        expected=roleDescription
        reality=rroleDescription  
      else
        result=true
        msg='Role info right'    
      end
      
      return result,msg,expected,reality
    end
    
    def approveDeleteRoles  #审批删除Roles
    
      $logger.info("审批删除的Roles...")
      
      if $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).exist?
        $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).click 
      end
      
      $a.iframe(FRAME_MAINFRAME).table(TABLE_TODOLISTTABLE).[](1).[](0).link(LINK_TASKINFO).click
      sleep $waittime*2
      $a.button(BUTTON_CLOSE).click
      sleep $waittime
      
      $a.iframe(FRAME_MAINFRAME).link(LINK_HANDLEBTN).when_present.click
      sleep $waittime
      $a.button(BUTTON_APPROVE).when_present.click
      
      sleep $waittime    
    end
    
    def deleteRoles(roleName)
    
      searchRoles(roleName)
      
      $logger.info("删除Roles...")
      
      $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](7).link(LINK_DELETE).click
      $a.button(:text,"OK").click
    
      sleep $waittime  
    end
    
    
    def validateDeleteRoles(roleName)

       result=false  
       expected=''
       reality=''
       
       $logger.info("检查删除的Roles...")       
       searchRoles(roleName)
       infoResult=$a.iframe(FRAME_MAINFRAME).span(SPAN_PAGEINFO).exists?
       
       if infoResult
        result=true
        msg='delete roles successfully'
       else
        result=false
        msg='delete roles failed'
       end
    end
    
    def linkRoleAndUser(roleName,userName)
    
      $logger.info("开始管理Role和Users...")
      
      searchRoles(roleName)
      $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](7).link(LINK_LINK).click
      
      $a.iframe(FRAME_TOPPOPFRAME).iframe(FRAME_ORGUSERMF).text_field(TEXTFIELD_RLOGINNAME).set userName
      $a.iframe(FRAME_TOPPOPFRAME).iframe(FRAME_ORGUSERMF).button(BUTTON_SEARCH).click
      $a.iframe(FRAME_TOPPOPFRAME).iframe(FRAME_ORGUSERMF).table(TABLE_GRIDVIEW).[](1).[](0).click
      $a.button(Button_Save).when_present.click  
    
      sleep $waittime  
      gotoHomepage
    end
    
    def approvelinkRoleAndUser  #审批角色和用户的关联
    
      $logger.info("审批关联的Role和User...")
      
      if $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).exist?
        $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).click 
      end
      
      $a.iframe(FRAME_MAINFRAME).table(TABLE_TODOLISTTABLE).[](1).[](0).link(LINK_TASKINFO).click
      sleep $waittime*2
      $a.button(BUTTON_CLOSE).click
      sleep $waittime 
      
      $a.iframe(FRAME_MAINFRAME).link(LINK_HANDLEBTN).when_present.click
      $a.button(BUTTON_APPROVE).when_present.click
      
      sleep $waittime    
    end
    
    def validateLink(roleName,userName) #验证角色和用户的关联
    
      result=false      
      expected='1person'
      
      $logger.info("检查关联的Role和User...")      
      
      searchRoles(roleName)
      person=$a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](4).text
      
      reality=person
      
      if person=='1person'
        result=true
        msg='link role and user successfully'
      else
        result=false
        msg='link role and user failed'
      end
      gotoHomepage
      
      return result,msg,expected,reality
    end
  
  end
end