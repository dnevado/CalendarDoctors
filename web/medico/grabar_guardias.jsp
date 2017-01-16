<%@ page language="java" contentType="text/html; charset=UTF-8"     pageEncoding="UTF-8"%>
    
<%@page import="com.guardias.*"%>
<%@page import="com.guardias.database.*"%>
<%@page import="java.util.*"%>        
<%@page import="com.google.gson.*"%>



    
<% 	


	/*String _Path = request.getServletContext().getRealPath("/") + "//medicos.xml";	
	ProcesarMedicos oUtilMedicos = new ProcesarMedicos();
	
   */
	String GuardiasJSON = request.getParameter("guardias");
    String Mes  = request.getParameter("MesGuardia");
	
    Guardias[] lGuardias ;
    		
    Gson gson = new GsonBuilder().create();
   
    lGuardias = gson.fromJson(GuardiasJSON, Guardias[].class); 
   
    
    for (int i=0;i<lGuardias.length;i++)
    {
    
    	
    	Guardias oGuardias = lGuardias[i];
    	/* BORRAMOS TODO EL FUTURO */
    	//GuardiasDBImpl.DeleteGuardia(oGuardias.getIdMedico(), oGuardias.getDiaGuardia());
    	GuardiasDBImpl.DeleteGuardia(new Long(-1), oGuardias.getDiaGuardia());
    	//GuardiasDBImpl.AddGuardia(oGuardias);
    	
    }
    for (int i=0;i<lGuardias.length;i++)
    {
    
    	
    	Guardias oGuardias = lGuardias[i];    	    	
    	GuardiasDBImpl.AddGuardia(oGuardias);
    	
    }
    
	out.println(lGuardias.length);	
	
	 
	
	%>
	
