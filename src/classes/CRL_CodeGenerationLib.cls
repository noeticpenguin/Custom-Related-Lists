public with sharing class CRL_CodeGenerationLib {
	private static ToolingAPI tooling = new ToolingAPI();
	@TestVisible private static Map<String, String> pageDetails;

	public static boolean GenerateClass(String body) {
		system.debug('Generating Class');
		ToolingAPI.ApexClass apexClass = new ToolingAPI.ApexClass();
		apexClass.Body = body;
		ToolingAPI.SaveResult sr = tooling.createSObject(apexClass);
		system.debug(sr);

		return true;
	}

	public static boolean generatePage(String pageName, String body) {
		System.debug('Generating Page');
		String salesforceHost = System.Url.getSalesforceBaseURL().toExternalForm();
		String url =  salesforceHost + '/services/data/v29.0/sobjects/ApexPage';
		HttpRequest req = new HttpRequest();

		//Sanitize the input'd page name to strip whitespace and replace spaces with _'s
		pageName = pageName.trim();
		pageName = pageName.replaceAll(' ', '_');

		pageDetails = new Map<String, String>();
		pageDetails.put('Name', pageName);
		pageDetails.put('Markup', body);
		pageDetails.put('ControllerType', '1');
		pageDetails.put('MasterLabel', pageName);
		pageDetails.put('ApiVersion', '33.0');
		String PagePayload = JSON.serialize(pageDetails);

		req.setMethod('POST');
		req.setEndpoint(url);
		req.setHeader('Content-type', 'application/json');
		req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
		req.setBody(PagePayload);

		Http http = new Http();

		HTTPResponse res = http.send(req);
		System.debug('Page Generation Response: ' + res.getBody());

		return true;
	}

}