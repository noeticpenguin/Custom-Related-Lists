public with sharing class CRL_NewCRLCtrl {
	public class CRLException extends Exception {}

	//Properties
	public newRelationWrapper wrapper {get; set;}
	@TestVisible
	private Related_list__c crl {get; private set;}
	@TestVisible
	private String controllerContents {get; private set;}
	@TestVisible
	private String pageContents {get; private set;}
	@TestVisible
	private String testContents {get; private set;}

	//Constructor
	public CRL_NewCRLCtrl(ApexPages.StandardController sc) {
		wrapper = new newRelationWrapper();
		wrapper.hasBeenSaved = false;
	}

	//Constraint Object.
	public class constraint {
		public Id sfId {get; set;}
		public SelectOption[] andOrOptions {get; private set;}
		public String andOr {get; set;}
		public String fieldname {get; set;}
		public String opperand {get; set;}
		public String criteria {get; set;}
		public Integer order {get; set;}
		public List<SelectOption> opperandOptions {get; private set;}
		public constraint(Integer incomingOrder) {
			if (incomingOrder != null) {
				order = incomingOrder;
			} else {
				order = 0;
			}
			opperandOptions = generateOptionsList('=, !=, >, <, <=, >=');
			andOrOptions = generateOptionsList('AND, OR');
		}

		public List<SelectOption> generateOptionsList(String commaDelimitedOptions) {
			String[] options = commaDelimitedOptions.split(',');
			List<SelectOption> retOptions = new List<SelectOption>();
			for (String s : options) {
				retOptions.add(New SelectOption(s, s));
			}
			return retOptions;
		}

		public string generateSoqlFilter() {
			if (!isValidConstraint()) {
				throw new CRLException('Invalid Constraint');
			}
			String retval = '';
			if (andOr == 'AND') {
				retval += ' AND (';
			} else {
				retval += ' OR (';
			}
			retval += fieldname + ' ' + opperand;
			if (criteria.toLowerCase() == 'true' || criteria.toLowerCase() == 'false' || criteria.toLowerCase().contains('null')) {
				retval += ' ' + criteria;
			} else {
				retval += ' \'' + criteria + '\'';
			}
			retval += ')';
			return retval;
		}

		public boolean isValidConstraint() {
			return (fieldname != null && opperand != null && criteria != null);
		}
	}

	//Wrapper Object.
	public class newRelationWrapper {
		public Boolean hasBeenSaved {get; private set;}
		public Integer selectedRowIndex {get; set;}
		public String name {get; set;}
		public Map<String, String> objToRelationshipField = new Map<String, String>();
		public String selectedMasterObj {get; set;}
		public String selectedDetailObj {get; set;}
		public List<constraint> criteria {get; set;}
		public SelectOption[] selectedFields {get; set;}
		public List<SelectOption> allFields {
			get {
				if (selectedDetailObj != null) {
					Schema.SObjectType token = Schema.getGlobalDescribe().get(selectedDetailObj);
					Schema.DescribeSObjectResult dr = token.getDescribe();
					Set<SelectOption> options = new Set<SelectOption>();
					Map<String, Schema.SObjectField> field_map = dr.fields.getMap();
					for (String key : field_map.keySet()) {
						Schema.DescribeFieldResult dfr = field_map.get(key).getDescribe();
						options.add(new SelectOption(key, dfr.getLabel()));
					}
					List<SelectOption> sorted = new List<SelectOption>();
					sorted.addAll(options);
					sorted.sort();
					return sorted;
				}
				return new List<SelectOption>();
			}
			private set;
		}

		public List<SelectOption> relatedObjects {
			get {
				system.debug(selectedMasterObj);
				if (selectedMasterObj != null) {
					Schema.SObjectType token = Schema.getGlobalDescribe().get(selectedMasterObj);
					Schema.DescribeSObjectResult dr = token.getDescribe();
					Set<SelectOption> options = new Set<SelectOption>();
					List<Schema.childRelationship> childRelationships = dr.getChildRelationships();
					for (Schema.childRelationship cr : childRelationships) {
						Schema.SObjectType t = cr.getChildSObject();
						Schema.describeSobjectResult dfr = t.getDescribe();
						String crName = String.valueOf(cr.getChildSObject());
						options.add(new SelectOption(crName, dfr.getLabel()));
						objToRelationshipField.put(crName, string.valueOf(cr.getField()));
					}
					List<SelectOption> retVal = new List<SelectOption>();
					retVal.addAll(options);
					retVal.sort();
					return retVal;
				}
				return new List<SelectOption>();
			}
			private set;
		}

		public List<SelectOption> selectableObjects {
			get {
				Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
				//Schema.getGlobalDescribe generates a read-only map.
				Map<String, Schema.SObjectType> gd2 = gd.clone();
				List<String> badKeys = new List<String>();
				for (String key : gd2.keySet()) {
					if (key.endsWith('__kav')) {
						badKeys.add(key);
					}
				}
				for (String bk : badKeys) {
					gd2.remove(bk);
				}
				List<String> keys = new List<String>();
				keys.addAll(gd2.keyset());
				Schema.DescribeSobjectResult[] results = Schema.describeSObjects(keys);
				Set<SelectOption> options = new Set<SelectOption>();
				for (Schema.DescribeSobjectResult key : results) {
					if (key.isCreateable() && key.isQueryable()) {
						options.add(new SelectOption(key.getName(), key.getLabel()));
					}
				}
				List<SelectOption> sorted = new List<SelectOption>();
				sorted.addAll(options);
				sorted.sort();
				List<SelectOption> returnOptions = new List<SelectOption>();
				returnOptions.add(new SelectOption('', 'Please Select a master Object'));
				returnOptions.addall(sorted);
				return returnOptions;
			}
		}

		public newRelationWrapper() {
			allFields = new List<SelectOption>();
			selectedFields = new List<SelectOption>();
			criteria = new List<constraint> {new constraint(0)};
		}

	}

	public PageReference save() {
		crl = new Related_list__c();
		crl.Displaying_Object__c = wrapper.selectedDetailObj;
		crl.Fields_to_Display__c = genStringOfFieldsToDisplay();
		crl.On_Object__c = wrapper.selectedMasterObj;
		crl.Relation_Field__c = wrapper.objToRelationshipField.get(wrapper.selectedDetailObj);
		crl.UUID__c = CRL_QueryTools.generateCrytographicUUID();
		if (wrapper.name.length() > 40) {
			crl.Name = wrapper.name.substring(0, 37) + '...';
		} else {
			crl.Name = wrapper.name;
		}

		crl.Criteria__c = '';
		for (constraint c : wrapper.criteria) {
			crl.Criteria__c += c.generateSoqlFilter();
		}

		try {
			insert crl;
		} catch (DmlException e) {
			System.debug(e.getMessage());
			//Yeah, so I could probably do something better with this.
			//Or I could go put my kid to bed. Sorry folks, Kid wins.
			if (Test.isRunningTest()) {
				throw e;
			}
		}

		wrapper.hasBeenSaved = true;

		return null;
	}

	public pageReference generateCode() {
		ApexPages.PageReference dynamicController = new PageReference('/apex/crl_MetaGenCtrl?id=' + crl.id);
		ApexPages.PageReference dynamicTests = new PageReference('/apex/crl_MetaGenTests?id=' + crl.id);
		ApexPages.PageReference dynamicPage = new PageReference('/apex/crl_MetaGenPage?id=' + crl.id);
		//these are class variables (private) but testVisible to help testing.
		if (Test.isRunningTest()) {
			controllerContents = 'No get content during tests';
			pageContents = 'No get content during tests';
			testContents = 'No get content during tests';
		} else {
			//Don't actually make these getContent() or upsert/generate code on test run
			controllerContents = dynamicController.getContent().toString();
			testContents = dynamicTests.getContent().toString();
			pageContents = dynamicPage.getContent().toString();
			CRL_codeGenerationLib.generateClass(controllerContents); //, crl.Foreign__Controller_Name__c);
			CRL_codeGenerationLib.generateClass(testContents);
			CRL_codeGenerationLib.generatePage(crl.Name.ReplaceAll(' ', '_'), pageContents);
		}

		ApexPages.PageReference postGenInstructions = new PageReference('/apex/CRL_PostGenInstructions?id=' + crl.id);
		return postGenInstructions;
	}

	public PageReference noop() {
		return null;
	}

	@testVisible
	private String genStringOfFieldsToDisplay() {
		String[] retValue = new String[] {};
		for (SelectOption s : wrapper.selectedFields) {
			retValue.add(s.getValue());
		}
		return String.join(retValue, ', ');
	}

	public void deleteConstraint() {
		try {
			constraint currentConstraint = wrapper.criteria[Integer.valueOf(wrapper.selectedRowIndex)];
			wrapper.criteria.remove(Integer.valueOf(wrapper.selectedRowIndex));
		} catch (Exception Ex) {
			ApexPages.addMessages(ex);
			if (Test.isRunningTest()) {
				throw ex;
			}
		}
	}

	public void addConstraint() {
		Integer order = 0;
		if (wrapper.criteria != null && wrapper.criteria.size() > 0) {
			order = wrapper.criteria.size();
		}
		try {
			constraint currentConstraint = new constraint(order);
			currentConstraint.order = order;
			wrapper.criteria.add(currentConstraint);
		} catch (Exception Ex) {
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Criteria #' + order + ' \'s value is required');
			ApexPages.addMessage(myMsg);
			if (Test.isRunningTest()) {
				throw ex;
			}
		}
	}
}