<%@ page language="java" contentType="text/html; charset=UTF-8"     pageEncoding="UTF-8"%>

<%@page import="com.guardias.cambios.*"%>    
<%@page import="com.guardias.*"%>
<%@page import="com.guardias.calendar.*"%>
<%@page import="com.guardias.database.*"%>
<%@page import="java.util.*"%>

<%@page import="com.guardias.database.GuardiasDBImpl"%>
<%@page import="com.guardias.database.MedicoDBImpl"%>
<%@page import="com.guardias.database.ConfigurationDBImpl"%>

<%@page import="java.util.*"%>

<%@page import="java.util.Calendar"%>
<%@page import="java.text.*"%>
<%@page import="com.guardias.*"%>
<%@page import="com.guardias.*"%>
<%@page import="java.util.*"%>
<%@page import="java.util.Map.*"%>

<jsp:useBean id="MedicoLogged" class="com.guardias.Medico" scope="session"/>



        
    
<%

Util.eEstadoCambiosGuardias _oNewState = Util.eEstadoCambiosGuardias.valueOf(request.getParameter("newstate"));


Integer _IDCambioGuardia = new Integer(-1);
Util.eTipoCambiosGuardias  _cType = Util.eTipoCambiosGuardias.CAMBIO;
if (request.getParameter("cambioid")!=null)
	_IDCambioGuardia = Integer.parseInt(request.getParameter("cambioid"));
if (request.getParameter("type")!=null)
	_cType = Util.eTipoCambiosGuardias.valueOf(request.getParameter("type"));


CambiosGuardias _oCambio = CambiosGuardiasDBImpl.getCambioGuardiasById(_IDCambioGuardia);

Medico _oMedicoSolicitante = MedicoDBImpl.getMedicos(_oCambio.getIdMedicoSolicitante()).get(0);

/* MEDICOS POR TIPO QUE HAGAN GUARDIA EN EL DIA FIN */
List<Guardias> _lGuardiasDiaDestino =  GuardiasDBImpl.getGuardiasEntreFechas(_oCambio.getFechaFinCambio(), _oCambio.getFechaFinCambio());

if (_lGuardiasDiaDestino!=null && _lGuardiasDiaDestino.size()>0)
{
%>

<form id="fmedicos" method="post" role="form" data-toggle="validator" onsubmit="return _saveChangeOnCall()"  novalidate="true">                                     						
<!-- SUCCESS  -->
<div id="success" class="alert alert-success" style="display:none">
<div class="panel-body">
    <p>Los datos han sido guardados satisfactoriamente</p>
</div>                                               
</div> 
<!--  SUCCESS -->
<div  id=error  class="alert alert-danger" style="display:none">   
   <div class="panel-body">
       <p>Se ha producido un error. Contacte con el administrador</p>
   </div>                                               
</div>             
																
<div class="form-group">
<label class="control-label" id="type">Tipo:</label>
<input disabled type="text"  value="<%=_cType%>"/>
</div>							
<div class="form-group">
<label class="control-label" id="labelresidente">Elige quién será asignado:</label>
<select class="form-control ui-select" name="medico" id="medico">
<%	for (Guardias oGuardia : _lGuardiasDiaDestino)  // quitamos el medico que lo solicito
	{
		
		Medico oMedico = MedicoDBImpl.getMedicos(oGuardia.getIdMedico()).get(0);
		
		// activo , del mismo tipo y que no sea el mismo */
		if (!oMedico.getID().equals(_oMedicoSolicitante.getID()) && oMedico.isActivo() && oMedico.getTipo().equals(_oMedicoSolicitante.getTipo()))
		{
			String _NombreMedico = oMedico.getNombre().concat(" ").concat(oMedico.getApellidos());							
		%>
		
			<option value="<%=oMedico.getID()%>"><%= _NombreMedico%></option>			
		<%
		}
	}	%>					 
</select>						
</div>												
<div class="form-group">
		<button type="submit" class="btn btn-block  btn-primary">Guardar</button>
	</div>				
</form>
<%  } %>

<script>

function _saveChangeOnCall()
{

	_changeState ('<%=_oNewState%>', <%=_IDCambioGuardia%>,$("#medico").val(),'<%=_cType%>');
	return false;
}

</script>
	
