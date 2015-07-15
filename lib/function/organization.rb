#!/usr/bin/ruby
# encoding: utf-8

require 'watir-webdriver'
require 'lib/ui.rb'
require 'lib/variable.rb'

module Function
  module Organization
  
    include Control::PublicControl
    include Control::OrganizationControl
  
    def clickMenu_Organization  #点击Organization主目录
    
      $logger.info("点击Organization主目录...")  
      
      $a.link(LINK_Organization).click
      
      sleep $waittime  
    end
    
    def clickRootnode_Organization  #点击Organization根节点
    
      $logger.info("点击Organization根节点...")
      
      $a.iframe(FRAME_MENUFRAME).span(LINK_OROOTNODE).click
      
      sleep $waittime  
    end
    
    def addOrganization(name='OrganizationTest',otherName='OrganizationTest',email='cssca@cssca.com',level='2',insideTel='01066885544',\
        outsideTel='010222666663',attendanceTel='0203885662',fax='05266663555',postalCode='100010',officeNo='1052',\
        address='北京海淀区学院路55号',description='test') #增加Organization
    
      clickMenu_Organization
      clickRootnode_Organization
      $a.iframe(FRAME_MAINFRAME).button(Button_Add).when_present.click
      
      $logger.info("输入新加Organization信息...") 
            
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_ONAME).when_present.set name #name      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OOTHERNAME).set otherName  #other name      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_EMAIL).set email #email      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OLEVEL).set level  #level      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OINSIDETEL).set insideTel  #inside tel      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OOUTSIDETEL).set outsideTel  #outside tel      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OATTENDANCETEL).set attendanceTel  #attendance tel     
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OFAX).set fax   #fax      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OPOST).set postalCode  #postal code      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OFFICENO).set officeNo #office no      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OADDRESS).set address  #address      
      $a.iframe(FRAME_MAINFRAME).textarea(TEXTFIELD_ODESCRIPTION).set description  #description            
      $a.iframe(FRAME_MAINFRAME).button(Button_Save).click #save按钮
      
      sleep $waittime
        
      gotoHomepage
    end
    
    
    def deleteOrganization(keyword_Organization='OrganizationTest') #删除Organization信息，默认删除第一条信息
      
      searchOrganization keyword_Organization
      
      $logger.info("删除Organization信息...") 
      
      $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](5).link(LINK_DELETE).when_present.click
      $a.button(:text,"OK").click
      
      sleep $waittime  
      
      gotoHomepage
    end
    
    
    def validateDelOrg(orgName) #验证删除Organization信息是否成功

      $logger.info("===>>开始验证删除Organization信息：")
      
      result=false  #初始化result为false  
      expected=''
      reality=''
      
      searchOrganization(orgName)
      result=$a.iframe(FRAME_MAINFRAME).span(SPAN_PAGEINFO).exists?
      
      if result
        msg="delete successfully"
      else
        msg="delete failed"
        expected='此条信息不存在'
        reality='此条信息还存在，确认删除是否成功，或者数据刚开始已经存在'  
      end
    
      $logger.info("<<===验证结果:"+result.to_s+','+msg+','+expected+','+reality)  
      return result,msg,expected,reality
    end
    
    def searchOrganization(keyword_Organization='OrganizationTest') #检索Function信息

      $a.goto $homepage
      
      clickMenu_Organization
      clickRootnode_Organization
      
      $logger.info("查找Organization信息...")

      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_SEARCH).when_present.set keyword_Organization
      $a.iframe(FRAME_MAINFRAME).button(BUTTON_SEARCH).click
      
      sleep $waittime  
    end
    
    
    def validateOrganization(name='OrganizationTest',otherName='OrganizationTest',email='cssca@cssca.com',level='2',\
        insideTel='01066885544',outsideTel='010222666663',attendanceTel='0203885662',fax='05266663555',postalCode='100010',\
        officeNo='1052',address='北京海淀区学院路55号',description='test') #检查OrganizationAdd结果
    
      result=false  #初始化result为false
        
      searchOrganization(name)
      $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](5).link(LINK_EDIT).click
      
      $logger.info("===>>开始验证Organization信息：")
      
      #rname
      rname=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_ONAME).value
      #other name
      rotherName=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OOTHERNAME).value
      #email
      remail=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_EMAIL).value
      #level
      rlevel=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OLEVEL).value
      #inside tel
      rinsideTel=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OINSIDETEL).value
      #outside tel
      routsideTel=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OOUTSIDETEL).value
      #attendance tel
      rattendanceTel=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OATTENDANCETEL).value
      #fax
      rfax=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OFAX).value
      #postal code
      rpostalCode=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OPOST).value
      #office no
      rofficeNo=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OFFICENO).value
      #address
      raddress=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OADDRESS).value
      #description
      rdescription=$a.iframe(FRAME_MAINFRAME).textarea(TEXTFIELD_ODESCRIPTION).value
      
      if rname!=name
        msg='Organization name wrong!'
        expected=name
        reality=rname
      elsif rotherName!=otherName
        msg='Organization otherName wrong'
        expected=otherName
        reality=rotherName
      elsif remail!=email
        msg='Organization email wrong'
        expected=email
        reality=remail  
      elsif rlevel!=level
        msg='Organization level wrong'
        expected=level
        reality=rlevel
      elsif rinsideTel!=insideTel
        msg='Organization insideTel wrong'
        expected=insideTel
        reality=rinsideTel
      elsif routsideTel!=outsideTel
        msg='Organization outsideTel wrong'
        expected=outsideTel
        reality=routsideTel
      elsif rattendanceTel!=attendanceTel  
        msg='Organization attendanceTel wrong'
        expected=attendanceTel
        reality=rattendanceTel
      elsif rfax!=fax
        msg='Organization fax wrong'
        expected=fax
        reality=rfax
      elsif rpostalCode!=postalCode
        msg='Organization postalCode wrong'
        expected=postalCode
        reality=rpostalCode    
      elsif rofficeNo!=officeNo
        msg='Organization officeNo wrong'
        expected=officeNo
        reality=rofficeNo
      elsif raddress!=address
        msg='Organization address wrong'
        expected=address
        reality=raddress
      elsif rdescription!=description
        msg='Organization description wrong'
        expected=description
        reality=rdescription
      else
        #全部验证通过后置result为true    
        msg='Add successful'
        result=true
        expected=''
        reality=''
      end
    
      $logger.info("<<===验证结果:"+result.to_s+','+msg+','+expected+','+reality)   
      return result,msg,expected,reality
    end
    
    
    def editOrganization(keyword_orgnizationName='OrganizationTest',name='editOrganization222',otherName='OrganizationTest222',\
        email='cssca222@cssca.com',level='2222',insideTel='010234',outsideTel='010234',attendanceTel='020234',fax='052234',\
        postalCode='100234',officeNo='1234',address='北京海淀区学院路234号',description='test234') #增加Organization
    
      searchOrganization(keyword_orgnizationName)
      $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](5).link(LINK_EDIT).click  
      
      $logger.info("输入编辑的Organization信息...") 
      
      #name
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_ONAME).when_present.set name
      #other name
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OOTHERNAME).set otherName
      #email
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_EMAIL).set email
      #level
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OLEVEL).set level
      #inside tel
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OINSIDETEL).set insideTel
      #outside tel
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OOUTSIDETEL).set outsideTel
      #attendance tel
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OATTENDANCETEL).set attendanceTel
      #fax
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OFAX).set fax
      #postal code
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OPOST).set postalCode
      #office no
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OFFICENO).set officeNo
      #address
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_OADDRESS).set address
      #description
      $a.iframe(FRAME_MAINFRAME).textarea(TEXTFIELD_ODESCRIPTION).set description
      
      #save按钮
      $a.iframe(FRAME_MAINFRAME).button(Button_Save).click
      
      sleep $waittime  
    end
    
    
    def enableOrganization(keyword_orgnizationName) #启用Organization   
    
      $logger.info("enable Organization...") 
      
      searchOrganization(keyword_orgnizationName)
      
      $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](1).click  
      $a.iframe(FRAME_MAINFRAME).button(BUTTON_ENABLE).click
      $a.button(:text,"OK").click
      
      sleep $waittime  
    end
    
    def disableOrganization(keyword_orgnizationName)  #disable Organization    
    
      $logger.info("disable Organization...") 
      
      searchOrganization(keyword_orgnizationName)
      $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](1).click  
      $a.iframe(FRAME_MAINFRAME).button(BUTTON_DISABLE).click
      $a.button(:text,"OK").click    
      
      sleep $waittime  
    end
    
    def validateEnableOrganization(organizationName)  #检查Organization是否启用

      result=false  #初始化result为false
      expected=''
      reality=''
      
      $logger.info("===>>开始验证启用的Organization：")
      
      searchOrganization(organizationName)
      enableOrdisable=$a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](3).text
      
      if enableOrdisable=="Enable"
        result=true
        msg="enable text right"
      else
        result=false
        msg="enable text wrong"
        expected="enable"
        reality=enableOrdisable
      end  
      
      $logger.info("<<===验证结果:"+result.to_s+','+msg+','+expected+','+reality)  
      return result,msg,expected,reality  
    end
    
    def validateDisableOrganization(organizationName) #检查Organization是否启用

      result=false  #初始化result为false
      expected=''
      reality=''      
    
      $logger.info("===>>开始验证未启用的Organization：")
    
      searchOrganization(organizationName)
      enableOrdisable=$a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](3).text
      
      if enableOrdisable=="Disable"
        result=true
        msg="Disable text right"
      else
        result=false
        msg="Disable text wrong"
        expected="enable"
        reality=enableOrdisable
      end  
      
      $logger.info("<<===验证结果:"+result.to_s+','+msg+','+expected+','+reality)  
      return result,msg,expected,reality 
    end
    
  end
end