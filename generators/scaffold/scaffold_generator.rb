class ScaffoldGenerator < Sprout::Generator::NamedBase  # :nodoc:

  def manifest
    record do |m|
      if (! user_requested_test)
        #m.directory full_class_dir
        m.template 'Application.as', application_class_path

        m.directory resource_class_dir
        m.template 'Resource.as', resource_class_path

        m.directory controller_class_dir
        m.template 'Controller.as', controller_class_path

=begin
        m.directory layout_class_dir
        m.template 'Layout.as', layout_class_path
=end
        m.directory view_class_dir
        m.template 'ListView.as', File.join(view_class_dir, "List#{class_name}View.as")
        m.template 'ShowView.as', File.join(view_class_dir, "Show#{class_name.singularize}View.as")
      end

#      m.directory controller_test_dir
#      m.template 'TestCase.as', controller_test_path
#      m.template 'TestSuite.as', File.join(test_dir, 'AllTests.as')
 
#      m.directory full_test_dir
#      m.template 'TestCase.as', full_test_case_path
#      m.template 'TestSuite.as', File.join(test_dir, 'AllTests.as')
    end
  end

=begin
  def assign_names!(name)
    # trim file name suffix in case it was submitted
    name.gsub!(/\//, '.')
    name.gsub!(/\.as$/, '')
    name.gsub!(/\.mxml$/, '')
    super("controllers.#{name}Controller")
  end
=end
=begin
  def assign_names!(name)
    @full_class_name = name
    parts = name.split('.')
    @class_name = parts.pop
    @package_name = parts.join('.')
    @class_file = @full_class_name.split('.').join(File::SEPARATOR) + '.as'
    @class_dir = File.dirname(@class_file)

    if(@class_dir == '.')
      @class_dir = ''
    end
  end

  # Full path to the parent directory that contains the class
  # like 'src/flash/display' for flash.display.Sprite class.
  def full_class_dir
    @full_class_dir ||= File.join(src_dir, class_dir)
    # pull trailing slash for classes in the root package
    @full_class_dir.gsub!(/\/$/, '')
    @full_class_dir
  end

  # Full path to the class file from your project_path like 'src/flash/display/Sprite.as'
  def full_class_path
    @full_class_path ||= File.join(src_dir, class_file)
  end
=end

  # Full path to the parent directory that contains the class
  # like 'src/flash/display' for flash.display.Sprite class.
  def application_class_path
    File.join(src_dir, "Application.as")
  end

  def controller_class_dir
    File.join(src_dir, 'controllers').gsub(/\/$/, '')
  end

  def controller_class_path
    File.join(controller_class_dir, "#{class_name}Controller.as")
  end

  def controller_test_dir
    controller_class_dir.gsub(src_dir, test_dir)
  end

  def controller_test_path
    controller_class_path.gsub(src_dir, test_dir)
  end

  def resource_class_dir
    File.join(src_dir, 'resources').gsub(/\/$/, '')
  end

  def resource_class_path
    File.join(resource_class_dir, "#{class_name.singularize}.as")
  end

  def view_class_dir
    File.join(src_dir, 'views', "#{class_name.downcase}").gsub(/\/$/, '')
  end
end