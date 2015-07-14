#!/usr/bin/ruby
# encoding: utf-8

module Control

################################
#         页面框架Frame
################################

#menuFrame
FRAME_MENUFRAME=Hash[:name=>"menuFrame"]

#mainFrame
FRAME_MAINFRAME=Hash[:name=>"mainFrame"]

#topPopModalCommonFrame
FRAME_TOPPOPFRAME=Hash[:name=>"topPopModalCommonFrame"]

#orguserMF
FRAME_ORGUSERMF=Hash[:name=>"orguserMF"]
################################
#         公共控件
################################

#Add按钮
Button_Add=Hash[:text=>"New"]

#Save按钮
Button_Save=Hash[:text=>"Save"]

#TABLE表格gridview
TABLE_FGRIDVIEW=Hash[:id=>"gridview"]

#TABLE表格gridview-todoListTable
TABLE_TODOLISTTABLE=Hash[:id=>"todoListTable"]

#EDIT按钮
LINK_EDIT=Hash[:title=>"Edit"]

#delete按钮
LINK_DELETE=Hash[:title=>"Delete"]

#link按钮
LINK_LINK=Hash[:title=>"Link User"]

#pageinfo信息
SPAN_PAGEINFO=Hash[:class=>"pageinfo"]

#用户名下拉框 dropdown-toggle
LINK_DROPDOWNTOGGLE=Hash[:id=>"abc"]

#logout链接
LINK_LOGOUT=Hash[:href=>"javascript:getlogout();"]

#claimBtn链接
LINK_CLAIMBTN=Hash[:id=>"claimBtn",:index=>0]

#handleBtn链接
LINK_HANDLEBTN=Hash[:id=>"handleBtn"]

#Approve按钮
BUTTON_APPROVE=Hash[:text=>"Approve"]

#Function_search文本框
TEXTFIELD_SEARCH=Hash[:name=>"q_simpleSearch"]

#Function_search按钮
BUTTON_SEARCH=Hash[:id=>"btnSimpleSearch"]

#Organization_ENABLE按钮
BUTTON_ENABLE=Hash[:text=>"Enable"]

#Organization_Disable按钮
BUTTON_DISABLE=Hash[:text=>"Disable"]

#添加时Submit按钮
BUTTON_SUBMIT=Hash[:id=>"btnSubmit"]

#确认信息Complete按钮
BUTTON_COMPLETE=Hash[:id=>"btnComplete"]

#关闭按钮
BUTTON_CLOSE=Hash[:class=>"close ax-close"]
################################
#         登录页面Login
################################

#登录页面_用户名输入框
TEXTFIELD_USERNAME=Hash[:id=>"username"]

#登录页面_密码输入框
TEXTFIELD_PASSWD=Hash[:id=>"password"]

#登录页面_登录按钮
BUTTON_LOGIN=Hash[:class=>"sign_btn"]
################################
#         功能管理页面Function
################################

#主页_Function链接
LINK_FUNCTION=Hash[:text=>"Function"]

#Function_Menu Root链接
LINK_MENUROOT=Hash[:text=>"Menu Root"]

#Function_Name文本框
TEXTFIELD_FNAME=Hash[:name=>"functionName"]

#Function_Code文本框
TEXTFIELD_FCODE=Hash[:name=>"functionCode"]

#RADIO_SHOW单选按钮
RADIO_FSHOW=Hash[:id=>"isShow1"]

#RADIO_HIDE单选按钮
RADIO_FHIDE=Hash[:id=>"isShow0"]

#pageTarget下拉框
SELECT_FPAGETARGET=Hash[:name=>"pageTarget"]

#pageURL输入框
TEXTFIELD_FPAGEURL=Hash[:name=>"pageUrl"]

#IconURL输入框
TEXTFIELD_FICONURL=Hash[:id=>"entity_iconUrl"]

#IconX输入框
TEXTFIELD_FICONX=Hash[:id=>"entity_iconX"]

#IconY输入框
TEXTFIELD_FICONY=Hash[:id=>"entity_iconY"]

#DESCRIPTION输入框
TEXTFIELD_FDESCRIPTION=Hash[:name=>"description"]

#TEXTFIELD_checkbox多选框
TEXTFIELD_FCHECKBOX=Hash[:name=>"ChkOne"]

#Function_hide按钮
Button_FHIDE=Hash[:text=>"Hide"]

#Function_show按钮
Button_FSHOW=Hash[:text=>"Show"]

################################
#         组织管理页面Organization
################################
#主页_Organization链接
LINK_Organization=Hash[:text=>"Organization"]

#Organization_RootNode链接
LINK_OROOTNODE=Hash[:text=>"Organization"]


#Organization Name
TEXTFIELD_ONAME=Hash[:name=>"organizationName"]

#Organization othername
TEXTFIELD_OOTHERNAME=Hash[:name=>"otherName"]

#Organization Name
TEXTFIELD_EMAIL=Hash[:name=>"email"]

#Organization level
TEXTFIELD_OLEVEL=Hash[:name=>"organizationLevel"]

#insideTel
TEXTFIELD_OINSIDETEL=Hash[:name=>"insideTel"]

#outsideTel
TEXTFIELD_OOUTSIDETEL=Hash[:name=>"outsideTel"]

#attendanceTel
TEXTFIELD_OATTENDANCETEL=Hash[:name=>"attendanceTel"]

#fax
TEXTFIELD_OFAX=Hash[:name=>"fax"]

#post
TEXTFIELD_OPOST=Hash[:name=>"post"]

#officeNo
TEXTFIELD_OFFICENO=Hash[:name=>"officeNo"]

#address
TEXTFIELD_OADDRESS=Hash[:name=>"address"]

#description
TEXTFIELD_ODESCRIPTION=Hash[:name=>"description"]

################################
#         用户管理页面User
################################

#主页_User链接
LINK_USER=Hash[:text=>"User"]



#fullName
TEXTFIELD_UFULLNAME=Hash[:name=>"fullName"]

#loginName
TEXTFIELD_ULOGINNAME=Hash[:name=>"loginName"]

#firstName
TEXTFIELD_UFIRSTNAME=Hash[:name=>"firstName"]

#middleName
TEXTFIELD_UMIDDLENAME=Hash[:name=>"middleName"]

#lastName
TEXTFIELD_ULASTNAME=Hash[:name=>"lastName"]

#gender
SELECT_UGENDER=Hash[:name=>"gender"]

#date of birth
TEXTFIELD_UDOFBIRTH=Hash[:id=>"entity_dateOfBirth"]

#entity_postalAddress
TEXTFIELD_UPOSTALCODE=Hash[:id=>"entity_postalAddress"]

#entity_homeFax
TEXTFIELD_UHOMEFAX=Hash[:id=>"entity_homeFax"]

#entity_residentialAddress
TEXTFIELD_URESIDENTIALADDRESS=Hash[:id=>"entity_residentialAddress"]

#entity_homeTel
TEXTFIELD_UHOMEPHONE=Hash[:id=>"entity_homeTel"]

#entity_email
TEXTFIELD_UEMAIL=Hash[:id=>"entity_email"]

#entity_mobile
TEXTFIELD_UMOBILE=Hash[:id=>"entity_mobile"]

#entity_degree
SELECT_UDEGREE=Hash[:id=>"entity_degree"]

#entity_graduatedInstitution
TEXTFIELD_UGRADUATEDINSTITUTION=Hash[:id=>"entity_graduatedInstitution"]

#entity_major
TEXTFIELD_UMAJOR=Hash[:id=>"entity_major"]

#entity_passwordQuestion
TEXTFIELD_UHINTQUESTION=Hash[:id=>"entity_passwordQuestion"]

#entity_passwordAnswer
TEXTFIELD_UANSWER=Hash[:id=>"entity_passwordAnswer"]

################################
#         角色管理页面Roles
################################

#主目录Roles
LINK_Roles=Hash[:text=>"Roles"]

#roleName
TEXTFIELD_ROLENAME=Hash[:name=>"roleName"]

#roleDescription
TEXTAREA_DESCRIPTION=Hash[:name=>"description"]

#link_taskinfo
LINK_TASKINFO=Hash[:index=>0]

TEXTFIELD_RLOGINNAME=Hash[:id=>"loginName"]

#TABLE表格gridview
TABLE_GRIDVIEW=Hash[:id=>"gridview"]
end 