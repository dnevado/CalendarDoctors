package com.guardias;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.Properties;
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
import java.util.*;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.*;
import javax.mail.internet.*;

public class Util {
		
		public static final String _COLOR_PRESENCIA = "";
		public static final String _COLOR_LOCALIZADA = "";
		public static final String _COLOR_REFUERZO = "";
		public static final String _COLOR_RESIDENTE = "";
	

		public  static final String _TITULO_EVENTO ="Guardia {TIPO}";
		public  static final String _DESCRIPCION_EVENTO ="Guardia {TIPO} {FECHA}";
		public  static final String _COLOR_EVENTO ="10";
	
	
		public final static long SECOND_MILLIS = 1000;
	    public final static long MINUTE_MILLIS = SECOND_MILLIS*60;
	    public final static long DAYS_MILLIS = MINUTE_MILLIS*60*24;
	    
	    public final static String  MIME_TYPE_SQLLITE = "application/x-sqlite3";
	    
	    
	    private final static String  RUTA_DATA_XML ="";
	    
	    
	    public  enum eTipoDia{DIARIO,FESTIVO} ;
	    public  enum eTipo{RESIDENTE,ADJUNTO} ;
	    public  enum eSubtipoResidente {R1,R2,R3,R4,R5,SIMULADO,ROTANTE} ;
	    
	    /* ESTO NOS SIRVE PARA DISTRIBUIR ENTRE EL NUMERO DE SEMANAS COMPLETAS */
	    /* PUEDE SER UN PROBLEMA QUE HAYA SEMANAS DE MENOS  DE 7 DIAS Y QUE SE DISTRIBUYAN UNIFORMEMENTE POR ESAS TB LOS RESIDENTES */ 
	    public final static int CALC_NUM_SEMANAS_MES= 4; 
	    
	    
	    public  enum eTipoGuardia {PRESENCIA,LOCALIZADA,REFUERZO,SIMULADO} ;  // PONEMOS UN CASO ESPECIAL PARA LAS GUARDOAS DE ADJUNTOS SIN RESIDENTES (SIMULADO)
	    private  static final String CALENDARIO_EMAIL_OWNER ="refundable.tech@gmail.com";
	    
	    private  static  String _EMAIL_GOOGLE_ACCOUNT_FROM ="wearyours.noreply@gmail.com";
	    private  static String _EMAIL_GOOGLE_ACCOUNT_PASSWORD ="";
	    private static String EMAIL_GOOGLE_ACCOUNT_HOST= "smtp.gmail.com";
	    
	    private static String BBDD_SQLLITE_PATH= "D:\\Program Files\\Apache Software Foundation\\Tomcat 9.0\\BBDD_sqllite\\guardias.db";
	    
	    public static String MAIL_SUBJECT = "Guardias del mes ";
	    public static String MAIL_BODY = "A continuación se incluye el calendario de guardias de ";
	    
	    public static String ENTORNO_PREFIJO_BACKUPS = "des"; // pro
	    
	    
	    
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
	    private static String oCONST_BBDD_PATH = "BBDD_SQLLITE_PATH";  // 0 cero si no se quieren.
	    
	    private static String oCONST_MAIL_FROM = "_EMAIL_GOOGLE_ACCOUNT_FROM";  // 0 cero si no se quieren.
	    private static String oCONST_MAIL_FROM_PASSWORD = "_EMAIL_GOOGLE_ACCOUNT_PASSWORD";  // 0 cero si no se quieren.
	    
	    private static String oCONST_CALENDARIO_EMAIL_OWNER = "CALENDARIO_EMAIL_OWNER";  // 0 cero si no se quieren.
	    
	    private static String oCONST_ENTORNO_PREFIJO_BACKUPS = "ENTORNO_PREFIJO_BACKUPS";  // 0 cero si no se quieren.
	    
	    
	
	
	 
	public static String getoCONST_ENTORNO_PREFIJO_BACKUPS() {
			return oCONST_ENTORNO_PREFIJO_BACKUPS;
		}


	public static String getoCONST_CALENDARIO_EMAIL_OWNER() {
			return oCONST_CALENDARIO_EMAIL_OWNER;
		}

	public static String getoCONST_BBDD_PATH() {
			return oCONST_BBDD_PATH;
		}

		public static String getoCONST_MAIL_FROM() {
			return oCONST_MAIL_FROM;
		}

		public static String getoCONST_MAIL_FROM_PASSWORD() {
			return oCONST_MAIL_FROM_PASSWORD;
		}
	public static int daysDiff( Date earlierDate, Date laterDate )
	    {
	        if( earlierDate == null || laterDate == null ) return 0;
	        
	        return (int)((laterDate.getTime()/DAYS_MILLIS) - (earlierDate.getTime()/DAYS_MILLIS));
	    }
	
 	


	

	public static void sendFromGMail(String[] to, String subject, String body, String PathToFile, String FileName ) throws IOException {
        Properties props = System.getProperties();
       
        
        _EMAIL_GOOGLE_ACCOUNT_FROM = ConfigurationDBImpl.GetConfiguration(oCONST_MAIL_FROM).getValue();
        _EMAIL_GOOGLE_ACCOUNT_PASSWORD = ConfigurationDBImpl.GetConfiguration(oCONST_MAIL_FROM_PASSWORD).getValue();
        
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", EMAIL_GOOGLE_ACCOUNT_HOST);
        props.put("mail.smtp.user", _EMAIL_GOOGLE_ACCOUNT_FROM);
        props.put("mail.smtp.password", _EMAIL_GOOGLE_ACCOUNT_PASSWORD);
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");

        Session session = Session.getDefaultInstance(props);
        MimeMessage message = new MimeMessage(session);

        try {
            message.setFrom(new InternetAddress(_EMAIL_GOOGLE_ACCOUNT_FROM));
            InternetAddress[] toAddress = new InternetAddress[to.length];

            // To get the array of addresses
            for( int i = 0; i < to.length; i++ ) {
                toAddress[i] = new InternetAddress(to[i]);
            }

            for( int i = 0; i < toAddress.length; i++) {
                message.addRecipient(Message.RecipientType.BCC, toAddress[i]);
            }
            
            message.addRecipient(Message.RecipientType.BCC, new InternetAddress(_EMAIL_GOOGLE_ACCOUNT_FROM));

            BodyPart messageBodyPart = new MimeBodyPart();

            Multipart multipart = new MimeMultipart();

            // Set text message part          

            // Part two is attachment
         /*    messageBodyPart = new MimeBodyPart();         
            DataSource source = new FileDataSource(PathToFile);
            messageBodyPart.setDataHandler(new DataHandler(source));
            messageBodyPart.setFileName(PathToFile);
            multipart.addBodyPart(messageBodyPart); */                     
            
            /*MimeBodyPart textBodyPart = new MimeBodyPart();
            textBodyPart.setText("Calendario.xls");

            MimeBodyPart attachmentBodyPart= new MimeBodyPart();
            DataSource source = new FileDataSource(PathToFile); // ex : "C:\\test.pdf"
            attachmentBodyPart.setDataHandler(new DataHandler(source));
            attachmentBodyPart.setFileName("2017-01-01.xls"); // ex : "test.pdf"

            multipart.addBodyPart(textBodyPart);  // add the text part
            multipart.addBodyPart(attachmentBodyPart); // add the attachement part
            */
            
         // Create the message body part
            

            // Fill the message
            messageBodyPart.setText(body);
            
            // Create a multipart message for attachment
           
            // Set text message part
            multipart.addBodyPart(messageBodyPart);

            // Second part is attachment
            messageBodyPart = new MimeBodyPart();
            String filename = "abc.txt";
            DataSource source = new FileDataSource(PathToFile);
            messageBodyPart.setDataHandler(new DataHandler(source));
            messageBodyPart.setFileName(FileName);
            multipart.addBodyPart(messageBodyPart);
            
            
            
            
            
            /* MimeBodyPart attachPart = new MimeBodyPart();
            String attachFile = PathToFile;
            attachPart.attachFile(attachFile);
            multipart.addBodyPart(attachPart);
            
            attachPart.setContent(message, "text/html");
            */
            // Send the complete message parts
            message.setContent(multipart);

            message.setSubject(subject);
          //  message.setText(body);
            Transport transport = session.getTransport("smtp");
            transport.connect(EMAIL_GOOGLE_ACCOUNT_HOST, _EMAIL_GOOGLE_ACCOUNT_FROM, _EMAIL_GOOGLE_ACCOUNT_PASSWORD);
            transport.sendMessage(message, message.getAllRecipients());
            transport.close();
            
            System.out.println("Sending mail " + subject );
            
        }
        catch (AddressException ae) {
            ae.printStackTrace();
        }
        catch (MessagingException me) {
            me.printStackTrace();
        }
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
