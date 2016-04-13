public with sharing class CRL_MetaGeneratorCtrl {
	//Private properties and class variables
	@testVisible
	private final Related_list__c crl;

	//Public properties and class variables
	//startPageTag is the bit we'll swap in on rendering of the VF page to return us valid VF syntax.
	public String startPageTag {
		get{
			return '<apex:page showHeader="false" sidebar="false" standardController="' + crl.On_Object__c + '" extensions="' + crl.Controller_Name__c + '">';
		}
	}

	//endPageTag is how we'll swap in the end apex:page element
	public String endPageTag {
		get {
			return '</apex:page>';
		}
	}

	public Id crlid {
		get {
			return crl.Id;
		}
	}

	public String masterObj {
		get {
			return crl.On_Object__c;
		}
	}

	public String detailObj {
		get {
			return crl.Displaying_Object__c;
		}
	}

	public String detailObjAsList {
		get {
			return '<' + crl.Displaying_Object__c + '>';
		}
	}

	public String className {
		get {
			return crl.Controller_Name__c;
		}
	}

	public string filteredListTag {
		get {
			return '{!FilteredList}';
		}
	}

	public string rowIdTag {
		get {
			return '{!row.Id}';
		}
	}

	public string rowFieldTag {
		get {
			return '{!row.\' + field + \'}';
		}
	}

	public string relationField {
		get {
			return crl.Relation_Field__c;
		}
	}

	public string fieldsToDisplay {
		get {
			return crl.Fields_to_Display__c;
		}
	}

	public string andand {
		get {
			return '&&';
		}
	}

	public string compString {
		get {
			return 	'<apex:form>\n' +
			'	<apex:actionFunction name="doInit" action="{!verifyRL}" rerender="allPanel"/>\n' +
			'	<apex:outputPanel id="allPanel">\n' +
			'		<apex:outputPanel rendered="{!NOT(initialized)}">\n' +
			'			<p align="center" style=\'{font-family:"Arial", Helvetica, sans-serif; font-size:20px;}\'>\n' +
			' 		<apex:image value="/img/loading.gif"/>\n' +
			'				&nbsp;Please wait\n' +
			'			</p>\n' +
			'			<script>\n' +
			'				 window.onload=function(){\n' +
			'					 doInit();\n' +
			'				 };\n' +
			'			</script>\n' +
			'		</apex:outputPanel>\n' +
			'		<apex:outputPanel rendered="{!initialized}">\n' +
			'					<apex:pageBlock title="' + this.crl.name + '">\n' +
			'							<apex:pageBlockTable var="row" value="{!FilteredList}">\n' +
			'									<apex:column headerValue="Link">\n' +
			'											<apex:outputLink value="/{!row.Id}" target="_parent">{!row.name}</apex:outputLink>\n' +
			'									</apex:column>\n' +
			'									<apex:repeat value="{!qt.columnTitles}" var="col">\n' +
			'											<apex:column headerValue="{!qt.columnLabels[col]}">\n' +
			'													<apex:outputField value="{!row[col]}" />\n' +
			'											</apex:column>\n' +
			'									</apex:repeat>\n' +
			'							</apex:pageBlockTable>\n' +
			'			</apex:pageBlock>\n' +
			'		</apex:outputPanel>\n' +
			'	</apex:outputPanel>\n' +
			'</apex:form>';
		}
	}

	public string criteria {
		get {
			return String.escapeSingleQuotes(crl.criteria__c);
		}
	}

	public string jsonCRL {
		get {
			return String.escapeSingleQuotes(JSON.serialize(crl));
		}
	}

	public string uuid {
		get{
			return crl.UUID__c;
		}
	}

	public CRL_MetaGeneratorCtrl(ApexPages.StandardController stdController) {
		this.crl = [SELECT Name,
								Criteria__c,
								Displaying_Object__c,
								Fields_to_Display__c,
								On_Object__c,
								Relation_Field__c,
								Controller_Name__c,
								UUID__c,
								Id
								FROM Related_list__c
								WHERE Id = :stdController.getId()
							 ];
	}

}
