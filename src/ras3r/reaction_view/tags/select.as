package ras3r.reaction_view.tags
{
	import fl.data.*;
	import ras3r.reaction_view.helpers.*;
	import ras3r.reaction_view.tags.*;

	// parse <select> tag as ComboBox
	public function select (options:Hash) :ComboBoxHelper
	{
		// extract choices from options
		var choices:* = options.remove('option');
		// translate XHTML5 option data for ComboBox
		choices.every(function (o:Hash, ...args) :Boolean
		{
			// re-key "value" as "data"
			o.data = o.remove('value');
			// re-key "text" as "label"
			o.label = o.remove('_text');
			// assign selected item
			if (o.remove('selected')) options.selectedItem = o;
			return true;
		});
		// cast choices to DataProvider
		options.dataProvider = (choices is DataProvider) ? choices : (new DataProvider(choices));
		// invoke the ComboBox factory and return
		return ComboBoxHelper.create(options);
	}
}