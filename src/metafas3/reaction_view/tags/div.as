package metafas3.reaction_view.tags
{
	import metafas3.reaction_view.helpers.*;
	import metafas3.reaction_view.tags.*;

	// parse <div> tag as FlowPane layout container
	public function div (options:Object, ...args) :BoxHelper
	{
		options.children = args;
		options.direction ||= 'vertical';
		options.configuration = [];
		for each (var child:* in options.children)
		{
			options.configuration.push({ target: child.display_object, includeInLayout: (child.position != 'absolute') })
		}

		return BoxHelper.create(options);
	}
}