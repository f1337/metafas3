package ras3r.reaction_view.helpers
{
	import as3spec.*;
	import fl.containers.*;
	import flash.display.*;
	import ras3r.*;

	public class ImageHelperTest extends Spec
	{
		public function run () :void
		{
			describe ('a new ImageHelper', function () :void
			{
				const imageHelper:ImageHelper = new ImageHelper;

				it ('should be a ImageHelper', function () :void
				{
					so(imageHelper).should.be.a.kind_of(ImageHelper);
				});

				it ('provides .create() which returns a new Image', function () :void
				{
					so(ImageHelper.create()).should.be.a.kind_of(ImageHelper);
				});

				it ('provides .default_options', function () :void
				{
					so(ImageHelper.default_options).should.be.a.kind_of(Object);
				});

				it ('gets and sets source', function () :void
				{
					var source:String = 'http://www.example.com';
					imageHelper.source = source;
					so(imageHelper.source).should.equal(source);
				});
/*
				it ('handles init events', function () :void
				{
					var loader:ImageHelper = ImageHelper.create();
					so(loader.contentLoaderInfo).should.trigger('init');
				});

				it ('handles ioError events', function () :void
				{
					var loader:ImageHelper = ImageHelper.create();
					so(loader.contentLoaderInfo).should.trigger('ioError');
				});
*/			});
		}
	}
}