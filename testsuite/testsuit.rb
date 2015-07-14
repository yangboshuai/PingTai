#!/usr/bin/ruby
# encoding: utf-8

require 'test/unit/testsuite'
require 'test/unit/ui/console/testrunner'

require 'testcase/testmodule01_login.rb'
require 'testcase/testmodule02_function.rb'
require 'testcase/testmodule03_organization.rb'
require 'testcase/testmodule04_user.rb'
require 'testcase/testmodule05_roles.rb'
class TestSuit1

  def self.suite
    suite=Test::Unit::TestSuite.new("TestSuit1-BasedFunction")
#    suite<<TestModule01.suite
    suite<<TestModule02.suite
    suite<<TestModule03.suite
    suite<<TestModule04.suite
    suite<<TestModule05.suite    
    return suite
  end
  
end

testReport=Test::Unit::UI::Console::TestRunner.run(TestSuit1)