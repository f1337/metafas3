package ras3r
{
	import ras3r.utils.*;

	dynamic public class Hash extends ObjectProxy
	{
		public function get length () :uint
		{
			var i:uint = 0;
			for (var key:String in this)
			{
				i++;
			}
			return i;
		}

		public function get values () :Array
		{
			var v:Array = [];
			for (var key:String in this)
			{
				v.push(this[key]);
			}
			return v;
		}


		public function Hash (value:Object = null)
		{
			super();
			if (value) update(value);
		}

		public function merge (hash:Object) :Hash
		{
			return (new Hash(this).update(hash));
		}

		// equivalent to ruby's Hash#delete
		// 'delete' is a reserved operator in AS
		public function remove (key:String) :*
		{
			var value:* = this[key];
			delete this[key];
			return value;
		}

		public function update (hash:Object) :Hash
		{
			for (var key:String in hash)
			{
				this[key] = hash[key];
			}
			return this;
		}
	}
}
