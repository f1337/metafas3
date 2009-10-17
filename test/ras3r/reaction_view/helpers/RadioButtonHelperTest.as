package ras3r.reaction_view.helpers
{
	import as3spec.*;
	import fl.controls.*;
	import fl.data.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import ras3r.*;
	import ras3r.utils.*;

	public class RadioButtonHelperTest extends Spec
	{
		public function run () :void
		{
			describe ('a new RadioButtonHelper', function () :void
			{
				const instance:RadioButtonHelper = new RadioButtonHelper;

				it ('should be a RadioButtonHelper', function () :void
				{
					so(instance).should.be.a.kind_of(RadioButtonHelper);
				});

				it ('provides .create() which returns a new RadioButtonHelper', function () :void
				{
					so(RadioButtonHelper.create()).should.be.a.kind_of(RadioButtonHelper);
				});

				it ('provides .default_options', function () :void
				{
					so(RadioButtonHelper.default_options).should.be.a.kind_of(Object);
				});

				it ('provides a display_object', function () :void
				{
					so(instance.display_object).should.be.a.kind_of(DisplayObject);
				});

				it ('provides a radio_button', function () :void
				{
					so(instance.radio_button).should.be.a.kind_of(RadioButton);
				});

				it ('provides a text_field', function () :void
				{
					so(instance.text_field).should.be.a.kind_of(TextField);
				});

				it ('gets and sets group', function () :void
				{
					var g:RadioButtonGroup = new RadioButtonGroup('test');
					instance.group = g;
					so(instance.group).should.equal(g);
					so(instance.radio_button.group).should.equal(g);
				});

				it ('gets and sets label', function () :void
				{
					instance.label = 'a string';
					so(instance.label).should.equal('a string');
					so(instance.text_field.text).should.equal('a string');
				});

				it ('gets and sets width', function () :void
				{
					instance.width = 300;
					so(instance.width).should.equal(300);
				});

				it ('gets and sets value', function () :void
				{
					instance.value = 'S';
					so(instance.value).should.equal('S');
					so(instance.radio_button.value).should.equal('S');
				});

			});
		}
	}
}