import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import com.google.api.client.util.DateTime;



import com.google.api.services.calendar.model.AclRule.Scope;
import com.sun.xml.internal.ws.message.EmptyMessageImpl;
import com.google.api.services.calendar.Calendar;
import com.google.api.services.calendar.Calendar.Calendars;
import com.google.api.services.calendar.model.Events;
import com.guardias.Util;
import com.google.api.services.calendar.model.Event;
import com.google.api.services.calendar.model.EventAttendee;
import com.google.api.services.calendar.model.EventDateTime;
import com.google.api.services.calendar.model.EventReminder;
import com.google.api.services.calendar.model.AclRule;
import com.google.api.services.calendar.model.CalendarList;
import com.google.api.services.calendar.model.CalendarListEntry;


import com.google.api.services.calendar.model.Colors;
import com.google.api.services.calendar.model.ColorDefinition;


public class CalendarEventUtil_novale {

	Calendar service =null;
	
	String _EMAIL_GOOGLE_ACCOUNT = Util._EMAIL_GOOGLE_ACCOUNT;
	
	
	
	public Event  CreateEvent(String Titulo, String Descripcion,String color,  java.util.Calendar Inicio,  java.util.Calendar Fin) throws IOException {
	
		Event event = new Event();
        String pageToken = null;
        
        service = new CalendarService_novale().configure();
        
        event.setSummary(Titulo);
        event.setLocation("No localización");
        event.setDescription(Descripcion);
        
        event.setColorId(color);
        
        java.util.Calendar startCal = java.util.Calendar.getInstance();        
        Date startDate = Inicio.getTime();

        java.util.Calendar endCal = java.util.Calendar.getInstance();      
        Date endDate = Fin.getTime();


        DateTime start = new DateTime(startDate);
        event.setStart(new EventDateTime().setDateTime(start));
        DateTime end = new DateTime(endDate);
        event.setEnd(new EventDateTime().setDateTime(end));
        
		
        return event;
        
	}
	
	public void  SendEvent(Event ev) throws IOException {
		
		SendEvent(ev, new ArrayList<String>());
	}
	
	public void  SendEvent(Event ev, List<String> EmailAddress) throws IOException {
		
		boolean bSendNotifications=false;
		if (EmailAddress!=null && EmailAddress.size()>0)
		{
		
			ArrayList<EventAttendee> attendees = new ArrayList<EventAttendee>();
	        
			for (String Email : EmailAddress)
			{
				attendees.add(new EventAttendee().setEmail(Email));
			}
			
	        ev.setAttendees(attendees);
	        
	        bSendNotifications = true;
        
		}
	        
        //Create access rule with associated scope
        AclRule rule = new AclRule();
        
        Scope scope = new Scope();
        scope.setType("user").setValue(_EMAIL_GOOGLE_ACCOUNT);
        rule.setScope(scope).setRole("owner");

        // Insert new access rule
        
        if (bSendNotifications)
        	service.events().insert("primary", ev).setSendNotifications(true).execute();
        else
        	service.events().insert("primary", ev).execute();
        
        service.acl().insert("primary", rule).execute();
        
		
	}
    public Event  SetRemainder(Event ev, Long MinutesBefore) throws IOException {
    	
    	EventReminder[] reminderOverrides = new EventReminder[] {
        	    new EventReminder().setMethod("email").setMinutes(MinutesBefore.intValue()),
        	//    new EventReminder().setMethod("popup").setMinutes(10),
        	};
        Event.Reminders reminders = new Event.Reminders()
        	    .setUseDefault(false)
        	    .setOverrides(Arrays.asList(reminderOverrides));
        
        ev.setReminders(reminders);
		
        return ev;
	}
	
 

    public static void main(String[] args) throws IOException {
        // TODO Auto-generated method stub
        Event event = new Event();
        Calendar service =null;
        String pageToken = null;
        
        service = new CalendarService_novale().configure();
             
                
        do {
          CalendarList calendarList = service.calendarList().list().setPageToken(pageToken).execute();
          List<CalendarListEntry> items = calendarList.getItems();

          for (CalendarListEntry calendarListEntry : items) {
            System.out.println(calendarListEntry.getSummary());
          }
          pageToken = calendarList.getNextPageToken();
        } while (pageToken != null);
        
        
        
        
         do {
        	  com.google.api.services.calendar.model.Events events = service.events().list("primary").setPageToken(pageToken).execute();
        	  java.util.List<Event> items = events.getItems();
        	  for (Event event1 : items) {
        	    System.out.println(event1.getSummary());
        	  }
        	  pageToken = events.getNextPageToken();
        	} while (pageToken != null);

        event.setSummary("Guardia Dia 14 Febrero Presencia");
        event.setLocation("ES");
        event.setDescription("Guardia Dia 14 Febrero Presencia");
        
        EventReminder[] reminderOverrides = new EventReminder[] {
        	    new EventReminder().setMethod("email").setMinutes(24 * 60),
        	//    new EventReminder().setMethod("popup").setMinutes(10),
        	};
        Event.Reminders reminders = new Event.Reminders()
        	    .setUseDefault(false)
        	    .setOverrides(Arrays.asList(reminderOverrides));
        
        event.setReminders(reminders);
        
        
        Colors colors  = service.colors().get().execute();
        // Print available event colors
        for (Map.Entry<String, ColorDefinition> color : colors.getEvent().entrySet()) {
          System.out.println("ColorId : " + color.getKey());
          System.out.println("  Background: " + color.getValue().getBackground());
          System.out.println("  Foreground: " + color.getValue().getForeground());
          
          event.setColorId("5");
        }
        
       
        
        

        ArrayList<EventAttendee> attendees = new ArrayList<EventAttendee>();
        
        attendees.add(new EventAttendee().setEmail("dnevado@gmail.com"));
        //attendees.add(new EventAttendee().setEmail("ana.maria.castano.leon@gmail.com"));
        
        // ...
        event.setAttendees(attendees);


        // set the number of days
        java.util.Calendar startCal = java.util.Calendar.getInstance();
        startCal.set(java.util.Calendar.MONTH, 1);
        startCal.set(java.util.Calendar.DATE, 16);
        startCal.set(java.util.Calendar.HOUR_OF_DAY, 20);
        startCal.set(java.util.Calendar.MINUTE, 0);
        Date startDate = startCal.getTime();

        java.util.Calendar endCal = java.util.Calendar.getInstance();
        endCal.set(java.util.Calendar.MONTH, 1);
        endCal.set(java.util.Calendar.DATE, 16);
        endCal.set(java.util.Calendar.HOUR_OF_DAY, 20);
        endCal.set(java.util.Calendar.MINUTE, 0);
        Date endDate = endCal.getTime();


        DateTime start = new DateTime(startDate);
        event.setStart(new EventDateTime().setDateTime(start));
        DateTime end = new DateTime(endDate);
        event.setEnd(new EventDateTime().setDateTime(end));

        // Create access rule with associated scope
        AclRule rule = new AclRule();
        
        Scope scope = new Scope();
        scope.setType("user").setValue("refundable.tech@gmail.com");
        rule.setScope(scope).setRole("owner");

        // Insert new access rule
        
        
        Event createdEvent = service.events().insert("primary", event).setSendNotifications(true).execute();
        
        AclRule createdRule = service.acl().insert("primary", rule).execute();

        System.out.println("Data is :"+createdEvent.getId() + "," + createdEvent.getStart()); 
    }
}  