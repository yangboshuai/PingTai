#!/usr/bin/ruby
# encoding: utf-8

require 'watir-webdriver'
require 'lib/ui.rb'
require 'lib/variable.rb'

module Function
  module User

    include Control::PublicControl
    include Control::UserControl
    
    def clickMenu_User  #点击User主目录
  
      $logger.info("点击User主目录...")    
      $a.link(LINK_USER).when_present.click
    
      sleep $waittime  
    end
  
    def clickOrganizationNode(organizationName) #点击Organization根节点
    
      $logger.info("点击要添加User的Organization节点...") 
       
      $a.iframe(FRAME_MENUFRAME).span(:text=>organizationName).click
      
      sleep $waittime  
    end
    
    def addUser(organizationName,name='userTest',loginName='userTest',firstName='firstName',middleName='middleName',lastName='lastName',\
        gender='Female',dofbirth='30-06-1982',postalCode='05266663555',homeFax='05266663555',residentialAddress='北京海淀区学院路55号',\
        homeTel='0205552336',email='test@sina.com',mobile='13587569875',degree='Junior high school',\
        graduatedInstitution='ChangShaUniversity',major='Doctor',    hintQuestion='888888',answer='888888') #增加Organization
    
      $a.goto $homepage
      clickMenu_User
      clickOrganizationNode(organizationName)
      $a.iframe(FRAME_MAINFRAME).button(Button_Add).when_present.click
      
      $logger.info("输入新加User信息...")  
      
      #name
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UFULLNAME).when_present.set name
      #loginName
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_ULOGINNAME).set loginName
      #firstName
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UFIRSTNAME).set firstName
      #middleName
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UMIDDLENAME).set middleName
      #lastName
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_ULASTNAME).set lastName
      #gender
      $a.iframe(FRAME_MAINFRAME).select(SELECT_UGENDER).select gender
      #date of birth
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UDOFBIRTH).set dofbirth
      #postalCode
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UPOSTALCODE).set postalCode
      #homeFax
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UHOMEFAX).set homeFax
      #residentialAddress
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_URESIDENTIALADDRESS).set residentialAddress
      #homeTel
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UHOMEPHONE).set homeTel
      #email
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UEMAIL).set email  
      #mobile
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UMOBILE).set mobile
      #degree
      $a.iframe(FRAME_MAINFRAME).select(SELECT_UDEGREE).select degree
      #graduatedInstitution
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UGRADUATEDINSTITUTION).set graduatedInstitution
      #major
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UMAJOR).set major
      #hintQuestion
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UHINTQUESTION).set hintQuestion
      #answer
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UANSWER).set answer
      
      #save按钮
      $a.iframe(FRAME_MAINFRAME).button(BUTTON_SUBMIT).click
      
      sleep $waittime*2  
      gotoHomepage
    end
    
    
    def deleteUser(organizationName,keyword_User='userTest')  #删除Organization信息，默认删除第一条信息
     
      searchUser(organizationName,keyword_User)
      
      $logger.info("删除User...")   
      
      $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](7).link(LINK_DELETE).click
      $a.button(:text,"OK").click
      
      sleep $waittime  
    end
    
    def searchUser(organizationName,keyword_User) #检索Function信息
      
      $a.goto $homepage
      clickMenu_User
      clickOrganizationNode(organizationName)
      
      $logger.info("查找User...")  
      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_SEARCH).set keyword_User
      $a.iframe(FRAME_MAINFRAME).button(BUTTON_SEARCH).click
      
      sleep $waittime  
    end
    
    def approveUser #审批通过的user
    
      $logger.info("审批新加的user...") 
      
      if $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).exist?
        $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).click 
      end
      
      $a.iframe(FRAME_MAINFRAME).table(TABLE_TODOLISTTABLE).[](1).[](0).link(LINK_TASKINFO).click
      sleep $waittime
      $a.button(BUTTON_CLOSE).click
      sleep $waittime
        
      $a.iframe(FRAME_MAINFRAME).link(LINK_HANDLEBTN).when_present.click
      $a.iframe(FRAME_MAINFRAME).button(BUTTON_APPROVE).when_present.click
      
      sleep $waittime
    end
    
    def approveDeleteUser #审批删除user
    
      $logger.info("审批删除的user...")
      
      if $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).exist?
        $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).click 
      end
      
      $a.iframe(FRAME_MAINFRAME).table(TABLE_TODOLISTTABLE).[](1).[](0).link(LINK_TASKINFO).click
      sleep $waittime
      $a.button(BUTTON_CLOSE).click
      sleep $waittime
      
      $a.iframe(FRAME_MAINFRAME).link(LINK_HANDLEBTN).when_present.click
      $a.button(BUTTON_APPROVE).when_present.click
      
      sleep $waittime  
    end
    
    def validateUserDelete(organizationName,loginName)

      result=false  #初始化result为false
      expected=''
      reality=''
       
      $logger.info("===>>开始验证删除User：")
      
      inputUsername(loginName)
      inputPasswd('123456')
      clickLogin
      loginResult,loginMsg,loginExpected,loginReality=validateLogin #验证点一
      
      login
      searchUser(organizationName,loginName)
      infoResult=$a.iframe(FRAME_MAINFRAME).span(SPAN_PAGEINFO).exists?  #验证点二
      
      if loginReality=='username or passwd wrong' and infoResult
        result=true
        msg='delete user successfully'
      else
        result=false
        msg='delete user failed'
      end
      
      $logger.info("<<===验证结果:"+result.to_s+','+msg+','+expected+','+reality)  
      return result,msg,expected,reality
    end
    
    def validateUseradd(loginName)  #初始化result为false    
      
      result=false
      expected='login successful'
      
      $logger.info("===>>开始验证新增User：")
      
      inputUsername(loginName)
      inputPasswd('123456')
      clickLogin
      loginResult,loginMsg,loginExpected,loginReality=validateLogin
      reality=loginReality
      
      if loginReality!='login successful'
        result=false      
        msg='add user failed'
      else
        result=true      
        msg='add user successfully'
      end
      
      $logger.info("<<===验证结果:"+result.to_s+','+msg+','+expected+','+reality)  
      return result,msg,expected,reality
    end
    
    
    def editUser(organizationName,username,name='editUserTest',firstName='editfirstName',middleName='editmiddleName',\
        lastName='editlastName',gender='Male',dofbirth='23-07-1984',postalCode='1111111',homeFax='1111111',\
        residentialAddress='北京海淀区学院路1111111号',homeTel='1111111',email='1111111test@sina.com',mobile='1111111',\
        degree='High school',graduatedInstitution='1111Changversity',major='1111111Doctor',hintQuestion='1111111888888',\
        answer='1111111888888') #编辑User信息，编辑第一条信息
      
      searchUser(organizationName,username)
      $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](7).link(LINK_EDIT).click
      
      $logger.info("编辑用户信息...")
      
      #name
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UFULLNAME).set name
      #firstName
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UFIRSTNAME).set firstName
      #middleName
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UMIDDLENAME).set middleName
      #lastName
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_ULASTNAME).set lastName
      #gender
      $a.iframe(FRAME_MAINFRAME).select(SELECT_UGENDER).select gender
      #date of birth
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UDOFBIRTH).set dofbirth
      #postalCode
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UPOSTALCODE).set postalCode
      #homeFax
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UHOMEFAX).set homeFax
      #residentialAddress
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_URESIDENTIALADDRESS).set residentialAddress
      #homeTel
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UHOMEPHONE).set homeTel
      #email
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UEMAIL).set email  
      #mobile
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UMOBILE).set mobile
      #degree
      $a.iframe(FRAME_MAINFRAME).select(SELECT_UDEGREE).select degree
      #graduatedInstitution
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UGRADUATEDINSTITUTION).set graduatedInstitution
      #major
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UMAJOR).set major
      #hintQuestion
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UHINTQUESTION).set hintQuestion
      #answer
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UANSWER).set answer
      
      #save按钮
      $a.iframe(FRAME_MAINFRAME).button(Button_Save).click  
      
      sleep $waittime  
    end
    
    
    def validateUserInfo(organizationName,username,name='editUserTest',firstName='editfirstName',middleName='editmiddleName',\
        lastName='editlastName',gender='Male',dofbirth='23-07-1984',postalCode='1111111',homeFax='1111111',\
        residentialAddress='北京海淀区学院路1111111号',homeTel='1111111',email='1111111test@sina.com',mobile='1111111',\
        degree='High school ',graduatedInstitution='1111111ChangShaUniversity',major='1111111Doctor',hintQuestion='1111111888888',\
        answer='1111111888888') #验证User信息

      result=false  #初始化result为false
      
      searchUser(organizationName,username)
      $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](7).link(LINK_EDIT).click
      
      $logger.info("===>>开始验证User信息：")
      
      #name
      rname=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UFULLNAME).value
      #firstName
      rfirstName=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UFIRSTNAME).value
      #middleName
      rmiddleName=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UMIDDLENAME).value
      #lastName
      rlastName=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_ULASTNAME).value
      #gender
      rgender=$a.iframe(FRAME_MAINFRAME).select(SELECT_UGENDER).selected_options[0].text
      #dofbirth
      rdofbirth=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UDOFBIRTH).value
      #postalCode
      rpostalCode=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UPOSTALCODE).value
      #homeFax
      rhomeFax=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UHOMEFAX).value
      #residentialAddress
      rresidentialAddress=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_URESIDENTIALADDRESS).value
      #homeTel
      rhomeTel=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UHOMEPHONE).value
      #email
      remail=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UEMAIL).value
      #mobile
      rmobile=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UMOBILE).value
      #degree
      rdegree=$a.iframe(FRAME_MAINFRAME).select(SELECT_UDEGREE).selected_options[0].text
      #graduatedInstitution
      rgraduatedInstitution=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UGRADUATEDINSTITUTION).value
      #major
      rmajor=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UMAJOR).value
      #hintQuestion
      rhintQuestion=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UHINTQUESTION).value
      #answer
      ranswer=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_UANSWER).value
      
      if rname!=name
        msg='User name wrong!'
        expected=name
        reality=rname
      elsif rfirstName!=firstName
        msg='User firstname wrong'
        expected=firstName
        reality=rfirstName
      elsif rmiddleName!=middleName
        msg='User middleName wrong'
        expected=middleName
        reality=rmiddleName  
      elsif rlastName!=lastName
        msg='User lastName wrong'
        expected=lastName
        reality=rlastName
      elsif rgender!=gender
        msg='User gender wrong'
        expected=gender
        reality=rgender
      elsif rdofbirth!=dofbirth
        msg='User dofbirth wrong'
        expected=dofbirth
        reality=rdofbirth
      elsif rpostalCode!=postalCode
        msg='User postalCode wrong'
        expected=postalCode
        reality=rpostalCode
      elsif rhomeFax!=homeFax
        msg='User homeFax wrong'
        expected=homeFax
        reality=rhomeFax
      elsif rresidentialAddress!=residentialAddress
        msg='User residentialAddress wrong'
        expected=residentialAddress
        reality=rresidentialAddress
      elsif rhomeTel!=homeTel
        msg='User homeTel wrong'
        expected=homeTel
        reality=rhomeTel
      elsif remail!=email
        msg='User email wrong'
        expected=email
        reality=remail
      elsif rmobile!=mobile
        msg='User mobile wrong'
        expected=mobile
        reality=rmobile
      elsif rdegree!=degree
        msg='User degree wrong'
        expected=degree
        reality=rdegree
      elsif rgraduatedInstitution!=graduatedInstitution
        msg='User graduatedInstitution wrong'
        expected=graduatedInstitution
        reality=rgraduatedInstitution
      elsif rmajor!=major
        msg='User major wrong'
        expected=major
        reality=rmajor  
      elsif rhintQuestion!=hintQuestion
        msg='User hintQuestion wrong'
        expected=hintQuestion
        reality=rhintQuestion
      elsif ranswer!=answer
        msg='User answer wrong'
        expected=answer
        reality=ranswer
      else
        #全部验证通过后置result为true    
        msg='edit successful'
        result=true
        expected=''
        reality=''
      end
      
      $logger.info("<<===验证结果:"+result.to_s+','+msg+','+expected+','+reality)    
      return result,msg,expected,reality  
    end
    
    def enableUser(organizationName,username) #检查User是否启用

      result=false  #初始化result为false
      expected=''
      reality=''
      
      searchUser(organizationName,username)
      $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](1).click  
      $a.iframe(FRAME_MAINFRAME).button(BUTTON_ENABLE).click
      
      $a.button(:text,"OK").click
      
      sleep $waittime  
    end
    
    def disableUser(organizationName,username)  #使User disable      
      
      searchUser(organizationName,username)
      
      $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](1).click  
      $a.iframe(FRAME_MAINFRAME).button(BUTTON_DISABLE).click      
      $a.button(:text,"OK").click
      
      sleep $waittime  
    end
    
    def validateDisableUser #检查User是否disable    

      result=false #初始化result为false
      expected=''
      reality=''
      
      $logger.info("===>>开始验证新增User：")
      
      inputUsername(loginName)
      inputPasswd('123456')
      clickLogin
      loginResult,loginMsg,loginExpected,loginReality=validateLogin
      
      if loginReality!='login successful'
        msg='add user failed'
        result=false
      else
        msg='add user successfully'
        result=true
      end
    
      $logger.info("<<===验证结果:"+result.to_s+','+msg+','+expected+','+reality)  
      return result,msg,expected,reality
    end
  
  
  end
end