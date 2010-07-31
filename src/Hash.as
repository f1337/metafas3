package
{
	import flash.utils.flash_proxy;
	import mx.utils.ObjectProxy;

	use namespace flash_proxy;

	dynamic public class Hash extends ObjectProxy
	{
		private var hash:Object = {};

		/**
		*	hash.length => uint
		*	Returns the number of key-value pairs in the hash.
		**/
		public function get length () :uint
		{
			var i:uint = 0;
			for (var key:String in hash)
			{
				i++;
			}
			return i;
		}

		/**
		*	hash.values => array
		*	Returns a new array populated with the values from hsh.
		**/
		public function get values () :Array
		{
			var v:Array = [];
			for (var key:String in hash)
			{
				v.push(getProperty(key));
			}
			return v;
		}

		/**
		*	new Hash()
		*	new Hash(object)
		*	Creates a new hash, optionally populated with the
		*	contents of object.
		**/
		public function Hash (object:Object = null)
		{
			super(hash);
			if (object) update(object);
		}

		/**
		*	hash.apply(object) => object
		*	Adds the contents of hash to object, overwriting object's
		*	entries with duplicate keys with those from hash.
		**/
		public function apply (object:Object) :Object
		{
			for (var key:String in hash)
			{
				try
				{
					object[key] = getProperty(key);
				}
				catch (exception:*)
				{
					//logger.info('Unable to apply hash property "' + key + '" to ' + object);
					//logger.info(">>>EXCEPTION:\n" + exception);
				}
			}
			return object;
		}

		/**
		*	hash.merge(object) => a_new_hash
		* 	Returns a new hash containing the contents of object
		*	and the contents of hash, overwriting entries in hash
		*	with duplicate keys with those from object.
		**/
		public function merge (object:Object) :Hash
		{
			return (new Hash(hash).update(object));
		}

		/**
		*	hash.remove(key) => value
		*	Deletes and returns a key-value pair from hash whose key
		*	is equal to key. If the key is not found, returns null. 
		*	Equivalent to ruby's Hash#delete. 
		*	'delete' is a reserved operator in AS3.
		**/
		public function remove (key:String) :*
		{
			var value:* = getProperty(key);
			deleteProperty(key);
			return value;
		}

		/**
		*	hash.update(object) => hash
		*	Adds the contents of object to hash, overwriting
		*	entries with duplicate keys with those from object.
		**/
		public function update (object:Object) :Hash
		{
			for (var key:String in object)
			{
				setProperty(key, object[key]);
			}
			return this;
		}
	}
}
