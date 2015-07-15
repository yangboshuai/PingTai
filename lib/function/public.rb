#!/usr/bin/ruby
# encoding: utf-8

require 'watir-webdriver'
require 'lib/ui.rb'
require 'lib/variable.rb'
require 'logger'
require 'win32ole'

module Function
  module PublicFunction
  
    def openUrl(url=$url) #打开指定网页
       
      $logger.info("打开网页"+url+"...")
     
      $a=Watir::Browser.new $browser
      $a.driver.manage.window.maximize
#      $a.driver.manage.timeouts.implicit_wait = 1 #隐式等待时间
      $a.goto url
     
      sleep $waittime
    end
  
    def quit  #关闭浏览器

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
#        $worksheet.Range("C1:F1").Interior.ColorIndex = 53  
#        $worksheet.Range("C1:F1").Font.ColorIndex = 5  
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
      $worksheet.Range("C7").Value=((format("%0.4f",passrate).to_f)*100).to_s+'%'
    
      $workbook.save
      $excel.Quit
    end
    
    def errorHandle #异常处理

      p "出错了："+$e.message      
      $logger.error("出错了："+$e.message)
      
      $a.screenshot.save "./bugPic/"+Time.new.strftime("%Y%m%d-%H-%M-%S")+'.png'
      quit
    end
    
    def createBeginLog

      $logger.info("-------------------------------------------\n\n")
      $logger.info("-------------------------------------------")

    end
    
    def gotoHomepage
      $a.goto $homepage
    end

  end
end