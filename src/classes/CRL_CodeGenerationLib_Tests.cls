@isTest
private class CRL_CodeGenerationLib_Tests {

	@isTest static void Test_generateClass() {
		HTTPMockCalloutFactory fakeResponse = new HTTPMockCalloutFactory(201,
				'OK',
				CRL_ToolingAPIMockObjectData.createClassResults,
				new Map<String, String>());
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();
		boolean result = CRL_codeGenerationLib.generateClass('public class foo { public static string bar = \'baz\'; }');
		Test.stopTest();
		System.assert(result, 'since the method hard codes a true return, this damn well better pass.');
	}

	@isTest static void Test_generatePage() {
		HTTPMockCalloutFactory fakeResponse = new HTTPMockCalloutFactory(201,
				'OK',
				CRL_ToolingAPIMockObjectData.createPageResults,
				new Map<String, String>());
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();
		boolean result = CRL_codeGenerationLib.generatePage('testPage', '<apex:page> </apex:page>');
		Test.stopTest();
		System.assert(result, 'since the method hard codes a true return, this damn well better pass.');
	}

	@isTest static void Test_ProperlyRenameFilenameWithSpaces() {
		HTTPMockCalloutFactory fakeResponse = new HTTPMockCalloutFactory(201,
				'OK',
				CRL_ToolingAPIMockObjectData.createPageResults,
				new Map<String, String>());
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();
		boolean result = CRL_codeGenerationLib.generatePage(' Awesome Sauce Test  Page   ', '<apex:page> </apex:page>');
		Test.stopTest();
		System.assertEquals(CRL_codeGenerationLib.pageDetails.get('Name'), 'Awesome_Sauce_Test__Page');

	}

}