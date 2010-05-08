package metafas3.reaction_view.tags
{
	import metafas3.reaction_view.helpers.*;
	import metafas3.reaction_view.tags.*;

	// parse <label> tag as TextField
	public function label (options:Hash) :TextFieldHelper
	{
		// support <label> nodes
		if (options._text) options.text = options.remove('_text');

		// strip <span>s and convert to <font>
		// <span style="color: #b87236; font-family: 'Helvetica Neue LT Std 56 Italic'; font-style: italic;"> special discount </span>
		if (options.htmlText)
		{
			options.htmlText = options.htmlText.replace(/\s{2,}/gs, ' ').replace(/<span[^>]*style="([^>]+)"[^>]*>([^<]+)<\/span>/g, ' $2 ');
			options.condenseWhite = true;
			logger.info('htmlText: ' + options.htmlText);
		}

		// hijack <a>nchor href properties
		if (options.href) options.htmlText = options.htmlText.replace(/<a([^>]+)href="#[^#\"]*"/, '<a$1href="event:' + options.remove('href').replace('#', '') + '"');

		return TextFieldHelper.create(options);
	}
}