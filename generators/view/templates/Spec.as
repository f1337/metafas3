package <%= package_name %>
{
	import as3spec.*;
	import fl.containers.*;
	import fl.controls.*;
	import flash.text.*;
	import ras3r.*;

	public class <%= test_case_name  %> extends Spec
	{
		public function run () :void
		{
			describe ('a new <%= class_name %>', function () :void
			{
				const assigns:Object = {};
				const <%= instance_name %>:<%= class_name %> = (ReactionView.create('<%= class_name.sub(/([A-Z][a-z]+)([A-Z][a-z]+)/, '\2/\1').downcase %>', assigns) as <%= class_name %>);
				<%= instance_name %>.build();

				it ('should be a <%= class_name %>', function () :void
				{
					so(<%= instance_name %>).should.be.a.kind_of(<%= class_name %>);
				});

				it ('should contain real code', function () :void
				{
				});
			});
		}
	}
}