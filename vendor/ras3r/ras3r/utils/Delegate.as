// (c) 2007 Ian Thomas
// Freely usable in whatever way you like, as long as it's attributed.
package ras3r.utils
{
	public class Delegate
	{
        public static function create (handler:Function, ...args) :Function
        {
            return function (...innerArgs) :void
            {
                handler.apply(this, innerArgs.concat(args));
            }
        }
	}
}