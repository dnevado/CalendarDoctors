<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@page import="com.guardias.*"%>
<%@page import="java.util.*"%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Distribución Guardias Médicos Inicio </title>
	<link href='<%=request.getContextPath()%>/css/bootstrap.min.css' rel='stylesheet' />
	<link href='<%=request.getContextPath()%>/css/jquery-ui.css' rel='stylesheet' />
	<link href='<%=request.getContextPath()%>/css/fullcalendar.css' rel='stylesheet' />
	<link href='<%=request.getContextPath()%>/css/fullcalendar.print.css' rel='stylesheet' media='print' />
    <link href='<%=request.getContextPath()%>/css/custom.css?er4544423423423' rel='stylesheet'/> 
	<!--  <link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Open+Sans" /> -->
	<!-- Custom Fonts -->
	<link href="<%=request.getContextPath()%>/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
	<link href="<%=request.getContextPath()%>/dist/css/sb-admin-2.css" rel="stylesheet">	
	<script src='<%=request.getContextPath()%>/js/lib/moment.min.js'></script>
	<script src='<%=request.getContextPath()%>/js/lib/jquery.min.js'></script>
	<script src='<%=request.getContextPath()%>/js/bootstrap.min.js'></script>
	<script src='<%=request.getContextPath()%>/js/jquery-ui.js'></script>
	<script src='<%=request.getContextPath()%>/js/jquery.ui.es.js'></script>
	<script src='<%=request.getContextPath()%>/js/fullcalendar.min.js'></script>
	<script src='<%=request.getContextPath()%>/js/locale-all.js'></script>

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>
<script>  var obj = {};
		var _PRESENCIA = '<%=Util.eTipoGuardia.PRESENCIA.toString().toLowerCase()%>';
		var _LOCALIZADA= '<%=Util.eTipoGuardia.LOCALIZADA.toString().toLowerCase()%>';
		var _REFUERZO= '<%=Util.eTipoGuardia.REFUERZO.toString().toLowerCase()%>';
		var _ADJUNTO= '<%=Util.eTipo.ADJUNTO.toString().toLowerCase()%>';
		var _RESIDENTE= '<%=Util.eTipo.RESIDENTE.toString().toLowerCase()%>';
</script>

<%

	/* por defecto de la base de datos si hay */
	
	
	
	String _PageToFill="get_guardias.jsp";
	String _SelectedMonth = "";
	
	boolean _bCalculating = false;
	
	
	

	if (request.getParameter("fecha")!=null) 
	{		
			_PageToFill="fill_agenda.jsp";
			_SelectedMonth = request.getParameter("fecha");
	}
	if (request.getParameter("start_calc")!=null)  // se rellena con los huecos  
	{
		_PageToFill="calc_agenda.jsp";
		_SelectedMonth = request.getParameter("start_calc");
		_bCalculating = true;
		
		if (request.getParameter("festivo1")!=null)
		{%>
			<script>
						obj["start_calc"] = '<%=request.getParameter("start_calc")%>';	
						obj["end_calc"] = '<%=request.getParameter("end_calc")%>';
		   </script>
	<%
			for (int j=1;j<=31;j++)
			{
				String _param = "poolday" + j;
				String _param1 = "festivo" + j;
				//out.println (request.getParameter(_param1));
				if (request.getParameter(_param1)!=null)
				{
%>
					<script>
						obj["poolday<%=j%>"] = '<%=request.getParameter(_param)%>';	
						obj["festivo<%=j%>"] = '<%=request.getParameter(_param1)%>';
					</script>
<%
				}
				
				
			}
		}
		
	
	}	
%>


<script>

function sortMe(a, b) {	
	  return a.className < b.className;
	}

/* class=orden1 orden2 DE LOS TIPOS DE GUARDIAS */
function _OrdenarGuardias()
{
	
	$('.fc-title').each(function( index ) {
		  // obtenemos el #residente #tipo A / B
		 var elem= $(this).find("div").sort(sortMe);
		  
         $(this).append(elem); 			  
		})

}

function _FillDataDays()
{
	// recorremos la tabla de datos de medicos y buscamos en el grid de calendario
	
	// quitamos opcion de excel
	
	if ($("#calendar div.adjunto").length>0)
	{				
		$("#toExcel").show();		
	}
	else
	{		
		$("#toExcel").hide();
	}
	
	
	$( "#doctor_list table tr" ).each(function( index ) { 
		
		Guardias = $("div."+ _ADJUNTO + "[id=" + $(this).attr("id") +"]").length;
		var ID_INICIAL = $(this).attr("id");
		//console.log("Id Medico:" + ID_INICIAL);		
		Localizada =0;
		Presencia =0;
		Refuerzo =0;
		LocalizadaF =0;
		PresenciaF =0;
		RefuerzoF =0;
		ID = -1;	
		// recorremos todos los dias 
		$( ".fc-title div."+ _ADJUNTO + "[id=" + ID_INICIAL +"]").each(function( index ) 
		{ 					  
		      if ($(this).hasClass(_REFUERZO))
		      {	  
		    	  if ($(this).hasClass("festivoc"))
		    		  RefuerzoF+=1;
		    	  else
		    	  	Refuerzo +=1;
		      }
		      if ($(this).hasClass(_LOCALIZADA))
		      {
		    	  if ($(this).hasClass("festivoc"))
		    		  LocalizadaF+=1;
		    	  else
		    	  	Localizada +=1;
		      }
		    	  
		      if ($(this).hasClass(_PRESENCIA))
		      {
		    	  if ($(this).hasClass("festivoc"))
		    		  PresenciaF+=1;
		    	  else
		    	  Presencia +=1;
		      }	  
		    	  			  
		});    		
		if (ID_INICIAL!=-1)
		{				
			$("#doctor_list table tr[id=" +ID_INICIAL +"] td.mespresencia").html(Presencia);			
			$("#doctor_list table tr[id=" +ID_INICIAL +"] td.meslocalizada").html(Localizada);
			$("#doctor_list table tr[id=" +ID_INICIAL +"] td.mesrefuerzo").html(Refuerzo);
			$("#doctor_list table tr[id=" +ID_INICIAL +"] td.mespresenciaf").html(PresenciaF);			
			$("#doctor_list table tr[id=" +ID_INICIAL +"] td.meslocalizadaf").html(LocalizadaF);
			$("#doctor_list table tr[id=" +ID_INICIAL +"] td.mesrefuerzof").html(RefuerzoF);
			$("#doctor_list table tr[id=" +ID_INICIAL +"] td.mestotaladjunto").html(Presencia+Localizada+Refuerzo+PresenciaF+LocalizadaF+RefuerzoF);
			
			
			//alert($(ID_INICIAL + "_data").html());			
			Localizada =0;
			Presencia =0;
			Refuerzo =0;
			LocalizadaF =0;
			PresenciaF =0;
			RefuerzoF =0;
		}
		// RESIDENTES 
		Guardias = $("div."+ _RESIDENTE + "[id=" + $(this).attr("id") +"]").length;
		FestivosR = 0;
		// recorremos todos los dias 
		$( ".fc-title div."+ _RESIDENTE + "[id=" + ID_INICIAL +"]").each(function( index ) 
		{ 					  
		      if ($(this).hasClass("festivoc"))
		    	  FestivosR+=1;
		    	  
		});
		$("#doctor_list table tr[id=" +ID_INICIAL +"] td.mestotalresidente").html(Guardias);
		$("#doctor_list table tr[id=" +ID_INICIAL +"] td.mesfestivos").html(FestivosR);
		$("#doctor_list table tr[id=" +ID_INICIAL +"] td.mesdiario").html(Guardias-FestivosR);
		
		
		
	});
	
	

}

function fSaveDatabase(){
	
	
	
	var aGuardias = [];
	
	
	//var _Date = $('#calendar').fullCalendar('getDate').format("YYYY-MM-DD");
	
	
	var LastIDADJUNTOPRESENCIA=0;  // para saber el ultimo y reordenar la secuecia
	
	
	/* CADA DIA */
	var contador=0;
	var _Date;
	
	$('#loading').modal('show');
	
	var _Date = $('#calendar').fullCalendar('getDate');
	
	var dayWrapper = moment(_Date);
	/* METEMOS EL DIA A 1 */
	dayWrapper.date(1);
	
	$('.fc-title').each(function( index ) {
	
		
		
		fguardia = dayWrapper.format("YYYY-MM-DD");
		
		$(this).find("div").each(function( index2 ) 
				{
					
					  var _oGuardia = {};
					  
					 _oGuardia["DiaGuardia"]=fguardia;

					  _oGuardia["IdMedico"]=$(this).attr("id");	
					  _oGuardia[_ADJUNTO]=0;
					  
					  /* ultimo adjunto de presencia */
					  if ($(this).hasClass(_ADJUNTO) && $(this).hasClass(_PRESENCIA)) 
					  		LastIDADJUNTOPRESENCIA = $(this).attr("id");					  
				      if ($(this).hasClass(_ADJUNTO))
				      {	  
				    	  _oGuardia[_ADJUNTO]=1;
				    	  
				    	  
				    	  
				      }
				      _oGuardia["Festivo"]=0;
				      if ($(this).hasClass("festivoc"))
				      {	  
				    	  _oGuardia["Festivo"]=1;
				      }
				      _oGuardia["Tipo"]=_PRESENCIA;
				       if ($(this).hasClass(_RESIDENTE))
				      {	  
				    	   _oGuardia["Tipo"]="";
				      }				      
				      if ($(this).hasClass(_LOCALIZADA))
				      {	  
				    	  _oGuardia["Tipo"]=_LOCALIZADA;
				      }				      
				      if ($(this).hasClass(_REFUERZO))
				      {	  				    	  
				    	  _oGuardia["Tipo"]=_REFUERZO;
				      }
				    	 				     
				      aGuardias[contador] = _oGuardia;
				      contador++;
				    	  			  
				});
		
			dayWrapper.add(1,"d");

		});
	
	
	
	  $.ajax({
          data: {guardias: JSON.stringify(aGuardias), MesGuardia : $('#calendar').fullCalendar('getDate').format("YYYY-MM-DD")}, //stringify is important,
          type: 'POST',
          dataType: 'JSON',
          url: '<%=request.getContextPath()%>/medico/grabar_guardias.jsp',
          success: function(data) {   
        	  _fn_OrdenarSecuenciaAdjuntos(LastIDADJUNTOPRESENCIA);
          },
          error: function(data) {   
        	  alert("Error:" + data);
          }
      });
	
	
}

	var _DateClicked= "";
	var _EventToChange;

	
	/* hay que ordenar para que aparezca en el orden correcto */ 
	function _fn_OrdenarSecuenciaAdjuntos(IDMEDICO)
	{
		$.ajax({
	          data: {lastidmedico: IDMEDICO}, //stringify is important,
	          type: 'POST',	          
	          url: '<%=request.getContextPath()%>/medico/reordenar_grabar_guardias.jsp',
	          success: function(data) {   
	        	  $('#loading').modal('hide');
	        	  $('#loaded').modal('show');
	          },
	          error: function(data) {   
	        	  alert("Error" + data);
	          }
	      });
		
	}
		
	
	
	function fn_Save(){
		
		  
		  
		  var _myindex = 1;
		 
		  var obj = {};
		  
		  
		  $('<input>').attr({
			    type: 'hidden',
			    id: 'start_calc',
			    name: 'start_calc',
			    value: $('#calendar').fullCalendar('getDate').format("YYYY-MM-DD")
			}).appendTo('#fSave');

		 /*  obj["start"] = $('#calendar').fullCalendar('getDate').format("YYYY-MM-DD");
		  obj["end"] = $('#calendar').fullCalendar('getDate').format("YYYY-MM-DD");
		  */
		  $('<input>').attr({
			    type: 'hidden',
			    id: 'end_calc',
			    name: 'end_calc',
			    value: $('#calendar').fullCalendar('getDate').format("YYYY-MM-DD")
			}).appendTo('#fSave');		  		 

		  	  
		  $('.fc-title').each(function( index ) {
			  // obtenemos el #residente #tipo A / B
			  var _Tipo= $(this).find("#poolday #pool:checked");
			 // alert(_Tipo);
			  // obtenemos si es festivo
			  var _Festivo= $(this).find(".festivo input");
			  
			  
			  //console.log( $(this).find(".festivo input:checked"));
			  
			  $('<input>').attr({
				    type: 'hidden',				    
				    name: 'poolday' + _myindex,
				    value: _Tipo.val()
			  
				}).appendTo('#fSave');
			  
			  	//obj["tipo" + _myindex] = _Tipo.val();
			  
			  			  
			//  _GET_DATA += ",tipo" + _myindex + "=" _Tipo.val();
			  var _festivoValue = false;
			  if ($(_Festivo).is(':checked')) {  
			  //if (_Festivo.val()=="V")
				  _festivoValue = true;
			  }		  
			  
			  $('<input>').attr({
				    type: 'hidden',				    
				    name: 'festivo' + _myindex,
				    value: _festivoValue
			  
				}).appendTo('#fSave');
			  
			  
			  //obj["festivo" + _myindex] = _festivoValue;
			  _myindex++;
			//  console.log( index + ": " + $( this ).text() );
			});
		  
		  
		  $("#fSave").submit();
		  

	}
	
	
	function fn_Excel()
	{
		var _Date = $('#calendar').fullCalendar('getDate').date(1).format("YYYY-MM-DD");
		/* METEMOS EL DIA A 1 */
		$("#filecontent").val($(".fc table").html());
		$("#fechaExcel").val(_Date);
		
		
		$("#ff3").submit();
		
	
	}
	

	function fn_FillMonth(){
		
				
		// todos seleccionados
		// todos seleccionados
		
		/* hay datos previos, avisamos y submit */
		if (<%=_bCalculating%>)
		{
		 $( function() {
			    $( "#dialog-confirm" ).dialog({
			      resizable: false,
			      height: "auto",
			   //   width: 400,
			      modal: true,
			      buttons: {
			        "Continuar": function() {
			          $( this ).dialog( "close" );
			            var _pageTo = "<%=request.getRequestURI()%>";
			  			$("#fecha").val($('#calendar').fullCalendar('getDate').format("YYYY-MM-DD"));
			  			//alert($("#fecha").val());
			  			$("#ff").submit();
			        },
			        "Cancelar": function() {
			          $( this ).dialog( "close" );
			        }
			      }
			    });
			    var buttons = $('.ui-dialog-buttonpane div').children('button');
			    buttons.removeClass().addClass('btn btn-block btn-primary');
			    var buttonsCAPA = $('.ui-dialog-buttonset').removeClass();			    
			  } );
  
		}
		else // normal
		{
			var _pageTo = "<%=request.getRequestURI()%>";
  			$("#fecha").val($('#calendar').fullCalendar('getDate').format("YYYY-MM-DD"));
  			//alert($("#fecha").val());
  			$("#ff").submit();
		}	
				
		 		

		
	}

	$(document).ready(function() {
		
		$('#calendar').fullCalendar({
			header: {
			     left: 'prev,next today',
	                center: 'title',
	                right: 'month,basicWeek,basicDay'
			},
		//	defaultDate: '2016-09-19',
			navLinks: true, // can click day/week names to navigate views
			editable: true,			 
			eventLimit: true, // allow "more" link when too many events
			color: "yellow",   // an option!
		    textColor: "black", // an option!
		    locale: 'es',
			events:   {
				url: '<%=_PageToFill%>',
				//method : 'post',
				data : obj,
				error: function() {
					$('#script-warning').show();
				}
			},
			 loading: function (bool) {
				if (bool)
					    
					    $('#loading').modal('show');
					  else 
					    $('#loading').modal('hide');
			 } ,
			    eventAfterAllRender: function (view) {
			    	_FillDataDays();
			    	_OrdenarGuardias();
			    },
			    eventRender: function (event, element) {
			    	element.find('.fc-title').html(event.title);
			    	if (event.title.indexOf("poolday")>=0)
			    		element.addClass('poolday');
			    }
		});
		
		<% if (!_SelectedMonth.equals("")) { %>
			
		$('#calendar').fullCalendar('gotoDate','<%=_SelectedMonth%>');
		
		<% } %>
		
		
		
			
		
	});

	
	
	
	

</script>

<body>

    <div id="wrapper">

       <jsp:include page="common/navigation.jsp"/>

    </div>
    <!-- /#wrapper -->
    <div id="page-wrapper">
    <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Calendario</h1>
                </div>
                 <div class="panel-heading">
                           <div class="row">
                               <div class="col-xs-10">									        	   	                                                                     
                                   <div id='calendar'></div>
                                   <!--  hay resultados -->
                                   <%  if (request.getParameter("fecha")==null)  {  // se rellena con los huecos o viene de BBDD                                	   
                                   %>                                                                                                          		
                                   <div class="panel panel-default">
				                        <div class="panel-heading">
				                            <i class="fa fa-bell fa-fw"></i> Resultados  Guardias
				                        </div>
				                        <!-- /.panel-heading -->
				                        <div class="panel-body">
	                            			<div class="row">
	                                			<div class="col-xs-11"> 
	                                    			<div id="doctor_list" class="table-responsive">		                                          
				                            				<jsp:include page="medico/results_doctor.jsp"/>                            				                          	    	
	                                    			</div>
	                                    	</div>
	                                    	<!--  table-responsive -->
	                                		</div>
				                        </div>                            
			                        </div>
			                        <!-- /.panel-body -->			                  
			                    	<% } %>                       
                             </div>
                               <div class="col-xs-2">
                               		<div class="panel panel-yellow colorsguardias"><div class="panel-heading">Presencia</div></div> 
                               		<div class="panel panel-green colorsguardias"><div class="panel-heading">Localizada</div></div>                               		
                               		<div class="panel panel-primary colorsguardias"><div class="panel-heading">Refuerzo</div></div>
                               		<div class="panel panel-red colorsguardias"><div class="panel-heading">Residente</div></div>
                               		
                                                                                                    
                                    <div class="panel panel-green">
				                        <div class="panel-heading">
				                            <i class="fa fa-bar-chart-o fa-fw"></i> Configurar Mes
				                        </div>
				                        <div class="panel-body">				                            
				                            <form  id=ff method=post ><!--  onsubmit="return  fn_FillMonth()" -->
												<input  type="hidden" name="fecha" id=fecha value='2016-09-10'/>
												<div  hidden="true" id="dialog-confirm" title="Datos previos">
													  	<p>Esto perderá los cálculos de pantalla que no estén correctamente almacenados.¿Deseas continuar?</p>
												</div>
												<a href="javascript:void(0)" onclick="fn_FillMonth()">
												<div class="panel-footer">
					                                <span class="pull-left">Empezar</span>
					                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
					                                <div class="clearfix"></div>
					                            </div>
												</a>
												<!-- <input  class="ui-button ui-widget ui-corner-all" type="submit" value="Resetear Mes"/> -->
											</form>
										</div>
									</div>	
									<% if (request.getParameter("fecha")!=null) /* hay calculo previo o hay datos previos cargados  */ { %>  
									<div class="panel panel-red">
				                        <div class="panel-heading">
				                            <i class="fa fa-bar-chart-o fa-fw"></i> Guardias
				                        </div>
				                        <div class="panel-body">				                            
				                                <form name="fSave" id=fSave method ="POST">			
				                                <a  href="javascript:void(0)" onclick="fn_Save()">																					
												<div class="panel-footer">
					                                <span class="pull-left">Calcular</span>
					                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
					                                <div class="clearfix"></div>
					                            </div>
												</a>
												<!-- <input class="ui-button ui-widget ui-corner-all" type="button" onclick="fn_Save()" value="Calcular Guardias "/> -->
											</form>
										</div>
									</div>
									<% } %>
									<% if (request.getParameter("start_calc")!=null) /* hay calculo previo o hay datos previos cargados  */ { %>
									<div class="panel panel-primary">
				                        <div class="panel-heading">
				                            <i class="fa fa-bar-chart-o fa-fw"></i> Resultados
				                        </div>
				                        <div class="panel-body">				                            
											<form  id=fSaveDatabase method=post>
												<input  type="hidden" name="fecha" id=fecha value='2016-09-10'/>
												<a href="javascript:void(0)"  onclick="fSaveDatabase()">
												<div class="panel-footer">
					                                <span class="pull-left">Guardar</span>
					                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
					                                <div class="clearfix"></div>
					                            </div>
												</a>
												<a href="#doctor_list">
												<div class="panel-footer">
					                                <span class="pull-left">Ver</span>
					                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
					                                <div class="clearfix"></div>
					                            </div>
												</a>
													<!-- <input  class="ui-button ui-widget ui-corner-all" type="submit" value="Guardar"/> -->
											</form>
										</div>
									</div>
									<% } %>
									<div id="toExcel" class="panel panel-yellow">
				                        <div class="panel-heading">
				                            <i class="fa fa-bar-chart-o fa-fw"></i> Excel
				                        </div>
				                        <div class="panel-body">				                            
				                            <form accept-charset="UTF-8" target="frame1" id=ff3 method=post action="toExcel.jsp" enctype="application/x-www-form-urlencoded">
												<input  type="hidden" name="fechaExcel" id=fechaExcel value='2016-09-10'/>
												<a href="javascript:void(0)" onclick="fn_Excel()">
												<div class="panel-footer">
					                                <span class="pull-left">Descargar</span>
					                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
					                                <div class="clearfix"></div>
					                            </div>
												</a>
												<input type="hidden" id="filecontent" name="filecontent">												
												<!-- <input  class="ui-button ui-widget ui-corner-all" onclick="fn_Excel()" type="button" value="Descargar Excel"/> -->
												
											</form>
										</div>
									</div>
									
                        			<!-- /.panel-body -->
                    				</div><!-- class="col-xs-2"> -->
                               </div>
                           </div>
                  </div>
                <!-- /.col-lg-12 -->
				<!-- Modal -->
				<div class="modal fade" id="loading" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
				  <div class="modal-dialog" role="document">
				    <div class="modal-content">
				      <div class="modal-header">
				        <h5 class="modal-title" id="exampleModalLabel">Cargando datos</h5>				        
				      </div>
				      <div class="modal-body">
				        <span>Por favor, espere..</span>
				      </div>
				      <!--  <div class="modal-footer">
				        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				        <button type="button" class="btn btn-primary">Save changes</button>
				      </div> -->
				    </div>
				  </div>
				</div>                
<!-- 				<div id="loading2" class="progress">	      
					  <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%">
					    <span>Ejecutando, por favor, espere..</span>
				  	</div>
				</div> -->
				<div class="modal fade" id="loaded" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
				  <div class="modal-dialog" role="document">
				    <div class="modal-content">
				      <div class="modal-header">
				        <h5 class="modal-title" id="exampleModalLabel">Correcto</h5>
				        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
				          <span aria-hidden="true">&times;</span>
				        </button>
				      </div>
				      <div class="modal-body">
				        <span>Los datos han sido almacenados correctamente</span>
				      </div>
				      <div class="modal-footer">
				        <button type="button" class="btn btn-primary" data-dismiss="modal">Cerrar</button>
				      <!--    <button type="button" class="btn btn-primary">Save changes</button>
				      </div> -->
				    </div>
				  </div>
				</div> 
				<div style="display:none" id="loaded2" title="Correcto"><p>Datos almacenados satisfactoriamente</p></div>
      </div>    
            	  
	  
		<div id="frame1"></div>
</body>
</html>


