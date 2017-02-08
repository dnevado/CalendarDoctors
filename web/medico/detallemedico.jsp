<%@page import="com.guardias.database.MedicoDBImpl"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@page import="com.guardias.*"%>
<%@page import="com.guardias.database.*"%>
<%@page import="java.text.SimpleDateFormat"%> 
<%@page import="java.util.*"%>



<!DOCTYPE html>
<html lang="es">

<head>

<style>

/* Color of invalid field */
.has-error .control-label,
.has-error .help-block,
.has-error .form-control-feedback {
    color: #a94442;
}
</style>


	
</head>
<body>
<script>

$(document).ready(function() 
{
	$('#fmedico').validator();
	fn_EnableResidente();
});


var holidays= [];

function getday(dateText, inst) { 
   
	/* QUITAMOS O PONEMOS CLASES DE SELECCION */
	alert(dateText);
	$('#vacaciones-usage').multiDatesPicker('removeDates', dateText);
	alert(dateText);
	/* var dayWrapper = moment(dateText);
	alert(dateText + $( "#vacaciones td.ui-datepicker-current-day").hasClass("ui-state-highlight"));
	
	if (!$( "#vacaciones td.ui-datepicker-current-day").hasClass("ui-state-highlight")) 		
		$( "#vacaciones td.ui-datepicker-current-day a").attr("id","selected");
	else
		$( "#vacaciones td.ui-datepicker-current-day a").attr("id","unselected");
	
	alert($( "#vacaciones td.ui-datepicker-current-day a").attr("id"));
	
	$('#vacaciones').multiDatesPicker('removeDates', dateText);
	*/
	 /* for (var i = 0; i < holidays.length; i++) {
			
         if (holidays[i] == _dateDay) {
         	console.log(holidays[i] + "," + _dateDay);	
             return [true, 'highlight'];
         }
     }*/
   
}

function date_(){
	
	$("#vacaciones").multiDatesPicker( {dateFormat: "yy-mm-dd",  minDate: "-1M", maxDate: "+4M",
	    // Primer dia de la semana El lunes
	    firstDay: 1,
	    // Dias Largo en castellano
	    dayNames: [ "Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado" ],
	    // Dias cortos en castellano
	    dayNamesMin: [ "Do", "Lu", "Ma", "Mi", "Ju", "Vi", "Sa" ],
	    // Nombres largos de los meses en castellano
	    monthNames: [ "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre" ],
	    // Nombres de los meses en formato corto 
	    monthNamesShort: [ "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dec" ]});		
	$('#vacaciones').multiDatesPicker('addDates', holidays);
	
}



function fn_EnableResidente()
{
	if ($("#tipo").val()=='<%= Util.eTipo.RESIDENTE.toString()%>')
	{
		$("#residente").show();
		$("#labelresidente").show();
		$("#guardiassolo").hide();
		$("#labelguardiassolo").hide();
	}	
	else
	{
		$("#residente").hide();
		$("#labelresidente").hide();
		$("#guardiassolo").show();
		$("#labelguardiassolo").show();
	}    
}


var obj = {};



function _GuardarMedico()
{
	
	//$('#fmedico').validator();
	obj['ID']=$("#id").val();
	obj['IDMEDICO']=$("#idmedico").val();
	obj['nombre']= $("#nombre").val();
	obj['apellidos']=	$("#apellidos").val();
	obj['inputEmail']=	$("#inputEmail").val();
	obj['tipo']=$("#tipo").val();
	//obj['stipo']=$("#stipo").val();
	obj['residente']=$("#residente").val();
	obj['guardiassolo']="N";
	if  ($("#guardiassolo").prop('checked'))
		obj['guardiassolo']= "S";		
	obj['vacaciones']= $("#vacaciones").val();
	//obj['simulado']=$("#simulado").val();
	obj['activo']= "N";
	if  ($("#activo").prop('checked'))
		obj['activo']= "S";
//	alert($("#activo").prop('checked'));
	obj['max_guardias']=	$("#max_guardias").val();	
	obj['nuevo']=	$("#nuevo").val(); 
	obj['vacaciones']=	$('#vacaciones').multiDatesPicker('getDates');
	//alert(obj['vacaciones']);
	obj['guardar']=	"1";
						
		
	$.ajax({
		  type: "POST",
		  url: '<%=request.getContextPath()%>/medico/detallemedico.jsp',
		  data: obj,
		  success: function(data) {
			  
			  if (data.responseText.indexOf("OK")>=0)			  		
			  	$("#success").show();
			  else
				  // auth issue
				  window.location.href='<%=request.getContextPath()%>/login.jsp';
		   },
		   error: function(data) {				  				  
				  alert(data);
			   }
		});
}

</script>

<%


	String Nuevo = "N";
	if (request.getParameter("id")!=null && request.getParameter("id").equals("-1"))
		Nuevo = "S";

	
	/* String _Path = request.getServletContext().getRealPath("/") + "//medicos.xml";	
	ProcesarMedicos oUtilMedicos = new ProcesarMedicos();
	*/
	boolean saving = false;
	boolean newMedico = false;
	if (request.getParameter("guardar") !=null)
			saving = true;
 
	if (request.getParameter("nuevo") !=null && request.getParameter("nuevo").equals("S"))
		newMedico=true;
	
	if (saving) 
	{
		
		Medico _NuevoMedico = new Medico();
		
		
		
		String ID = request.getParameter("ID");
		String IDMEDICO = request.getParameter("IDMEDICO");
		String nombre = request.getParameter("nombre");
		String apellidos = request.getParameter("apellidos");
		Util.eTipo tipo = Util.eTipo.ADJUNTO; 
		String inputEmail = request.getParameter("inputEmail");
		String  Max_Num_Guardias= request.getParameter("max_guardias");
		String[] aVacaciones = request.getParameterValues("vacaciones[]");
		
		
		if (request.getParameter("tipo")!=null && request.getParameter("tipo").toString().equals(Util.eTipo.RESIDENTE.toString()))
			tipo = Util.eTipo.RESIDENTE;
		
		Util.eSubtipoResidente stipo     = Util.eSubtipoResidente.R1;		
		if (request.getParameter("residente")!=null && request.getParameter("residente")!=null)
			stipo =Util.eSubtipoResidente.valueOf(request.getParameter("residente"));
		
		//String residente = request.getParameter("residente");
		Boolean guardiassolo = request.getParameter("guardiassolo")!=null && request.getParameter("guardiassolo").toString().equals("S") ? new Boolean(true) :  new Boolean(false);
		String  vacaciones = request.getParameter("vacaciones");	
		Boolean activo = request.getParameter("activo")!=null && request.getParameter("activo").toString().equals("S") ? new Boolean(true) :  new Boolean(false);
					
		_NuevoMedico.setActivo(activo);
		_NuevoMedico.setNombre(nombre);
		_NuevoMedico.setApellidos(apellidos);
		_NuevoMedico.setGuardiaSolo(guardiassolo);
		//_NuevoMedico.setID(new Long(ID));
		_NuevoMedico.setIDMEDICO(new Long(IDMEDICO));
		//_NuevoMedico.setlGuardias(lGuardias);
		//_NuevoMedico.setlVacaciones(lVacaciones);
				
		_NuevoMedico.setSubTipoResidente(stipo);
		_NuevoMedico.setTipo(tipo);
		_NuevoMedico.setEmail(inputEmail);
		_NuevoMedico.setMax_NUM_Guardias(Long.valueOf(Max_Num_Guardias));
		
		
		 
		
		if (newMedico)
		{
			MedicoDBImpl.AddMedico(_NuevoMedico);		
			Medico ThisMedico = MedicoDBImpl.getUltimoIDMedico();
			
			ID=ThisMedico.getID().toString();
			
		}
		else
		{
			_NuevoMedico.setID(Long.parseLong(ID));
			MedicoDBImpl.UpdateMedico(Long.parseLong(ID), _NuevoMedico);
		}
		/* VACACIONES */
		/* COGEMOS EL DIA ACTUAL Y BORRAMOS HACIA ADELANTE */
		/* OJO, PARA LAS VACACIONES, AL SER FUTURAS, BORRAMOS CADA REGISTRO PREVIO QUE HUBIERA EN EL FUTURO, DEL MES EN CURSO Y DEL SGTE */
		/* vamos a borrar vacaciones del mes actual */
		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		
		Date _Hoy = new Date();
		_Hoy.setDate(1);// desde el dia uno
		
		String  _MesMenorVacaciones = formatter.format(_Hoy); 
		
		if (aVacaciones!=null)
		{
			for (int j=0;j<aVacaciones.length;j++)
			{
							
				String DiaVacaciones = aVacaciones[j];
				if (_MesMenorVacaciones.equals(""))
					_MesMenorVacaciones = DiaVacaciones;
				
				if (_MesMenorVacaciones.compareTo(DiaVacaciones)>0)
					_MesMenorVacaciones = DiaVacaciones;
				
				
			}
		}
		
		/* BORRAMOS DESDE EL MES */
			
		VacacionesDBImpl.DeleteVacacionesMedicoDesde(new Long(ID), _MesMenorVacaciones );
		
		if (aVacaciones!=null)
		{
			for (int j=0;j<aVacaciones.length;j++)
			{					
				String DiaVacaciones = aVacaciones[j];
				
				VacacionesDBImpl.AddVacacionesMedico(new Long(ID), DiaVacaciones);
				
				
			}
		
		}
			
		
		 //oUtilMedicos.GrabarMedico(_Path,"s", _NuevoMedico);
		 
		 
		 
		 
		 out.print("OK");
		 		 		 
		 		 		
	}
	else	
	{
	
	

	Long _ID = new Long(-1);
	if (request.getParameter("id") !=null)
		_ID = Long.parseLong(request.getParameter("id"));
	
	List<Medico> _lMedicos =null;
	Medico _oMedico = null;
	List<Vacaciones_Medicos> _lVacaciones = null;
	if (!_ID.equals(new Long(-1)))
	{
		_lMedicos = MedicoDBImpl.getMedicos(_ID);	
		if (_lMedicos!=null && _lMedicos.size()>0)		
			_oMedico = _lMedicos.get(0);
		
		
		_lVacaciones = VacacionesDBImpl.getVacacionesMedicos(new Long(_ID), ""); 
		
	}
	else
		_oMedico = new Medico();
	
		
	//Medico _oMedico = oUtilMedicos.LeerMedico(_Path,_ID.toString());
	
		
%>
<div id="wrapper">
	<!-- /.row -->
    <div class="row">
    	<div class="col-lg-12">
	        <div class="panel panel-default">	
    	     	<div class="panel-heading">
        	     	Detalle Médico
         		</div>
				 <div class="panel-body">
				<form  id=fmedico method=post role="form" data-toggle="validator" onsubmit="return _GuardarMedico()">                                        						
                        <!-- SUCCESS  -->
						<div  id=success  class="alert alert-success" style="display:none">
                        <div class="panel-heading"></div>
                        <div class="panel-body">
                            <p>Los datos han sido guardados satisfactoriamente</p>
                        </div>                                               
                    	</div> 
						<!--  SUCCESS -->            
						<div class="form-group">
						<label  class="control-label">Id Médico:</label>
						<input   type="number" required maxlength="6"  class="ui-textfield form-control" type="text" name="idmedico" id="idmedico"  value='<%=_oMedico.getIDMEDICO()%>'/>						
						</div>						
						<div class="form-group">
						<label  class="control-label" >Nombre:</label>
						<input   maxlength="25" required class="ui-textfield form-control" type="text" name="nombre" id="nombre"  value='<%=_oMedico.getNombre() !=null ? _oMedico.getNombre()  : ""%>'/>
						</div>
						<div class="form-group">
						<label  class="control-label">Apellidos:</label>
						<input    maxlength="25" required class="ui-textfield form-control" type="text" name="apellidos"  id="apellidos" value='<%=_oMedico.getApellidos() !=null ? _oMedico.getApellidos()  : ""%>'/>
						</div>
						<div class="form-group">
						<label  class="control-label">Max Guardias Mes:</label>
						<input type="number" required maxlength="2" class="ui-textfield form-control" type="text" name="max_guardias"  id="max_guardias" value='<%=_oMedico.getMax_NUM_Guardias()%>'/>
						</div>
						<div class="form-group">
						<label  class="control-label">Tipo:</label>
						<select required class="form-control ui-select" name="tipo" id="tipo" onChange="fn_EnableResidente()">
							<option <%=_oMedico.getTipo().equals(Util.eTipo.ADJUNTO) ? "selected" : ""%> value="<%=Util.eTipo.ADJUNTO %>"><%=Util.eTipo.ADJUNTO%></option>
							<option <%=_oMedico.getTipo().equals(Util.eTipo.RESIDENTE) ? "selected" : ""%> value="<%=Util.eTipo.RESIDENTE %>"><%=Util.eTipo.RESIDENTE %></option>
						</select>						
						</div>
						<div class="form-group">
						    <label  class="control-label" for="inputEmail" class="control-label">Email</label>
						    <input type="email" class="form-control" id="inputEmail" placeholder="Email" value="<%=_oMedico.getEmail()%>" data-error="Bruh, that email address is invalid" required>						    
					    </div>																								
						<div class="form-group">
						<label  class="control-label" id="labelresidente">Residente:</label>
						<select class="form-control ui-select" name="residente" id="residente">
							<option <%=_oMedico.getSubTipoResidente().equals(Util.eSubtipoResidente.R1) ? "selected" : ""%> value="<%=Util.eSubtipoResidente.R1%>"><%=Util.eSubtipoResidente.R1%></option>
							  <option <%=_oMedico.getSubTipoResidente().equals(Util.eSubtipoResidente.R2) ? "selected" : ""%> value="<%=Util.eSubtipoResidente.R2%>"><%=Util.eSubtipoResidente.R2%></option>
							  <option <%=_oMedico.getSubTipoResidente().equals(Util.eSubtipoResidente.R3) ? "selected" : ""%> value="<%=Util.eSubtipoResidente.R3%>"><%=Util.eSubtipoResidente.R3%></option>
							  <option <%=_oMedico.getSubTipoResidente().equals(Util.eSubtipoResidente.R4) ? "selected" : ""%> value="<%=Util.eSubtipoResidente.R4%>"><%=Util.eSubtipoResidente.R4%></option>
							  <option <%=_oMedico.getSubTipoResidente().equals(Util.eSubtipoResidente.R5) ? "selected" : ""%> value="<%=Util.eSubtipoResidente.R5%>"><%=Util.eSubtipoResidente.R5%></option>
							  <option <%=_oMedico.getSubTipoResidente().equals(Util.eSubtipoResidente.ROTANTE) ? "selected" : ""%> value="<%=Util.eSubtipoResidente.ROTANTE%>"><%=Util.eSubtipoResidente.ROTANTE%></option>
							  <option <%=_oMedico.getSubTipoResidente().equals(Util.eSubtipoResidente.SIMULADO) ? "selected" : ""%> value="<%=Util.eSubtipoResidente.SIMULADO%>"><%=Util.eSubtipoResidente.SIMULADO%></option>					  
						</select>						
						</div>												
						<% 			
						String _selected ="";
						if (_oMedico.isGuardiaSolo())
							_selected="checked";
						
						%>
						<div class="form-group">
							<label  class="control-label" id="labelguardiassolo">Guardias Solo:</label>
							<input <%=_selected%> type="checkbox" name="guardiassolo"  id ="guardiassolo" value='<%=_oMedico.isGuardiaSolo()%>'/>
						</div>	
						<% _selected=""; 
						if (_oMedico.isActivo())
							_selected="checked";
						
						%>
						<div class="form-group">
							<label  class="control-label" >Activo:</label>
							<input <%=_selected%> type="checkbox" <%=_selected %> name="activo" id="activo" value='<%=_oMedico.isActivo()%>'/>
						</div>					
						<div class="form-group">
							<label  class="control-label"></label>
							<div id="vacaciones"></div>
							<script>
							<% 
							
							if (_lVacaciones!=null && _lVacaciones.size()>0)
							{
								for (int j=0;j<_lVacaciones.size();j++)
								{															
									Vacaciones_Medicos oVacaciones = _lVacaciones.get(j);
									%>
									holidays[<%=j%>] = '<%=oVacaciones.getDiaVacaciones()%>';
								<%																								
								}
							}
							%>
							</script>
							 <button type="button" onclick="date_()" class="pull-center btn btn-outline btn-success">Vacaciones</button>							 							  							
						</div>						
						
																	
						<input type="hidden" name="guardar"  value='1'/>
						<input type="hidden" name="id" id="id" value='<%=_oMedico.getID()%>'/>	
						<input type="hidden" name="pid" id="pid" value='<%=_ID%>'/>
						<input type="hidden" name="nuevo" id="nuevo" value='<%=Nuevo%>'/>
						
						<div class="form-group">
    							<button type="submit" class="btn btn-block  btn-primary">Guardar</button>
  						</div>				
						</form>
		</div>
	</div>
	</div>
</div>
</div>
	<%  }  %>

</body>
</html>