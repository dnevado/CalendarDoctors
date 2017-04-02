<%@page import="com.guardias.*"%> 
<jsp:useBean id="MedicoLogged" class="com.guardias.Medico" scope="session"/>
<nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
			
			 <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
             	<a class="navbar-brand" href="inicio.jsp"><img src="<%=request.getContextPath()%>/public/images/medoncalls4_s.jpg"/></a>
            </div>
			         
            <ul class="nav navbar-top-links navbar-right">     
                <!-- /.dropdown -->
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <i class="fa fa-user fa-fw"></i> <i class="fa fa-caret-down"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-user">
                        <li><a href="#"><i class="fa fa-user fa-fw"></i>Tu perfil</a>
                        </li>
                        <li><a href="#"><i class="glyphicon glyphicon-calendar"></i>Tu calendario</a>
                        </li>
                        <li><a href="#"><i class="glyphicon glyphicon-thumbs-up"></i>Tus cambios</a>
                        </li>
                        <li class="divider"></li>
                        <li><a href="<%=request.getContextPath()%>/logout.jsp"><i class="fa fa-sign-out fa-fw"></i>Salir</a>
                        </li>
                    </ul>
                    <!-- /.dropdown-user -->
                </li>
                <!-- /.dropdown -->
            </ul>
            <!-- /.navbar-top-links -->

<% 
if (MedicoLogged.isAdministrator())
{%>

            <div class="navbar-default sidebar" role="navigation">
                <div class="sidebar-nav navbar-collapse">
                    <ul class="nav" id="side-menu">                       
                        <li>
                            <a href="<%=request.getContextPath()%>/inicio.jsp"><i class="glyphicon glyphicon-calendar"></i>Calendario</a>
                        </li>
                        <li>
                            <a href="<%=request.getContextPath()%>/medicos.jsp"><i class="glyphicon glyphicon-user"></i>M�dicos</a>
                        </li>
                        <li>
                            <a href="<%=request.getContextPath()%>/cambios_guardias.jsp"><i class="glyphicon glyphicon-thumbs-up"></i>Cambios</a>
                        </li>
                        
                        <li>
                            <a href="<%=request.getContextPath()%>/config.jsp"><i class="glyphicon glyphicon-lock"></i>Configuraci�n</a>
                        </li>
                        <!-- <li>
                            <a href="#"><i class="fa fa-bar-chart-o fa-fw"></i> Charts<span class="fa arrow"></span></a>
                            <ul class="nav nav-second-level">
                                <li>
                                    <a href="flot.html">Flot Charts</a>
                                </li>
                                <li>
                                    <a href="morris.html">Morris.js Charts</a>
                                </li>
                            </ul>                            
                        </li> -->                       
                    </ul>
                </div>
                <!-- /.sidebar-collapse -->
            </div>
            <!-- /.navbar-static-side -->
<% } %>    	            
        </nav>
        
        
    