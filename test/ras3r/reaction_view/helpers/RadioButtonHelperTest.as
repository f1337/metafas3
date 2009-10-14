package ras3r.reaction_view.helpers
{
	import as3spec.*;
	import fl.controls.*;
	import fl.data.*;
	import flash.events.*;
	import ras3r.*;
	import ras3r.utils.*;

	public class RadioButtonHelperTest extends Spec
	{
		public function run () :void
		{
			describe ('a new RadioButtonHelper', function () :void
			{
				it ('provides .create() which returns a new RadioButtonHelper', function () :void
				{
					so(RadioButtonHelper.create()).should.be.a.kind_of(RadioButtonHelper);
				});

				it ('provides .default_options', function () :void
				{
					so(RadioButtonHelper.default_options).should.be.a.kind_of(Object);
				});
			});
		}
	}
}