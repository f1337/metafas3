package metafas3.reaction_view.tags
{
	import metafas3.reaction_view.helpers.*;
	import metafas3.reaction_view.tags.*;

	// parse <a> tag
	public function a (options:Hash) :TextFieldHelper
	{
		// if <a> wraps display object children,
		// apply "click" event handler to each child
		if (options.children)
		{
			for each (var child:* in options.children)
			{
				child.buttonMode = true;
				child.click = options.href;
			}

			return null;
		}
		// else, treat <a> as textfield
		else
		{
			if (options.html) options.htmlText = options.remove('html');
			// hijack href's w/ relative URLs
			if (options.href && options.htmlText) options.htmlText = options.htmlText.replace(/<a([^>]+)href="[^\"]+"/, '<a$1href="event:' + options.remove('href').replace('#', '') + '"');
			return label(options);
		}

		return null;
	}
}