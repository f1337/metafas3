package metafas3.reaction_view.tags
{
	import metafas3.reaction_view.helpers.*;
	import metafas3.reaction_view.tags.*;

	// parse <fieldset> tag as MetaFieldset layout container
	public function fieldset (options:Object, ...args) :FieldsetHelper
	{
		options.children = args;
		return FieldsetHelper.create(options);
	}
}