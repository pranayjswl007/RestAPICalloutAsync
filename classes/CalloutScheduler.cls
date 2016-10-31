public class CalloutScheduler implements Queueable,Database.AllowsCallouts  {
    
    public void execute(QueueableContext qc){
        System.debug('User Info'+UserInfo.getSessionId());
        OAuth2 oauth=getAuthenticationToken();
        String respBody=fetchOrgLimits(oauth);
        
        //Do whatever with your response;
        
         
    }
    
    private  OAuth2 getAuthenticationToken(){
        
        //Todo move to custom settings or custom metadatatypes
		String clientId = '3MVG9Nvmjd9lcjRmEPHUUv1ObBM5ElLyvtlBZgx.dePGToAbzvE9fs4Qg2fCPG1opHRgQXnMOq5TfmggnIADw';
		String clientSecret = '8597539260781607143';
		String username='username@sf.com';
		String password='password101';


		String reqbody = 
		'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;

		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setBody(reqbody);
		req.setMethod('POST');
		req.setEndpoint('https://login.salesforce.com'+'/services/oauth2/token');//Note if my domain is set up use the proper domain name else use login.salesforce.com for prod or developer or test.salesforce.com for sandbox instance

		HttpResponse res = h.send(req);
		System.debug(res.getBody());
		OAuth2 oauth = (OAuth2)JSON.deserialize(res.getbody(), OAuth2.class);
		return oauth;

    
    }
    
    
    private String fetchOrgLimits(OAuth2 oauth){
        
      Http h1 = new Http();
      HttpRequest req1 = new HttpRequest();
      req1.setHeader('Authorization','Bearer '+oauth.access_token);
      req1.setHeader('Content-Type','application/json');
      req1.setHeader('accept','application/json');
      req1.setMethod('GET');
      req1.setEndpoint(oauth.instance_url+'/services/data/v37.0/limits');//URL will be your Salesforce REST API end point where you will do POST,PUT,DELETE orGET
      HttpResponse res1 = h1.send(req1);
      system.debug('pr res body'+String.valueOF(res1.getBody())); 
      return res1.getBody();
    
        
    }
    
    class OAuth2 {

        public String access_token;
        public String instance_url;
        public String id;
        public String token_type;
        public String issued_at;
        public String signature;
    }
    

}
