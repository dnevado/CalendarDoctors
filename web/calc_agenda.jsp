
<%@page import="com.guardias.database.GuardiasDBImpl"%>
<%@page import="com.guardias.database.MedicoDBImpl"%>
<%@page import="com.guardias.database.ConfigurationDBImpl"%>

<%@page import="java.util.*"%>

<%@page import="java.util.Calendar"%>
<%@page import="java.text.*"%>
<%@page import="com.guardias.*"%>
<%@page import="org.json.*"%>
<%@page import="com.guardias.*"%>
<%@page import="java.util.*"%>
<%@page import="java.util.Map.*"%>



<%


/*{“Employees”:[

{
“Name”:”ABC”,
“Designation”:”Manager”,
“Pay”:”Rs. 60000/-“,
“PhoneNumbers”:[{
“LandLine” : “11-2xxxx99”,
“Mobile” : “11xxxxxx11”
}]
},
*/

//javax.json.JsonObject object = Json.createObjectBuilder().build();


JSONObject allEmps=new JSONObject();
JSONObject empObj=null;

 
 


String _start = request.getParameter("start_calc"); //2016-08-28
String _end = request.getParameter("end_calc");

Date _dINI = new Date();
Date _dFIN = new Date();

DateFormat _format = new SimpleDateFormat("yyyy-MM-dd");

_dINI = _format.parse(_start);
_dFIN = _format.parse(_end);


Calendar _cINI = Calendar.getInstance();
Calendar _cFIN = Calendar.getInstance();

/* SUMAMOS UN MES */
_cINI.setTimeInMillis(_dINI.getTime());
_cINI.set(Calendar.DAY_OF_MONTH, 1);
_cFIN.setTimeInMillis(_dFIN.getTime());
_cFIN.set(Calendar.DAY_OF_MONTH, 1);
_cFIN.add(Calendar.MONTH, 1);

List lItems = new ArrayList();


List lGuardias = new ArrayList();

List<Long> lFestivos = new ArrayList<Long>();


Long MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS = Long.parseLong(ConfigurationDBImpl.GetConfiguration(Util.getoCONST_MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS()).getValue());

Long NUMERO_GUARDIAS_PRESENCIA = Long.parseLong(ConfigurationDBImpl.GetConfiguration(Util.getoCONST_NUMERO_PRESENCIAS()).getValue());
Long NUMERO_REFUERZOS_LOCALIZADAS = Long.parseLong(ConfigurationDBImpl.GetConfiguration(Util.getoCONST_NUMERO_REFUERZOS_LOCALIZADAS()).getValue());
Long NUMERO_RESIDENTES_POR_DIA = Long.parseLong(ConfigurationDBImpl.GetConfiguration(Util.getoCONST_NUMERO_RESIDENTES()).getValue());


/* INCLUYENDO SIMULADOS Y ACTIVOS*/
Long  _NUM_TOTAL_RESIDENTES =new Long(0);
Long  _NUM_TOTAL_GUARDIAS_CUBIERTAS_RESIDENTES=new Long(0);  // numero de simulados o guardias sin residentes-
Long  _NUM_SIMULADOS_POR_SEMANA =new Long(0);

Long  _NUM_RESIDENTES_ASIGNADOS_PREVIOS_A_ADJUNTOS =new Long(0);  // CUANTOS ADJUNTOS REQUIEREN UN RESIDENTE SI O SI 

/* 
	[1] --> [DIA] 
			[PRESENCIA] --> IDMEDICO			
			[REFUERZO] --> IDMEDICO O NO
			[LOCALIZADO] --> IDMEDICO	 O NO	
	


/*<xml version='1.0'/>
<medicos>
	<m nombre="M0" tipo="G">
		<vacaciones>
			<v>01-01-2016 / 01-01-2017</v>
		</vacaciones>
	</m>
*/


String _Path = request.getServletContext().getRealPath("/") + "//medicos.xml";

ProcesarMedicos oUtilMedicos = new ProcesarMedicos();



lItems = MedicoDBImpl.getMedicos();

List<Long> lGenerada = new ArrayList();


int _daysOfMonth = com.guardias.Util.daysDiff(_cINI.getTime(),_cFIN.getTime());


int _Index;

boolean  bEncontrado = false;
boolean _EsFestivo = false; 	

String _Festivo = ""; // o B

long _TOTAL_FESTIVOS_MES=0;

HashMap<Long, Hashtable> lMedicosGuardias  = new HashMap<Long, Hashtable>();
List<Medico> _lResidentes  = new ArrayList<Medico>();
List<Medico> _lAdjuntos  = new ArrayList<Medico>();


_lAdjuntos  =ProcesarMedicos.getAdjuntos(lItems, true);

/* LO PRIMERO ASIGNAR LOS ADJUNTOS POR ORDEN DE APARICION O SECUENCIA PARA LAS PRESENCIAS 


			[_TIPO] --> ADJUNTO	
			[_TOTAL_GUARDIAS_MES]
			[_TOTAL_FESTIVOS_MES]		
			[_TOTAL_PRESENCIA_MES]
			[_TOTAL_REFUERZO_MES]
			[_TOTAL_LOCALIZADA_MES]					
			[_TOTAL_PRESENCIA_FESTIVOS_MES]
			[_TOTAL_LOCALIZADA_FESTIVOS_MES]
			[_TOTAL_REFUERZO_FESTIVOS_MES]							
			[_TOTAL_SIMULADO_MES]		
			[_TOTAL_SIMULADO_FESTIVOS_MES]
			[0]  --> [PRESENCIA, LOCALIZADA, REFUERZO]
			[1]  --> DIA GUARDIA
			[2]	 --> DIA GUARDIA	

*/

Calendar _cINICIO = Calendar.getInstance();
Calendar _cFINAL = Calendar.getInstance();

_cINICIO.setTimeInMillis(_cINI.getTimeInMillis());
_cFINAL.setTimeInMillis(_cFIN.getTimeInMillis());


/* 20170201 ACUMULAMOS LO DEL A�O EN CURSO PARA VER SI CUADRAN MEJOR LAS CIFRAS EQUITATIVAS>*/
/* OJO, QUITAMOS LOS DEL MES EN CURSO, DE PRINCIPIOS DE A�O HASTA EL MES  ANTERIOR EN CURSO  
FECHA INICIO --> SIEMPRE DIA 1, MES 1, A�O EN CURSO
FECHA FIN  --> RESTAMOS UN DIA (<=30, 31)*/
Calendar _cANYO_INICIO= Calendar.getInstance();

_cANYO_INICIO.set(_cINI.get(Calendar.YEAR), 0, 1);
String _ANYO_INICIO =  _format.format(_cANYO_INICIO.getTime());				
_cANYO_INICIO.setTimeInMillis(_cINI.getTimeInMillis());
// RESTAMOS UN DIA 
_cANYO_INICIO.add(Calendar.DATE, -1);
String _ANYO_HASTA =  _format.format(_cANYO_INICIO.getTime());



/* 1. ASIGNACION DE PRESENCIAS EN ORDEN */

for (int j=1;j<=_daysOfMonth;j++)	
{
	
	
	_EsFestivo = Boolean.parseBoolean(request.getParameter("festivo" + j));
	
	/* si es festivo y no lo encuentra en la lista de festivos*/
	if (_EsFestivo && !lFestivos.contains(new Long(j)))
		lFestivos.add(new Long(j));
	
	
	/* CUANTAS PRESENCIAS HAY QUE RELLENAR */
	for (int countPresencias=0;countPresencias<NUMERO_GUARDIAS_PRESENCIA;countPresencias++)
	{
		
		for (int x=0;x<_lAdjuntos.size();x++)
		{
		
			bEncontrado = false;
			
			String _DATE = _format.format(_cINICIO.getTime());
			
			Medico oM = (Medico) _lAdjuntos.get(x);
			
			
			if (oUtilMedicos.NoTieneVacaciones(oM, _DATE)
					&& (lGenerada.size()==0 || !lGenerada.contains(oM.getID())))
			{
				
				
				lGenerada.add(oM.getID());
				
			    // existe el medico residente en su lista de control
				Hashtable _lDatosGuardiasMedico=null;
				
				if (!lMedicosGuardias.containsKey(oM.getID()))
				{			
					// la generamos
					_lDatosGuardiasMedico = new Hashtable();
					lMedicosGuardias.put(oM.getID(),_lDatosGuardiasMedico);
					_lDatosGuardiasMedico.put("_TIPO",Util.eTipo.ADJUNTO);
					_lDatosGuardiasMedico.put("_TOTAL_GUARDIAS_MES",0);
					_lDatosGuardiasMedico.put("_TOTAL_FESTIVOS_MES",0);
					
					
				
					int TOTAL_PRESENCIA = GuardiasDBImpl.getTotalGuardiasPorMedicoTipoEntreFechas(oM.getID(), Util.eTipoGuardia.PRESENCIA.toString().toLowerCase(),new Long(0),_ANYO_INICIO,_ANYO_HASTA);	
					int TOTAL_LOCALIZADA = GuardiasDBImpl.getTotalGuardiasPorMedicoTipoEntreFechas(oM.getID(), Util.eTipoGuardia.LOCALIZADA.toString().toLowerCase(),new Long(0),_ANYO_INICIO,_ANYO_HASTA);
					int TOTAL_REFUERZO = GuardiasDBImpl.getTotalGuardiasPorMedicoTipoEntreFechas(oM.getID(), Util.eTipoGuardia.REFUERZO.toString().toLowerCase(),new Long(0),_ANYO_INICIO,_ANYO_HASTA);						
					int TOTAL_REFUERZO_FESTIVO = GuardiasDBImpl.getTotalGuardiasPorMedicoTipoEntreFechas(oM.getID(), Util.eTipoGuardia.REFUERZO.toString().toLowerCase(),new Long(1),_ANYO_INICIO,_ANYO_HASTA);
					int TOTAL_PRESENCIA_FESTIVO = GuardiasDBImpl.getTotalGuardiasPorMedicoTipoEntreFechas(oM.getID(), Util.eTipoGuardia.PRESENCIA.toString().toLowerCase(),new Long(1),_ANYO_INICIO,_ANYO_HASTA);	
					int TOTAL_LOCALIZADA_FESTIVO = GuardiasDBImpl.getTotalGuardiasPorMedicoTipoEntreFechas(oM.getID(), Util.eTipoGuardia.LOCALIZADA.toString().toLowerCase(),new Long(1),_ANYO_INICIO,_ANYO_HASTA);
					
					int TOTAL_SIMULADOS= GuardiasDBImpl.getTotalGuardiasPorMedico_DeSimulados(oM.getID(), new Long(0),_ANYO_INICIO,_ANYO_HASTA);
					int TOTAL_SIMULADOS_FESTIVO = GuardiasDBImpl.getTotalGuardiasPorMedico_DeSimulados(oM.getID(), new Long(1),_ANYO_INICIO,_ANYO_HASTA);
					
					
					
					/* FIN 20170201 ACUMULAMOS LO DEL A�O EN CURSO PARA VER SI CUADRAN MEJOR LAS CIFRAS EQUITATIVAS>*/
					
					/***************************************************
					PARA DESHACER EL CAMBIO, QUITARLOS TOTALES SIGUIENTES Y CAMBIARLOS POR CERO PARA INICIARLIZARLOS 
					*/
					
					_lDatosGuardiasMedico.put("_TOTAL_" + Util.eTipoGuardia.PRESENCIA.toString() + "_MES",TOTAL_PRESENCIA);
					_lDatosGuardiasMedico.put("_TOTAL_" + Util.eTipoGuardia.REFUERZO.toString()+ "_MES",TOTAL_REFUERZO);
					_lDatosGuardiasMedico.put("_TOTAL_" + Util.eTipoGuardia.LOCALIZADA.toString()+ "_MES",TOTAL_LOCALIZADA);
					_lDatosGuardiasMedico.put("_TOTAL_" + Util.eTipoGuardia.PRESENCIA.toString() + "_FESTIVOS_MES",TOTAL_PRESENCIA_FESTIVO);
					_lDatosGuardiasMedico.put("_TOTAL_" + Util.eTipoGuardia.LOCALIZADA.toString()+ "_FESTIVOS_MES",TOTAL_LOCALIZADA_FESTIVO);
					_lDatosGuardiasMedico.put("_TOTAL_" + Util.eTipoGuardia.REFUERZO.toString()+ "_FESTIVOS_MES",TOTAL_REFUERZO_FESTIVO);
					_lDatosGuardiasMedico.put("_TOTAL_" + Util.eSubtipoResidente.SIMULADO.toString() + "_DIARIO_MES",TOTAL_SIMULADOS);
					_lDatosGuardiasMedico.put("_TOTAL_" + Util.eSubtipoResidente.SIMULADO.toString() + "_FESTIVOS_MES",TOTAL_SIMULADOS_FESTIVO);
								
					
				}			
				else
					// la obtenemos la que haya 
					_lDatosGuardiasMedico = (Hashtable) lMedicosGuardias.get(oM.getID());
				
				/* PONEMOS EL DIA */
				_lDatosGuardiasMedico.put(new Long(j), Util.eTipoGuardia.PRESENCIA.toString());  // redundate, dia key , dia value
							
				// SUMAMOS UNO
							
				
				/* CAMBIO 03-01-2017  NO SUMAMOS CUANDO SEA FESTIVO AL TOTAL DE CADA GUARDIA 
				_lDatosGuardiasMedico.put("_TOTAL_" + Util.eTipoGuardia.PRESENCIA.toString() + "_MES", Integer.valueOf(_lDatosGuardiasMedico.get("_TOTAL_" + Util.eTipoGuardia.PRESENCIA.toString() + "_MES").toString()) +1);
				CAMBIO 03-01-2017  NO SUMAMOS CUANDO SEA FESTIVO AL TOTAL DE CADA GUARDIA */
				/* SI ES FESTIVO, SUMAMOS EL FESTIVO TAMBIEN */
				_EsFestivo = Boolean.parseBoolean(request.getParameter("festivo" + j));
				if (_EsFestivo)
				{
						// SUMAMOS UNO
						_lDatosGuardiasMedico.put("_TOTAL_" + Util.eTipoGuardia.PRESENCIA.toString() + "_FESTIVOS_MES", Integer.valueOf(_lDatosGuardiasMedico.get("_TOTAL_" + Util.eTipoGuardia.PRESENCIA.toString() + "_FESTIVOS_MES").toString()) +1);
						_lDatosGuardiasMedico.put("_TOTAL_FESTIVOS_MES", Integer.valueOf(_lDatosGuardiasMedico.get("_TOTAL_FESTIVOS_MES").toString()) +1);
						
				}			
				else {
					/* CAMBIO 03-01-2017  NO SUMAMOS CUANDO SEA FESTIVO AL TOTAL DE CADA GUARDIA*/ 
					_lDatosGuardiasMedico.put("_TOTAL_" + Util.eTipoGuardia.PRESENCIA.toString() + "_MES", Integer.valueOf(_lDatosGuardiasMedico.get("_TOTAL_" + Util.eTipoGuardia.PRESENCIA.toString() + "_MES").toString()) +1);
					_lDatosGuardiasMedico.put("_TOTAL_GUARDIAS_MES", Integer.valueOf(_lDatosGuardiasMedico.get("_TOTAL_GUARDIAS_MES").toString()) +1);
					/* CAMBIO 03-01-2017  NO SUMAMOS CUANDO SEA FESTIVO AL TOTAL DE CADA GUARDIA */						
					
				}
				
				System.out.println("Agregado al dia : " + j + ", m�dico:" + oM.getID() + ",PRESENCIA");
				
				bEncontrado = true;													
				break;
				
				
			}
			// que no he encontrado a nadie, limpio la lista y recorro el mismo dia
			if (x==_lAdjuntos.size()-1)			
			{
				lGenerada.clear();
				j--;
			}
			
			
		}
	// si no ha encontrado a nadie mas, vaciamos la lista de control de asignaciones
	
	
	} // fin de cuantas presencias hay que generar
	
	if (bEncontrado)	
		_cINICIO.add(Calendar.DAY_OF_MONTH, 1);
	
	
	

}
		

ArrayList<Long> _lPoolDAYS= new ArrayList();
/* VERIFICAMOS QUE EST� EL POOLDAY RELLENO PARA ASIGNARLO AL R1 */

System.out.println("Verificamos el poool...");

for (int j=1;j<=_daysOfMonth;j++)	
{
	if (request.getParameter("poolday" + j)!=null && !request.getParameter("poolday" + j).equals("")) _lPoolDAYS.add(new Long(j));
	_EsFestivo = Boolean.parseBoolean(request.getParameter("festivo" + j));
	if (_EsFestivo)
	{
		_TOTAL_FESTIVOS_MES++;	
	}
	
}	

/* DATOS PARA CALCULAR LA DISTRIBUCION */

/* 1. ASIGNAR POOL, EL RESTO PUEDEN IR EN SECUENCIA O NO.
2. OBTENER NUMERO DE DIAS LABORALES
3. OBTENER NUMERO DE DIAS FESTIVOS
4. RELLENAR SEGUN CRITERIO 
*/

/* LISTA DE CONTROL RESIDENTES

	[1] --> IDMEDICO
	
	    [_TIPO] --> RESIDENTE
	    [_SUBTIPO] --> R1....R2....SIMULADO...ROTANTE
		[_NUMERO_GUARDIAS_RESIDENTE_MES]
		[_TOTAL_GUARDIAS_RESIDENTE_FESTIVO]				
		[0]  --> DIA GUARDIA    o POOL DAY
		[1]  --> DIA GUARDIA    o POOL DAY
		[2]	 --> DIA GUARDIA	o POOL DAY
				
/* LISTA DE CONTROL ADJUNTOS 

	[5] --> IDMEDICO

			[_TIPO] --> ADJUNTO	
			[_TOTAL_GUARDIAS_MES]
			[_TOTAL_FESTIVOS_MES]		
			[_TOTAL_PRESENCIA_MES]
			[_TOTAL_REFUERZO_MES]
			[_TOTAL_LOCALIZADA_MES]					
			[_TOTAL_PRESENCIA_FESTIVOS_MES]
			[_TOTAL_LOCALIZADA_FESTIVOS_MES]
			[_TOTAL_REFUERZO_FESTIVOS_MES]							
			[_TOTAL_SIMULADO_DIARIO_MES]		
			[_TOTAL_SIMULADO_FESTIVOS_MES]
			[0]  --> [PRESENCIA, LOCALIZADA, REFUERZO]
			[1]  --> [PRESENCIA, LOCALIZADA, REFUERZO]
			[2]	 --> [PRESENCIA, LOCALIZADA, REFUERZO]	
					
					
	*/				







			
//_NUM_TOTAL_RESIDENTES = ProcesarMedicos.getNumeroResidentes(lItems);			
			
_lResidentes  =ProcesarMedicos.getResidentes(lItems);
_NUM_TOTAL_RESIDENTES = new Long(_lResidentes.size());

// no contemplamos vacaciones etc...es una aproximacion
_NUM_TOTAL_GUARDIAS_CUBIERTAS_RESIDENTES = ProcesarMedicos.getGuardiasSinCubrir(Util.eTipo.RESIDENTE,_lResidentes,_cINI, _cFIN );   // SIMULADOS



_cINI.setFirstDayOfWeek(Calendar.MONDAY); //sets first day to monday, for example.
_cINI.setMinimalDaysInFirstWeek(1);
int NUM_SEMANAS_MES = _cINI.getActualMaximum(Calendar.WEEK_OF_MONTH);

/* TOTAL SIMULADOS / TOTAL SEMANAS */
/* OJO, QUE LA SEMANA ULTIMA PUEDE CONTENER UN UNICO DIA */
//_NUM_SIMULADOS_POR_SEMANA = _NUM_TOTAL_GUARDIAS_SIN_CUBRIR_RESIDENTES / NUM_SEMANAS_MES;
/* RESTO MAYOR DE 0 , SUMAMOS UNO MAS PARA PODER ASIGNARLOS , MAS FLEXIBLES */

/* AGREGAMOS LOS R1  A LOS DIAS POOOL */

System.out.println("Agregamos el poool...");


Collections.shuffle(_lResidentes);

for (int x=0;x<_lPoolDAYS.size();x++)   // recorremos los pool dates
{
	
	Long _PoolDay = _lPoolDAYS.get(x);
	
	/* for (int poolcount=0;poolcount<2;poolcount++) // recorremos m�dicos residentes
	{*/
	
		for (int k=0;k<_lResidentes.size();k++) // recorremos m�dicos residentes
		{
			
			Medico oM = (Medico) _lResidentes.get(k);
		
			// R1 y residentes 
			if (oM.getTipo().equals(Util.eTipo.RESIDENTE) &&  oM.getSubTipoResidente().equals(Util.eSubtipoResidente.R1))
			{
				
				// existe el medico residente en su lista de control
				Hashtable _lDatosGuardiasMedico=null;
				
				if (!lMedicosGuardias.containsKey(oM.getID()))
				{			
					// la generamos
					_lDatosGuardiasMedico = new Hashtable();
					lMedicosGuardias.put(oM.getID(),_lDatosGuardiasMedico);
					_lDatosGuardiasMedico.put("_TIPO",Util.eTipo.RESIDENTE);
					_lDatosGuardiasMedico.put("_SUBTIPO",oM.getSubTipoResidente());
					_lDatosGuardiasMedico.put("_NUMERO_GUARDIAS_" + Util.eTipo.RESIDENTE + "_MES",0);
					_lDatosGuardiasMedico.put("_TOTAL_GUARDIAS_" + Util.eTipo.RESIDENTE + "_FESTIVO",0);
					
				}			
				else
					// la obtenemos la que haya 
					_lDatosGuardiasMedico = (Hashtable) lMedicosGuardias.get(oM.getID());
				
				/* PONEMOS EL DIA */
				_lDatosGuardiasMedico.put(_PoolDay, "POOLDAY");  // redundate, dia key , dia value
				
				/* if  (!_lDatosGuardiasMedico.containsKey("_NUMERO_GUARDIAS_RESIDENTE_MES"))
					_lDatosGuardiasMedico.put("_NUMERO_GUARDIAS_RESIDENTE_MES",1);  // la primera
				else*/  // SI NO, SUMAMOS UNO			
				
				/* SI ES FESTIVO, SUMAMOS EL FESTIVO TAMBIEN */
				_EsFestivo = Boolean.parseBoolean(request.getParameter("festivo" + _PoolDay.longValue()));
				if (_EsFestivo)
				{
					/*if  (!_lDatosGuardiasMedico.containsKey("_TOTAL_GUARDIAS_RESIDENTE_FESTIVO"))
						_lDatosGuardiasMedico.put("_TOTAL_GUARDIAS_RESIDENTE_FESTIVO",1);  // la primera
					else  */// SI NO, SUMAMOS UNO
					_lDatosGuardiasMedico.put("_TOTAL_GUARDIAS_" + Util.eTipo.RESIDENTE + "_FESTIVO", Integer.valueOf(_lDatosGuardiasMedico.get("_TOTAL_GUARDIAS_" + Util.eTipo.RESIDENTE + "_FESTIVO").toString()) +1);
				}			
				else  // guardias diarias 03-01-2017
					_lDatosGuardiasMedico.put("_NUMERO_GUARDIAS_" + Util.eTipo.RESIDENTE + "_MES", Integer.valueOf(_lDatosGuardiasMedico.get("_NUMERO_GUARDIAS_" + Util.eTipo.RESIDENTE + "_MES").toString()) +1);
				//_lDatosGuardiasMedico.replace(oM.getID(), _lDatosGuardiasMedico);
				
				//System.out.println("Agregado al pool : " + _PoolDay + ", m�dico:" + oM.getID() + ",");
				
				
				break;
			}
	
		}
	// fin de total de pooles definidos

}  // fin de dias poool

 /* PROCESO PARA RESIDENTES CONTROLANDO LOS QUE TENGA EL CHECK DE QUE NO PUEDEN ESTAR SOLOS (ADJUNTOS) COMO GUARDIA Y POR TANTO, DEBEN TENER UN RESIDENTE SI O SI 
SI NO SE HACE AQUI TE ARRIESGAS A TENERLO EL ULTIMO DIA DEL MES Y ASIGNARLO SIN RESIDENTE 
*/

Calendar cGuardiaDia = Calendar.getInstance();
cGuardiaDia.setTimeInMillis(_cINI.getTimeInMillis());

System.out.println("Relleno de los m�dicos que tienen que tener un residente...");



/* ENTRAMOS SI SOLO HAY UNA PRESENCIA Y UN RESIDENTE POR DIA, EN OTRO CASO , NO SE ENTRA */

if (NUMERO_GUARDIAS_PRESENCIA==new Long(1) && NUMERO_RESIDENTES_POR_DIA==new Long(1) &&   ProcesarMedicos.ExisteMedicoConGuardiaSolo_EnElMes(lMedicosGuardias, _lAdjuntos, new Long(-1)))
{
	for (int j=1;j<=_daysOfMonth;j++)	  
	{
		
		boolean bExisteMedicoConGuardiaSolo = ProcesarMedicos.ExisteMedicoConGuardiaSolo_EnElMes(lMedicosGuardias, _lAdjuntos,new Long(j));
		
		if (bExisteMedicoConGuardiaSolo && !_lPoolDAYS.contains(new Long(j)))  // hay un medico adjunto que no puede estar solo en el dia y ya no hay residente pool asignado
		{
			
			Random rand = new Random();
			
			int value = rand.nextInt(_lResidentes.size());  // integer entre 0 y size -1		
			bEncontrado = false;
			Medico oM = null;			
			Medico _oAdjunto = null;
			boolean IgnorarMenorNumeroGuardias = false;  // cuando el que menos ha hecho guardias le toque esta asignacion (p.e. festivo)  pero ha trabajado el dia anterior
			
			
			/* PARA EVITAR BUCLES, PUEDE PASAR QUE ME ASIGNE UN RESIDENTE, SEA UN FESTIVO Y EL ORDEN ALEATORIO QUE DA ORDENADO DE FESTIVOS DE MENOR A MAYOR HACE QUE NO COINCIDAN*/
			boolean AllMedicosVerificados = false;  // si todos los medicos est�n verificados, se los asigno a simulado
			List<Long> _ListaIDMedicosVerificados = new ArrayList<Long>();
			
			
			
			
			/* para no embuclarse, se asignan a simulados */
			AllMedicosVerificados = ProcesarMedicos.TodosMedicosVerificadosDia(_lResidentes, _ListaIDMedicosVerificados);
			
			while (!bEncontrado) 
			{
			
			    oM = (Medico) _lResidentes.get(value);
					
				String _DATE = _format.format(cGuardiaDia.getTime());
				boolean NoTieneVacaciones = oUtilMedicos.NoTieneVacaciones(oM, _DATE);
				boolean ExcedeLimiteGuardiasMes = false;
				boolean ExcedeHorasSeguidas = false;
				boolean EsResidenteConMenosFestivos = false;
				boolean TienePoolDayAsignadoDiaSgte = false;
				boolean SimuladosEquitativosConAdjunto = false;  // repartimos de manera proporcional entre la semana los simulados y equitativo entre los adjuntos
				int _GuardiasPreviasSeguidas=0; 
				
				_EsFestivo = Boolean.parseBoolean(request.getParameter("festivo" + j));
				
				if (!_ListaIDMedicosVerificados.contains(oM.getID()))
					_ListaIDMedicosVerificados.add(oM.getID());
				
				Hashtable _lDatosTemp;
				
				if (lMedicosGuardias.containsKey(oM.getID())) // existe el medico con guardias
				{
					
					_lDatosTemp = (Hashtable) lMedicosGuardias.get(oM.getID());
				
					 Long _total =  Long.parseLong(_lDatosTemp.get("_NUMERO_GUARDIAS_" + Util.eTipo.RESIDENTE + "_MES").toString())
							 			+ Long.parseLong(_lDatosTemp.get("_TOTAL_GUARDIAS_" + Util.eTipo.RESIDENTE + "_FESTIVO").toString());
					 //System.out.println("M�dico: " + oM.getID() + ",guardiasmes:" + _total);
					 // lleva m�s guardias calculadas que total tiene predefinidas
					 if (_total.intValue()>=oM.getMax_NUM_Guardias().intValue())
					 {	 
						ExcedeLimiteGuardiasMes = true;
					 }				 
					 // verificamos dias anteriores
					 _GuardiasPreviasSeguidas = ProcesarMedicos.getDiasPreviosConGuardiasSeguidos(j, _lDatosTemp, _daysOfMonth);
					 //System.out.println(Util.CONST_MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTES  + "," + _GuardiasPreviasSeguidas);
					 
					 //Long MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS = Long.parseLong(ConfigurationDBImpl.GetConfiguration(Util.getoCONST_MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS()).getValue());
					 
					 if (_GuardiasPreviasSeguidas>= MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS.intValue())
					 {
						 ExcedeHorasSeguidas = true;
					 }
					 /* TIENE EL MEDICO ASIGNADO EL POOL EL DIA J+1*/
					 if (_lDatosTemp.containsKey(new Long(j+1)) && _lDatosTemp.get(new Long(j+1)).equals("POOLDAY"))
					 {
						 	TienePoolDayAsignadoDiaSgte =true;
					 }
					  
					 _EsFestivo = Boolean.parseBoolean(request.getParameter("festivo" + j));
					 
					 EsResidenteConMenosFestivos = true;
					 Long  ResidenteConMenosFestivos = new Long(-1);
					// IgnorarMenorNumeroGuardias = false;
					 if (_EsFestivo)
					 { 
						 //	ResidenteConMenosFestivos  = ProcesarMedicos.ResidenteMenosFestivosyNoExcedeDelTotal(lMedicosGuardias, _lResidentes, _DATE,j);
						 	/* PUEDE DARSE QUE EL RESIDENTE CON MENOS FESTIVOS HAYA TRABAJADO EL VIERNES, CON LO QUE NO SE LE PUEDE ASIGNAR EL SABADO Y ENTRA EN BUCLE */
						 	ResidenteConMenosFestivos  = ProcesarMedicos.ResidenteMenosGuardiasyNoExcedeDelTotal(lMedicosGuardias, _lResidentes, _DATE, j, _daysOfMonth);
						 	EsResidenteConMenosFestivos = oM.getID().equals(ResidenteConMenosFestivos);  
						 	if  (EsResidenteConMenosFestivos)  
									IgnorarMenorNumeroGuardias =true;
						 	/* else 
						 			IgnorarMenorNumeroGuardias =false; */
						 						 						
					 }
					 if (!oM.isResidenteSimulado() &&  NoTieneVacaciones && !ExcedeLimiteGuardiasMes &&  !ExcedeHorasSeguidas && !TienePoolDayAsignadoDiaSgte && 
								(!_EsFestivo || (_EsFestivo &&  (IgnorarMenorNumeroGuardias ||  (!IgnorarMenorNumeroGuardias && EsResidenteConMenosFestivos)))))
						bEncontrado =true;
					
				}  // fin 	if (lMedicosGuardias.containsKey(oM.getID())) // existe el medico con guardias
				else
					if (!oM.isResidenteSimulado() && NoTieneVacaciones && !TienePoolDayAsignadoDiaSgte)  
							bEncontrado =true;
				
				
				/* SI YA HAN SIDO VERIFICADOS TODOS, LE ASIGNO AL ADJUNTO EL PRIMER RESIDENTE QUE NO SEA SIMULADO Y CUMPLA LAS CONDICIONES */
				if (AllMedicosVerificados && !oM.isResidenteSimulado() && NoTieneVacaciones && !TienePoolDayAsignadoDiaSgte)
					bEncontrado =true;
				
				/* System.out.println("Relleno de adjuntos con residente,Dia:" + j + "_GuardiasPreviasSeguidas:" +  _GuardiasPreviasSeguidas + ",NoEstaVacaciones:" + NoTieneVacaciones + ",isResidenteSimulado:" + oM.isResidenteSimulado() + ",Residente:" + oM.getApellidos() + ",ExcedeLimiteGuardiasMes:" +  ExcedeLimiteGuardiasMes
						 + ",ExcedeHorasSeguidas:" + ExcedeHorasSeguidas + ",EsResidenteConMenosFestivos:" + EsResidenteConMenosFestivos + ",TienePoolDayAsignadoDiaSgte" + TienePoolDayAsignadoDiaSgte						
						+ ",SimuladosEquitativosConAdjunto:" + SimuladosEquitativosConAdjunto);
				*/
				
				Random rand2 = new Random();
				
				value = rand2.nextInt(_lResidentes.size());  // integer entre 0 y size -1
				
			} // end while 
				
			Hashtable _lDatosGuardiasMedico=null;
			
			if (!lMedicosGuardias.containsKey(oM.getID()))
			{			
				// la generamos
				_lDatosGuardiasMedico = new Hashtable();
				lMedicosGuardias.put(oM.getID(),_lDatosGuardiasMedico);
				_lDatosGuardiasMedico.put("_TIPO",Util.eTipo.RESIDENTE);
				_lDatosGuardiasMedico.put("_SUBTIPO",oM.getSubTipoResidente());
				_lDatosGuardiasMedico.put("_NUMERO_GUARDIAS_" + Util.eTipo.RESIDENTE + "_MES",0);
				_lDatosGuardiasMedico.put("_TOTAL_GUARDIAS_" + Util.eTipo.RESIDENTE + "_FESTIVO",0);						
			}			
			else
				// la obtenemos la que haya 
				_lDatosGuardiasMedico = (Hashtable) lMedicosGuardias.get(oM.getID());
			
			/* PONEMOS EL DIA */
			_lDatosGuardiasMedico.put(new Long(j), "NOPOOLDAY");  // redundate, dia key , dia value
			
			/* if  (!_lDatosGuardiasMedico.containsKey("_NUMERO_GUARDIAS_RESIDENTE_MES"))
				_lDatosGuardiasMedico.put("_NUMERO_GUARDIAS_RESIDENTE_MES",1);  // la primera
			else*/  // SI NO, SUMAMOS UNO
			/* SI ES FESTIVO, SUMAMOS EL FESTIVO TAMBIEN */
			_EsFestivo = Boolean.parseBoolean(request.getParameter("festivo" + j));
			if (_EsFestivo)
			{
				/* if  (!_lDatosGuardiasMedico.containsKey("_TOTAL_GUARDIAS_RESIDENTE_FESTIVO"))
					_lDatosGuardiasMedico.put("_TOTAL_GUARDIAS_RESIDENTE_FESTIVO",1);  // la primera
				else*/  // SI NO, SUMAMOS UNO
					_lDatosGuardiasMedico.put("_TOTAL_GUARDIAS_RESIDENTE_FESTIVO", Integer.valueOf(_lDatosGuardiasMedico.get("_TOTAL_GUARDIAS_RESIDENTE_FESTIVO").toString()) +1);
			}
			else	/* 03-01-2017 */ 
				 _lDatosGuardiasMedico.put("_NUMERO_GUARDIAS_" + Util.eTipo.RESIDENTE + "_MES", Integer.valueOf(_lDatosGuardiasMedico.get("_NUMERO_GUARDIAS_" + Util.eTipo.RESIDENTE + "_MES").toString()) +1);
			
			
			
			
			_NUM_RESIDENTES_ASIGNADOS_PREVIOS_A_ADJUNTOS++;  // un adjunto ya tiene preasingado el residente antes que nadie 
			
		}
		
	
	}	
}	
System.out.println("Fin relleno de los m�dicos que tienen que tener un residente...");



/*NO RELLENAR EN SECUENCIA PUESTO QUE SI HAY FALTA DE HUECOS PARA RELLENAR , DEBEN SER ADJUDICADOS POR SIMULADOS Y NO DEBEN QUEDAR TODOS AL FINAL DEL MES

*/



/* PROCESO PARA RESIDENES  

NO RELLENAR EN SECUENCIA PUESTO QUE SI HAY FALTA DE HUECOS PARA RELLENAR , DEBEN SER ADJUDICADOS POR SIMULADOS Y NO DEBEN QUEDAR TODOS AL FINAL DEL MES

*/

System.out.println("Starting proceso para residentes..");





Calendar cWeek = Calendar.getInstance();
cGuardiaDia.setTimeInMillis(_cINI.getTimeInMillis());

		



/* 1. RECORRER LOS FESTIVOS PRIMERO DE LA SEMANA 
2. DESPUES LOS DIARIOS PRIMERO DE LA SEMANA
3. ORDENARIA LA LISTA lDiasSemanaAleatorio POR FESTIVOS Y DESPUES DIARIOS PERO ALEATORIOS 


1. ES FESTIVO (ordenados por festivos) 

	--> bFilledFestivosPorResidentes:false;
	--> Faltan _RESIDENTES_SEMANA
	--> No sobrepasan el total semana / mes 
	--> MAS TODAS LAS VALIDACIONES INDIVIDUALES DEL MEDICO
	
2. 	ES DIARIO
	bFilledFestivosPorResidentes:true; --> si es un residente 
	Faltan _RESIDENTES_SEMANA
	No sobrepasan el total semana / mes
	
	
HINT --> ORDENAR RESIDENTES POR RESIDENTES Y ULTIMO SIMULADOS 	
*/	 
/* recorremos semanas mes */ 
/* TOTAL SIMULADOS / TOTAL SEMANAS */
/* OJO, QUE LA SEMANA ULTIMA PUEDE CONTENER UN UNICO DIA */
 
 
 
/* RESTO MAYOR DE 0 , SUMAMOS UNO MAS PARA PODER ASIGNARLOS , MAS FLEXIBLES */
  
/*if (NUM_SEMANAS_MES==6)	// numero semanas mes, caso enero 2017  
{
	_RESIDENTES_SEMANA+=1;
}
*/

//System.out.println (_RESIDENTES_SEMANA);

cWeek.setTimeInMillis(_cINI.getTimeInMillis());
cGuardiaDia.setTimeInMillis(_cINI.getTimeInMillis());

int MONTH_ACTIVE = cGuardiaDia.get(Calendar.MONTH);

/* CAMBIAMOS NUMERO RESIDENTES POR SEMANA QUE SEA VARIABLE 20170103 */
/* PORCENTAJE DE GUARDIAS CUBIERTAS SOBRE EL MES */
//float _PERCENT_RESIDENTES_GUARDIAS_MES =_NUM_TOTAL_GUARDIAS_CUBIERTAS_RESIDENTES.intValue() / _daysOfMonth; //  
/* if (_NUM_TOTAL_GUARDIAS_CUBIERTAS_RESIDENTES.intValue() / Util.CALC_NUM_SEMANAS_MES>0)	// cubiertas por residentes 
{
	_RESIDENTES_SEMANA+=1;
}

System.out.println("_RESIDENTES_SEMANA:" + _RESIDENTES_SEMANA);
*/

//int n= 1;


// RESTAMOS LAS GUARDIAS TOTALES DE RESIDENTES INICIAL A LAS QUE SE HAN METIDO PREVIAMENTE A LOS ADJUNTOS SOLOS  
//_NUM_TOTAL_GUARDIAS_CUBIERTAS_RESIDENTES = _NUM_TOTAL_GUARDIAS_CUBIERTAS_RESIDENTES - _NUM_RESIDENTES_ASIGNADOS_PREVIOS_A_ADJUNTOS; 


/* INTRODUCCION DE LOS RESIDENTES/SIMULADOS  DE MANERA INTELIGENTE */

for (int j=1;j<=NUM_SEMANAS_MES;j++)
{
	
	
	// aleatatorio de los dias diarios  Y FESTIVOS
	// 2017 se solucionaria si establecisesemos los dias en funcion de los adjuntos en orden de mas simulados a menos , solo para los diarios */
	//List<Long> lDiasDSemanaAleatorio = ProcesarMedicos.ListaDiasSemanaAleatoria(cWeek, lFestivos, Util.eTipoDia.DIARIO, MONTH_ACTIVE);
	
	
	 /* COGEMOS LOS DIAS SEGUN ORDEN ASCENDENTE DE ADJUNTOS CON MAS SIMULADOS , ASI SE VAN ASIGNANDO A LOS RESIDENTES */
	List<Long> lDiasDSemanaAleatorio = ProcesarMedicos.ListaDiasSemanaPorOrdenMenorSimulados(cWeek, lFestivos, Util.eTipoDia.DIARIO, MONTH_ACTIVE,lMedicosGuardias,_lAdjuntos);
	
	List<Long> lDiasFSemanaAleatorio = ProcesarMedicos.ListaDiasSemanaAleatoria(cWeek, lFestivos, Util.eTipoDia.FESTIVO, MONTH_ACTIVE);
	
	// Generamos un LinkedHashMap  uniendo ambas estructuras, d�a y si es festivo, por orden 
	Map<Long,Util.eTipoDia> _mapDiasSemana = new LinkedHashMap<Long,Util.eTipoDia>();
	// FESTIVOS 
	for (int cDia=0;cDia<lDiasFSemanaAleatorio.size();cDia++) _mapDiasSemana.put(lDiasFSemanaAleatorio.get(cDia), Util.eTipoDia.FESTIVO);
	// DIARIOS 
	for (int cDia=0;cDia<lDiasDSemanaAleatorio.size();cDia++) _mapDiasSemana.put(lDiasDSemanaAleatorio.get(cDia), Util.eTipoDia.DIARIO);
	
	
	/* DEPENDE DEL NUMERO DE DIAS DE SEMANA 
	
	REGLA DE TRES, GUARDIAS_A_CUBRIR  --> DIAS MES, SOBRE X DIAS SEMANA x SERAN tanto 
	
	*/
	
	int RESIDENTES_VARIABLE_SEMANA = (int) Math.ceil(_NUM_TOTAL_GUARDIAS_CUBIERTAS_RESIDENTES.intValue() * _mapDiasSemana.size() / 31f); // 7 DIAS SEMANA	
	/* RENDONDAMOS AL ENTERO MAS CERCANO */
	
	
    for (Map.Entry<Long,Util.eTipoDia> DiaSemana : _mapDiasSemana.entrySet())
	{
	
    	
    	//System.out.println("valorn:" + n);
		Long DIASEMANAMES= new Long(DiaSemana.getKey());		
		
		//System.out.println("1Dia:" + DIASEMANA);
		Util.eTipoDia _TIPODIA = DiaSemana.getValue();
		
		//System.out.println("_TIPODIA:" + _TIPODIA);
		cGuardiaDia.set(Calendar.DATE, DIASEMANAMES.intValue());
		
		boolean bExisteMedicoConGuardiaSolo = ProcesarMedicos.ExisteMedicoConGuardiaSolo_EnElMes(lMedicosGuardias, _lAdjuntos,DIASEMANAMES);
		
		if (!_lPoolDAYS.contains(DIASEMANAMES) && !bExisteMedicoConGuardiaSolo)
		{
		
			/* CUANTOS RESIDENTE HAY QUE RELLENAR ???*/
			for (int countResidentes=0;countResidentes<NUMERO_RESIDENTES_POR_DIA;countResidentes++)
			{
			
			
			Random rand = new Random();
			
			int value = rand.nextInt(_lResidentes.size());  // integer entre 0 y size -1		
			
						
			bEncontrado = false;			
			Medico oM = null;			
			Medico _oAdjunto = null;
			
			//Long AdjuntoIDPresenciaDia = new Long(-1);
			List<Long> _ListaIDMedicosVerificados = new ArrayList<Long>();
			
			boolean IgnorarMenorNumeroGuardias = false;  // cuando el que menos ha hecho guardias le toque esta asignacion (p.e. festivo)  pero ha trabajado el dia anterior 
			//boolean TodosResidentesCupoMaximo = ProcesarMedicos.TodosResidentesCupoMaximo(lMedicosGuardias, _lResidentes);  // si todos los residentes menos SIMULADO tienen el cupo relleno de maximo de guardias
			boolean NoTieneVacaciones = true;
			boolean ExcedeLimiteGuardiasMes = false;
			boolean EsResidenteConMenosFestivos = false;
			boolean TienePoolDayAsignadoDiaSgte = false;
			boolean SimuladosEquitativosConAdjunto = false;  // repartimos de manera proporcional entre la semana los simulados y equitativo entre los adjuntos
			List<Long> lAdjuntosConMenosSimulados =   new ArrayList<Long>();
			Long  ResidenteConMenosFestivos = new Long(-1);
			int _GuardiasPreviasSeguidas=0;
			/* SIMULADOS */
			boolean bAdjuntoConMenosSimulados= false;
			boolean bAsignadosSimuladosSemana = false;
			/* RESIDENTES  */
			boolean bAsignadosResidentesSemana = false;
			boolean AllMedicosVerificados = false;  // si todos los medicos est�n verificados, se los asigno a simulado
			boolean SimuladoYaVerificado=false;  // para que no asigne residentes de primera
			
			boolean bEstaGuardiaEnElDia=false;  // cuando haya mas de un residente por dia
			
			
			
			
			
			_EsFestivo = _TIPODIA.equals(Util.eTipoDia.FESTIVO);
			int _DIAS_SEMANA_EN_CURSO = 0;						 
			int _NUM_SIMULADOS_ACTUALES_SEMANA = 0;
			int _NUM_RESIDENTES_ACTUALES_SEMANA = 0;
			 
			 _NUM_RESIDENTES_ACTUALES_SEMANA = ProcesarMedicos.NumeroResidentesSemana(cGuardiaDia, lMedicosGuardias,false, MONTH_ACTIVE);  
			
			 if (RESIDENTES_VARIABLE_SEMANA<=_NUM_RESIDENTES_ACTUALES_SEMANA)
				 bAsignadosResidentesSemana =  true; // ya estan asignados ya que hay menos dias de los que exige 
			 else
			 {	 
				 bAsignadosResidentesSemana =  false;
			 	/* if ( _NUM_RESIDENTES_ACTUALES_SEMANA < _RESIDENTES_SEMANA)				 
			 		bAsignadosResidentesSemana =  false;
			 	else
			 		bAsignadosResidentesSemana =  true;
			 	*/
			 }
			 
			 System.out.println("dia:" + DIASEMANAMES + ",_NUM_RESIDENTES_ACTUALES_SEMANA:" + _NUM_RESIDENTES_ACTUALES_SEMANA + ",RESIDENTES_VARIABLE_SEMANA:" + RESIDENTES_VARIABLE_SEMANA);
			 
				
			List<Long>  lIDAdjuntoGuardiaDia = ProcesarMedicos.getMedicoGuardiaDia(DIASEMANAMES.intValue(), lMedicosGuardias, Util.eTipo.ADJUNTO, _lAdjuntos);
			
			List<Long> lIDResidenteGuardiaDia = ProcesarMedicos.getMedicoGuardiaDia(DIASEMANAMES.intValue(), lMedicosGuardias, Util.eTipo.RESIDENTE, _lResidentes);
			
			
			 
		    /*  TESTING 			
		    List<Long> ListAdjuntoConMenosSimulados = ProcesarMedicos.ListAdjuntoConMenosSimulados(lMedicosGuardias, _lAdjuntos, DIASEMANAMES.intValue(), _EsFestivo);
		    bAdjuntoConMenosSimulados = ListAdjuntoConMenosSimulados.contains(IDAdjuntoGuardiaDia);
		    */
		    
		    /* FIN TESTING */ 
			 
			
			while (!bEncontrado) 
			{
				
				
				// VERIFICAMOS PARA EL RESIDENTE, QUE 
				/* 1. NO ESTE DE VACACIONES 
				/* 2. NO SOBREPASE EL LIMITE DE GUARDIAS
				/* 3. QUE EL DIA ANTERIOR (24) PUEDA O NO TRABAJAR
				/* 4. SI ES UN FESTIVO, SEA EL QUE MENOS TIENE
				/* 5. SI ES EL SIMULADO, QUE NO HAYA M�S QUE EL NUMERO POR SEMANA ASIGNADAS  (CUIDADO LA ULTIMA SEMANA) ,
				QUE ESTEN REPARTIDOS EQUITATIVAMENTE ENTRE LOS ADJUNTOS (OJO AL FLAG DE QUE NO PUEDE ASIGNARSE SIMULADO SI NO PUEDE ESTAR SOLO) 
				*/
				
				ExcedeLimiteGuardiasMes = false;				
				EsResidenteConMenosFestivos = false;
				TienePoolDayAsignadoDiaSgte = false;
				SimuladosEquitativosConAdjunto = false;  // repartimos de manera proporcional entre la semana los simulados y equitativo entre los adjuntos
				boolean ExcedeHorasSeguidas = false;
				lAdjuntosConMenosSimulados =   new ArrayList<Long>();
				
				ResidenteConMenosFestivos = new Long(-1);
				_GuardiasPreviasSeguidas=0;
				/* SIMULADOS */
				bAdjuntoConMenosSimulados= false;
				
				/* HAY LA ASIGNACION MINIMA DE SIMULADOS, POR DEFECTO, LO INTENTAMOS , SIEMPRE QUE SE CUMPLAN LAS CONDICIONES */
				
				//	bAsignadosSimuladosSemana = true;
				
				
				 oM = (Medico) _lResidentes.get(value);
				
				String _DATE = _format.format(cGuardiaDia.getTime());
				NoTieneVacaciones = oUtilMedicos.NoTieneVacaciones(oM, _DATE);
				
				bEstaGuardiaEnElDia=false;  // cuando haya mas de un residente por dia
				if (lIDResidenteGuardiaDia.isEmpty()==false && lIDResidenteGuardiaDia.contains(oM.getID()))
					bEstaGuardiaEnElDia = true;
				
				
				
				/* para no embuclarse, se asignan a simulados */
				AllMedicosVerificados = ProcesarMedicos.TodosMedicosVerificadosDia(_lResidentes, _ListaIDMedicosVerificados);
				
				
				Hashtable _lDatosTemp=null;
				if (lMedicosGuardias.containsKey(oM.getID())) // existe el medico con guardias en la lista de control
				{
					
				
					_lDatosTemp = (Hashtable) lMedicosGuardias.get(oM.getID());
					 Long _total =  Long.parseLong(_lDatosTemp.get("_NUMERO_GUARDIAS_" + Util.eTipo.RESIDENTE + "_MES").toString())
							 			+ Long.parseLong(_lDatosTemp.get("_TOTAL_GUARDIAS_" + Util.eTipo.RESIDENTE + "_FESTIVO").toString());
					 //System.out.println("M�dico: " + oM.getID() + ",guardiasmes:" + _total);
					 // lleva m�s guardias calculadas que total tiene predefinidas
					 if (_total.intValue()>=oM.getMax_NUM_Guardias().intValue())
					 {	 
						ExcedeLimiteGuardiasMes = true;
					 }				 
					 // verificamos dias anteriores
					 _GuardiasPreviasSeguidas = ProcesarMedicos.getDiasPreviosConGuardiasSeguidos(DIASEMANAMES.intValue(), _lDatosTemp,_daysOfMonth);
					 
					  
					 /* RESIDENTES NO PUEDEN ESTAR MAS DE 24 SEGUIDAS, NO CONFIGURABLE */  
					 //Long MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS = Long.parseLong(ConfigurationDBImpl.GetConfiguration(Util.getoCONST_MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS()).getValue());
				//	 System.out.println(Util.CONST_MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTES  + "," + _GuardiasPreviasSeguidas);
					 if (_GuardiasPreviasSeguidas>= MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS.intValue())
					 {
						 ExcedeHorasSeguidas = true;
					 }
					 /* TIENE EL MEDICO ASIGNADO EL POOL EL DIA J+1*/
					 if (_lDatosTemp.containsKey(new Long(DIASEMANAMES+1)) && _lDatosTemp.get(new Long(DIASEMANAMES+1)).equals("POOLDAY"))
					 {
						 	TienePoolDayAsignadoDiaSgte =true;
					 }

				
				}   // fin de calculo de medico aleatorio
				
				
				
					  
				EsResidenteConMenosFestivos = true;
				if (_EsFestivo)
				{ 
					   //	ResidenteConMenosFestivos  = ProcesarMedicos.ResidenteMenosFestivosyNoExcedeDelTotal(lMedicosGuardias, _lResidentes, _DATE,j);
					 	/* PUEDE DARSE QUE EL RESIDENTE CON MENOS FESTIVOS HAYA TRABAJADO EL VIERNES, CON LO QUE NO SE LE PUEDE ASIGNAR EL SABADO Y ENTRA EN BUCLE */
					 	ResidenteConMenosFestivos  = ProcesarMedicos.ResidenteMenosGuardiasyNoExcedeDelTotal(lMedicosGuardias, _lResidentes, _DATE, DIASEMANAMES.intValue(), _daysOfMonth);
					 	EsResidenteConMenosFestivos = oM.getID().equals(ResidenteConMenosFestivos);  
					 	
					 						 						
				}
				 // simulado y ya tengo los festivos rellenos, verifico el simulado
				
				 
				if (oM.isResidenteSimulado())
				{
					 if (AllMedicosVerificados)						
						 	bEncontrado =true;
					  else
					  {				
						  if (!_ListaIDMedicosVerificados.contains(oM.getID())) _ListaIDMedicosVerificados.add(oM.getID());
					  }	
					
				}
				else  // residente, si est�n todos ya rellenos a nivel de semana, dejamos hueco al simulado
				   /* 2017-23-01 */ 
				   /*&& !bAdjuntoConMenosSimulados */
				   { 
					 	if (!bAsignadosResidentesSemana   && NoTieneVacaciones && !ExcedeLimiteGuardiasMes   && !bEstaGuardiaEnElDia && !ExcedeHorasSeguidas 
							&& !TienePoolDayAsignadoDiaSgte && (!_EsFestivo || (_EsFestivo &&   EsResidenteConMenosFestivos)))
								bEncontrado =true;
				 		else
				 		{	
				 			if (!_ListaIDMedicosVerificados.contains(oM.getID()))
								_ListaIDMedicosVerificados.add(oM.getID());
				 		}
				   }
				Random r = new Random();			
				value = r.nextInt(_lResidentes.size());  // integer entre 0 y size -1
				//System.out.println("Bucle residentes, aleatorio entre 0 y " + _lResidentes.size() + ":" + value);
				
				
			  // System.out.println("Dia:" + DIASEMANAMES + "Residente:" + oM.getApellidos() +  oM.getID() + ",bAsignadosResidentesSemana:" + bAsignadosResidentesSemana + ",ResidenteConMenosFestivos:" + ResidenteConMenosFestivos + ",AllMedicosVerificados:" + AllMedicosVerificados + ",bAsignadosResidentesSemana:" + bAsignadosResidentesSemana + "TotalGuardias:" + (_lDatosTemp!=null ?_lDatosTemp.get("_NUMERO_GUARDIAS_" + Util.eTipo.RESIDENTE + "_MES") : 0) + ",Festivos:" + (_lDatosTemp!=null ? _lDatosTemp.get("_TOTAL_GUARDIAS_RESIDENTE_FESTIVO"):0));
			
				//System.out.println("bEncontrado:" + bEncontrado + ",dia:" +  DIASEMANAMES);
				
			}  // fin de encontrado
			
			
			//n++;
			
			Hashtable _lDatosGuardiasMedico=null;
			
			if (!lMedicosGuardias.containsKey(oM.getID()))
			{			
				// la generamos
				_lDatosGuardiasMedico = new Hashtable();
				lMedicosGuardias.put(oM.getID(),_lDatosGuardiasMedico);
				_lDatosGuardiasMedico.put("_TIPO",Util.eTipo.RESIDENTE);
				_lDatosGuardiasMedico.put("_SUBTIPO",oM.getSubTipoResidente());
				_lDatosGuardiasMedico.put("_NUMERO_GUARDIAS_" + Util.eTipo.RESIDENTE + "_MES",0);
				_lDatosGuardiasMedico.put("_TOTAL_GUARDIAS_" + Util.eTipo.RESIDENTE + "_FESTIVO",0);						
			}			
			else
				// la obtenemos la que haya 
				_lDatosGuardiasMedico = (Hashtable) lMedicosGuardias.get(oM.getID());
			
			/* PONEMOS EL DIA */
			_lDatosGuardiasMedico.put(DIASEMANAMES, "NOPOOLDAY");  // redundate, dia key , dia value
			
			/* if  (!_lDatosGuardiasMedico.containsKey("_NUMERO_GUARDIAS_RESIDENTE_MES"))
				_lDatosGuardiasMedico.put("_NUMERO_GUARDIAS_RESIDENTE_MES",1);  // la primera
			else*/  // SI NO, SUMAMOS UNO
			/* SI ES FESTIVO, SUMAMOS EL FESTIVO TAMBIEN */			
			if (_EsFestivo)
			{				
					_lDatosGuardiasMedico.put("_TOTAL_GUARDIAS_" + Util.eTipo.RESIDENTE +"_FESTIVO", Integer.valueOf(_lDatosGuardiasMedico.get("_TOTAL_GUARDIAS_" + Util.eTipo.RESIDENTE +"_FESTIVO").toString()) +1);
			}
			else	/* 03-01-2017 */
			{
				 _lDatosGuardiasMedico.put("_NUMERO_GUARDIAS_" + Util.eTipo.RESIDENTE + "_MES", Integer.valueOf(_lDatosGuardiasMedico.get("_NUMERO_GUARDIAS_" + Util.eTipo.RESIDENTE + "_MES").toString()) +1);
			
			}
			/*  SI ES UN SIMULADO, LE METEMOS AL MEDICO ADJUNTO UN CONTADOR DE SIMULADOS  */
			/*  OJO, 2017041 --> NO TIENE SENTIDO AUMENTAR CONTADOR DE SIMULADOS CUANDO HAY MAS MEDICOS PRESENTES EN EL DIA */ 
			if (oM.isResidenteSimulado())
			{
				Hashtable _lDatosGuardiasAdjunto=null;
				
				boolean _bHayUnAdjuntoSoloDePresencia = true;
				if (!lIDAdjuntoGuardiaDia.isEmpty() && lIDAdjuntoGuardiaDia.size()>1)
						_bHayUnAdjuntoSoloDePresencia = false;
				
				if (_bHayUnAdjuntoSoloDePresencia)
				{
					
					Long IDAdjuntoGuardiaDia = lIDAdjuntoGuardiaDia.get(0);
					if (lMedicosGuardias.containsKey(IDAdjuntoGuardiaDia))
					{
						_lDatosGuardiasAdjunto = (Hashtable) lMedicosGuardias.get(IDAdjuntoGuardiaDia);
						String _Key =  "_TOTAL_" + Util.eSubtipoResidente.SIMULADO.toString() + "_DIARIO_MES"; 
						if (_EsFestivo)
							_Key =  "_TOTAL_" + Util.eSubtipoResidente.SIMULADO.toString() + "_FESTIVOS_MES";
						
						
						_lDatosGuardiasAdjunto.put(_Key, Integer.valueOf(_lDatosGuardiasAdjunto.get(_Key).toString()) +1);
						
					}
				}
						
			}
			
			System.out.println("Encontrado:true, Medico:" +oM.getApellidos() + ",Dia:" + DIASEMANAMES + "TotalGuardias:" + _lDatosGuardiasMedico.get("_NUMERO_GUARDIAS_" + Util.eTipo.RESIDENTE + "_MES") + ",Festivos:" + _lDatosGuardiasMedico.get("_TOTAL_GUARDIAS_RESIDENTE_FESTIVO"));
			
			
			} // FIN DE ITERACION DE RESIDENTES 		
				
		} // fin de if (!_lPoolDAYS.contains(DIASEMANA) && !bExisteMedicoConGuardiaSolo)

		cWeek.add(Calendar.DAY_OF_MONTH, 1);
	}  // for dias de semana
    
	
	

} // for semanas del mes 

//for (int j=1;j<=_daysOfMonth;j++)	

/*[_TIPO] --> ADJUNTO	
			[_TOTAL_GUARDIAS_MES]
			[_TOTAL_FESTIVOS_MES]		
			[_TOTAL_PRESENCIA_MES]
			[_TOTAL_REFUERZO_MES]
			[_TOTAL_LOCALIZADA_MES]					
			[_TOTAL_PRESENCIA_FESTIVOS_MES]
			[_TOTAL_LOCALIZADA_FESTIVOS_MES]
			[_TOTAL_REFUERZO_FESTIVOS_MES]							
			[_TOTAL_SIMULADOS_DIARIO_MES]		
			[_TOTAL_SIMULADOS__FESTIVOS_MES]
			[0]  --> [PRESENCIA, LOCALIZADA, REFUERZO]
			[1]  --> [PRESENCIA, LOCALIZADA, REFUERZO]
			[2]	 --> [PRESENCIA, LOCALIZADA, REFUERZO]
*/

/* DISTRIBUIMOS LAS LOCALIZADAS Y LOS REFUERZOS DE LOS ADJUNTOS */
for (int j=1;j<=_daysOfMonth;j++)	
{
	
		/* SACAMOS ALEATORIOS */

		Random rand = new Random();
		
		int value = rand.nextInt(_lAdjuntos.size());  // integer entre 0 y size -1
		
		bEncontrado = false;
		
		Medico oM = null;
		
		//System.out.println("Generamos aleatorio entre los residentes, entre 0 y  " + _lResidentes.size() + ",valor:" + value);
		// obtenemos el residente para ese dia
		
		Medico oResidente = null;
		List<Long> lIDResidenteGuardiaDia = new ArrayList<Long>();
		List<Long> lIDAdjuntoGuardiaDia =  new ArrayList<Long>();
		
		/* CUANTAS LOCALIZADAS Y REFUERZOS  HAY QUE RELLENAR */
		// puede ser que sean menos que residentes existan o incluso mas o igual
		// 1. IGUAL, CRITERIO DE TIPO DE RESIDENTE --> RECORREMOS
		// 2. MENOS, CONTAMOS SI HAY  R1 EXISTENTES PARA AJUSTAR LOS REFUERZOS --> LOCALIZADAS TODAS
		// 3. SI HAY MAS, PUES INDETERMINADO --> NO SE LE DEJARA
		
		lIDResidenteGuardiaDia = ProcesarMedicos.getMedicoGuardiaDia(j, lMedicosGuardias, Util.eTipo.RESIDENTE, _lResidentes);
		
		boolean _GuardiasTodasLocalizadas = NUMERO_REFUERZOS_LOCALIZADAS<lIDResidenteGuardiaDia.size();
		
		// bucle de numero de localizadas y refuerzos
		for (int countLocalizadasRefuerzos=0;countLocalizadasRefuerzos<NUMERO_REFUERZOS_LOCALIZADAS;countLocalizadasRefuerzos++)
		{
		
		    
			//PRESENCIA 
			lIDAdjuntoGuardiaDia = ProcesarMedicos.getMedicoGuardiaDia(j, lMedicosGuardias, Util.eTipo.ADJUNTO, _lAdjuntos);
			
			if (lIDResidenteGuardiaDia.isEmpty())
			{
				System.out.println ("Buscando localizada y refuerzo dia " + j + ",no se ha encontrado el residente");
				break;
			}
			
			Util.eTipoGuardia _TipoGuardiaAdjunto = Util.eTipoGuardia.LOCALIZADA;
			if (!_GuardiasTodasLocalizadas)
			{
				
				Long IDResidenteGuardiaDia = lIDResidenteGuardiaDia.get(countLocalizadasRefuerzos);
			
				oResidente = ProcesarMedicos.GetMedicoPorID(_lResidentes, IDResidenteGuardiaDia);
				//oResidente = _lResidentes.get(IDResidenteGuardiaDia.intValue());
				Util.eSubtipoResidente _TipoResidente = oResidente.getSubTipoResidente();
				 _TipoGuardiaAdjunto = Util.eTipoGuardia.REFUERZO;
				/* R4, R5 */
				if (_TipoResidente.equals(Util.eSubtipoResidente.R4) || _TipoResidente.equals(Util.eSubtipoResidente.R5))
				{
					_TipoGuardiaAdjunto = Util.eTipoGuardia.LOCALIZADA;
				
				}
			}
			String _Key = "";
			
			while (!bEncontrado) 
			{
				
				
				// VERIFICAMOS PARA EL ADJUNTO, EL TIPO DE RESIDENTE QUE TOCA, LOCALIZADA O REFUERZO, VERIFICANDO QUE SEA EL QUE MENOS TENGA 
				// (OJO, CUIDADO CON EL MENOR ESTRICTO , PODRIA DARSE QUE TODOS TENGAN LAS MISMAS */
						
				/* 1. NO ESTE DE VACACIONES  OK 
				/* 2. EQUIDAD EN FESTIVOS 
				/* 3. MAXIMAS GUARDIAS SEGUIDAS OK
				/* 4. QUE NO ESTE DE PRESENCIA EL ESE DIA OK
				   5.hay que verificar que el residente no es simulado para los adjuntos que no pueden estar solos OK
				   6. No exceda el total de guardias asignadas
				   7. SI ES EL PRIMER REFUERZO O LOCALIZADA, QUE LO COJA DEL ALEATORIO, SI NO, SIEMPRE VA A ENCONTRAR EL PRIMERO DE LA SECUENCIA
				*/
				
				
				 oM = (Medico) _lAdjuntos.get(value);
				
				String _DATE = _format.format(_cINI.getTime());
				boolean NoTieneVacaciones = oUtilMedicos.NoTieneVacaciones(oM, _DATE);		
				//boolean ExcedeHorasSeguidas = false;
				boolean EsAdjuntoConMenosGuardias  = false;  // festivos o no			
				//boolean ExcedeLimiteGuardiasMes = false;			
				boolean EstaPresenciaEseDia = false;
				
				
				/* para verificar que no de siempre el primero de la secuencia por menor numero de guardias hechas (el orden) */
				boolean ExisteTipoGuardiaPrevia = false;
				
				
				EstaPresenciaEseDia  = lIDAdjuntoGuardiaDia.contains(oM.getID());
				
				Long  AdjuntoConMenosGuardias = new Long(-1);
				
				Hashtable _lDatosTemp;
				if (!EstaPresenciaEseDia && lMedicosGuardias.containsKey(oM.getID())) // existe el medico con guardias
				{
					
					
					ExisteTipoGuardiaPrevia = ProcesarMedicos.ExisteTipoGuardiaPrevia(lMedicosGuardias,_TipoGuardiaAdjunto);
					
				
					_lDatosTemp = (Hashtable) lMedicosGuardias.get(oM.getID());
					
					 				 
					 				 
					 // GUARDIAS TOTALES 				  
					 _EsFestivo = Boolean.parseBoolean(request.getParameter("festivo" + j));				 				
					 _Key = "_TOTAL_" + _TipoGuardiaAdjunto.toString();
					 if (_EsFestivo)  _Key = _Key.concat("_FESTIVOS");				 
					 	_Key = _Key.concat("_MES");
					 
					 // EXCLUYENDO EL QUE EST� DE PRESENCIA y OJO EL EXCESO DE HORAS SEGUIDAS  
					 AdjuntoConMenosGuardias = ProcesarMedicos.AdjuntoMenosGuardiasYHorasSeguidas(false, _TipoGuardiaAdjunto, _Key, lMedicosGuardias, _lAdjuntos, lIDAdjuntoGuardiaDia,j, _daysOfMonth);
					 EsAdjuntoConMenosGuardias = AdjuntoConMenosGuardias.equals(oM.getID());
					 
									 								
					if (!ExisteTipoGuardiaPrevia ||  EsAdjuntoConMenosGuardias)
						bEncontrado =true;
					/* else
						bEncontrado = false; */
				}   // fin de calculo de medico aleatorio			
					
				Random r = new Random();
				value = r.nextInt(_lAdjuntos.size());  // integer entre 0 y size -1
							
				
			}  // fin de encontrado 
			
			
			System.out.println("Agregado al dia : " + j + ", m�dico adjunto:" + oM.getID() + "," + _TipoGuardiaAdjunto + " " + _Key + ",Adjunto de Guardia:" + lIDAdjuntoGuardiaDia.toString());
			//System.out.println("NoTieneVacaciones:" + NoTieneVacaciones + "," + ) ;
			
			// metemos los datos 
			// existe el medico residente en su lista de control
			Hashtable _lDatosGuardiasMedico=null;
			
			/* AQUI YA TIENEN QUE  ESTAR TODOS LOS ADJUNTOS CON LAS PRESENCIAS  RELLENAS */
			 
			_lDatosGuardiasMedico = (Hashtable) lMedicosGuardias.get(oM.getID());
			
			/* PONEMOS EL DIA */
			_lDatosGuardiasMedico.put(new Long(j), _TipoGuardiaAdjunto.toString());  // redundate, dia key , dia value
			/* 03-01-2017  _lDatosGuardiasMedico.put("_TOTAL_GUARDIAS_MES", Integer.valueOf(_lDatosGuardiasMedico.get("_TOTAL_GUARDIAS_MES").toString()) +1);*/
			if (_EsFestivo)
				_lDatosGuardiasMedico.put("_TOTAL_FESTIVOS_MES", Integer.valueOf(_lDatosGuardiasMedico.get("_TOTAL_FESTIVOS_MES").toString()) +1);
			else
				/* 03-01-2017 */	
				_lDatosGuardiasMedico.put("_TOTAL_GUARDIAS_MES", Integer.valueOf(_lDatosGuardiasMedico.get("_TOTAL_GUARDIAS_MES").toString()) +1);
			
				
			if (_EsFestivo)
				_lDatosGuardiasMedico.put("_TOTAL_" + _TipoGuardiaAdjunto.toString() + "_FESTIVOS_MES", Integer.valueOf(_lDatosGuardiasMedico.get("_TOTAL_" + _TipoGuardiaAdjunto.toString() + "_FESTIVOS_MES").toString()) +1);
			else /* 03-01-2017 */
				_lDatosGuardiasMedico.put("_TOTAL_" + _TipoGuardiaAdjunto.toString() + "_MES", Integer.valueOf(_lDatosGuardiasMedico.get("_TOTAL_" + _TipoGuardiaAdjunto.toString() + "_MES").toString()) +1);
				
			if (oResidente.isResidenteSimulado())
			{
				
				if (_EsFestivo)			
					_lDatosGuardiasMedico.put("_TOTAL_" + Util.eSubtipoResidente.SIMULADO.toString() + "_FESTIVOS_MES", Integer.valueOf(_lDatosGuardiasMedico.get("_TOTAL_" + Util.eSubtipoResidente.SIMULADO.toString() + "_FESTIVOS_MES").toString()) +1);
				else /* 03-01-2017 */
					_lDatosGuardiasMedico.put("_TOTAL_" + Util.eSubtipoResidente.SIMULADO.toString() + "_DIARIO_MES", Integer.valueOf(_lDatosGuardiasMedico.get("_TOTAL_" + Util.eSubtipoResidente.SIMULADO.toString() + "_DIARIO_MES").toString()) +1);
					
			}
	
		
		} // FIN DE COUNT DE LOCALIZADAS Y REFUERZOS	
		
		
		cGuardiaDia.add(Calendar.DATE,1);
	
}


 
 HashMap<Long, Hashtable> lResultados  = new HashMap<Long, Hashtable>();
 

 cGuardiaDia.setTimeInMillis(_cINI.getTimeInMillis());
 


 for (int j=1;j<=_daysOfMonth;j++)
 {
	 
	 String _DATE = _format.format(cGuardiaDia.getTime());
	 _EsFestivo = Boolean.parseBoolean(request.getParameter("festivo" + j));
	  _Festivo = "";
	 if (_EsFestivo) _Festivo="checked";  
	 /* RECORREMOS LA LISTA DE CADA GUARDIA Y MEDICO */
	 Long IDMEDICO = new Long(-1);
	 Iterator entries = lMedicosGuardias.entrySet().iterator();
	
	 
	 bEncontrado = false;
	 
	 /*String _DPresencia ="";
	 String _DLocalizado ="";
	 String _DRefuerzo ="";
	 */
	 
	 Hashtable _lDatos=null;

	 // la generamos
	 _lDatos = new Hashtable();
	 lResultados.put(new Long(j),_lDatos);
	 
	 
	 while (entries.hasNext()) 
		{
		 
		
		 
		  Entry thisEntry = (Entry) entries.next();
		  Long keyMEDICO = (Long) thisEntry.getKey(); 
		  // puede ser un adjunto  en una lista de residente
		  // CAMBIO 20161226, INCLUIMOS EN LOS RESULTADOS A LOS RESIDENTES 
		  /* if (!ProcesarMedicos.ExisteMedicoPorId(_lAdjuntos,keyMEDICO))		  
			  continue;*/
		// CAMBIO 20161226, INCLUIMOS EN LOS RESULTADOS A LOS RESIDENTES
		  Medico _oM= ProcesarMedicos.GetMedicoPorID(lItems,keyMEDICO);
		  Hashtable lDatosTemp = (Hashtable) thisEntry.getValue();		  		  
		  /* cada subclave del medico, buscamos si tiene el dia DiaMes */
		  Iterator entriesDAYS = lDatosTemp.entrySet().iterator();		  	 	  
		  
		  if (lDatosTemp.containsKey(new Long(j)))   // encuentra el dia 
		  {
			  String _Temp = (String) lDatosTemp.get(new Long(j));
			  String _Temp2 = "";
			  
			  /* AL INCLUIR RESIDENTES, PODEMOS OBTENER POOLDAY, NOPOOLDAY*/
			  _Temp2 = _Temp.replace("NOPOOLDAY", Util.eTipo.RESIDENTE.toString()).replace("POOLDAY", Util.eTipo.RESIDENTE.toString());
			  
			  _lDatos.put(_Temp2, _oM.getID()  + "|" + _oM.getApellidos() + "|" + _oM.getNombre()  + "|" + (_oM.getSubTipoResidente().equals(Util.eSubtipoResidente.SIMULADO) ? Util.eSubtipoResidente.SIMULADO : "NO_".concat(Util.eSubtipoResidente.SIMULADO.toString())));
			  			 
				  
		  }	   
		  		  
		  
		} 
	 	
	  // Collections.sort(lResultados);
 
 	
	
	
	 cGuardiaDia.add(Calendar.DAY_OF_MONTH, 1);
	
 }
 
 /* PINTAMOS LOS DATOS  EN EL CALENDARIO */
 
 cGuardiaDia.setTimeInMillis(_cINI.getTimeInMillis());
 

 String _EventsJSON = "["; 
 
 /* for (int j=1;j<=_daysOfMonth;j++)
 {
	 
	 
	 _EsFestivo = Boolean.parseBoolean(request.getParameter("festivo" + j));
	  _Festivo = "";
	 if (_EsFestivo) _Festivo="checked";  
	  RECORREMOS LA LISTA DE CADA GUARDIA Y MEDICO 
	 Long IDMEDICO = new Long(-1);
	 
	
	 
	 bEncontrado = false;
	 
	 String _DPresencia ="";
	 String _DLocalizado ="";
	 String _DRefuerzo ="";
	 */
	 
	 Hashtable _lDatos=null;

	 // la generamos
	 _lDatos = new Hashtable();	 
	 
	 
	 
	 Iterator entries = lResultados.entrySet().iterator();
	  
	 /* POR CADA DIA DE RESULTADOS */ 
	 while (entries.hasNext()) 
		{

		 
		 
		 String _DATE = _format.format(cGuardiaDia.getTime());
		 
		 
		  Entry thisEntry = (Entry) entries.next();
		  Long keyDAY = (Long) thisEntry.getKey(); 
		  // puede ser un adjunto  en una lista de residente		  		  		  
		  Hashtable lDatosTemp = (Hashtable) thisEntry.getValue();		  		  
		  /* cada subclave del medico, buscamos si tiene el dia DiaMes */
		  Iterator entriesGuardias = lDatosTemp.entrySet().iterator();		  	 	  
		  /* POR CADA DIA TIPO DE GUARDIA */
		  
		  _EventsJSON += "{\"title\":\"";
		 
		  _EsFestivo = Boolean.parseBoolean(request.getParameter("festivo" + keyDAY.intValue()));
		  
		  String sFestivo = _EsFestivo ? "festivoc" : "";
		   
		  
		  int classContador=1;
		   
		  while (entriesGuardias.hasNext())
		  {
			  //REFUERZO=10|CASTA�O LEON|ANA MARIA
			  Entry thisGuardiaDay = (Entry) entriesGuardias.next();
			  String sthisGuardiaDay = "";
			  sthisGuardiaDay = String.valueOf(thisGuardiaDay.getValue());
			  String[] aDatosMedico = sthisGuardiaDay.split("\\|"); 
			  
			  
			  Long _GuardiaMedicoID = (Long) Long.valueOf(aDatosMedico[0]);
			  String _GuardiaApellidos = (String) aDatosMedico[1] ;
			  String _GuardiaNombre = (String) aDatosMedico[2];
			  String _GuardiaSimulado = (String) aDatosMedico[3];
			  
			  
			  String _classTipo= "";
			  String _sGuardia = Util.eTipo.RESIDENTE.toString();			  
			  String _sSubTipoGuardia = "";
			  /* GUARDIA ADJUNTOS */
			  if (!thisGuardiaDay.getKey().toString().equals(Util.eTipo.RESIDENTE.toString()))
			  {	  
			  	Util.eTipoGuardia _Guardia = com.guardias.Util.eTipoGuardia.valueOf(thisGuardiaDay.getKey().toString());
			  	_sGuardia = _Guardia.toString();
			  	_classTipo= "adjunto";
			  }
			  //if 
			  

			  _EventsJSON += "<div class='orden" + classContador + " " + _classTipo +  " " + _sGuardia.toString().toLowerCase() +" " +  _GuardiaSimulado.toLowerCase() + " " + sFestivo + "' id=" + _GuardiaMedicoID + ">"   + _GuardiaApellidos + "," + _GuardiaNombre + "</div>";
			  classContador+=1;
		  }
					
		  _EventsJSON += "\",\"start\": \"" + _DATE + "\",";
		  _EventsJSON += "\"textEscape\": false";		 
		  _EventsJSON += "},";
		  
		  cGuardiaDia.add(Calendar.DAY_OF_MONTH, 1);
		  
		  
		  }	   
		  		  

		_EventsJSON += "]";
		_EventsJSON=_EventsJSON.replace("},]", "}]"); 

	    System.out.println(_EventsJSON);
		out.println(_EventsJSON);


%>