package com.guardias.calendar;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.charset.Charset;
import java.util.Collections;
import java.util.TimeZone;

import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.services.calendar.Calendar;
import com.google.api.services.calendar.CalendarScopes;
import com.google.api.services.calendar.model.Setting;





/**
 * @author Yaniv Inbar
 */
public class CalendarService {

  /**
   * Be sure to specify the name of your application. If the application name is {@code null} or
   * blank, the application will log a warning. Suggested format is "MyCompany-ProductName/1.0".
   */
  private static final String APPLICATION_NAME = "ServiceCalendar";

  /** E-mail address of the service account. */
  private static final String SERVICE_ACCOUNT_EMAIL = "guardiasapi@guardias-155520.iam.gserviceaccount.com";

  /** Global instance of the HTTP transport. */
  private static HttpTransport httpTransport;

  /** Global instance of the JSON factory. */
  private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();


  public  Calendar configure() {
    try {
      httpTransport = new NetHttpTransport();
	// check for valid setup
	if (SERVICE_ACCOUNT_EMAIL.startsWith("Enter ")) {
	  System.err.println(SERVICE_ACCOUNT_EMAIL);
	  System.exit(1);
	}
	/* URL loc = this.getClass().getResource("/ServiceApp-13c8dce63281.p12"); 
	String path = loc.getPath(); 
	File file = new File(path);*/
	// service account credential (uncomment setServiceAccountUser for domain-wide delegation)
	
	File initialFile = new File("c:\\Guardias-718fedead1ea.json");
    InputStream targetStream = new FileInputStream(initialFile);


    JsonFactory jsonFactory = JacksonFactory.getDefaultInstance();

    HttpTransport httpTransport = GoogleNetHttpTransport.newTrustedTransport();


    //GoogleCredential credential2 = GoogleCredential.fromStream(targetStream, httpTransport, jsonFactory);
    /* GoogleCredential credential3;

    credential3 = credential2.createScoped(Collections.singleton(CalendarScopes.CALENDAR));
	
	*/
	GoogleCredential credential = new GoogleCredential.Builder()
		    .setTransport(httpTransport)
		    .setJsonFactory(JSON_FACTORY)
		    .setServiceAccountId(SERVICE_ACCOUNT_EMAIL)
		    .setServiceAccountScopes(Collections.singleton(CalendarScopes.CALENDAR))
		    .setServiceAccountPrivateKeyFromP12File(new File("c:\\Guardias-a1592342c053.p12"))		    		    
		    .build();
		
	
		
    Calendar   client3 = new com.google.api.services.calendar.Calendar.Builder(httpTransport, JSON_FACTORY, credential).setApplicationName(APPLICATION_NAME).build();
    
    /*  Calendar   client = new com.google.api.services.calendar.Calendar.Builder(
	     httpTransport, JSON_FACTORY, credential3)
	        .setApplicationName(APPLICATION_NAME).build();
     */
     
    System.out.println("Client : "+client3);
    
    
    return client3;
    } catch (Throwable t) {
      t.printStackTrace();
    }
    System.exit(1);
    return null;
  }

}  
