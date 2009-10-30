//
//  <%= model.project_name %>.as
//
//  Created <%= Date.today.to_s(:db) %>.
//

package
{
	import ras3r.*;
	<% controller_classes.each do |controller| %>
	import <%= controller %>;<% end %>
	<% model_classes.each do |model| %>
	import <%= model %>;<% end %>
	<% view_classes.each do |view| %>
	import <%= view %>;<% end %>

	public class <%= model.project_name %> extends Application
	{
		// >>> CONTROLLERS<% controller_classes.each do |controller| %>
		private static var <%= controller.split('.').last.camelize(:lower) %>:<%= controller.split('.').last %>;<% end %>
		// >>> VIEWS<% view_classes.each do |view| %>
		private static var <%= view.split('.').last.camelize(:lower) %>:<%= view.split('.').last %>;<% end %>
	}
}
