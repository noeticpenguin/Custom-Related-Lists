@isTest
public with sharing class HTTPMockCalloutFactory implements HttpCalloutMock {
	Protected Integer             code;
	Protected String              status;
	Protected String              bodyAsString;
	Protected Blob                bodyAsBlob;
	Protected Map<String, String> responseHeaders;

	/**
	 * constructor
	 * @param  code                        Numeric Response code, i.e.: 400, 200, 201 etc.
	 * @param  status                      Status Code, i.e.: Success, Not Authorized
	 * @param  body                        Response Body
	 * @param  Map<String,responseHeaders> key/value of response headers
	 * @return                             this
	 */
	public HTTPMockCalloutFactory(Integer code, String status, String body, Map<String, String> responseHeaders) {
		this.code = code;
		this.status = status;
		this.bodyAsString = body;
		this.bodyAsBlob = null;
		this.responseHeaders = responseHeaders;
	}

	/**
	 * respond fullfills the mock interface and returns a response crafted by the the constructor.
	 * @param  req httpRequest
	 * @return     this
	 */
	public HTTPResponse respond(HTTPRequest req) {
		HttpResponse res = new HttpResponse();
		res.setStatusCode(this.code);
		res.setStatus(this.status);
		res.setBody(this.bodyAsString);
		return res;
	}
}