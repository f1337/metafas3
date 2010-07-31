package environments
{
	public class Production
	{
		logger.verbose = false;

		// setup analytics tracker
		tracker.init({
			account: 'UA-1234567-8',
			hostname: 'example.com',
			segment: ('keyword_value')
		});
	}
}