package metafas3.reaction_view.tags
{
	import metafas3.reaction_view.helpers.*;
	import metafas3.reaction_view.tags.*;

	// parse <form> tag as FlowPane layout container
	public function form (options:Object, ...args) :FormHelper
	{
		options.children = args;
		return FormHelper.create(options);
	}
}