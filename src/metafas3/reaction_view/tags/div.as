package metafas3.reaction_view.tags
{
	import metafas3.reaction_view.helpers.*;
	import metafas3.reaction_view.tags.*;

	// parse <div> tag as FlowPane layout container
	public function div (options:Object, ...args) :BoxHelper
	{
		options.children = args;
		return BoxHelper.create(options);
	}
}