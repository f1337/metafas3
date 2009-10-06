package ras3r.reaction_view.helpers
{
	import as3spec.*;
	import flash.text.*;

	public class TextFieldHelperTest extends Spec
	{
		public function run () :void
		{
			describe ('a new TextFieldHelper', function () :void
			{
				it ('provides .create() which returns a new TextField', function () :void
				{
					so(TextFieldHelper.create()).should.be.a.kind_of(TextField);
				});

				it ('provides .default_options', function () :void
				{
					so(TextFieldHelper.default_options).should.be.a.kind_of(Object);
				});

				it ('applies options.format to textField.defaultFormat', function () :void
				{
					var options:Object = { format: { size: 22 } };
					var tf:TextField = TextFieldHelper.create(options);
					so(tf.defaultTextFormat.size).should.equal(options.format.size);
				});

				describe ('when format.font is defined', function () :void
				{
					describe ('with options.embedFonts explicity set to false', function () :void
					{
						it ('disables textField.embedFonts', function () :void
						{
							var options:Object = { format: { font: 'Test' }, embedFonts: false };
							var tf:TextField = TextFieldHelper.create(options);
							so(tf.embedFonts).should.equal(false);
						});

						it ('forces antiAliasType="normal"', function () :void
						{
							var options:Object = { format: { font: 'Test' }, antiAliasType: 'advanced' };
							var tf:TextField = TextFieldHelper.create(options);
							so(tf.antiAliasType).should.equal('normal');
						});
					});

					describe ('with options.embedFonts undefined', function () :void
					{
						it ('enables textField.embedFonts', function () :void
						{
							var options:Object = { format: { font: 'Test' } };
							var tf:TextField = TextFieldHelper.create(options);
							so(tf.embedFonts).should.equal(true);
						});

						it ('defaults to antiAliasType="advanced" with format.size <= 48', function () :void
						{
							var options:Object = { format: { font: 'Test', size: 23 } };
							var tf:TextField = TextFieldHelper.create(options);
							so(tf.antiAliasType).should.equal('advanced');
						});

						it ('allows explicit antiAliasType="normal" with format.size <= 48', function () :void
						{
							var options:Object = { format: { font: 'Test', size: 23 }, antiAliasType: 'normal' };
							var tf:TextField = TextFieldHelper.create(options);
							so(tf.antiAliasType).should.equal('normal');
						});

						it ('forces antiAliasType="normal" with format.size > 48', function () :void
						{
							var options:Object = { format: { font: 'Test', size: 49 }, antiAliasType: 'advanced' };
							var tf:TextField = TextFieldHelper.create(options);
							so(tf.antiAliasType).should.equal('normal');
						});
					});
				});

				describe ('when format.font UNdefined and', function () :void
				{
					it ('disables textField.embedFonts with no explicit options.embedFonts', function () :void
					{
						var options:Object = { format: { size: 12 } };
						var tf:TextField = TextFieldHelper.create(options);
						so(tf.embedFonts).should.equal(false);
					});

					it ('disables textField.embedFonts with no explicit options.embedFonts: true', function () :void
					{
						var options:Object = { format: { size: 12 }, embedFonts: true };
						var tf:TextField = TextFieldHelper.create(options);
						so(tf.embedFonts).should.equal(false);
					});
				});

				describe ('when it merges .create(options) with .default_options', function () :void
				{
					TextFieldHelper.default_options.update({ 
						alpha: 50, embedFonts: true
					});

					var options:Object = { embedFonts: false };
					var tf:TextField = TextFieldHelper.create(options);

					it ('should not overwrite default options', function () :void
					{
						so(TextFieldHelper.default_options.embedFonts).should.equal(true);
					});

					it ('assign default value to instance when option.property is null', function () :void
					{
						so(tf.alpha).should.equal(TextFieldHelper.default_options.alpha);
					});

					it ('assign explicit value to instance when option.property is not null', function () :void
					{
						so(tf.embedFonts).should.equal(options.embedFonts);
					});
				});
			});
		}
	}
}