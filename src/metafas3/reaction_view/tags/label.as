package metafas3.reaction_view.tags
{
	import metafas3.reaction_view.helpers.*;
	import metafas3.reaction_view.tags.*;

	// parse <label> tag as TextField
	public function label (options:Hash) :TextFieldHelper
	{
		if ((! options.htmlText) && options._text) options.htmlText = options.remove('_text');
		return TextFieldHelper.create(options);
	}
}