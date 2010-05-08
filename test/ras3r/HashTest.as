package metafas3
{
	import as3spec.*;

	public class HashTest extends Spec
	{
		public function run () :void
		{
			describe ('a new Hash', function () :void
			{
				const hash:Hash = new Hash;

				it ('should be a Hash', function () :void
				{
					so(hash).should.be.a.kind_of(Hash);
				});

				it ('assigns properties to object', function () :void
				{
					hash.silly = 'rabbit';
					var dummy:Object = {};
					hash.apply(dummy);
					so(dummy.silly).should.equal(hash.silly);
				});
			});
		}
	}
}