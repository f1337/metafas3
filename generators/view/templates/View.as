//
//  <%= class_name %>.as
//
//  Created <%= Date.today.to_s(:db) %>.
//

package <%= package_name %>
{
	import ras3r.*;

	dynamic public class <%= class_name %> extends ReactionView
	{
		public function <%= class_name %> () :void
		{
			super();
		}
	}
}