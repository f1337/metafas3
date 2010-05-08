//
//  <%= model.project_name %>.as
//
//  Created <%= Date.today.to_s(:db) %>.
//

package
{
	import metafas3.*;
	<% controller_classes.each do |controller| %>
	import <%= controller %>;<% end %>
	<% environment_classes.each do |env| %>
	import <%= env %>;<% end %>
	<% model_classes.each do |model| %>
	import <%= model %>;<% end %>
	<% view_classes.each do |view| %>
	import <%= view %>;<% end %>

	public class <%= model.project_name %> extends Application
	{
		// >>> ENVIRONMENTS<% environment_classes.each do |env| %>
		private static var <%= env.split('.').last.camelize(:lower) %>:<%= env.split('.').last %>;<% end %>
		// >>> CONTROLLERS<% controller_classes.each do |controller| %>
		private static var <%= controller.split('.').last.camelize(:lower) %>:<%= controller.split('.').last %>;<% end %>
		// >>> VIEWS<% view_classes.each do |view| %>
		private static var <%= view.split('.').last.camelize(:lower) %>:<%= view.split('.').last %>;<% end %>
	}
}
