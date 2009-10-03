package ras3r.reaction_view.helpers
{
	import fl.controls.*;
	import ras3r.*;

	public class TextInputHelper
	{
		static public var default_options:Hash = new Hash;

		static public function create (options:Object = null) :TextInput
		{
			options = default_options.merge(options);
			var text_input:TextInput = new TextInput();

			// set "upSkin" style from "background" option
			if (options.background) text_input.setStyle('upSkin', options.remove('background'));

			// assign TextInput properties from options hash
			for (var p:String in options)
			{
				text_input[p] = options[p];
			}

			return text_input;
		}
	}
}
