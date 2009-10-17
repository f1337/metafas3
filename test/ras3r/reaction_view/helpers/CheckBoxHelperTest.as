package ras3r.reaction_view.helpers
{
	import as3spec.*;
	import flash.display.*;

	public class CheckBoxHelperTest extends Spec
	{
		public function run () :void
		{
			describe ('a new CheckBoxHelper', function () :void
			{
				const instance:CheckBoxHelper = new CheckBoxHelper;

				it ('should be a CheckBoxHelper', function () :void
				{
					so(instance).should.be.a.kind_of(CheckBoxHelper);
				});

				it ('provides .create() which returns a new CheckBoxHelper', function () :void
				{
					so(CheckBoxHelper.create()).should.be.a.kind_of(CheckBoxHelper);
				});

				it ('provides .default_options', function () :void
				{
					so(CheckBoxHelper.default_options).should.be.a.kind_of(Object);
				});

				it ('provides a display_object', function () :void
				{
					so(instance.display_object).should.be.a.kind_of(DisplayObject);
				});
			});
		}
	}
}