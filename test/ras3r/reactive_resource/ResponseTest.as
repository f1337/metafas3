package ras3r.reactive_resource
{
	import as3spec.*;

	public class ResponseTest extends Spec
	{
		public function run () :void
		{
			describe ('a new Response', function () :void
			{
				const response:Response = new Response;

				it ('should be a Response', function () :void
				{
					so(response).should.be.a.kind_of(Response);
				});

				it ('should parse JSON object notation', function () :void
				{
					var object:Object = response.decode_json('{ "title": "Test Title" }');
					so(object.title).should.equal('Test Title');
				});

				it ('should parse JSON array notation', function () :void
				{
					var array:Object = response.decode_json('[ { "title": "Test Title" }, { "title": "Another Test Title" } ]');
					so(array).should.be.a.kind_of(Array);
					so(array[0].title).should.equal('Test Title');
				});
			});
		}
	}
}