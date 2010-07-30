package metafas3.reaction_view.tags
{
	import metafas3.reaction_view.helpers.*;
	import metafas3.reaction_view.tags.*;

	// parse <input> tags as corresponding UIComponents
	public function input (options:Hash) :Helper
	{
		var type:String = options.remove('type');
		switch (type)
		{
			case 'checkbox':
				return CheckBoxHelper.create(options);
				break;
			// hidden fields don't render any components
			case 'hidden':
				return null;
				break;
			case 'image':
				options.remove('name'); // discard name
				options.source = options.remove('src');
				return ImageButtonHelper.create(options);
				break;
			// 'password', is a TextInput w/ displayAsPassword=true
			case 'password':
				options.displayAsPassword = true;
				break;
			case 'radio':
				return RadioButtonHelper.create(options);
				break;
			// 'text', 'email', 'tel', etc. use fail-safe TextInput
			default:
				break;
		}

		// fail-safe: TextInput
		return TextInputHelper.create(options);
	}
}