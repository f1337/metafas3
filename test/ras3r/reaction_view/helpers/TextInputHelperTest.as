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

				it ('applies options.format to its textFormat style', function () :void
				{
					var options:Object = { format: { size: 22 } };
					var ti:TextInput = TextInputHelper.create(options);
					so(ti.getStyle('textFormat').size).should.equal(options.format.size);
				});

				describe ('when format.font is defined', function () :void
				{
					describe ('with options.embedFonts explicity set to false', function () :void
					{
						it ('disables embedFonts style', function () :void
						{
							var options:Object = { format: { font: 'Test' }, embedFonts: false };
							var ti:TextInput = TextInputHelper.create(options);
							so(ti.getStyle('embedFonts')).should.equal(false);
						});
					});

					describe ('with options.embedFonts undefined', function () :void
					{
						it ('enables embedFonts style', function () :void
						{
							var options:Object = { format: { font: 'Test' } };
							var ti:TextInput = TextInputHelper.create(options);
							so(ti.getStyle('embedFonts')).should.equal(true);
						});
					});
				});

				describe ('when format.font UNdefined and', function () :void
				{
					it ('disables embedFonts style with no explicit options.embedFonts', function () :void
					{
						var options:Object = { format: { size: 12 } };
						var ti:TextInput = TextInputHelper.create(options);
						so(ti.getStyle('embedFonts')).should.equal(false);
					});

					it ('disables embedFonts style with explicit options.embedFonts: true', function () :void
					{
						var options:Object = { format: { size: 12 }, embedFonts: true };
						var ti:TextInput = TextInputHelper.create(options);
						so(ti.getStyle('embedFonts')).should.equal(false);
					});
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