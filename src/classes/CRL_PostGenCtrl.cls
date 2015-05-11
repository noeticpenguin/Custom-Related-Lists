public with sharing class CRL_PostGenCtrl {

	public final Related_list__c crl {get; private set;}

	// The extension constructor initializes the private member
	// variable mysObject by using the getRecord method from the standard
	// controller.
	public CRL_PostGenCtrl(ApexPages.StandardController stdController) {
		this.crl = [SELECT Name,
			Criteria__c,
			Displaying_Object__c,
			Fields_to_Display__c,
			On_Object__c,
			Relation_Field__c,
			Controller_Name__c,
			Id
		FROM Related_list__c
		WHERE Id = :stdController.getId()
		];
	}
}