class ViewGenerator < Ras3rGenerator  # :nodoc:
  def manifest
    record do |m|
      if (!user_requested_test)
        m.directory full_class_dir
        m.template 'View.as', full_class_path
        m.template '../../controller/templates/Application.as', File.join(src_dir, "#{model.project_name}.as"), :collision => :force
      end
 
      m.directory full_test_dir
      m.template 'Spec.as', full_test_case_path
      m.template '../../test/templates/TestSuite.as', File.join(test_dir, 'AllTests.as'), :collision => :force
    end
  end

  protected
  def assign_names!(name)
    #controller = name.sub(/^([^\/]+\/)?[^\/]+$/, '\1') ||
    #controller = name.sub(/\/?[^\/]+$/, '') || name.underscore.split('_').last.pluralize
    super("views.#{name}")
  end
end