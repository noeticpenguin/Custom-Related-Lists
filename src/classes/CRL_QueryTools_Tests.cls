@isTest
private class CRL_QueryTools_Tests {

	private static Account setupAccountObj() {
		Account a = new Account();
		a.Name = 'Test Account of awesomeness';
		insert a;
		return a;
	}

	@isTest static void Test_CRL_QueryToolsConstructorWValidRelatedList() {
		Related_list__c rl = TestFactory.generateRelatedListAndInsert();
		Account a = setupAccountObj();

		test.startTest();
		CRL_QueryTools qt = new CRL_QueryTools(rl.id, a.id);
		test.stopTest();

		system.assertEquals(a.id, qt.masterObjectId, 'expected constructor to set masterid');
		system.assertNotEquals(qt.crl, null, 'expected the related list to be set as ivar fr by constructor');
	}

	@isTest static void Test_CRL_Query_Getters() {
		Related_list__c rl = TestFactory.generateRelatedListAndInsert();
		Account a = setupAccountObj();

		test.startTest();
		CRL_QueryTools qt = new CRL_QueryTools(rl.id, a.id);
		test.stopTest();

		system.assertEquals(qt.columnTitles.size(), 2, 'expected column titles array to have 2 members');
		system.assertEquals(qt.CRL_friendlyName, rl.name , 'expected column titles array to have 2 members');
		system.assertEquals(qt.criteria, rl.Criteria__c , 'expected criteria to match RL record');
		system.assertEquals(qt.fieldsToDisplay, rl.Fields_to_Display__c , 'expected fields to display to match RL record');
	}

	@isTest static void Test_ColumLabels() {
		Related_list__c rl = TestFactory.generateRelatedListAndInsert();
		Account a = setupAccountObj();

		test.startTest();
		CRL_QueryTools qt = new CRL_QueryTools(rl.id, a.id);
		test.stopTest();
		Map<String, String> results = qt.columnLabels;
		system.assertEquals(results.keySet().size(), 2 , 'expected column titles array to have 2 members');

	}

	@isTest static void Test_buildSelectClause() {
		Related_list__c rl = TestFactory.generateRelatedListAndInsert();
		Account a = setupAccountObj();
		CRL_QueryTools qt = new CRL_QueryTools(rl.id, a.id);
		test.startTest();
		String selectClause = qt.buildSelectClause();
		test.stopTest();
		system.assertEquals('SELECT id, isClosed', selectClause, 'expected Select clause to match!');
	}

	@isTest static void Test_buildFromClaus() {
		Related_list__c rl = TestFactory.generateRelatedListAndInsert();
		Account a = setupAccountObj();
		CRL_QueryTools qt = new CRL_QueryTools(rl.id, a.id);
		test.startTest();
		String fromClause = qt.buildFromClause();
		test.stopTest();
		system.assertEquals(' FROM Case', fromClause, 'expected From clause to match!');
	}

	@isTest static void Test_buildWhereClause() {
		Related_list__c rl = TestFactory.generateRelatedListAndInsert();
		Account a = setupAccountObj();
		CRL_QueryTools qt = new CRL_QueryTools(rl.id, a.id);
		test.startTest();
		String whereClause = qt.buildWhereClause();
		test.stopTest();
		system.assertEquals(' WHERE ID != null AND (isClosed = false) AND AccountId = \'' + a.id + '\'', whereClause, 'expected Where clause to match!');
	}

}