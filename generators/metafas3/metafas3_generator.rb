class Metafas3Generator < Sprout::Generator::NamedBase  # :nodoc:
  protected
  # Get the list of controllers (which are files) as a
  # list of fully qualified class names
  def controller_classes
    @controller_classes = Dir.glob(src_dir + '/controllers/?*Controller.as')
    @controller_classes.collect! do |file|
      actionscript_file_to_class_name(file)
    end
    @controller_classes
  end

  # Get the list of environments (which are files) as a
  # list of fully qualified class names
  def environment_classes
    @environment_classes = Dir.glob(src_dir + '/config/environments/?*.as')
    @environment_classes.collect! do |file|
      actionscript_file_to_class_name(file)
    end
    @environment_classes
  end

  # Get the list of models (which are files) as a
  # list of fully qualified class names
  def model_classes
    @model_classes = Dir.glob(src_dir + '/models/?*.as')
    @model_classes.collect! do |file|
      actionscript_file_to_class_name(file)
    end
    @model_classes
  end

  # Get the list of views (which are files) as a
  # list of fully qualified class names
  def view_classes
    @view_classes = Dir.glob(src_dir + '/views/**/?*.as')
    @view_classes.collect! do |file|
      actionscript_file_to_class_name(file)
    end
    @view_classes
  end
end