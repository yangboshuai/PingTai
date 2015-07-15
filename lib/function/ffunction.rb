#!/usr/bin/ruby
# encoding: utf-8

require 'watir-webdriver'
require 'lib/ui.rb'
require 'lib/variable.rb'

module Function
  module FFunction    
    
    include Control::PublicControl
    include Control::FunctionControl
    
    def clickMenu_Function  #点击Function主目录
    
      $logger.info("点击Function主目录...")
      
      $a.link(LINK_FUNCTION).when_present.click
      
      sleep $waittime
    end
    
    def clickF_MenuRoot #点击MenuRoot根节点    

      $logger.info("点击Function页面中的MenuRoot跟节点...")
      
      $a.iframe(FRAME_MENUFRAME).link(LINK_MENUROOT).click
      
      sleep $waittime  
    end
    
    def addFunction(name='FunctionTest',code='Functiontest',sOrh='show',pageTarget='Navigation',pageUrl='apex.menu.test,iconUrl',\
        iconUrl='apex.menu.test',iconX='',iconY='',description='')  #输入新增Function信息
        
      #@parm：name,code,sOrh,pageTarget,pageUrl,iconUrl,iconX,iconY,description
      #@value:sOrh:show,hide; pageTarget:Workspace,Navigation
    
      clickMenu_Function
      clickF_MenuRoot
      
      $logger.info("addFunction输入信息...")
      
      $a.iframe(FRAME_MAINFRAME).button(Button_Add).when_present.click      
      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_FNAME).set name  #name      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_FCODE).set code  #Code      
      if sOrh=='show' 
        $a.iframe(FRAME_MAINFRAME).radio(RADIO_FSHOW).set  #show
      elsif sOrh=='hide'
        $a.iframe(FRAME_MAINFRAME).radio(RADIO_FHIDE).set  #hide
      end
      $a.iframe(FRAME_MAINFRAME).select(SELECT_FPAGETARGET).select pageTarget  #pageTarget      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_FPAGEURL).set pageUrl  #pageUrl      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_FICONURL).set iconUrl  #iconUrl      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_FICONX).when_present.set iconX #iconX      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_FICONY).set iconY  #iconY      
      $a.iframe(FRAME_MAINFRAME).textarea(TEXTFIELD_FDESCRIPTION).set description  #description
      
      $a.iframe(FRAME_MAINFRAME).button(Button_Save).click  
      
      sleep $waittime*2   
    end
    
    def validateFunction(name='FunctionTest',code='Functiontest',sOrh='show',pageTarget='Navigation',pageUrl='apex.menu.test,iconUrl',\
        iconUrl='apex.menu.test',iconX='',iconY='',description='')  #检查FunctionAdd结果   
        
      #@parm：name,code,sOrh,pageTarget,pageUrl,iconUrl,iconX,iconY,description
      #@value:sOrh:show,hide; pageTarget:Workspace,Navigation

      $logger.info("===>>开始验证Function信息：")      
      
      result=false  #初始化result为false
      
      searchFunction(name)
      
      $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](6).link(LINK_EDIT).click
      
      rname=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_FNAME).value
      rcode=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_FCODE).value       
      if $a.iframe(FRAME_MAINFRAME).radio(RADIO_FSHOW).set? && !($a.iframe(FRAME_MAINFRAME).radio(RADIO_FHIDE).set?)
        rsOrh='show'
      elsif !($a.iframe(FRAME_MAINFRAME).radio(RADIO_FSHOW).set?) && ($a.iframe(FRAME_MAINFRAME).radio(RADIO_FHIDE).set?)
        rsOrh='hide'
      end      
      rpageTarget=$a.iframe(FRAME_MAINFRAME).select(SELECT_FPAGETARGET).selected_options[0].text
      rpageUrl=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_FPAGEURL).value
      riconUrl=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_FICONURL).value
      riconX=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_FICONX).value
      riconY=$a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_FICONY).value
      rdescription=$a.iframe(FRAME_MAINFRAME).textarea(TEXTFIELD_FDESCRIPTION).value      
      
      #若iconX不为空则转换成N$格式
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
        
      else  #全部验证通过后置result为true            
        msg='Function info right'
        result=true
        expected=''
        reality=''
      end
      
      $logger.info("<<===验证结果:"+result.to_s+','+msg+','+expected+','+reality) 
    
      return result,msg,expected,reality
    end
    
    
    def searchFunction(keyword_functionName)  #检索Function信息      

      $a.goto $homepage
      clickMenu_Function
      clickF_MenuRoot
      
      $logger.info("查找Function...")
      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_SEARCH).when_present.set keyword_functionName
      $a.iframe(FRAME_MAINFRAME).button(BUTTON_SEARCH).click
      
      sleep $waittime*2
    end
    
    
    def deleteFunction(keyword_functionName='Functiontest') #删除Function信息
      
      searchFunction keyword_functionName
      
      $logger.info("删除Function...")
      
      $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](6).link(LINK_DELETE).click
      $a.button(:text,"OK").click
      
      sleep $waittime  
    end
    
    
    def editFunction(keyword_functionName='Functiontest',name='Functiontest2',code='Functiontest2',sOrh='hide',pageTarget='Workspace',\
        pageUrl='2apex.menu.test,iconUrl',iconUrl='2apex.menu.test',iconX='2',iconY='2',description='2')  #编辑Function新信息
      #
      #@parm：name,code,sOrh,pageTarget,pageUrl,iconUrl,iconX,iconY,description
      #@value:sOrh:show,hide;pageTarget:Workspace,Navigation

      searchFunction(keyword_functionName)
      
      $logger.info("编辑Function...")  
      
      $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](6).link(LINK_EDIT).click     
      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_FNAME).set name  #name      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_FCODE).set code  #code

      if sOrh=='show'
        $a.iframe(FRAME_MAINFRAME).radio(RADIO_FSHOW).set  #show
      elsif sOrh=='hide'
        $a.iframe(FRAME_MAINFRAME).radio(RADIO_FHIDE).set  #hide
      end

      $a.iframe(FRAME_MAINFRAME).select(SELECT_FPAGETARGET).select pageTarget  #pageTarget      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_FPAGEURL).set pageUrl  #pageUrl      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_FICONURL).set iconUrl  #iconUrl      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_FICONX).when_present.set iconX #iconX      
      $a.iframe(FRAME_MAINFRAME).text_field(TEXTFIELD_FICONY).set iconY  #iconY      
      $a.iframe(FRAME_MAINFRAME).textarea(TEXTFIELD_FDESCRIPTION).set description  #description
      
      $a.iframe(FRAME_MAINFRAME).button(Button_Save).click
      
      sleep $waittime  
    end
    
    
    def validateDeleteFunction(keyword_functionName)   #检查Function信息是否被删除
    
      $logger.info("===>>开始验证删除Function信息：")
      
      result=false  #初始化result为false
      expected=''
      reality=''
      
      searchFunction(keyword_functionName)
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
    
    
    def hideFunction(keyword_functionName='Functiontest') #hide Function
    
      $logger.info("hideFunction...")  
      
      $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](1).text_field(TEXTFIELD_FCHECKBOX).click
      $a.iframe(FRAME_MAINFRAME).button(Button_FHIDE).click
      $a.button(:text,"OK").click  
      
      sleep $waittime  
    end
    
    def showFunction(keyword_functionName='Functiontest') #show Function
    
      $logger.info("showFunction...") 
      
      $a.iframe(FRAME_MAINFRAME).table(TABLE_FGRIDVIEW).[](1).[](1).text_field(TEXTFIELD_FCHECKBOX).click
      $a.iframe(FRAME_MAINFRAME).button(Button_FSHOW).click
      $a.button(:text,"OK").click
      
      sleep $waittime  
    end
  end
end