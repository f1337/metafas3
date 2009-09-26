module Sprout
  # The MXMLCSpec helper wraps up flashplayer and mxmlc unit test tasks by
  # using either a Singleton or provided ProjectModel instance.
  #
  # The simple case that uses a Singleton ProjectModel:
  #   spec :test
  #
  # Using a ProjectModel instance:
  #   project_model :model
  #
  #   spec :test => :model
  #
  # Configuring the proxy MXMLCTask
  #   spec :test do |t|
  #     t.link_report = 'LinkReport.rpt'
  #   end
  #
  class MXMLCSpec < MXMLCHelper

    def initialize(args, &block)
      super
      outer_task = define_outer_task

      library :as3spec
      
      mxmlc output do |t|
        configure_mxmlc t
        configure_mxmlc_application t
        t.debug = true
        t.source_path << model.test_dir
        t.prerequisites << :as3spec
        
        if(model.test_width && model.test_height)
          t.default_size = "#{model.test_width} #{model.test_height}"
        end

        yield t if block_given?
      end

      define_player
      outer_task.prerequisites << output
      outer_task.prerequisites << player_task_name
    end
    
    def create_output
      return "#{create_output_base}Runner.swf"
    end

    def create_input
      input = super
      input.gsub!(/#{input_extension}$/, "Runner#{input_extension}") 
      return input
    end
  
  end
end

def spec(args, &block)
  return Sprout::MXMLCSpec.new(args, &block)
end
