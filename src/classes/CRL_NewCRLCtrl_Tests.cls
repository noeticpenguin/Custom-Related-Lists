@isTest
private class CRL_NewCRLCtrl_Tests {

	private static CRL_NewCRLCtrl.constraint setupInnerClassConstraint() {
		CRL_NewCRLCtrl.constraint c = new CRL_NewCRLCtrl.constraint(0);
		c.sfId = 'a1lS0000000kaMK';
		c.andOr = 'OR';
		c.opperand = '=';
		c.fieldname = 'isClosed';
		c.criteria = 'false';
		c.order = 1;
		//andOrOptions and opperandOptions should be pre-set by constructor.
		return c;
	}

	private static CRL_NewCRLCtrl.newRelationWrapper setupNewRelationWrapper() {
		CRL_NewCRLCtrl.newRelationWrapper w = new CRL_NewCRLCtrl.newRelationWrapper();
		w.selectedRowIndex = 1;
		w.name = 'Awesome New Relation';
		w.selectedMasterObj = 'Account';
		w.selectedDetailObj = 'Case';
		return w;
	}

	private static Related_list__c generateRelatedListAndInsert() {
		Related_list__c rl = new Related_list__c();
		rl.name = 'Awesome New Relation';
		rl.Displaying_Object__c = 'Case';
		rl.On_Object__c = 'Account';
		rl.Fields_to_Display__c = 'id, isClosed';
		rl.Relation_Field__c = 'AccountId';
		rl.UUID__c = CRL_QueryTools.generateCrytographicUUID();
		insert rl;
		return rl;
	}

	//Test Methods

	@isTest static void Test_NewRelationCtrlConstructor() {
		Related_list__c rl = generateRelatedListAndInsert();
		ApexPages.StandardController sc = new ApexPages.StandardController(rl);
		CRL_NewCRLCtrl crl = new CRL_NewCRLCtrl(sc);
		Test.startTest();
		System.assert(crl.crl == null);
		System.assert(crl.wrapper != null);
		System.assert(crl.wrapper.hasBeenSaved == false);
		Test.stopTest();
	}

	@isTest static void Test_innerClassConstraintConstructor() {
		CRL_NewCRLCtrl.constraint c = setupInnerClassConstraint();
		//Class getters/setter tests
		test.startTest();
		system.assertEquals(c.sfId, 'a1lS0000000kaMK', 'expected the getter (sfid) to return what was set');
		system.assertEquals(c.andOr, 'OR', 'expected the getter (andOr) to return what was set');
		system.assertEquals(c.opperand, '=', 'expected the getter (operand) to return what was set');
		system.assertEquals(c.criteria, 'false', 'expected the getter (criteria) to return what was set');
		system.assertEquals(c.order, 1, 'expected the getter (order) to return what was set');
		system.assertEquals(c.opperandOptions.size(), 6, 'expected 8 operands');
		system.assertEquals(c.andOrOptions.size(), 2, 'expected 2 options');
		test.stopTest();
	}

	@isTest static void Test_innerClassConstraintGenOptionsList() {
		CRL_NewCRLCtrl.constraint c = setupInnerClassConstraint();
		//Test generate Options util function.
		String input = 'foo, bar, baz';
		test.startTest();
		List<SelectOption> options = c.generateOptionsList(input);
		test.stopTest();
		system.assertEquals(options.size(), 3);
	}

	@isTest static void Test_innerClassConstraintGenSoqlFilterORBoolean() {
		CRL_NewCRLCtrl.constraint c = setupInnerClassConstraint();
		test.startTest();
		String testString = c.generateSoqlFilter();
		test.stopTest();
		system.assertEquals(' OR (isClosed = false)', testString, 'expected a valid soql filter returned.');
	}

	@isTest static void Test_innerClassConstraintGenSoqlFilterANDBoolean() {
		CRL_NewCRLCtrl.constraint c = setupInnerClassConstraint();
		c.andOr = 'AND';
		test.startTest();
		String testString = c.generateSoqlFilter();
		test.stopTest();
		system.assertEquals(' AND (isClosed = false)', testString, 'expected a valid soql filter returned.');
	}

	@isTest static void Test_innerClassConstraintGenSoqlFilterORString() {
		CRL_NewCRLCtrl.constraint c = setupInnerClassConstraint();
		c.criteria = 'a1lS0000000kaMK';
		test.startTest();
		String testString = c.generateSoqlFilter();
		test.stopTest();
		system.assertEquals(' OR (isClosed = \'a1lS0000000kaMK\')', testString, 'expected a valid soql filter returned.');
	}

	@isTest static void Test_innerClassConstraintGenSoqlFilterANDString() {
		CRL_NewCRLCtrl.constraint c = setupInnerClassConstraint();
		c.andOr = 'AND';
		c.criteria = 'a1lS0000000kaMK';
		c.fieldname = 'RecordTypeId';
		test.startTest();
		String testString = c.generateSoqlFilter();
		test.stopTest();
		system.assertEquals(' AND (RecordTypeId = \'a1lS0000000kaMK\')', testString, 'expected a valid soql filter returned.');
	}

	@isTest static void Test_innerClassConstraintIsValidConstraintPositive() {
		CRL_NewCRLCtrl.constraint c = setupInnerClassConstraint();
		//Test isValidConstraint - positive
		test.startTest();
		Boolean result = c.isValidConstraint();
		test.stopTest();
		system.assert(result, 'expected true since fieldname, opperand and criteria are all set.');
	}

	@isTest static void Test_innerClassConstraintIsValidConstraintNegative() {
		CRL_NewCRLCtrl.constraint c = setupInnerClassConstraint();
		//Test isValidConstraint - negative
		test.startTest();
		c.fieldname = null;
		Boolean result = c.isValidConstraint();
		test.stopTest();
		system.assert(!result, 'expected false since fieldname was just nullified');
	}

	@isTest static void Test_InnerClassNewRelationWrapperConstructor() {
		CRL_NewCRLCtrl.newRelationWrapper w = setupNewRelationWrapper();
		test.startTest();
		system.assertEquals(w.hasBeenSaved, null, 'expected the default value of hasBeenSaved to be null due to private set method');
		system.assertEquals(w.selectedRowIndex, 1, 'expected row index to be 1');
		system.assertEquals(w.name, 'Awesome New Relation', 'expected name to have been set by setup method');
		system.assertEquals(w.selectedMasterObj, 'Account', 'expected master object to be account, as set by setup method');
		system.assertEquals(w.selectedDetailObj, 'Case', 'expected detail object to be case, as set by setup method');
		system.assert(w.allFields.size() > 0, 'given selected detail object of case, the field list should not be null');
		system.assert(w.relatedObjects.size() > 0, 'given selected master object of Account, the relatedObjects list should not be null');
		system.assert(w.selectableObjects.size() > 0, 'Selectable Objects should never be null, or an empty list.');
		test.stopTest();
	}

	@isTest static void Test_InnerClassNewRelationWrapperRelatedObjectsWNullMaster() {
		CRL_NewCRLCtrl.newRelationWrapper w = setupNewRelationWrapper();
		test.startTest();
		system.assertNotEquals(w.selectedMasterObj, null, 'expected setup method to populate selectedMasterObj');
		w.selectedMasterObj = null;
		system.assertEquals(w.relatedObjects.size(), 0, 'when selected master object is null, relatedObjects should be empty list');
		test.stopTest();
	}

	@isTest static void Test_InnerClassNewRelationWrapperAllFieldsWNullDetail() {
		CRL_NewCRLCtrl.newRelationWrapper w = setupNewRelationWrapper();
		test.startTest();
		system.assertNotEquals(w.selectedDetailObj, null, 'expected setup method to populate selectedDetailObj');
		w.selectedDetailObj = null;
		system.assertEquals(w.allFields.size(), 0, 'when selected detail object is null, allFields should be empty list');
		test.stopTest();
	}

	@isTest static void Test_NoopMethodReturnsNull() {
		Related_list__c rl = generateRelatedListAndInsert();
		ApexPages.StandardController sc = new ApexPages.StandardController(rl);
		CRL_NewCRLCtrl crl = new CRL_NewCRLCtrl(sc);
		Test.startTest();
		system.assertEquals(crl.noop(), null, 'expected noop to return null');
		Test.stopTest();
	}

	@isTest static void Test_SaveMethodPositive() {
		Related_list__c rl = generateRelatedListAndInsert();
		ApexPages.StandardController sc = new ApexPages.StandardController(rl);
		CRL_NewCRLCtrl icrl = new CRL_NewCRLCtrl(sc);
		icrl.wrapper = setupNewRelationWrapper();
		icrl.wrapper.selectedMasterObj = 'Account';
		List<SelectOption> r = icrl.wrapper.relatedObjects;
		icrl.wrapper.selectedDetailObj = 'Case';
		icrl.wrapper.selectedFields = new List<SelectOption>();
		icrl.wrapper.selectedFields.add(new SelectOption('isClosed', 'isClosed'));
		icrl.wrapper.criteria[0].criteria = 'false';
		icrl.wrapper.criteria[0].fieldname = 'isClosed';
		icrl.wrapper.criteria[0].opperand = '=';

		system.assert(icrl.wrapper.criteria.size() > 0, 'Should be at least one criteria');
		Test.startTest();
		icrl.save();
		Test.stopTest();
		System.assert(icrl.crl != null, 'After save, the crl.crl property should not be null');
		System.assertEquals(icrl.crl.Displaying_Object__c, icrl.wrapper.selectedDetailObj);
		System.assertEquals(icrl.crl.On_Object__c, icrl.wrapper.selectedMasterObj);
		System.assert(icrl.crl.Fields_to_Display__c != null);
		System.assertEquals(icrl.crl.Relation_Field__c, icrl.wrapper.objToRelationshipField.get(icrl.wrapper.selectedDetailObj));
		System.assertEquals(icrl.crl.Name, icrl.wrapper.name);
		System.assertNotEquals(icrl.crl.Criteria__c, null);
		System.assertEquals(icrl.wrapper.hasBeenSaved, true);
	}

	@isTest static void Test_GenerateSoqlFilterThrowsErrorWbadConstraint() {
		CRL_NewCRLCtrl.constraint c = setupInnerClassConstraint();
		c.fieldname = null;
		boolean didFailAsExpected = false;
		test.startTest();
		try {
			String testString = c.generateSoqlFilter();
		} catch (CRL_NewCRLCtrl.CRLException e) {
			if (e.getMessage() == 'Invalid Constraint') {
				didFailAsExpected = true;
			}
		}
		test.stopTest();
		system.assert(didFailAsExpected, 'expected an invalid constraint CRL_NewCRLCtrl.CRLException when fieldname is null.');
	}

	@isTest static void Test_SaveW45CharacterName() {
		Related_list__c rl = generateRelatedListAndInsert();
		ApexPages.StandardController sc = new ApexPages.StandardController(rl);
		CRL_NewCRLCtrl icrl = new CRL_NewCRLCtrl(sc);
		icrl.wrapper = setupNewRelationWrapper();
		icrl.wrapper.selectedMasterObj = 'Account';
		List<SelectOption> r = icrl.wrapper.relatedObjects;
		icrl.wrapper.selectedDetailObj = 'Case';
		icrl.wrapper.selectedFields = new List<SelectOption>();
		icrl.wrapper.selectedFields.add(new SelectOption('isClosed', 'isClosed'));
		icrl.wrapper.name = 'AVeryLongNameThatExceedsFortyCharactersByAFewCharacters';
		icrl.wrapper.criteria[0].criteria = 'false';
		icrl.wrapper.criteria[0].fieldname = 'isClosed';
		icrl.wrapper.criteria[0].opperand = '=';

		system.assert(icrl.wrapper.criteria.size() > 0, 'Should be at least one criteria');
		Test.startTest();
		icrl.save();
		Test.stopTest();
		System.assert(icrl.crl != null, 'After save, the crl.crl property should not be null');
		Related_list__c testResult = [SELECT ID, Name FROM Related_list__c WHERE ID = :icrl.crl.Id LIMIT 1];
		System.assertNotEquals(testResult.name, icrl.wrapper.name);

	}

	@isTest static void Test_SaveWithMissingDataThrowsError() {
		Related_list__c rl = generateRelatedListAndInsert();
		ApexPages.StandardController sc = new ApexPages.StandardController(rl);
		CRL_NewCRLCtrl icrl = new CRL_NewCRLCtrl(sc);
		icrl.wrapper = setupNewRelationWrapper();
		icrl.wrapper.selectedMasterObj = null;
		icrl.wrapper.criteria[0].criteria = 'false';
		icrl.wrapper.criteria[0].fieldname = 'isClosed';
		icrl.wrapper.criteria[0].opperand = '=';

		system.assert(icrl.wrapper.criteria.size() > 0, 'Should be at least one criteria');
		boolean didFailAsExpected = false;
		Test.startTest();
		try {
			icrl.save();
		} catch (DmlException e) {
			didFailAsExpected = true;
		}
		Test.stopTest();
		System.assert(didFailAsExpected, 'expected missing data to trigger DML failure');
	}

	@isTest static void Test_GenerateCode() {
		Related_list__c rl = generateRelatedListAndInsert();
		ApexPages.StandardController sc = new ApexPages.StandardController(rl);
		CRL_NewCRLCtrl icrl = new CRL_NewCRLCtrl(sc);
		icrl.wrapper = setupNewRelationWrapper();
		icrl.wrapper.selectedMasterObj = 'Account';
		List<SelectOption> r = icrl.wrapper.relatedObjects;
		icrl.wrapper.selectedDetailObj = 'Case';
		icrl.wrapper.selectedFields = new List<SelectOption>();
		icrl.wrapper.selectedFields.add(new SelectOption('isClosed', 'isClosed'));
		icrl.wrapper.criteria[0].criteria = 'false';
		icrl.wrapper.criteria[0].fieldname = 'isClosed';
		icrl.wrapper.criteria[0].opperand = '=';

		system.assert(icrl.wrapper.criteria.size() > 0, 'Should be at least one criteria');
		icrl.save();
		Test.startTest();
		PageReference results = icrl.generateCode();
		Test.stopTest();
		System.assert(results.getUrl().endsWith('/apex/CRL_PostGenInstructions?id=' + icrl.crl.id), 'Expected generate code to redirect to after deploy page');
		System.assertEquals(icrl.controllerContents, 'No get content during tests', 'Expected generateCode to populate instance var controllerContents with controller contents');
		System.assertEquals(icrl.pageContents, 'No get content during tests', 'Expected generateCode to populate instance var pageContents with page contents');

	}

	@isTest static void Test_genStringOfFieldsToDisplay() {
		Related_list__c rl = generateRelatedListAndInsert();
		ApexPages.StandardController sc = new ApexPages.StandardController(rl);
		CRL_NewCRLCtrl icrl = new CRL_NewCRLCtrl(sc);
		icrl.wrapper = setupNewRelationWrapper();
		icrl.wrapper.criteria[0].criteria = 'false';
		icrl.wrapper.criteria[0].fieldname = 'isClosed';
		icrl.wrapper.criteria[0].opperand = '=';
		icrl.wrapper.selectedFields = new List<SelectOption>();
		icrl.wrapper.selectedFields.add(new SelectOption('foo', 'bar'));
		icrl.wrapper.selectedFields.add(new SelectOption('far', 'baz'));

		test.startTest();
		String results = icrl.genStringOfFieldsToDisplay();
		test.stopTest();

		system.assertEquals('foo, far', results, 'expected properly formatted comma delimited string');
	}

	@isTest static void Test_DeleteConstraint() {
		Related_list__c rl = generateRelatedListAndInsert();
		ApexPages.StandardController sc = new ApexPages.StandardController(rl);
		CRL_NewCRLCtrl icrl = new CRL_NewCRLCtrl(sc);
		icrl.wrapper = setupNewRelationWrapper();
		icrl.wrapper.criteria[0].criteria = 'false';
		icrl.wrapper.criteria[0].fieldname = 'isClosed';
		icrl.wrapper.criteria[0].opperand = '=';

		system.assertEquals(1, icrl.wrapper.criteria.size(), 'setup included 1, and only 1, criteria');
		icrl.addConstraint();
		system.assertEquals(2, icrl.wrapper.criteria.size(), 'add constraint should have added to the constraint list');
		test.startTest();
		icrl.deleteConstraint();
		test.stopTest();
		system.assertEquals(1, icrl.wrapper.criteria.size(), 'Having added one, deleting a constraint should take our list size back to 1');
	}

	@isTest static void Test_DeleteConstraint_ThrowsException() {
		Related_list__c rl = generateRelatedListAndInsert();
		ApexPages.StandardController sc = new ApexPages.StandardController(rl);
		CRL_NewCRLCtrl icrl = new CRL_NewCRLCtrl(sc);
		icrl.wrapper = setupNewRelationWrapper();
		icrl.wrapper.criteria[0].criteria = 'false';
		icrl.wrapper.criteria[0].fieldname = 'isClosed';
		icrl.wrapper.criteria[0].opperand = '=';
		boolean didFailAsExpected = false;

		icrl.wrapper.criteria = null;
		test.startTest();
		try {
			icrl.deleteConstraint();
		} catch (Exception e) {
			didFailAsExpected = true;
		}
		test.stopTest();
		system.assert(didFailAsExpected, 'Expected an exception');
	}

	@isTest static void Test_AddConstraint() {
		Related_list__c rl = generateRelatedListAndInsert();
		ApexPages.StandardController sc = new ApexPages.StandardController(rl);
		CRL_NewCRLCtrl icrl = new CRL_NewCRLCtrl(sc);
		icrl.wrapper = setupNewRelationWrapper();
		icrl.wrapper.criteria[0].criteria = 'false';
		icrl.wrapper.criteria[0].fieldname = 'isClosed';
		icrl.wrapper.criteria[0].opperand = '=';

		system.assertEquals(1, icrl.wrapper.criteria.size(), 'setup included 1, and only 1, criteria');
		test.startTest();
		icrl.addConstraint();
		test.stopTest();

		system.assertEquals(2, icrl.wrapper.criteria.size(), 'add constraint should have added to the constraint list');
	}

	@isTest static void Test_AddConstraint_ThrowsException() {
		Related_list__c rl = generateRelatedListAndInsert();
		ApexPages.StandardController sc = new ApexPages.StandardController(rl);
		CRL_NewCRLCtrl icrl = new CRL_NewCRLCtrl(sc);
		icrl.wrapper = setupNewRelationWrapper();
		icrl.wrapper.criteria[0].criteria = 'false';
		icrl.wrapper.criteria[0].fieldname = 'isClosed';
		icrl.wrapper.criteria[0].opperand = '=';
		boolean didFailAsExpected = false;

		icrl.wrapper.criteria = null;
		test.startTest();
		try {
			icrl.addConstraint();
		} catch (Exception e) {
			didFailAsExpected = true;
		}
		test.stopTest();
		system.assert(didFailAsExpected, 'Expected an exception');
	}

}