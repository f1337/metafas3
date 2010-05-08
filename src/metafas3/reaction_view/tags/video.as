package metafas3.reaction_view.tags
{
	import metafas3.reaction_view.helpers.*;
	import metafas3.reaction_view.tags.*;

	// parse <video> tag as FLVPlayer
	// http://www.adobe.com/devnet/flashplayer/articles/hd_video_flash_player_03.html
	// http://help.adobe.com/en_US/FlashPlatform//reference/actionscript/3/fl/video/FLVPlayback.html?allClasses=1
	public function video (options:Hash) :VideoHelper
	{
		options.source = options.remove('src');
		return VideoHelper.create(options);
	}
}