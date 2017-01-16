package com.guardias;

import java.io.File;
import java.io.InputStream;
import java.net.URL;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.ResourceBundle;

import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.util.DateTime;
import com.google.api.services.calendar.CalendarScopes;
import com.google.api.services.calendar.model.Calendar;
import com.google.api.services.calendar.model.Event;
import com.google.api.services.calendar.model.EventAttendee;
import com.google.api.services.calendar.model.EventDateTime;
import com.google.api.services.calendar.model.EventReminder;
import com.guardias.database.ConfigurationDBImpl;


public class Util {


		public final static long SECOND_MILLIS = 1000;
	    public final static long MINUTE_MILLIS = SECOND_MILLIS*60;
	    public final static long DAYS_MILLIS = MINUTE_MILLIS*60*24;
	    
	    private final static String  RUTA_DATA_XML ="";
	    public  enum eTipo{RESIDENTE,ADJUNTO} ;
	    public  enum eSubtipoResidente {R1,R2,R3,R4,R5,SIMULADO,ROTANTE} ;
	    
	    
	    
	    
	    public  enum eTipoGuardia {PRESENCIA,LOCALIZADA,REFUERZO} ; 
	    
	    
	    private  static Long MAX_NUMERO_DIAS_SEGUIDOS_ADJUNTOS_VALUE = new Long(2);  // EXCEPTO PRESENCIA - PRESENCIA
	    private static Long MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTES_VALUE = new Long(1); // EXCEPTO PRESENCIA - PRESENCIA
	    
	    private static Long DIFERENCIA_MAX_SIMULADOS_POR_ADJUNTO_MES_VALUE = new Long(1); // DIFERENCIA ASUMIBLE DE SIMULADOS ENTRE ADJUNTOS, PARA QUE NO SEA MUY 
	    
	    private static Long MAXIMAS_ITERACIONES_PERMITIDAS_VALUE = new Long(1); // DIFERENCIA ASUMIBLE DE SIMULADOS ENTRE ADJUNTOS, PARA QUE NO SEA MUY
	    
	    /*
	    private static String   PUBLICAR_CALENDARIO_GMAIL_VALUE = ""; // S/N
	    private static String  GOOGLE_SERVICE_ACCOUNT_VALUE = "GOOGLE_SERVICE_ACCOUNT";
	    private static String  CALENDARIO_FICHERO_P12_RUTA_VALUE = "CALENDARIO_FICHERO_P12_RUTA";
	    private static Long   CALENDARIO_MINUTOS_RECORDATORIO_VALUE = new Long(0);
	    
	    */
	    // MECANICA LA ASIGNACION DE RESIDENTES SIMULADOS NI PREVISORA
	    
	    
	    private static String oCONST_NUMERO_DIAS_SEGUIDOS_ADJUNTOS = "CONST_MAX_NUMERO_DIAS_SEGUIDOS_ADJUNTOS";
	    private static String oCONST_MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS = "CONST_MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTES";
	    private static String oCONST_DIFERENCIA_MAX_SIMULADOS_POR_ADJUNTO_MES = "CONST_DIFERENCIA_MAX_SIMULADOS_POR_ADJUNTO_MES";
	    private static String oCONST_MAXIMAS_ITERACIONES_PERMITIDAS = "CONST_MAXIMAS_ITERACIONES_PERMITIDAS";
	    private static String oCONST_CALENDARIO_GMAIL = "PUBLICAR_CALENDARIO_GMAIL";	    
	    private static String oCONST_GOOGLE_SERVICE_ACCOUNT = "GOOGLE_SERVICE_ACCOUNT";
	    private static String oCONST_CALENDARIO_FICHERO_P12_RUTA = "CALENDARIO_FICHERO_P12_RUTA";
	    private static String oCONST_CALENDARIO_MINUTOS_RECORDATORIO = "CALENDARIO_MINUTOS_RECORDATORIO";  // 0 cero si no se quieren.
	    private static String oCONST__SERVICE_CALENDAR = "ServiceCalendar";  // 0 cero si no se quieren.
	    
	    
	    
	    
	    


	 
	public static int daysDiff( Date earlierDate, Date laterDate )
	    {
	        if( earlierDate == null || laterDate == null ) return 0;
	        
	        return (int)((laterDate.getTime()/DAYS_MILLIS) - (earlierDate.getTime()/DAYS_MILLIS));
	    }
	 
	 	







	public static String getoCONST_NUMERO_DIAS_SEGUIDOS_ADJUNTOS() {
		return oCONST_NUMERO_DIAS_SEGUIDOS_ADJUNTOS;
	}


	public static String getoCONST_MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS() {
		return oCONST_MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS;
	}




	public static String getoCONST_DIFERENCIA_MAX_SIMULADOS_POR_ADJUNTO_MES() {
		return oCONST_DIFERENCIA_MAX_SIMULADOS_POR_ADJUNTO_MES;
	}



	public static String getoCONST_MAXIMAS_ITERACIONES_PERMITIDAS() {
		return oCONST_MAXIMAS_ITERACIONES_PERMITIDAS;
	}



	public static String getoCALENDARIO_GMAIL() {
		return oCONST_CALENDARIO_GMAIL;
	}




	public static String getoCONST_GOOGLE_SERVICE_ACCOUNT() {
		return oCONST_GOOGLE_SERVICE_ACCOUNT;
	}


	public static String getoCONST_CALENDARIO_FICHERO_P12_RUTA() {
		return oCONST_CALENDARIO_FICHERO_P12_RUTA;
	}



	public static String getoCONST_CALENDARIO_MINUTOS_RECORDATORIO() {
		return oCONST_CALENDARIO_MINUTOS_RECORDATORIO;
	}



	public static String getoCONST__SERVICE_CALENDAR() {
		return oCONST__SERVICE_CALENDAR;
	}






	public static void main(String[] args) {}
		 
	
}
