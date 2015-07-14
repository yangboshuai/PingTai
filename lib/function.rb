#!/usr/bin/ruby
# encoding: utf-8

require 'watir-webdriver'
require 'lib/variable.rb'
require 'lib/ui.rb'
require 'test/unit'
require 'logger'
require 'win32ole'


module Function

include Control

################################
#         登录页面Login
################################

#def openUrl(url='http://10.10.2.40:8080/apex/login')
def openUrl(url=$url)
  #打开指定网页 
  #@parm：url     
  #@return
   $logger.info("打开网页"+url+"...")
  
   $a=Watir::Browser.new:chrome
   $a.driver.manage.window.maximize
#  $a.driver.manage.timeouts.implicit_wait = 1 # seconds
  $a.goto url
  
  sleep $waittime
end

def inputUsername(username)
  #登录页面输入用户名
  #@parm：username     
  #@return
   $logger.info("输入用户名"+username+"...")
  
   $a.text_field(Control::TEXTFIELD_USERNAME).set username
   
   sleep $waittime
end

def inputPasswd(passwd)
  #登录页面输入密码
  #@parm：username     
  #@return
   $logger.info("输入密码"+passwd+"...")
   $a.text_field(Control::TEXTFIELD_PASSWD).set passwd
   
   sleep $waittime
end 

def clickLogin
  #点击登录按钮
  #@parm：username     
  #@return
  $logger.info("点击登录按钮...")
  
  $a.button(Control::BUTTON_LOGIN).click
  
  sleep $waittime
end

def validateLogin(expected='login successful')
  #验证登录结果
  #@parm：expected
  #@value：passwd wrong；username wrong；login successful
  #@return
  $logger.info("===>>开始验证登录信息：")
  
  #初始化result为false
  result=false  
  reality=''
  msg=''
  
  if $a.span(:text,"The entered password is not correct.").exists?
    msg='passwd wrong'
  elsif $a.text_field(:id=>"jcaptchaCode").exists?
    msg='username wrong'
  elsif $a.button(:text,"Yes").exists?
    $a.button(:text,"Yes").click
    sleep(2)
    if $a.div(:class,"pull-right").exists?
      msg='login successful'
    elsif $a.span(:text,"The entered password is not correct.").exists?
      msg='passwd wrong'
    else
      msg='login failed'
    end
  elsif $a.div(:class,"pull-right").exists?
    msg='login successful'
  else
    msg='login failed' 
  end
  
  reality=msg

  if expected==reality
    result=true    
    msg='check pass'
  else  
    result=false
    msg='check fail'
  end
  
  $logger.info("<<===验证结果:"+result.to_s+','+msg+','+expected+','+reality)
  
  return result,msg,expected,reality  
end

def login(username='sysadmin',passwd='123456')
  #输入用户名，输入密码，点击登录，验证登录
  #@parm：username,passwd
  #@return
  
  inputUsername(username)
  inputPasswd(passwd)
  clickLogin
  validateLogin
end


def logout
  #退出系统  
  $logger.info("退出系统...")  
  
  $a.goto $homepage
  $a.link(LINK_DROPDOWNTOGGLE).click
  $a.link(LINK_LOGOUT).click
  $a.button(:text,"OK").click 
   
end
################################
#         功能管理页面Function
################################

def clickMenu_Function
#点击Function主目录
  $logger.info("点击Function主目录...")  
  
  $a.link(Control::LINK_FUNCTION).when_present.click
  
  sleep $waittime
end

def clickF_MenuRoot
#点击MenuRoot根节点
  $logger.info("点击Function页面中的MenuRoot跟节点...")
  
  $a.iframe(FRAME_MENUFRAME).link(Control::LINK_MENUROOT).click
  
  sleep $waittime  
end

def addFunction(name='Functiontest',code='Functiontest',sOrh='show',pageTarget='Navigation',pageUrl='apex.menu.test,iconUrl',iconUrl='apex.menu.test',iconX='',iconY='',description='')
  #输入新增Function信息
  #@parm：name,code,sOrh,pageTarget,pageUrl,iconUrl,iconX,iconY,description
  #@value:sOrh:show,hide;pageTarget:Workspace,Navigation
  #@return

  clickMenu_Function
  clickF_MenuRoot
  
  $logger.info("addFunction输入信息...")
  
  $a.iframe(FRAME_MAINFRAME).button(Control::Button_Add).when_present.click
  
  #name
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_FNAME).set name
  #Code
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_FCODE).set code
  #Hide or Show
  if sOrh=='show'
    $a.iframe(FRAME_MAINFRAME).radio(Control::RADIO_FSHOW).set
  elsif sOrh=='hide'
    $a.iframe(FRAME_MAINFRAME).radio(Control::RADIO_FHIDE).set
  end
  #Page Target 
  $a.iframe(FRAME_MAINFRAME).select(Control::SELECT_FPAGETARGET).select pageTarget
  #pageUrl
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_FPAGEURL).set pageUrl
  #iconUrl
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_FICONURL).set iconUrl
  #iconX
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_FICONX).when_present.set iconX
  #iconY
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_FICONY).set iconY
  #description
  $a.iframe(FRAME_MAINFRAME).textarea(Control::TEXTFIELD_FDESCRIPTION).set description
  
  $a.iframe(FRAME_MAINFRAME).button(Control::Button_Save).click  
  
  sleep $waittime*2   
end

def validateFunction(name='Functiontest',code='Functiontest',sOrh='show',pageTarget='Navigation',pageUrl='apex.menu.test,iconUrl',iconUrl='apex.menu.test',iconX='',iconY='',description='')
  #检查FunctionAdd结果
  #@parm：name,code,sOrh,pageTarget,pageUrl,iconUrl,iconX,iconY,description
  #@value:sOrh:show,hide;pageTarget:Workspace,Navigation
  #@return:result:结果；msg：错误信息；expected：期望值；reality：实际值
  $logger.info("===>>开始验证Function信息：")
  
  #初始化result为false
  result=false
  
  searchFunction(name)
  $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](6).link(LINK_EDIT).click
  
  rname=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_FNAME).value
  rcode=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_FCODE).value 
   
  if $a.iframe(FRAME_MAINFRAME).radio(Control::RADIO_FSHOW).set? and !($a.iframe(FRAME_MAINFRAME).radio(Control::RADIO_FHIDE).set?)
    rsOrh='show'
  elsif !($a.iframe(FRAME_MAINFRAME).radio(Control::RADIO_FSHOW).set?) and ($a.iframe(FRAME_MAINFRAME).radio(Control::RADIO_FHIDE).set?)
    rsOrh='hide'
  end
  
  rpageTarget=$a.iframe(FRAME_MAINFRAME).select(Control::SELECT_FPAGETARGET).selected_options[0].text
  rpageUrl=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_FPAGEURL).value
  riconUrl=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_FICONURL).value
  riconX=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_FICONX).value
  riconY=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_FICONY).value
  rdescription=$a.iframe(FRAME_MAINFRAME).textarea(Control::TEXTFIELD_FDESCRIPTION).value
  

  if iconX!=''
    iconX_convert="N$"+format("%0.2f",iconX.to_f)
  else
    iconX_convert=''
  end
  
  if rname!=name
    msg='Function name wrong!'
    expected=name
    reality=rname
  elsif rcode!=code
    msg='Function code wrong'
    expected=code
    reality=rcode
  elsif rsOrh!=sOrh
    msg='Function sOrh wrong'
    expected=sOrh
    reality=rsOrh  
  elsif rpageTarget!=pageTarget
    msg='Function pageTarget wrong'
    expected=pageTarget
    reality=rpageTarget      
  elsif rpageUrl!=pageUrl
    msg='Function pageUrl wrong'
    expected=pageUrl
    reality=rpageUrl     
  elsif riconUrl!=iconUrl
    msg='Function iconUrl wrong'
    expected=iconUrl
    reality=riconUrl
  elsif riconX!=iconX_convert  
    msg='Function iconX wrong'
    expected=iconX_convert 
    reality=riconX
    
  elsif riconY!=iconY
    msg='Function iconY wrong'
    expected=iconY
    reality=riconY
  elsif rdescription!=description
    msg='Function description wrong'
    expected=description
    reality=rdescription
  else
    #全部验证通过后置result为true    
    msg='Function info right'
    result=true
    expected=''
    reality=''
  end
  
  $logger.info("<<===验证结果:"+result.to_s+','+msg+','+expected+','+reality) 

  return result,msg,expected,reality
end


def searchFunction(keyword_functionName)
  #检索Function信息
  #@parm：keyword
  #@value:
  #@return
  $a.goto $homepage
  clickMenu_Function
  clickF_MenuRoot
  $logger.info("查找Function...")  
  $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_SEARCH).when_present.set keyword_functionName
  $a.iframe(FRAME_MAINFRAME).button(BUTTON_SEARCH).click
  
  sleep $waittime  
end


def deleteFunction(keyword_functionName='Functiontest')
  #删除Function信息，默认删除第一条信息
  #@parm：keyword
  #@value:
  #@return
  
  searchFunction keyword_functionName
  
  $logger.info("删除Function...")
  
  $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](6).link(LINK_DELETE).click
  $a.button(:text,"OK").click
  
  sleep $waittime  
end


def editFunction(keyword_functionName='Functiontest',name='Functiontest2',code='Functiontest2',sOrh='hide',pageTarget='Workspace',pageUrl='2apex.menu.test,iconUrl',iconUrl='2apex.menu.test',iconX='2',iconY='2',description='2')
  #输入新增Function信息
  #@parm：name,code,sOrh,pageTarget,pageUrl,iconUrl,iconX,iconY,description
  #@value:sOrh:show,hide;pageTarget:Workspace,Navigation
  #@return
  searchFunction(keyword_functionName)
  
  $logger.info("编辑Function...")  
  
  $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](6).link(LINK_EDIT).click
  
  #name
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_FNAME).set name
  #Code
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_FCODE).set code
  #Hide or Show
  if sOrh=='show'
    $a.iframe(FRAME_MAINFRAME).radio(Control::RADIO_FSHOW).set
  elsif sOrh=='hide'
    $a.iframe(FRAME_MAINFRAME).radio(Control::RADIO_FHIDE).set
  end
  #Page Target 
  $a.iframe(FRAME_MAINFRAME).select(Control::SELECT_FPAGETARGET).select pageTarget
  #pageUrl
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_FPAGEURL).set pageUrl
  #iconUrl
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_FICONURL).set iconUrl
  #iconX
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_FICONX).when_present.set iconX
  #iconY
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_FICONY).set iconY
  #description
  $a.iframe(FRAME_MAINFRAME).textarea(Control::TEXTFIELD_FDESCRIPTION).set description
  
  $a.iframe(FRAME_MAINFRAME).button(Control::Button_Save).click
  
  sleep $waittime  
end


def validateDeleteFunction
  $logger.info("===>>开始验证删除Function信息：")
  expected=''
  reality=''
  #初始化result为false
  result=false
  
  result=$a.iframe(FRAME_MAINFRAME).span(Control::SPAN_PAGEINFO).exists?
  if result    
    msg="delete successfully"
  else
    msg="delete failed"
  end

  $logger.info("<<===验证结果:"+result.to_s+','+msg+','+expected+','+reality)
  return result,msg,expected,reality
end


def hideFunction(keyword_functionName='Functiontest')
  $logger.info("hideFunction...")  
  $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](1).text_field(TEXTFIELD_FCHECKBOX).click
  $a.iframe(FRAME_MAINFRAME).button(Button_FHIDE).click
  $a.button(:text,"OK").click  
  
  sleep $waittime  
end

def showFunction(keyword_functionName='Functiontest')
  $logger.info("showFunction...") 
  $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](1).text_field(TEXTFIELD_FCHECKBOX).click
  $a.iframe(FRAME_MAINFRAME).button(Button_FSHOW).click
  $a.button(:text,"OK").click
  
  sleep $waittime  
end

################################
#         组织管理页面Organization
################################

def clickMenu_Organization
#点击Organization主目录
  $logger.info("点击Organization主目录...")  
  $a.link(Control::LINK_Organization).click
  
  sleep $waittime  
end

def clickRootnode_Organization
#点击Organization根节点
  $logger.info("点击Organization根节点...") 
  $a.iframe(FRAME_MENUFRAME).span(Control::LINK_OROOTNODE).click
  
  sleep $waittime  
end

def addOrganization(name='OrganizationTest',otherName='OrganizationTest',email='cssca@cssca.com',level='2',insideTel='01066885544',
outsideTel='010222666663',attendanceTel='0203885662',fax='05266663555',postalCode='100010',officeNo='1052',address='北京海淀区学院路55号',description='test')
#增加Organization
  clickMenu_Organization
  clickRootnode_Organization
  $a.iframe(FRAME_MAINFRAME).button(Control::Button_Add).when_present.click
  
  $logger.info("输入新加Organization信息...") 
  #name
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_ONAME).when_present.set name
  #other name
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OOTHERNAME).set otherName
  #email
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_EMAIL).set email
  #level
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OLEVEL).set level
  #inside tel
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OINSIDETEL).set insideTel
  #outside tel
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OOUTSIDETEL).set outsideTel
  #attendance tel
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OATTENDANCETEL).set attendanceTel
  #fax
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OFAX).set fax
  #postal code
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OPOST).set postalCode
  #office no
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OFFICENO).set officeNo
  #address
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OADDRESS).set address
  #description
  $a.iframe(FRAME_MAINFRAME).textarea(Control::TEXTFIELD_ODESCRIPTION).set description
  
  #save按钮
  $a.iframe(FRAME_MAINFRAME).button(Control::Button_Save).click
  
  sleep $waittime*2  
  gotoHomepage
end


def deleteOrganization(keyword_Organization='OrganizationTest')
  #删除Organization信息，默认删除第一条信息
  #@parm：keyword
  #@value:
  #@return
  
  searchOrganization keyword_Organization
  $logger.info("删除Organization信息...") 
  $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](5).link(LINK_DELETE).when_present.click
  $a.button(:text,"OK").click
  
  sleep $waittime  
  gotoHomepage
end


def validateDelOrg(orgName)
  #验证删除Organization信息是否成功
  #@parm：
  #@value:
  #@return
  $logger.info("===>>开始验证删除Organization信息：")
  
  #初始化result为false
  result=false  
  expected=''
  reality=''
  
  searchOrganization(orgName)
  result=$a.iframe(FRAME_MAINFRAME).span(Control::SPAN_PAGEINFO).exists?
  if result
    msg="delete successfully"
  else
    msg="delete failed"
  end

  $logger.info("<<===验证结果:"+result.to_s+','+msg+','+expected+','+reality)  
  return result,msg,expected,reality
end


def searchOrganization(keyword_Organization='OrganizationTest')
  #检索Function信息
  #@parm：keyword
  #@value:
  #@return
  
  $a.goto $homepage
  clickMenu_Organization
  clickRootnode_Organization
  $logger.info("查找Organization信息...")  
  $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_SEARCH).when_present.set keyword_Organization
  $a.iframe(FRAME_MAINFRAME).button(BUTTON_SEARCH).click
  
  sleep $waittime  
end


def validateOrganization(name='OrganizationTest',otherName='OrganizationTest',email='cssca@cssca.com',level='2',insideTel='01066885544',
outsideTel='010222666663',attendanceTel='0203885662',fax='05266663555',postalCode='100010',officeNo='1052',address='北京海淀区学院路55号',description='test')
  #检查OrganizationAdd结果
  #@parm：name,otherName,email,insideTel,outsideTel,attendanceTel,fax,postalCode,officeNo,address,description
  #@value:
  #@return:result:结果；msg：错误信息；expected：期望值；reality：实际值

  #初始化result为false
  result=false
    
  searchOrganization(name)
  $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](5).link(LINK_EDIT).click
  
  $logger.info("===>>开始验证Organization信息：")
  #rname
  rname=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_ONAME).value
  #other name
  rotherName=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OOTHERNAME).value
  #email
  remail=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_EMAIL).value
  #level
  rlevel=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OLEVEL).value
  #inside tel
  rinsideTel=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OINSIDETEL).value
  #outside tel
  routsideTel=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OOUTSIDETEL).value
  #attendance tel
  rattendanceTel=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OATTENDANCETEL).value
  #fax
  rfax=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OFAX).value
  #postal code
  rpostalCode=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OPOST).value
  #office no
  rofficeNo=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OFFICENO).value
  #address
  raddress=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OADDRESS).value
  #description
  rdescription=$a.iframe(FRAME_MAINFRAME).textarea(Control::TEXTFIELD_ODESCRIPTION).value
  
  result=false  
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


def editOrganization(keyword_orgnizationName='OrganizationTest',name='editOrganization222',otherName='OrganizationTest222',email='cssca222@cssca.com',level='2222',insideTel='010234',
outsideTel='010234',attendanceTel='020234',fax='052234',postalCode='100234',officeNo='1234',address='北京海淀区学院路234号',description='test234')
#增加Organization
  searchOrganization(keyword_orgnizationName)
  $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](5).link(LINK_EDIT).click  
  
  $logger.info("输入编辑的Organization信息...") 
  #name
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_ONAME).when_present.set name
  #other name
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OOTHERNAME).set otherName
  #email
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_EMAIL).set email
  #level
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OLEVEL).set level
  #inside tel
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OINSIDETEL).set insideTel
  #outside tel
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OOUTSIDETEL).set outsideTel
  #attendance tel
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OATTENDANCETEL).set attendanceTel
  #fax
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OFAX).set fax
  #postal code
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OPOST).set postalCode
  #office no
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OFFICENO).set officeNo
  #address
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_OADDRESS).set address
  #description
  $a.iframe(FRAME_MAINFRAME).textarea(Control::TEXTFIELD_ODESCRIPTION).set description
  
  #save按钮
  $a.iframe(FRAME_MAINFRAME).button(Control::Button_Save).click
  
  sleep $waittime  
end


def enableOrganization(keyword_orgnizationName)
#启用Organization

  $logger.info("enable Organization...") 
  searchOrganization(keyword_orgnizationName)
  $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](1).click  
  $a.iframe(FRAME_MAINFRAME).button(BUTTON_ENABLE).click
  $a.button(:text,"OK").click
  
  sleep $waittime  
end

def disableOrganization(keyword_orgnizationName)
#disable Organization

  $logger.info("disable Organization...") 
  searchOrganization(keyword_orgnizationName)
  $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](1).click  
  $a.iframe(FRAME_MAINFRAME).button(BUTTON_DISABLE).click
  $a.button(:text,"OK").click    
  
  sleep $waittime  
end

def validateEnableOrganization(organizationName)
#检查Organization是否启用
  expected=''
  reality=''
  #初始化result为false
  result=false
    
  $logger.info("===>>开始验证启用的Organization：")
  
  #验证1
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

def validateDisableOrganization(organizationName)
#检查Organization是否启用
  expected=''
  reality=''
  #初始化result为false
  result=false

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

################################
#        用户管理页面User
################################

def clickMenu_User
#点击User主目录
  $logger.info("点击User主目录...")    
  $a.link(Control::LINK_USER).when_present.click
  
  sleep $waittime  
end

def clickOrganizationNode(organizationName)
#点击Organization根节点
  $logger.info("点击要添加User的Organization节点...")  
  $a.iframe(FRAME_MENUFRAME).span(:text=>organizationName).click
  
  sleep $waittime  
end

def addUser(organizationName,name='userTest',loginName='userTest',firstName='firstName',middleName='middleName',lastName='lastName',
gender='Female',dofbirth='30-06-1982',postalCode='05266663555',homeFax='05266663555',residentialAddress='北京海淀区学院路55号',homeTel='0205552336',
email='test@sina.com',mobile='13587569875',degree='Junior high school',graduatedInstitution='ChangShaUniversity',major='Doctor',
hintQuestion='888888',answer='888888')
#增加Organization
  $a.goto $homepage
  clickMenu_User
  clickOrganizationNode(organizationName)
  $a.iframe(FRAME_MAINFRAME).button(Control::Button_Add).when_present.click
  
  $logger.info("输入新加User信息...")  
  #name
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UFULLNAME).when_present.set name
  #loginName
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_ULOGINNAME).set loginName
  #firstName
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UFIRSTNAME).set firstName
  #middleName
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UMIDDLENAME).set middleName
  #lastName
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_ULASTNAME).set lastName
  #gender
  $a.iframe(FRAME_MAINFRAME).select(Control::SELECT_UGENDER).select gender
  #date of birth
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UDOFBIRTH).set dofbirth
  #postalCode
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UPOSTALCODE).set postalCode
  #homeFax
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UHOMEFAX).set homeFax
  #residentialAddress
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_URESIDENTIALADDRESS).set residentialAddress
  #homeTel
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UHOMEPHONE).set homeTel
  #email
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UEMAIL).set email  
  #mobile
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UMOBILE).set mobile
  #degree
  $a.iframe(FRAME_MAINFRAME).select(Control::SELECT_UDEGREE).select degree
  #graduatedInstitution
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UGRADUATEDINSTITUTION).set graduatedInstitution
  #major
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UMAJOR).set major
  #hintQuestion
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UHINTQUESTION).set hintQuestion
  #answer
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UANSWER).set answer
  
  #save按钮
  $a.iframe(FRAME_MAINFRAME).button(Control::BUTTON_SUBMIT).click
  
  sleep $waittime*2  
  gotoHomepage
end


def deleteUser(organizationName,keyword_User='userTest')
  #删除Organization信息，默认删除第一条信息
  #@parm：keyword
  #@value:
  #@return
 
  searchUser(organizationName,keyword_User)
  $logger.info("删除User...")   
  $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](7).link(LINK_DELETE).click
  $a.button(:text,"OK").click
  
  sleep $waittime  
end

def searchUser(organizationName,keyword_User)
  #检索Function信息
  #@parm：keyword
  #@value:
  #@return
    
  $a.goto $homepage
  clickMenu_User
  clickOrganizationNode(organizationName)
  $logger.info("查找User...")  
  $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_SEARCH).set keyword_User
  $a.iframe(FRAME_MAINFRAME).button(BUTTON_SEARCH).click
  
  sleep $waittime  
end

def approveUser
#审批通过的user
  $logger.info("审批新加的user...") 
  if $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).exist?
    $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).click 
  end
  
  $a.iframe(FRAME_MAINFRAME).table(TABLE_TODOLISTTABLE).[](1).[](0).link(LINK_TASKINFO).click
  sleep 5
  $a.button(BUTTON_CLOSE).click
  sleep 2
    
  $a.iframe(FRAME_MAINFRAME).link(LINK_HANDLEBTN).when_present.click
  $a.iframe(FRAME_MAINFRAME).button(BUTTON_APPROVE).when_present.click
  
  sleep $waittime
end

def approveDeleteUser
#审批删除user
  $logger.info("审批删除的user...")
  if $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).exist?
    $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).click 
  end
  
  $a.iframe(FRAME_MAINFRAME).table(TABLE_TODOLISTTABLE).[](1).[](0).link(LINK_TASKINFO).click
  sleep 5
  $a.button(BUTTON_CLOSE).click
  sleep 2
  
  $a.iframe(FRAME_MAINFRAME).link(LINK_HANDLEBTN).when_present.click
  $a.button(BUTTON_APPROVE).when_present.click
  
  sleep $waittime  
end

def validateUserDelete(organizationName,loginName)
  expected=''
  reality=''
  #初始化result为false
  result=false
    
  $logger.info("===>>开始验证删除User：")
  inputUsername(loginName)
  inputPasswd('123456')
  clickLogin
  loginResult,loginMsg,loginExpected,loginReality=validateLogin
  
  login
  searchUser(organizationName,loginName)
  infoResult=$a.iframe(FRAME_MAINFRAME).span(Control::SPAN_PAGEINFO).exists?
  
  if loginReality=='passwd wrong' and infoResult
    result=true
    msg='delete user successfully'
  else
    result=false
    msg='delete user failed'
  end

  $logger.info("<<===验证结果:"+result.to_s+','+msg+','+expected+','+reality)  
  return result,msg,expected,reality
end

def validateUseradd(loginName)

  #初始化result为false
  result=false
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


def editUser(organizationName,username,name='editUserTest',firstName='editfirstName',middleName='editmiddleName',lastName='editlastName',
gender='Male',dofbirth='23-07-1984',postalCode='1111111',homeFax='1111111',residentialAddress='北京海淀区学院路1111111号',homeTel='1111111',
email='1111111test@sina.com',mobile='1111111',degree='High school',graduatedInstitution='1111111ChangShaUniversity',major='1111111Doctor',
hintQuestion='1111111888888',answer='1111111888888')
  #编辑User信息，编辑第一条信息
  #@parm：
  #@value:
  #@return
  
  searchUser(organizationName,username)
  $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](7).link(LINK_EDIT).click
  $logger.info("编辑用户信息...")  
  #name
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UFULLNAME).set name
  #firstName
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UFIRSTNAME).set firstName
  #middleName
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UMIDDLENAME).set middleName
  #lastName
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_ULASTNAME).set lastName
  #gender
  $a.iframe(FRAME_MAINFRAME).select(Control::SELECT_UGENDER).select gender
  #date of birth
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UDOFBIRTH).set dofbirth
  #postalCode
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UPOSTALCODE).set postalCode
  #homeFax
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UHOMEFAX).set homeFax
  #residentialAddress
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_URESIDENTIALADDRESS).set residentialAddress
  #homeTel
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UHOMEPHONE).set homeTel
  #email
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UEMAIL).set email  
  #mobile
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UMOBILE).set mobile
  #degree
  $a.iframe(FRAME_MAINFRAME).select(Control::SELECT_UDEGREE).select degree
  #graduatedInstitution
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UGRADUATEDINSTITUTION).set graduatedInstitution
  #major
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UMAJOR).set major
  #hintQuestion
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UHINTQUESTION).set hintQuestion
  #answer
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UANSWER).set answer
  
  #save按钮
  $a.iframe(FRAME_MAINFRAME).button(Control::Button_Save).click  
  
  sleep $waittime  
end


def validateUserInfo(organizationName,username,name='editUserTest',firstName='editfirstName',middleName='editmiddleName',lastName='editlastName',
gender='Male',dofbirth='23-07-1984',postalCode='1111111',homeFax='1111111',residentialAddress='北京海淀区学院路1111111号',homeTel='1111111',
email='1111111test@sina.com',mobile='1111111',degree='High school ',graduatedInstitution='1111111ChangShaUniversity',major='1111111Doctor',
hintQuestion='1111111888888',answer='1111111888888')

  #初始化result为false
  result=false
  
  searchUser(organizationName,username)
  $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](7).link(LINK_EDIT).click
  $logger.info("===>>开始验证User信息：")
  #name
  rname=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UFULLNAME).value
  #firstName
  rfirstName=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UFIRSTNAME).value
  #middleName
  rmiddleName=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UMIDDLENAME).value
  #lastName
  rlastName=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_ULASTNAME).value
  #gender
  rgender=$a.iframe(FRAME_MAINFRAME).select(Control::SELECT_UGENDER).selected_options[0].text
  #dofbirth
  rdofbirth=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UDOFBIRTH).value
  #postalCode
  rpostalCode=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UPOSTALCODE).value
  #homeFax
  rhomeFax=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UHOMEFAX).value
  #residentialAddress
  rresidentialAddress=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_URESIDENTIALADDRESS).value
  #homeTel
  rhomeTel=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UHOMEPHONE).value
  #email
  remail=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UEMAIL).value
  #mobile
  rmobile=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UMOBILE).value
  #degree
  rdegree=$a.iframe(FRAME_MAINFRAME).select(Control::SELECT_UDEGREE).selected_options[0].text
  #graduatedInstitution
  rgraduatedInstitution=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UGRADUATEDINSTITUTION).value
  #major
  rmajor=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UMAJOR).value
  #hintQuestion
  rhintQuestion=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UHINTQUESTION).value
  #answer
  ranswer=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_UANSWER).value
  
  result=false  
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


def enableUser(organizationName,username)
#检查User是否启用
  expected=''
  reality=''
  #初始化result为false
  result=false
  
  searchUser(organizationName,username)
  $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](1).click  
  $a.iframe(FRAME_MAINFRAME).button(BUTTON_ENABLE).click
  $a.button(:text,"OK").click
  
  sleep $waittime  
end

def disableUser(organizationName,username)
  #使User disable
  
  searchUser(organizationName,username)
  $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](1).click  
  $a.iframe(FRAME_MAINFRAME).button(BUTTON_DISABLE).click
  $a.button(:text,"OK").click
  
  sleep $waittime  
end

def validateDisableUser
#检查User是否disable

  expected=''
  reality=''
  #初始化result为false
  result=false
  
  $logger.info("===>>开始验证新增User：")
  
  inputUsername(loginName)
  inputPasswd('123456')
  clickLogin
  loginResult,loginMsg,loginExpected,loginReality=validateLogin()

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

################################
#        角色管理页面Roles
################################

def clickMenu_Roles
#点击Organization主目录
  $logger.info("点击Roles主目录...")  
  $a.link(Control::LINK_Roles).click
  
  sleep $waittime  
end

def addRoles(roleName="roleTest01",roleDescription="test")
#新加Roles
  clickMenu_Roles
  $logger.info("addRoles输入Roles信息...")
  
  $a.iframe(FRAME_MAINFRAME).button(Control::Button_Add).when_present.click  
  
  #roleName
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_ROLENAME).set roleName
  #roleDescription
  $a.iframe(FRAME_MAINFRAME).textarea(Control::TEXTAREA_DESCRIPTION).set roleDescription

  #submit按钮
  $a.iframe(FRAME_MAINFRAME).button(Control::BUTTON_SUBMIT).click
  
  sleep $waittime*2  
  gotoHomepage
  
end


def approveRoles
#审批通过的Roles
  $logger.info("审批新加的Roles...") 
  if $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).exist?
    $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).click 
  end
  
  $a.iframe(FRAME_MAINFRAME).table(TABLE_TODOLISTTABLE).[](1).[](0).link(LINK_TASKINFO).click
  sleep 5
  $a.button(BUTTON_CLOSE).click
  sleep 2
  
  $a.iframe(FRAME_MAINFRAME).link(LINK_HANDLEBTN).when_present.click
  sleep 4
  $a.iframe(FRAME_MAINFRAME).button(BUTTON_APPROVE).when_present.click
  
  sleep $waittime  
end

def completeRoles
#确认Roles
  $logger.info("确认新加的Roles...") 
  
  if $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).exist?
    $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).click 
  end
  
  $a.iframe(FRAME_MAINFRAME).link(LINK_HANDLEBTN).when_present.click
  $a.iframe(FRAME_MAINFRAME).button(BUTTON_COMPLETE).when_present.click
  
  sleep $waittime  
end


def searchRoles(keyword_RoleName)
  #检索Roles信息
  #@parm：roleName
  #@value:
  #@return
  
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
  
  if reality==expected
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
  sleep(2)
  #roleName
  $a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_ROLENAME).set roleName
  #roleDescription
  $a.iframe(FRAME_MAINFRAME).textarea(Control::TEXTAREA_DESCRIPTION).set roleDescription
  
  #save按钮
  $a.iframe(FRAME_MAINFRAME).button(Control::Button_Save).when_present.click

  sleep $waittime      
end

def validateRoles(roleName=TESTDATA_EDITROLENAME,roleDescription='editRoleTest')

  searchRoles(roleName)
  $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](7).link(LINK_EDIT).click
  $logger.info("===>>开始验证Roles信息：")
  
  #roleName
  rroleName=$a.iframe(FRAME_MAINFRAME).text_field(Control::TEXTFIELD_ROLENAME).value
  #roleDescription
  rroleDescription=$a.iframe(FRAME_MAINFRAME).textarea(Control::TEXTAREA_DESCRIPTION).value
  
  result=false  
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
    expected=''
    reality=''    
  end
  
  return result,msg,expected,reality
end

def approveDeleteRoles
#审批删除Roles
  $logger.info("审批删除的Roles...")
  if $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).exist?
    $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).click 
  end
  
  $a.iframe(FRAME_MAINFRAME).table(TABLE_TODOLISTTABLE).[](1).[](0).link(LINK_TASKINFO).click
  sleep 5
  $a.button(BUTTON_CLOSE).click
  sleep 2
  
  $a.iframe(FRAME_MAINFRAME).link(LINK_HANDLEBTN).when_present.click
  sleep 2
  $a.button(BUTTON_APPROVE).when_present.click
  
  sleep $waittime    
end

def deleteRoles(roleName)
  searchRoles(roleName)
  $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](7).link(LINK_DELETE).click
  $a.button(:text,"OK").click

  sleep $waittime  
end


def validateDeleteRoles(roleName)
   expected=''
   reality=''
   result=false  
    
   searchRoles(roleName)
   infoResult=$a.iframe(FRAME_MAINFRAME).span(Control::SPAN_PAGEINFO).exists?
   
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

def approvelinkRoleAndUser
#审批删除Roles
  $logger.info("审批关联的Role和User...")
  if $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).exist?
    $a.iframe(FRAME_MAINFRAME).link(LINK_CLAIMBTN).click 
  end
  
  $a.iframe(FRAME_MAINFRAME).table(TABLE_TODOLISTTABLE).[](1).[](0).link(LINK_TASKINFO).click
  sleep 5
  $a.button(BUTTON_CLOSE).click
  sleep 2
  
  $a.iframe(FRAME_MAINFRAME).link(LINK_HANDLEBTN).when_present.click
  $a.button(BUTTON_APPROVE).when_present.click
  
  sleep $waittime    
end

def validateLink(roleName,userName)
#审批删除Roles
  result=false
  $logger.info("检查关联的Role和User...")
  expected=''
  reality=''
  
  searchRoles(roleName)
  person=$a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](4).text
  
  expected='1person'
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

################################
#         公共方法Function
################################

def quit
#关闭浏览器
#@parm：
#@return
  $logger.info("退出浏览器...")  
  $a.quit
end

def createExcel  
  $excel=WIN32OLE::new('excel.Application')
  $workbook=$excel.Workbooks.Open($path)
  $excel.DisplayAlerts = false
  
  if $new   
    $logger.info("新加ExcelReport...")  
    $worksheet=$workbook.Worksheets.Add()
    $worksheet.name='TestReport'+Time.new.strftime("%Y%m%d%H%M%S")
    $reportName=$worksheet.name
    
    #########################测试报告标题###################################
    $worksheet.Range("C1").Value = "北京中软冠群软件技术有限公司测试报告"  
    #合并单元格  
    $worksheet.Range("C1:F1").Merge
    #水平居中 -4108  
    $worksheet.Range("C1:F1").HorizontalAlignment = -4108  
#    $worksheet.Range("C1:F1").Interior.ColorIndex = 53  
#    $worksheet.Range("C1:F1").Font.ColorIndex = 5  
    $worksheet.Range("C1:F1").Font.Bold = true  
    $worksheet.Range("C1:F1").Font.Size =18  
    
    #########################Summary###################################
    $worksheet.Range("B3").Value="测试时间："    
    $worksheet.Range("B4").Value="测试用例总数："
    $worksheet.Range("B5").Value="通过测试用例数："
    $worksheet.Range("B6").Value="失败测试用例数："
    $worksheet.Range("B7").Value="通过率："    
    
    #########################测试结果title###################################    
    $worksheet.Range("B"+$i.to_s+":G"+$i.to_s).value = ["TestModule","TestCase","Result","Message","Expected","Reality"]
    $worksheet.Range("B"+$i.to_s+":G"+$i.to_s).Interior.ColorIndex=17
    $worksheet.Range("B"+$i.to_s+":G"+$i.to_s).Font.Bold=true
    
    #########################测试报告列宽，自动换行###################################    
    $worksheet.Range("B:G").ColumnWidth=20 
    $worksheet.Columns("B:G").WrapText=true
    $worksheet.Range("C3").WrapText=false
    
    
    #修改标志，下一个case不用新建report sheet
    $new=false
    
  else
    $worksheet=$excel.Sheets($reportName)
    $logger.info("打开已有ExcelReport...")      
  end  
end

def writeResult(testModule,testCase,result,msg,expected,reality)
  $i=$i+1
  
  if result
    convertResult="Pass"
  else
    convertResult="Fail"
  end
  
  $worksheet.Range("B"+$i.to_s+":G"+$i.to_s).value = [testModule,testCase,convertResult,msg,expected,reality];
  
  #结果如果不正确，将该行的颜色置为红色
  if !result
    $worksheet.Range("B"+$i.to_s+":G"+$i.to_s).Font.Bold=true 
    $worksheet.Range("B"+$i.to_s+":G"+$i.to_s).Font.ColorIndex=26
    $failCount+=1
  else
    $passCount+=1
  end
  
end

def closeExcel
  
  #########################测试结果边框，背景颜色###################################    
  $worksheet.Range("B9"+":G"+$i.to_s).Borders(1).LineStyle = 1
  $worksheet.Range("B9"+":G"+$i.to_s).Borders(2).LineStyle = 1
  $worksheet.Range("B9"+":G"+$i.to_s).Borders(3).LineStyle = 1  
  $worksheet.Range("B9"+":G"+$i.to_s).Borders(4).LineStyle = 1
  $worksheet.Range("B10"+":G"+$i.to_s).Interior.ColorIndex=20
  
  #########################计算汇总结果################################### 
  $worksheet.Range("C3").Value=Time.new.strftime("%Y年%m月%d日 %H:%M:%S")
  $worksheet.Range("C4").Value=($passCount+$failCount).to_s
  $worksheet.Range("C5").Value=$passCount.to_s
  $worksheet.Range("C6").Value=$failCount.to_s
  passrate=$passCount/($passCount+$failCount).to_f 
  $worksheet.Range("C7").Value=((format("%0.2f",passrate).to_f)*100).to_s+'%'

  $workbook.save
  $excel.Quit
end

def errorHandle
#异常处理
#@parm：
#@return
  p "出错了："+$e.message
  $logger.error("出错了："+$e.message)
  $a.screenshot.save "./bugPic/"+Time.new.strftime("%Y%m%d-%H-%M-%S")+'.png'
  quit
end

def createBeginLog
  $logger.info("\n\n")
  $logger.info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
end

def gotoHomepage
  $a.goto $homepage
end
end