package environments
{
	public class Standalone
	{
		logger.verbose = true;
		
		ENV['HOST'] = 'https://otw-stage.offthewall.resource.com'; // NO TRAILING SLASH!
		ENV['PATH'] = '/stores/2/products/index.html'; // LEADING SLASH REQUIRED!
		ENV['ASSET_HOST'] = '/vendors/proactiv/stores/default';
	}
}