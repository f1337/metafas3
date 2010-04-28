package ras3r.reaction_view.tags
{
	import ras3r.reaction_view.helpers.*;
	import ras3r.reaction_view.tags.*;

	// parse <embed> tag as "Image" (custom UILoader)
	// (mf:) kinda defeats the purpose of HTML5 fallback content?
	// (mf counterpoint 1:) sorta, but how else to describe "popup a flash overlay here"?
	// (mf counterpoint 2:) plus, you can define fallback content for <embed>
	public function embed (options:Hash) :ImageHelper
	{
		options.remove('type'); // discard type, we don't use it.
		options.source = options.remove('src');
		return ImageHelper.create(options);
	}
}