class ControllerGenerator < Sprout::Generator::NamedBase  # :nodoc:
  def manifest
    record do |m|
      if (!user_requested_test)
        m.directory full_class_dir
        m.template 'Controller.as', full_class_path
      end
 
      m.directory full_test_dir
      m.template '../../test/templates/Spec.as', full_test_case_path
      m.template '../../test/templates/TestSuite.as', File.join(test_dir, 'AllTests.as'), :collision => :force
    end
  end

	protected
	def assign_names!(name)
		super("controllers.#{name.classify.pluralize}Controller")
	end
end