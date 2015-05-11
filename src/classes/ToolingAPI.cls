/**
 * Copyright (c) 2013, Apex Tooling API
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 * - Neither the name of the Apex Tooling API, inc nor the names of its contributors
 *      may be used to endorse or promote products derived from this software without
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/**
 *	This is a truncated / eviscerated version of the full toolingAPI class from Andrew
 *	Fawcett and James Logthry. You can find more here:
 *	https://github.com/afawcett/apex-toolingapi/tree/apex-toolingapi-rest
**/

public with sharing class ToolingAPI {

	/**
	 * Complete list of all Tooling API objects (as per those in WSDL that extend tns:sObject)
	 **/
	public enum SObjectType {
		ApexClass,
		ApexClassMember,
		AsyncApexJob,
		ContainerAsyncRequest,
		CustomObject,
		CustomField,
		MetadataContainer,
		MetadataContainerMember,
		Name,
		User,
		UserPreference
	}

	// The API version used relates to the types and structures defined here
	private static final String TOOLING_API_URI = '/services/data/v30.0/tooling';

	// Session Id can be resovled automatically depending on consturctor used
	@testVisible
	private String sessionId;

	// Interface used to implement customi serialization on SObject based types
	private interface ISerialize {
		void serialize(JSONGenerator generator);
	}

	/**
	 * Uses the current users Session Id, only compatible in a interactive context
	 * @throws ToolingAPIException if no Session Id can be resolved (e.g. in a batch context)
	 **/
	public ToolingAPI() {
		this.sessionId = UserInfo.getSessionId();
		if (this.sessionId == null)
			throw new ToolingAPIException('Unable to obtain Session Id');
	}

	/**
	 * Generic methods for creating an sobject record
	 * @param sobjectRecord The sobject record to create.
	 **/
	public ToolingAPI.SaveResult createSObject(SObject_x sobjectRecord) {
		return (ToolingAPI.SaveResult) submitRestCallAndDeserialize(
						 '/sobjects/' + sobjectRecord.type_x
						 , ToolingAPI.SaveResult.class
						 , 'POST'
						 , sobjectRecord
					 );
	}

	public class ApexClass extends SObject_x implements ISerialize {
		public Double            apiVersion;
		public String            body;
		public Double            bodyCrc;
		public String            fullName;
		public boolean           isValid;
		public Integer           lengthWithoutComments;
		public ApexClassMetadata metadata;
		public String            name;
		public String            namespacePrefix;
		public String            status;
		public SymbolTable       symbolTable;
		public ApexClass() {
			super(SObjectType.ApexClass);
		}
		public override void serialize(JSONGenerator jsonGen) {
			super.serialize(jsonGen);
			if (apiVersion != null)
				jsonGen.writeNumberField('apiVersion', apiVersion);
			if (body != null)
				jsonGen.writeStringField('body', body);
			if (name != null)
				jsonGen.writeStringField('name', name);
			if (status != null)
				jsonGen.writeStringField('status', status);
			if (fullName != null)
				jsonGen.writeStringField('fullName', fullName);
			if (metadata != null)
				jsonGen.writeObjectField('metadata', metadata);
		}
	}

	public class ApexClassMetadata {
		public Double                   apiVersion;
		public PackageVersion[]         packageVersions;
		public String                   status;
	}

	public class Error {
		public String[] fields;
		public String   message;
		public String   statusCode;
	}

	public class ErrorResponse {
		public List<String> fields;
		public String errorCode;
		public String message;
	}

	public virtual class ExternalConstructor extends ExternalSymbol {
		public Parameter[] parameters;
	}

	public class ExternalMethod extends ExternalConstructor {
		public String[] argTypes;
		public String returnType;
	}

	public class ExternalReference {
		public ExternalMethod[] methods;
		public String           name;
		public String           namespace;
		public Position[]       references;
		public ExternalSymbol[] variables;
	}

	public virtual class ExternalSymbol {
		public String     name;
		public Position[] references;
	}

	public class Field {
		public boolean         autoNumber;
		public Integer         byteLength;
		public boolean         calculated;
		public String          calculatedFormula;
		public boolean         cascadeDelete;
		public boolean         caseSensitive;
		public String          controllerName;
		public boolean         createable;
		public boolean         custom;
		public String          defaultValueFormula;
		public boolean         defaultedOnCreate;
		public boolean         dependentPicklist;
		public boolean         deprecatedAndHidden;
		public Integer         digits;
		public boolean         displayLocationInDecimal;
		public boolean         externalId;
		public boolean         filterable;
		public boolean         groupable;
		public boolean         htmlFormatted;
		public boolean         idLookup;
		public String          inlineHelpText;
		public String          label;
		public Integer         length;
		public String          name;
		public boolean         nameField;
		public boolean         namePointing;
		public boolean         nillable;
		public boolean         permissionable;
		public PicklistEntry[] picklistValues;
		public Integer         precision;
		public String[]        referenceTo;
		public String          relationshipName;
		public Integer         relationshipOrder;
		public boolean         restrictedDelete;
		public boolean         restrictedPicklist;
		public Integer         scale;
		public String          soapType;
		public boolean         sortable;
		public String          type_x;
		public boolean         unique;
		public boolean         updateable;
		public boolean         writeRequiresMasterRead;
	}

	public class InvalidateSessionsResult {
		public Error[] errors;
		public Boolean success;
	}

	public virtual class Metadata {
		public Double           apiVersion;
		public boolean          availableInTouch;           //PageMetaData
		public boolean          confirmationTokenRequired;  //PageMetaData
		public String           description;                //PageMetadata, ComponentMetaData
		public String           fullName;
		public String           label;                      //PageMetadata, ComponentMetaData
		public String           module;
		public PackageVersion[] packageVersions;
		public String           status;                     //ClassMetadata, TriggerMetaData
		public String []        urls;
	}

	public class MetadataContainer extends SObject_x implements ISerialize {
		public Boolean isDeleted;
		public String  name;
		public MetadataContainer() {
			super(SObjectType.MetadataContainer);
		}
		public override void serialize(JSONGenerator jsonGen) {
			super.serialize(jsonGen);
			if (isDeleted != null)
				jsonGen.writeBooleanField('isDeleted', isDeleted);
			if (Name != null)
				jsonGen.writeStringField('name', name);
		}
	}

	public class MetadataContainerMember extends SObject_x implements ISerialize {
		public String            content;
		public SObject_x         contentEntity;
		public Id                contentEntityId;
		public DateTime          lastSyncDate;
		public MetadataContainer metadataContainer;
		public Id                metadataContainerId;
		public MetadataContainerMember() {
			super(SObjectType.MetadataContainerMember);
		}
		public override void serialize(JSONGenerator jsonGen) {
			super.serialize(jsonGen);
			if (content != null)
				jsonGen.writeStringField('content', content);
			if (contentEntity != null)
				jsonGen.writeObjectField('contentEntity', contentEntity);
			if (contentEntityId != null)
				jsonGen.writeIdField('contentEntityId', contentEntityId);
			if (lastSyncDate != null)
				jsonGen.writeDateTimeField('lastSyncDate', lastSyncDate);
			if (metadataContainer != null)
				jsonGen.writeObjectField('metadataContainer', metadataContainer);
			if (metadataContainerId != null)
				jsonGen.writeObjectField('metadataContainerId', metadataContainerId);
		}
	}

	public virtual class Constructor extends VisibilitySymbol {
		public List<Parameter> parameters;
	}

	public class Method extends Constructor {
		public String returnType;
	}

	public class PackageVersion {
		public Integer majorNumber;
		public Integer minorNumber;
		public String  namespace;
	}

	public class Parameter {
		public String name;
		public String type;
	}

	public class PicklistEntry {
		public boolean active;
		public boolean defaultValue;
		public String  label;
		public String  validFor;
		public String  value;
	}

	public class Position {
		public Integer column;
		public Integer line;
	}

	public class QueryResult {
		public boolean              done;
		public String               entityTypeName;
		public String               nextRecordsUrl;
		public SObject_x[]          records;
		public Integer              size;
		public Integer              totalSize;
		public String               queryLocator;
	}

	public class SaveResult {
		public Error[] errors;
		public String  id;
		public boolean success;
	}

	public virtual class SObject_x {
		public transient SObjectType type_x {get; private set;}
		public transient String[]    fieldsToNull;
		public Id                    id;
		public Id                    createdById;
		public User_x                createdBy;
		public DateTime              createdDate;
		public boolean               isDeleted;
		public Id                    lastModifiedById;
		public User_x                lastModifiedBy;
		public Datetime              lastModifiedDate;
		public DateTime              systemModstamp;
		public SObject_x(SObjectType sObjectType) {
			type_x = sObjectType;
		}
		public virtual void serialize(JSONGenerator jsonGen) {
			if (id != null)
				jsonGen.writeStringField('id', id);
			if (fieldsToNull != null)
				for (String fieldToNull : fieldsToNull)
					jsonGen.writeNullField(fieldToNull);
		}
	}

	public virtual class Symbol {
		public Position   location;
		public String[]   modifiers;
		public String     name;
		public Position[] references;
		public String     type_x;
	}

	public class SymbolTable {
		public Constructor[]            constructors;
		public ExternalReference[] externalReferences;
		public Id                  id;
		public SymbolTable[]       innerClasses;
		public String[]            interfaces;
		public Method[]            methods;
		public String              name;
		public String              namespace;
		public VisibilitySymbol[]  properties;
		public Symbol              tableDeclaration;
		public Symbol[]            variables;
	}

	public class ToolingAPIException extends Exception {
		public ToolingAPIException(List<ErrorResponse> errorResponses) {
			this(errorResponses[0].errorCode + ' : ' + errorResponses[0].message);
		}
	}

	public class ToolingAPIAuthorizationException extends Exception {

	}

	public class User_x extends SObject_x implements ISerialize {
		public QueryResult delegatedUsers;
		public QueryResult userPreferences;
		public Id          workspaceId;
		public User_x() {
			super(SObjectType.User);
		}
		public override void serialize(JSONGenerator jsonGen) {
			super.serialize(jsonGen);
			if (delegatedUsers != null)
				jsonGen.writeObjectField('delegatedUsers', delegatedUsers);
			if (userPreferences != null)
				jsonGen.writeObjectField('userPreferences', userPreferences);
			if (workspaceId != null)
				jsonGen.writeIdField('workspaceId', workspaceId);
		}
	}

	public virtual class VisibilitySymbol extends Symbol {
		public String visibility;
	}

	//Private helper methods go here
	//

	/*
	 * Static helper method for the "happy path" of JSON deserialization.
	 * This method should be used for the public methods when the generic JSON deserialize method
	 * may be used. Sends a HTTP GET request.
	 */
	private Object submitRestCallAndDeserialize(String relativeUrl, Type classType) {
		return submitRestCallAndDeserialize(relativeUrl, classType, 'GET');
	}

	/*
	 * Static helper method for the "happy path" of JSON deserialization.
	 * This method should be used for the public methods when the generic JSON deserialize method
	 * may be used. Sends a HTTP requested based on method parameter.
	 */
	private Object submitRestCallAndDeserialize(String relativeUrl, Type classType, String method) {
		return submitRestCallAndDeserialize(relativeUrl, classType, method, null);
	}

	/*
	 * Static helper method for the "happy path" of JSON deserialization.
	 * This method should be used for the public methods when the generic JSON deserialize method
	 * may be used. Sends a HTTP requested based on method parameter and data.
	 */
	private Object submitRestCallAndDeserialize(String relativeUrl, Type classType, String method, Object data) {
		system.debug('#########' + data);
		HttpResponse response = submitRestCall(relativeUrl, method, data);
		String responseBody = response.getBody();
		system.debug('#########' + responseBody);
		if (responseBody != null && responseBody.length() > 0)
			return JSON.deserialize(responseBody, classType);
		return null;
	}

	/*
	 * Helper method for submitting the REST HTTP GET request.
	 *
	 * @throws ToolingAPIAuthorizationException if the remote site is not authorized.
	 */
	private HttpResponse submitRestCall(String relativeUrl) {
		return submitRestCall(relativeUrl, 'GET');
	}
	/*
	 * Helper method for submitting the REST request using the given method.
	 *
	 * @throws ToolingAPIAuthorizationException if the remote site is not authorized.
	 */
	private HttpResponse submitRestCall(String relativeUrl, String method) {
		return submitRestCall(relativeUrl, method, null);
	}

	/*
	 * Helper method for submitting the REST request using the given method and data.
	 *
	 * @throws ToolingAPIAuthorizationException if the remote site is not authorized.
	 */
	private HttpResponse submitRestCall(String relativeUrl, String method, Object data) {
		Http h = new Http();
		HttpRequest queryReq = new HttpRequest();
		queryReq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + TOOLING_API_URI + relativeUrl);
		queryReq.setHeader('Authorization', 'OAuth ' + this.sessionId);
		queryReq.setHeader('Content-Type', 'application/json');
		queryReq.setMethod(method);
		if (data != null) {
			// Custom serializer?
			if (data instanceof ISerialize) {
				ISerialize dataToserialize = (ISerialize) data;
				JSONGenerator jsonGen = JSON.createGenerator(false);
				jsonGen.writeStartObject();
				dataToserialize.serialize(jsonGen);
				jsonGen.writeEndObject();
				queryReq.setBody(jsonGen.getAsString());
			} else {
				// Standard JSON serializer emits null values,
				//    which are generally not tolerated by Tooling API
				queryReq.setBody(JSON.serialize(data));
			}
		}

		HttpResponse queryRes = null;
		try {
			queryRes = h.send(queryReq);
		} catch (System.CalloutException ce) {
			if (ce.getMessage().containsIgnoreCase('unauthorized endpoint')) {
				throw new ToolingAPIAuthorizationException(ce);
			} else {
				throw ce;
			}
		}

		Integer successCode = 200;
		if (method.equals('POST'))
			successCode = 201;
		else if (method.equals('DELETE'))
			successCode = 204;
		if (queryRes.getStatusCode() != successCode)
			if (queryRes.getBody().length() > 0)
				throw new ToolingAPIException((List<ErrorResponse>) JSON.deserialize(queryRes.getBody(), List<ErrorResponse>.class));
			else
				throw new ToolingAPIException('Unexpected HTTP Status ' + queryRes.getStatusCode());
		return queryRes;
	}

	/**
	 * Helper method for parsing query results
	 **/
	private QueryResult parseQueryResult(String jsonStr) {
		QueryResult queryResult = (QueryResult)JSON.deserialize(jsonStr, ToolingAPI.QueryResult.class);
		queryResult.records = getQueryResultRecords(jsonStr);
		return queryResult;
	}

	/**
	 * Helper method for parsing the QueryResult response and determining
	 * which instance of sObject_x to use
	 */
	private List<SObject_x> getQueryResultRecords(String jsonStr) {

		String recordType = getRecordType(jsonStr);

		if (recordType != null) {
			JSONParser parser = JSON.createParser(jsonStr);

			while (parser.nextToken() != null) {
				if ((parser.getText() == 'records')) {
					parser.nextToken();
					return (List<SObject_x>)parser.readValueAs(Type.forName('List<ToolingAPI.' + recordType + '>'));
				}
			}
		}

		return null;
	}

	/**
	 * Helper method for parsing type attribute from query result records in JSON response
	 */
	private String getRecordType(String jsonStr) {
		JSONParser parser = JSON.createParser(jsonStr);

		while (parser.nextToken() != null) {
			if ((parser.getText() == 'records')) {
				while (parser.nextToken() != null) {
					if (parser.getText() == 'attributes') {
						while (parser.nextToken() != null) {
							if (parser.getText() == 'type') {
								//Value of type attribute
								parser.nextToken();
								return parser.getText();
							}
						}
					}
				}
			}
		}
		return null;
	}
}