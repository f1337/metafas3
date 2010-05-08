package metafas3.reaction_view.helpers
{
	import as3spec.*;
	import fl.controls.*;
	import metafas3.*;

	public class ComboBoxHelperTest extends Spec
	{
		public function run () :void
		{
			describe ('a new ComboBoxHelper', function () :void
			{
				it ('provides .create() which returns a new ComboBox', function () :void
				{
					so(ComboBoxHelper.create()).should.be.a.kind_of(ComboBoxHelper);
				});

				it ('provides .default_options', function () :void
				{
					so(ComboBoxHelper.default_options).should.be.a.kind_of(Object);
				});

				it ('applies options.format to its textField style', function () :void
				{
					var options:Object = { format: { size: 22 } };
					var cb:ComboBoxHelper = ComboBoxHelper.create(options);
					so(cb.textField.getStyle('textFormat').size).should.equal(options.format.size);
				});

				it ('applies options.format to its dropdown style', function () :void
				{
					var options:Object = { format: { size: 22 } };
					var cb:ComboBoxHelper = ComboBoxHelper.create(options);
					so(cb.dropdown.getRendererStyle('textFormat').size).should.equal(options.format.size);
				});

				describe ('when it merges .create(options) with .default_options', function () :void
				{
					ComboBoxHelper.default_options.update({ 
						alpha: 50, editable: true
					});

					var options:Object = { editable: false };
					var cb:ComboBoxHelper = ComboBoxHelper.create(options);

					it ('should not overwrite default options', function () :void
					{
						so(ComboBoxHelper.default_options.editable).should.equal(true);
					});

					it ('assign default value to instance when option.property is null', function () :void
					{
						so(cb.alpha).should.equal(ComboBoxHelper.default_options.alpha);
					});

					it ('assign explicit value to instance when option.property is not null', function () :void
					{
						so(cb.editable).should.equal(options.editable);
					});
				});
			});
		}
	}
}