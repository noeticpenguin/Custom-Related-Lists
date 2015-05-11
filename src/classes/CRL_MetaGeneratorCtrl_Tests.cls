@isTest
private class CRL_MetaGeneratorCtrl_Tests {

	@isTest static void Test_CRL_MetaGeneratorCtrl_Constructor() {
		Related_list__c rl = TestFactory.generateRelatedListAndInsert();
		ApexPages.StandardController sc = new ApexPages.StandardController(rl);

		Test.startTest();
		CRL_MetaGeneratorCtrl mgc = new CRL_MetaGeneratorCtrl(sc);
		Test.stopTest();
		system.assert(mgc.CRL != null);
		system.assertEquals(mgc.CRL.name, rl.name);
		system.assertEquals(mgc.CRL.Displaying_Object__c, rl.Displaying_Object__c);
		system.assertEquals(mgc.CRL.On_Object__c, rl.On_Object__c);

	}

	@isTest static void Test_CRL_MetaGeneratorCtrl_TestGetters() {
		Related_list__c rl = TestFactory.generateRelatedListAndInsert();
		ApexPages.StandardController sc = new ApexPages.StandardController(rl);
		CRL_MetaGeneratorCtrl mgc = new CRL_MetaGeneratorCtrl(sc);

		Test.startTest();
		system.assertEquals(mgc.startPageTag,
												'<apex:page showHeader="false" sidebar="false" standardController="' + mgc.CRL.On_Object__c + '" extensions="' + mgc.CRL.Controller_Name__c + '">',
												'Expected getter to return established string' );
		system.assertEquals(mgc.endPageTag,
												'</apex:page>',
												'Expected getter to return established string' );
		system.assertEquals(mgc.CRLid,
												mgc.CRL.id,
												'Expected the CRLid getter to return the CRL.id' );
		system.assertEquals(mgc.masterObj,
												mgc.CRL.On_Object__c,
												'Expected getter to return CRL.On_Object__c' );
		system.assertEquals(mgc.detailObj,
												mgc.CRL.Displaying_Object__c,
												'Expected getter to return CRL.Displaying_Object__c' );
		system.assertEquals(mgc.detailObjAsList,
												'<' + mgc.CRL.Displaying_Object__c + '>',
												'Expected getter to return established string' );
		system.assertEquals(mgc.className,
												mgc.CRL.Controller_Name__c,
												'Expected getter to return Controller name' );
		system.assertEquals(mgc.filteredListTag,
												'{!FilteredList}',
												'Expected getter to return the filtered list tag' );
		system.assertEquals(mgc.rowIdTag,
												'{!row.Id}',
												'Expected getter to return Row id tag' );
		system.assertEquals(mgc.rowFieldTag,
												'{!row.\' + field + \'}',
												'Expected getter to return established string' );
		system.assertEquals(mgc.relationField,
												'AccountId',
												'Expected getter to return established string' );
		system.assertEquals(mgc.fieldsToDisplay,
												'id, isClosed',
												'Expected getter to return established string' );
		system.assertEquals(mgc.criteria,
												'AND (isClosed = false)',
												'Expected getter to return established string' );
		system.assertEquals(mgc.andand,
												'&&',
												'Expected getter to return established string' );
		system.assert(mgc.compString.contains('onload=function()'),
									'Expected getter to return established string' );
		system.assertNotEquals(JSON.deserialize(mgc.jsonCRL, Related_list__c.class),
													 null,
													 'Expected getter to return established string' );
		system.assertNotEquals(mgc.uuid,
													 null,
													 'Expected getter to return established string' );
		Test.stopTest();
	}

}