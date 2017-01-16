<%@page import="com.guardias.database.ConfigurationDBImpl"%>
<%@page import="com.guardias.Configuracion"%>
<%@page import="com.guardias.Util"%>

<script>

function fn_EnableMoreData(){
	
	if ($("#calendario:checked")!=null)
	{
		$("#calendario1").show();
		$("#calendario2").show();
		$("#calendario3").show();
	}
	else
	{
		$("#calendario1").hide();
		$("#calendario2").hide();
		$("#calendario3").hide();
	}
	
	
}


</script>


<% if (request.getParameter("saving")!=null) {
	
	
	Long maxiteraciones =  Long.parseLong(request.getParameter("maxiteraciones")); 
	//Long request.getParameter("bbdd")
	Long max_dias_seguidos_adjuntos =  Long.parseLong(request.getParameter("max_dias_seguidos_adjuntos"));
	Long max_dias_seguidos_residentes =  Long.parseLong(request.getParameter("max_dias_seguidos_residentes"));
	Long max_diferencia_entre_simulados_de_adjuntos =  Long.parseLong(request.getParameter("max_diferencia_entre_simulados_de_adjuntos"));
	
	
	
	String calendario ="N";  
	
	if (request.getParameter("calendario")!=null)
	{
		calendario =  "S";
	}
	
	Configuracion _oConfiguracion = new Configuracion();
	_oConfiguracion.setKey(Util.getoCONST_MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS());
	_oConfiguracion.setValue(max_dias_seguidos_residentes.toString());	
	ConfigurationDBImpl.UpdateConfiguracion(_oConfiguracion);
	
	_oConfiguracion.setKey(Util.getoCONST_NUMERO_DIAS_SEGUIDOS_ADJUNTOS());
	_oConfiguracion.setValue(max_dias_seguidos_adjuntos.toString());	
	ConfigurationDBImpl.UpdateConfiguracion(_oConfiguracion);
	
	_oConfiguracion.setKey(Util.getoCONST_DIFERENCIA_MAX_SIMULADOS_POR_ADJUNTO_MES());
	_oConfiguracion.setValue(max_diferencia_entre_simulados_de_adjuntos.toString());	
	ConfigurationDBImpl.UpdateConfiguracion(_oConfiguracion);
	
	_oConfiguracion.setKey(Util.getoCONST_MAXIMAS_ITERACIONES_PERMITIDAS());
	_oConfiguracion.setValue(maxiteraciones.toString());	
	ConfigurationDBImpl.UpdateConfiguracion(_oConfiguracion);
	
	_oConfiguracion.setKey(Util.getoCALENDARIO_GMAIL());
	_oConfiguracion.setValue(calendario);	
	ConfigurationDBImpl.UpdateConfiguracion(_oConfiguracion);
	
	
}


	Configuracion oCONST_MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS = ConfigurationDBImpl.GetConfiguration(Util.getoCONST_MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS());
	Configuracion oCONST_NUMERO_DIAS_SEGUIDOS_ADJUNTOS = ConfigurationDBImpl.GetConfiguration(Util.getoCONST_NUMERO_DIAS_SEGUIDOS_ADJUNTOS());
	Configuracion oCONST_DIFERENCIA_MAX_SIMULADOS_POR_ADJUNTO_MES = ConfigurationDBImpl.GetConfiguration(Util.getoCONST_DIFERENCIA_MAX_SIMULADOS_POR_ADJUNTO_MES());
	Configuracion oCONST_MAXIMAS_ITERACIONES_PERMITIDAS = ConfigurationDBImpl.GetConfiguration(Util.getoCONST_MAXIMAS_ITERACIONES_PERMITIDAS());
	Configuracion oCALENDARIO_GMAIL = ConfigurationDBImpl.GetConfiguration(Util.getoCALENDARIO_GMAIL());	
	//Configuracion oDATABASE_PATH = ConfigurationDBImpl.GetConfiguration(Util.oDATABASE_PATH);



%>

<form  id=fconfig method=post role="form" data-toggle="validator">

<div  id=success  class="panel panel-success" style="display:none">
       <div class="panel-heading">
          Correcto.
       </div>
		<div class="panel-body">
			<p>Los datos han sido guardados satisfactoriamente</p>
		</div>                                               
</div>

<!--  SUCCESS -->            
<div class="form-group">
<label  class="control-label"> Máximas iteraciones (En caso de embuclarse por condiciones, detectar y salir)</label>
<input maxlength="6"  required class="ui-textfield form-control" type="number" name="maxiteraciones" id="maxiteraciones"  value='<%=oCONST_MAXIMAS_ITERACIONES_PERMITIDAS.getValue() %>'/>
</div>						
<div class="form-group">
<label  class="control-label">Ruta/_Name Base Datos SqlLite </label>
<input disabled="disabled" maxlength="6"  class="ui-textfield form-control" type="text" name="bbdd" id="bbdd"  value='<%=System.getProperty("catalina.home") %>)\BBDD_sqllite\guardias.db'/>
</div>
<div class="form-group">
<label  class="control-label">Máximo Número de Días Seguidos Adjuntos (Excepto Presencia - Presencia) </label>
<input  maxlength="2" required class="ui-textfield form-control" type="number" name="max_dias_seguidos_adjuntos" id="max_dias_seguidos_adjuntos"  value='<%=oCONST_NUMERO_DIAS_SEGUIDOS_ADJUNTOS.getValue()%>'/>
</div>
<div class="form-group">
<label  class="control-label">Máximo Número de Días Seguidos Residentes (Excepto Presencia - Presencia) </label>
<input  maxlength="2"  required class="ui-textfield form-control" type="number" name="max_dias_seguidos_residentes" id="max_dias_seguidos_residentes"  value='<%=oCONST_MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS.getValue()%>'/>
</div>
<div class="form-group">
<label  class="control-label">Máxima diferencia entre simulados asignados a los adjuntos por mes </label>
<input  maxlength="2"  required class="ui-textfield form-control" type="number" name="max_diferencia_entre_simulados_de_adjuntos" id="max_diferencia_entre_simulados_de_adjuntos"  value='<%=oCONST_DIFERENCIA_MAX_SIMULADOS_POR_ADJUNTO_MES.getValue()%>'/>
</div>
<div class="form-group">
<label  class="control-label">Publicar y Sincronizar Calendario Gmail </label>
<input   class="form-control"  type="checkbox" onchange="fn_EnableMoreData()" name="calendario" id="calendario"  value="S" <%=(oCALENDARIO_GMAIL.getValue().equals("S") ? "checked" : "")%>/>
</div>
<div id="datoscalendario1" class="form-group">
<label  class="control-label">Service Account Google Name (oAuth2 autenticación)</label>
<input  maxlength="250"  class="ui-textfield form-control" type="text" name="gserviceaccount" id="gserviceaccount"  value=''/>
</div>
<div id="datoscalendario2" class="form-group">
<label  class="control-label">Enviar Recordatorio Calendario (Número de minutos antes de que ocurra,0 no se envían)</label>
<input maxlength="6"  required class="ui-textfield form-control" type="number" name="minutosrecordatorio" id="minutosrecordatorio"  value='0'/>
</div>
<div id="datoscalendario3" class="form-group">
<label  class="control-label">Ruta Fichero Clave Pública/Privada P12</label>
<input  maxlength="400"  class="ui-textfield form-control" type="text" name="ficherop12" id="ficherop12"  value=''/>
</div>

<input type="hidden" name="saving"  value='1'/>
	<button type="submit" class="btn btn-block  btn-primary">Guardar</button>
</form>

<% if (request.getParameter("saving")!=null) { %>                        
	<script>$('#success').show();</script>
<% } %>                  <!-- SUCCESS  -->
<script>$(document).ready(function() 
{
	$('#fconfig').validator();	
});</script>