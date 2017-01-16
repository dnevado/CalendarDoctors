

<%@ page language="java" import="java.io.*" %> 
<% 

  String _excel = (String) request.getParameter("filecontent");
  String _Date = (String) request.getParameter("fechaExcel");

  response.setContentType("application/vnd.ms-excel charset=ISO-8859-1"); 
  response.setHeader("Content-Disposition","inline;filename=" + _Date+".xls"); 
  response.setHeader("Cache-Control","no-cache"); 
  response.setCharacterEncoding("UTF-8");

  
  /* SUSTITUIMOS CLASS POR STYLE EN LINEA */
  
  String[] _CONST_STRING_ORIGINAL =  {"class=\"fc-event-container","class=\"orden3 adjunto presencia \"","class=\"orden2 adjunto refuerzo \"","class=\"orden1  residente \"","class=\"orden2 adjunto localizada \"","class=\"orden3 adjunto presencia festivoc\"","class=\"orden2 adjunto refuerzo festivoc\"","class=\"orden1  residente festivoc\"","class=\"orden2 adjunto localizada festivoc\""};
  String[] _CONST_STRING_REPLACEBY = {"style=\"background-color: #f1be76\" class=\"fc-event-container","style=\" color: #c77405;\"  class=\"orden3 presencia","style=\" color: #1c94c4;\"  class=\"orden2 refuerzo ","style=\"color: #d9534f;\"  class=\"orden1  residente \"","style=\" color: #1A6B1D;\"  class=\"orden2 adjunto localizada \"","style=\" color: #c77405;background-color: #c1bfb4;\"  class=\"orden3 adjunto presencia festivoc\"","style=\" color: #1c94c4;background-color: #c1bfb4;\"  class=\"orden2 adjunto refuerzo festivoc\"","style=\" color: #d9534f;background-color: #c1bfb4;\"  class=\"orden1  residente festivoc\"","style=\" color: #1A6B1D;background-color: #c1bfb4;\" class=\"orden2 adjunto localizada festivoc\""};
  
  
  
  /*  
 class="fc-day-header	
style="background-color:#cecece" class="fc-day-header

class="fc-event-container
style="background-color: #f1be76" class="fc-event-container

class="orden3 presencia
style=" color: #c77405;"  class="orden3 presencia

class="orden2 refuerzo 
style=" color: #1c94c4;"  class="orden2 refuerzo 

class="orden1 residente "
style="color: #d9534f;"  class="orden1 residente "

class="orden2 localizada
style=" color: #1A6B1D;"  class="orden2 localizada

class="orden3 adjunto presencia festivoc"
style=" color: #c77405;background-color: #c1bfb4;"  class="orden3 adjunto presencia festivoc"

class="orden2 adjunto refuerzo festivoc"
style=" color: #1c94c4;background-color: #c1bfb4;"  class="orden2 adjunto refuerzo festivoc"

class="orden1  residente festivoc"
style=" color: #d9534f;background-color: #c1bfb4;"  class="orden1  residente festivoc"

class="orden2 adjunto localizada festivoc"
style=" color: #1A6B1D;background-color: #c1bfb4;"  class="orden2 adjunto localizada festivoc"
  */
  


	/* RECORREMOS AL REVES PARA QUE NO HAYA REPLACES DOBLES, P.E.  class="orden2 adjunto refuerzo festivoc" class="orden2 refuerzo  */
	//for (int j=0;j<_CONST_STRING_ORIGINAL.length;j++)
	for (int i=_CONST_STRING_ORIGINAL.length-1; i > 0; i--)

	{
		_excel = _excel.replaceAll(_CONST_STRING_ORIGINAL[i], _CONST_STRING_REPLACEBY[i]);
	}

	OutputStream outputStream = response.getOutputStream();
	
	// now get a PrintWriter to stream the chars.
	PrintWriter out2 = new PrintWriter(new OutputStreamWriter(outputStream,"ISO-8859-1"));
	outputStream.write(0xEF);   // 1st byte of BOM
	outputStream.write(0xBB);
	outputStream.write(0xBF);   // last byte of BOM
	
	
	try 
	{
		out2.print(_excel);
		out2.close();	
	}
	catch (Exception e)
	{
		
	}
	
  

   
  
%>