package ras3r.reaction_view.helpers
{
	import as3spec.*;
	import fl.controls.*;

	public class TextInputHelperTest extends Spec
	{
		public function run () :void
		{
			describe ('a new TextInputHelper', function () :void
			{
				it ('provides .create() which returns a new TextInput', function () :void
				{
					so(TextInputHelper.create()).should.be.a.kind_of(TextInput);
				});

				it ('provides .default_options', function () :void
				{
					so(TextInputHelper.default_options).should.be.a.kind_of(Object);
				});

				describe ('when it merges .create(options) with .default_options', function () :void
				{
					TextInputHelper.default_options.update({ 
						alpha: 50, editable: true
					});

					var options:Object = { editable: false };
					var ti:TextInput = TextInputHelper.create(options);

					it ('should not overwrite default options', function () :void
					{
						so(TextInputHelper.default_options.editable).should.equal(true);
					});

					it ('assign default value to instance when option.property is null', function () :void
					{
						so(ti.alpha).should.equal(TextInputHelper.default_options.alpha);
					});

					it ('assign explicit value to instance when option.property is not null', function () :void
					{
						so(ti.editable).should.equal(options.editable);
					});
				});
			});
		}
	}
}