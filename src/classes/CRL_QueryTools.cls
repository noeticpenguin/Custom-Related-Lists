public with sharing class CRL_QueryTools {

	@testVisible
	private Related_list__c crl;
	@testVisible
	private Id masterObjectId;

	public string[] columnTitles {get
		{
			return crl.Fields_to_Display__c.split(', ');
		} set;
	}

	public Map<String, String> columnLabels {
		get {
			Schema.SObjectType token = Schema.getGlobalDescribe().get(crl.Displaying_Object__c);
			Schema.DescribeSObjectResult dr = token.getDescribe();
			Set<SelectOption> options = new Set<SelectOption>();
			Map<String, String> results = new Map<String, String>();
			Map<String, Schema.SObjectField> field_map = dr.fields.getMap();
			for (String key : columnTitles) {
				results.put(key, field_map.get(key).getDescribe().getLabel());
			}
			return results;
		}
	}

	public string CRL_friendlyName {
		get {
			return crl.Name;
		}
	}

	public string criteria {
		get {
			return crl.Criteria__c;
		}
	}

	public string fieldsToDisplay {
		get {
			return crl.Fields_to_Display__c;
		}
	}

	public CRL_QueryTools(Id crlid, Id masterId) {
		masterObjectId = masterId;
		crl = [SELECT Name,
					 Criteria__c,
					 Displaying_Object__c,
					 Fields_to_Display__c,
					 On_Object__c,
					 Relation_Field__c,
					 Controller_Name__c,
					 Id
					 FROM Related_list__c
					 WHERE id = :crlid];
	}

	public string buildSelectClause() {
		String selectClause = 'SELECT ' + crl.Fields_to_Display__c;
		if (!selectClause.toLowerCase().contains(' id')) {
			selectClause += ', ID, Name ';
		}
		return selectClause;
	}

	public string buildFromClause() {
		//detailObjectName
		return ' FROM ' + crl.Displaying_Object__c;
	}

	public string buildWhereClause() {
		return ' WHERE ID != null ' + criteria + ' AND ' + crl.Relation_Field__c + ' = \'' + masterObjectId + '\'';
	}

	public static string generateCrytographicUUID() {
		//this just generates a 32 character string that is Unique. This uuid is used
		//to promote record data from one org to another.
		return EncodingUtil.convertToHex(Crypto.generateAesKey(128));
	}


}
