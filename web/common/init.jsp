<%@ page language="java" contentType="text/html; charset=UTF-8"     pageEncoding="UTF-8"%> 
<%@page import="com.guardias.database.MedicoDBImpl"%>
    
<%@page import="com.guardias.*"%>
<%@page import="com.guardias.database.*"%>
<%@page import="java.text.SimpleDateFormat"%> 
<%@page import="java.util.*"%>
 
 
 <%
  String UserLogged = (String) request.getSession().getAttribute("User");

  Medico MedicoLogged = MedicoDBImpl.getMedicoByEmail(UserLogged);
  
  request.setAttribute("MedicoLogged", MedicoLogged);
 
 %>
      