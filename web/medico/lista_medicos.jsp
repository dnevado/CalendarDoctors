<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@page import="com.guardias.*"%>
<%@page import="com.guardias.database.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>

<jsp:useBean id="MedicoLogged" class="com.guardias.Medico" scope="session"/>


<script>

var _DoctorTableList;



function fn_callOrdenDoctorList() {
	//Return a helper with preserved width of cells	
	var fixHelper = function(e, ui) {  
		  ui.children().each(function() {  
		    $(this).width($(this).width());  
		  });  
		  return ui;  
		};
	
	$( "#doctor_list tbody" ).sortable({
	    axis: 'y',
	    helper: fixHelper,
	    update: function (event, ui) {
	        var data = $("#doctor_list tbody").sortable('serialize');
	    //    alert(data);
	        alert("Elemento reordenado satisfactoriamente");
	        
	        // POST to server using $.post or $.ajax
	        $.ajax({
	            data: data,
	            type: 'POST',
	            url: '<%=request.getContextPath()%>/medico/medico_orden.jsp',
	        });
	        
	        
	    }
	});
	
	$( "#doctor_list tbody" ).disableSelection();
} 



 $( document ).ready(function() {			
	 fn_callOrdenDoctorList();
	 _DoctorTableList=$("#doctor_list").DataTable( {
		    responsive: true
	 } );
}); 

</script>

 <div class="row">
<div class="col-lg-12 form-group">
        <button onclick="EditarMedico(-1)" type="button" class="pull-right btn btn-outline btn-warning">Nuevo</button>                    
</div>
</div>	
	
<table id="doctor_list" class="table responsive table-bordered table-hover table-striped"  style="width: 100%;"  role="grid">
<thead>
    <tr>
    	<th>#</th>
        <th>Ident.</th>
        <th>Nombre Apellidos</th>               
        <th>Email</th>
        <th title=" Máximas Guardias">G</th>
        <th title=" Confirmado">C</th>
        <th></th>
        <th title=" Activo">A</th>
        <th title=" Vacaciones">Vacaciones</th>       
    </tr>
</thead>
<tbody>
<%
	
	List<Medico> lItems = new ArrayList<Medico>();
	
	String _Path = request.getServletContext().getRealPath("/") + "//medicos.xml";
	
//	System.out.println(_Path);
	
	

	ProcesarMedicos oUtilMedicos = new ProcesarMedicos();
	
	
	//lItems = oUtilMedicos.LeerMedicos(_Path,true);
	lItems =  MedicoDBImpl.getMedicos(new Long(-1),MedicoLogged.getServicioId());
	
	//lItems =
	Calendar c_ = Calendar.getInstance();
	//SimpleDateFormat _df = new SimpleDateFormat("yyyy-MM-dd");
	DateFormat _format = new SimpleDateFormat("yyyy-MM-dd");
	
	c_.add(Calendar.MONTH, 1);
	c_.set(Calendar.DAY_OF_MONTH, 1);
	
	
	
	String _fINICIO = _format.format(c_.getTime());
	c_.add(Calendar.MONTH, 5);
	String _fFIN = _format.format(c_.getTime());
	
	
	for (int j=0;j<lItems.size();j++)
	{
		
		String _RowColor= "";
		
		
		Medico oMedico = lItems.get(j);
		
		if (oMedico.getActivoServicio().equals(new Long(0)))
				_RowColor = "red";
		
	   	List<Vacaciones_Medicos> lVacaciones = VacacionesDBImpl.getMesesVacacionesMedicosDesdeHasta(oMedico.getID(), _fINICIO, _fFIN);
		
	%>
	
	   <!--  <a href="#" class="list-group-item">
			                                    <i class="fa fa-money fa-fw"></i> Payment Received
			                                    <span class="pull-right text-muted small"><em>Yesterday</em>
			                                    </span>
			                                </a> -->
	
	   
    <tr onclick="EditarMedico(<%=oMedico.getID()%>)" class="ui-state-default <%=_RowColor%>"  id="id_<%=oMedico.getID()%>_medico">
    <td><%=oMedico.getOrden()%></td>    
    <td><%=oMedico.getIDMEDICO()%></td>
    <td><%=oMedico.getNombre()%> <%=oMedico.getApellidos()%></td>
    <td><%=oMedico.getEmail()%></td>
    <td><%=oMedico.getMax_NUM_Guardias()%></td>
    <td><%=oMedico.isConfirmado() ? 'S' : 'N'%></td>
    <td><%=oMedico.getTipo()%></td>
    <td><%=oMedico.getActivoServicio().equals(new Long(1)) ? 'S' : 'N'%></td>
    <td>
    <%
    	if (lVacaciones!=null && !lVacaciones.isEmpty())
    	{
    	   int jV=0;	
    	   for (Vacaciones_Medicos oVacaciones : lVacaciones) 
    	   {
    		  /*  Calendar cVacaciones= Calendar.getInstance();
    		   cVacaciones.setTimeInMillis(_format.parse(oVacaciones.getDiaVacaciones()).getTime()); */    		   
    		   String _Mes = Util.MonthText(Integer.parseInt(oVacaciones.getDiaVacaciones()));    	 	  
    	   %>
    	    
    	    <div class="checkbox"><input disabled="disabled" id="checkvacaciones_<%=oMedico.getID()%>_<%=jV%>" type="checkbox" value="<%= _Mes%>" checked/>
    	    <label for="checkvacaciones_<%=oMedico.getID()%>_<%=j%>"><%=_Mes%></label></div>    		        		
    	<%  jV++;
    		}
    	 	
        }
    
    %>
    
    </td>
    </tr>
    </a>   
    
		
	<% }
	%>	
	</tbody>
</table>
	<!--  <div id="editarmedico"  title="Datos del Médico"></div>-->