require 'sprout'
# Optionally load gems from a server other than rubyforge:
# set_sources 'http://gems.projectsprouts.org'
sprout 'as3'

require 'lib/tasks/flashplayer_redgreen_task'
require 'lib/tasks/mxmlc_spec'

############################################
# Configure your Project Model
model = project_model :model do |m|
  m.project_name            = 'metafas3'
  m.language                = 'as3'
  m.background_color        = '#FFFFFF'
  m.width                   = 970
  m.height                  = 550
  # m.use_fdb               = true
  # m.use_fcsh              = true
  # m.preprocessor          = 'cpp -D__DEBUG=false -P - - | tail -c +3'
  # m.preprocessed_path     = '.preprocessed'
  # m.src_dir               = 'src'
  m.lib_dir               	= 'vendor'
  m.swc_dir               	= 'vendor'
  # m.bin_dir               = 'bin'
  # m.test_dir              = 'test'
  # m.doc_dir               = 'doc'
  # m.asset_dir             = 'assets'
  # m.compiler_gem_name     = 'sprout-flex4sdk-tool'
  # m.compiler_gem_version  = '>= 4.0.0'
  # m.source_path           	<< "#{m.lib_dir}/metafas3"
	m.libraries								<< :corelib
	m.libraries								<< :as3spec
	m.test_output							= "#{m.bin_dir}/#{m.project_name}-test.swf"
	m.library_path						<< "#{m.swc_dir}/cs4_components.swc"
end

desc 'Compile and debug the application'
debug :debug

#unit :test
desc 'Compile run the test harness'
spec :spec

desc 'Compile the optimized deployment'
deploy :deploy

desc 'Create documentation'
document :doc

desc 'Compile a SWC file'
swc :swc

desc 'Compile and run the test harness for CI'
ci :cruise

# set up the default rake task
task :default => :debug
