# Generate a new ActionScript 3.0 TestCase and rebuild the test suites.
# This generator can be executed as follows:
# 
#   sprout -n as3 SomeProject
#   cd SomeProject
#   script/generate test utils.MathUtilTest
#
class TestGenerator < Sprout::Generator::NamedBase # :nodoc:

  def manifest
    record do |m|
      m.directory full_test_dir
      m.template "Spec.as", full_test_case_path

      m.template 'TestSuite.as', File.join(test_dir, 'AllTests.as'), :collision => :force
    end
  end
  
end
