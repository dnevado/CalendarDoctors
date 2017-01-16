<%@ page language="java" contentType="text/html; charset=UTF-8"     pageEncoding="UTF-8"%>
    
<%@page import="com.guardias.*"%>
<%@page import="com.guardias.database.*"%>
<%@page import="java.util.*"%>        
<%@page import="com.google.gson.*"%>



    
<% 	
	
	Long IDMedico = Long.parseLong(request.getParameter("lastidmedico"));
    
    List<Medico> lMedico = MedicoDBImpl.getMedicos(IDMedico);
    
    Long TOTAL = MedicoDBImpl.getUltimoOrden(Util.eTipo.ADJUNTO.toString());
    Medico oMedico = lMedico.get(0);
   
    MedicoDBImpl.OrdenarSecuenciasMedicoUltimaGuardia(oMedico.getOrden(), TOTAL, Util.eTipo.ADJUNTO.toString());
	
%>
	
