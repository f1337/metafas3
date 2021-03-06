require 'sprout'
# Optionally load gems from a server other than rubyforge:
# set_sources 'http://gems.projectsprouts.org'
sprout 'as3'

require '../../lib/tasks/flashplayer_redgreen_task'
require '../../lib/tasks/mxmlc_spec'

############################################
# Configure your Project Model
model = project_model :model do |m|
  m.project_name            = 'hello_world'
  m.language                = 'as3'
  m.background_color        = '#FFFFFF'
  m.width                   = 400
  m.height                  = 400
  # m.use_fdb               = true
  # m.use_fcsh              = true
  # m.preprocessor          = 'cpp -D__DEBUG=false -P - - | tail -c +3'
  # m.preprocessed_path     = '.preprocessed'
  # m.src_dir               = 'src'
  m.lib_dir               	= '../../vendor'
  m.swc_dir               	= '../../vendor'
  # m.bin_dir               = 'bin'
  # m.test_dir              = 'test'
  # m.doc_dir               = 'doc'
  # m.asset_dir             = 'assets'
  # m.compiler_gem_name     = 'sprout-flex4sdk-tool'
  # m.compiler_gem_version  = '>= 4.0.0'
	m.use_network = false
  m.source_path           	<< '../../src'
  m.source_path           	<< 'config'
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
# flashplayer :spec => model.test_output
# mxmlc model.test_output => :model do |t|
# 	t.debug					= true
# 	t.use_network		= false # for using filesystem fixtures
# 	t.input					= "#{model.src_dir}/#{model.project_name}Runner.as"
# 	t.output				= model.test_output
# 	t.source_path		<< model.test_dir
# 	t.source_path		<< "#{model.lib_dir}/metafas3"
# 	t.library_path	<< "#{model.swc_dir}/as3spec.swc"
# 	t.library_path	<< "#{model.swc_dir}/corelib.swc"
# 	t.library_path	<< "#{model.swc_dir}/cs3_components.swc"
# end
# task :test => :spec

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
