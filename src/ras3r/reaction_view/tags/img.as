package ras3r.reaction_view.tags
{
	import ras3r.reaction_view.helpers.*;
	import ras3r.reaction_view.tags.*;

	// parse <img> tag as "Image" (custom UILoader)
	public function img (options:Hash) :ImageHelper
	{
		options.remove('alt'); // discard alt, we don't use it.
		options.source = options.remove('src');
		return ImageHelper.create(options);
	}
}