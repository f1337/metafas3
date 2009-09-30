package ras3r.controls
{
	import as3spec.*;

	public class TextTest extends Spec
	{
		public function run () :void
		{
			describe ('a new Text', function () :void
			{
				const text:Text = new Text;

				it ('should be a Text', function () :void
				{
					so(text).should.be.a.kind_of(Text);
				});

				it ('should provide autoSize = "left" by default', function () :void
				{
					so(text.autoSize).should.equal('left');
				});

				it ('should override 100x100 default size via autoSize', function () :void
				{
					so(text.height).should.not.equal(100);
					so(text.width).should.not.equal(100);
				});

				it ('should pass format values to defaultTextFormat', function () :void
				{
					var format:Object = {
						align: 			'right',
						blockIndent:	10,
						bold:			true,
						bullet:			false,
						color:			0xff0000,
						font:			'Arial',
						indent:			20,
						italic:			true,
						kerning:		true,
						leading:		5,
						leftMargin:		20,
						letterSpacing:	4,
						rightMargin:	20,
						size:			16,
						target:			'_blank',
						underline:		true,
						url:			'http://www.example.com'
					}

					text.format = format;

					for (var key:String in format)
					{
						so(text.defaultTextFormat[key]).should.equal(format[key]);
					}
				});
			});
		}
	}
}