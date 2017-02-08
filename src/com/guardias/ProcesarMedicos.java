package com.guardias;

import java.io.File;
import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.xml.parsers.ParserConfigurationException;

import com.guardias.database.ConfigurationDBImpl;
import com.guardias.database.VacacionesDBImpl;
import com.guardias.xml.*;

import org.xml.sax.SAXException;


public class ProcesarMedicos {

	
	
	/* DIA 1 Y PARCIALES DE 7 */ 
	public static List<Long> ListaDiasSemanaAleatoria(Calendar cSemana, List<Long> ListaFestivos, Util.eTipoDia TipoDia, int MesActual)
	{
		
		
		
		List<Long> lDays = new ArrayList<Long>();
		
		Calendar _cINICIO  = Calendar.getInstance();
		_cINICIO.setTimeInMillis(cSemana.getTimeInMillis()); 
		
		
		Calendar calcSemanaCal= Calendar.getInstance(); 
		calcSemanaCal.setTimeInMillis(_cINICIO.getTimeInMillis());
		final int currentDayOfWeek = (calcSemanaCal.get(Calendar.DAY_OF_WEEK) + 7 - calcSemanaCal.getFirstDayOfWeek()) % 7;		 
		//calcSemanaCal.set(Calendar., Calendar.WEDNESDAY);
		calcSemanaCal.add(Calendar.DATE , -currentDayOfWeek);
		
		/* si ha pasado de mes cSemana al siguiente */				
		/* int _days  = ProcesarMedicos.DiasSemanaCursoDentroMes(cSemana, MesActual);
		if (_days<7)
		{
			calcSemanaCal.setTimeInMillis(cSemana.getTimeInMillis());
		}*/
		int _days  = 7;
		
		for (int j=1;j<=_days;j++)
		{
			if (calcSemanaCal.get(Calendar.MONTH)==MesActual)
			{
			
			Long _ActualDayOfWeek = new Long(calcSemanaCal.get(Calendar.DATE));
			if (TipoDia.equals(Util.eTipoDia.DIARIO))			
					if (!ListaFestivos.contains(_ActualDayOfWeek))
							lDays.add(_ActualDayOfWeek);

			if (TipoDia.equals(Util.eTipoDia.FESTIVO))			
				if (ListaFestivos.contains(_ActualDayOfWeek))
						lDays.add(_ActualDayOfWeek);
			
			}
			calcSemanaCal.add(Calendar.DATE, 1);
		}
		Collections.shuffle(lDays);
		return lDays;
		 
		
	}
	
	
	/* DIA 1 Y PARCIALES DE 7 */ 
	public static List<Long> ListaDiasSemanaPorOrdenMenorSimulados(Calendar cSemana, List<Long> ListaFestivos, Util.eTipoDia TipoDia, int MesActual,
			HashMap<Long, Hashtable> _ListaGuardiasMedicos, List<Medico> lMedicos)
	{ 
		
		
		
		/* DIA, TOTAL SIMULADOS */
		Map<Long,Long> lUNSortedListaDiasMedicos = new HashMap <Long, Long>();
						
		
		Calendar _cINICIO  = Calendar.getInstance();
		_cINICIO.setTimeInMillis(cSemana.getTimeInMillis()); 
		
		
		Calendar calcSemanaCal= Calendar.getInstance(); 
		calcSemanaCal.setTimeInMillis(_cINICIO.getTimeInMillis());
		final int currentDayOfWeek = (calcSemanaCal.get(Calendar.DAY_OF_WEEK) + 7 - calcSemanaCal.getFirstDayOfWeek()) % 7;		 
		//calcSemanaCal.set(Calendar., Calendar.WEDNESDAY);
		calcSemanaCal.add(Calendar.DATE , -currentDayOfWeek);
		
		/* si ha pasado de mes cSemana al siguiente */				
		/* int _days  = ProcesarMedicos.DiasSemanaCursoDentroMes(cSemana, MesActual);
		if (_days<7)
		{
			calcSemanaCal.setTimeInMillis(cSemana.getTimeInMillis());
		}*/
		int _days  = 7;
		
		
		
		for (int j=1;j<=_days;j++)
		{
			
			if (calcSemanaCal.get(Calendar.MONTH)==MesActual)
			{
			
			Long _ActualDayOfWeek = new Long(calcSemanaCal.get(Calendar.DATE));
			Long  IDAdjuntoGuardiaDia = new Long(-1);
			
			try {
				IDAdjuntoGuardiaDia = ProcesarMedicos.getMedicoGuardiaDia(_ActualDayOfWeek.intValue(), _ListaGuardiasMedicos, Util.eTipo.ADJUNTO, lMedicos);
				
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			String _KeyTOTAL ="_TOTAL_" + Util.eSubtipoResidente.SIMULADO + "_DIARIO_MES"; 
			String _KeyTOTAL_Festivos ="_TOTAL_" + Util.eSubtipoResidente.SIMULADO + "_FESTIVOS_MES";
    		/* if (EsFestivo)
				_KeyTOTAL= "_TOTAL_" + Util.eSubtipoResidente.SIMULADO + "_FESTIVOS_MES";
    		*/
    		Hashtable  DatosGuardias = _ListaGuardiasMedicos.get(IDAdjuntoGuardiaDia);
    		Long Total =  new Long(0);
    		Long TotalF =  new Long(0);
    		if (DatosGuardias.containsKey(_KeyTOTAL))   
    		{	
    			Total =  Long.parseLong(DatosGuardias.get(_KeyTOTAL).toString());    		    			
    		}
    		if (DatosGuardias.containsKey(_KeyTOTAL_Festivos))   
    		{	
    			TotalF =  Long.parseLong(DatosGuardias.get(_KeyTOTAL_Festivos).toString());    		    			
    		}
			
    		boolean bDayToAdd = false;
    		
			if (TipoDia.equals(Util.eTipoDia.DIARIO))			
					if (!ListaFestivos.contains(_ActualDayOfWeek))
							bDayToAdd=true;
							//lDays.add(_ActualDayOfWeek);

			if (TipoDia.equals(Util.eTipoDia.FESTIVO))			
				if (ListaFestivos.contains(_ActualDayOfWeek))
						bDayToAdd=true;
						//lDays.add(_ActualDayOfWeek);

			
			if (bDayToAdd)
				{
					lUNSortedListaDiasMedicos.put(_ActualDayOfWeek, Total + TotalF);
					System.out.println("Dia:" + _ActualDayOfWeek + ",total:" + Total + TotalF);
				}
				
			}
			
			
			
			
			calcSemanaCal.add(Calendar.DATE, 1);
		}
		
		
	   Set<Entry<Long, Long>> mapEntries = lUNSortedListaDiasMedicos.entrySet();
        
        List<Map.Entry<Long, Long>> lSortedListaGuardiasMedicos = new ArrayList<Map.Entry<Long, Long>>();
        
        for(Entry<Long, Long> entry : mapEntries) {
       //     System.out.println(entry.getValue() + " - "+ entry.getKey());

            lSortedListaGuardiasMedicos.add(entry);
        }
        
        // used linked list to sort, because insertion of elements in linked list is faster than an array list. 
        

        // sorting the List
        ByTotalesGuardiasASC _ByTotalesGuardiasASC  = new ByTotalesGuardiasASC();
        
        Collections.sort(lSortedListaGuardiasMedicos, _ByTotalesGuardiasASC);
		
        
        // Storing the list into Linked HashMap to preserve the order of insertion. 
        List<Long> lDaysSorted = new ArrayList<Long>();
        	for(Entry<Long,Long> entry: lSortedListaGuardiasMedicos) {
        		lDaysSorted.add(entry.getKey());
        		System.out.println("key:" + entry.getKey());
        }
        
        	
        	System.out.println(lDaysSorted);
        
		return lDaysSorted;
		 
		
	}
	
	
	/* ESTO ES PARA REVISAR QUE AUNQUE FALTEN POR ASIGNAR CUPOS DE RESIDENTES, SI HAY VACACIONES, ESTO NO SE CONTEMPLA, POR LO QUE SI ESTAN TODOS VERIFICADOS, SE AGIGNA AL SIMULADO */
	public static boolean  TodosMedicosVerificadosDia(List<Medico> _ListaABuscar, List<Long> ListaConIdsOrigen) throws ParserConfigurationException, SAXException, IOException
	{
		
		return _ListaABuscar.size()==ListaConIdsOrigen.size();
	}
	
	
	
	public java.util.List<Medico> LeerMedicos(String PathXml) throws ParserConfigurationException, SAXException, IOException
	{
		
				
		return 		LeerMedicos(PathXml, false);
		// Devolvemos la lista de los objetos obtenidos en el XML, este metodo ya es propio del Handler y creado por nosotros
		//return handler.getList();
		
	}
	
	
	
	
	public java.util.List<Medico> LeerMedicos(String PathXml, boolean orden) throws ParserConfigurationException, SAXException, IOException
	{
		
		File f = new File(PathXml);
		Procesar pMedicos= new Procesar(f);
		java.util.List<Medico> lMedicos = new ArrayList();
		
		lMedicos = pMedicos.getMedicos();
		
		
		
		if (orden)
			Collections.sort(lMedicos,new ByOrdenComparator());
			
		
		return lMedicos;
		
				
		// Devolvemos la lista de los objetos obtenidos en el XML, este metodo ya es propio del Handler y creado por nosotros
		//return handler.getList();
		
	}
	
	
	public Medico LeerMedico(String PathXml, String ID) throws ParserConfigurationException, SAXException, IOException
	{
		
		File f = new File(PathXml);
		Procesar pMedicos= new Procesar(f);
		java.util.List<Medico> lMedicos = new ArrayList();
		
		lMedicos = pMedicos.getMedicos();
		
		
		Medico _resultado = new Medico();
		
		for (int j=0;j<lMedicos.size();j++)
		{
			Medico oMedico = lMedicos.get(j);
			if (oMedico.getID().equals(new Long(ID)))				
			{			
				return oMedico;
			}
		}
		
		return null;
		
				
		// Devolvemos la lista de los objetos obtenidos en el XML, este metodo ya es propio del Handler y creado por nosotros
		//return handler.getList();
		
	}
	
	
	public void GrabarMedico(String PathXml, String ID, Medico _NewMedico) throws ParserConfigurationException, SAXException, IOException
	{
	
		File f = new File(PathXml);
		Procesar pMedicos= new Procesar(f);
				
		
		
		pMedicos.updateElementValue(_NewMedico);
	
		
	}
	
	/* SUMAMOS EL TOTAL DE  GUARDIAS A REALIZAR POR CADA RESIDENTE PARA RESTARSELAS Al MES DSPUES 
	 * 
	 *  HABRIA QUE REVISAR LAS VACACIONES 
	 *  2016-01-01 FORMAT 
	 *  
	 *  
	 *  
	 *  
	 *  int _daysOfMonth = com.guardias.Util.daysDiff(_cINI.getTime(),_cFIN.getTime());

	 *  */
	public static Long getGuardiasSinCubrir(Util.eTipo TipoMedico,  List<Medico> lMedicos, Calendar Inicio, Calendar Fin) throws ParseException
	{		
		
		int _daysOfMonth = com.guardias.Util.daysDiff(Inicio.getTime(),Fin.getTime());

		DateFormat _format = new SimpleDateFormat("yyyy-MM-dd");
		
		int TOTAL=0;
		
		int _DIAS_VACACIONES = 0;
		int _MAX_GUARDIAS = 0;
		
		Calendar _cINICIO = Calendar.getInstance();
		
		_cINICIO.setTimeInMillis(Inicio.getTimeInMillis());
		
		for (int i=0;i<lMedicos.size();i++)
		{
									
			Medico oMedico = lMedicos.get(i);
			
			_DIAS_VACACIONES = 0;
			_MAX_GUARDIAS = 0;
			
			// quitamos al simulado 
			if (oMedico.isActivo() && oMedico.getTipo().equals(TipoMedico) && !oMedico.getSubTipoResidente().equals(Util.eSubtipoResidente.SIMULADO))
			{
				_MAX_GUARDIAS = oMedico.getMax_NUM_Guardias().intValue();
				
				_cINICIO.setTimeInMillis(Inicio.getTimeInMillis());
										
				for (int j=1;j<=_daysOfMonth;j++)	
				{
				
					String _DATE = _format.format(_cINICIO.getTime());
					//2016-01-01/2016-01-10
					if (!ProcesarMedicos.NoTieneVacaciones(oMedico, _DATE))  // ésta de vacaciones				
					{	
						_DIAS_VACACIONES++;				
					}
					_cINICIO.add(Calendar.DAY_OF_MONTH, 1);
				}
				
				
				
				// acumulamos las guardias potenciales menos las vacaciones posibles.				
				if (_MAX_GUARDIAS-_DIAS_VACACIONES>0)  // solo acumulamos los margenes positivos 
					TOTAL += (_MAX_GUARDIAS-_DIAS_VACACIONES);
				
				
				
				
			}
		}
		if (TOTAL>=_daysOfMonth) TOTAL=0;
		
		return new Long(TOTAL);
	}
	
	
	
	public static Long getNumeroResidentes(List<Medico> lMedicos) throws ParseException
	{		
		
		int TOTAL=0;
		
		for (int j=0;j<lMedicos.size();j++)
		{
			Medico oMedico = lMedicos.get(j);
			if (oMedico.isActivo() && oMedico.getTipo().equals(Util.eTipo.RESIDENTE))				
			{	
				TOTAL++;				
			}
		}
				
		
		return new Long(TOTAL);
	}
	
	
	/* PARA DISTRIBUIR LOS PRIMEROS RESIDENTES ENTRE LOS QUE NO PUEDEN ESTAR SOLOS */
	
	public static boolean ExisteMedicoConGuardiaSolo_EnElMes(HashMap<Long, Hashtable> _listaGuardiasActuales, List<Medico> lMedicos, Long OptionalDay) throws ParseException
	{
		
		boolean Existe = false;
		Iterator entries = _listaGuardiasActuales.entrySet().iterator();
		Medico oMedico = null; 
		Long keyMEDICO = new Long(-1);
		while (entries.hasNext()) 
		{
			
		  Entry thisEntry = (Entry) entries.next();
		  keyMEDICO = (Long) thisEntry.getKey();
		  if (!ExisteMedicoPorId(lMedicos,keyMEDICO))		  
			  continue;
		  oMedico= GetMedicoPorID(lMedicos,keyMEDICO);
		  Hashtable<String, String> lDatosTemp = (Hashtable) thisEntry.getValue();
		  
		  
		  if (oMedico.isGuardiaSolo())
		  {
			 // si es para un dia en particular 
			  if (!OptionalDay.equals(new Long(-1)))
			  {
				  if (lDatosTemp.containsKey(OptionalDay))
					  return true;
				  
			  }
			  else
				  return true;  
			  
			  
		  }
		  
		  keyMEDICO = (Long) thisEntry.getKey(); 
		}  
		
		return Existe;
	}
	
	
	/* public  static  Hashtable  getDatosGuardiasMedico(Long _IdMedico, HashMap<Long, Hashtable> _ListaGuardiasMedicos, Util.eTipo TipoMedico, List<Medico> lMedicos) throws ParseException
	{		
		
		Iterator entries = _ListaGuardiasMedicos.entrySet().iterator();	
		Long keyMEDICO = new Long(-1);
		
		boolean bEncontrado= false;
		
		Hashtable lDatosTemp=null;
		
		while (entries.hasNext() && !bEncontrado) 
		{
		  Entry thisEntry = (Entry) entries.next();
		  keyMEDICO = (Long) thisEntry.getKey(); 
		  // puede ser un adjunto  en una lista de residente
		  if (!ExisteMedicoPorId(lMedicos,keyMEDICO))		  
			  continue;
		  
		   lDatosTemp = (Hashtable) thisEntry.getValue();
		  if (keyMEDICO.equals(_IdMedico))
			  bEncontrado =true;
		

		} 						
		return lDatosTemp;
	}
	*/
	
	/* 
	[1]
	[7]
	[0]
	DiaMes --> Dia actual para agregarle guardias o no
	*/
	
	public  static Long getMedicoGuardiaDia(int _DiaMes, HashMap<Long, Hashtable> _ListaGuardiasMedicos, Util.eTipo TipoMedico, List<Medico> lMedicos) throws ParseException
	{		
		
		Iterator entries = _ListaGuardiasMedicos.entrySet().iterator();

		Medico oMedico = null; 
		
		Long keyMEDICO = new Long(-1);
		
		boolean bEncontrado= false;
		
		Medico _oM = null;
		
		while (entries.hasNext() && !bEncontrado) 
		{
		  Entry thisEntry = (Entry) entries.next();
		  keyMEDICO = (Long) thisEntry.getKey(); 
		  // puede ser un adjunto  en una lista de residente
		  if (!ExisteMedicoPorId(lMedicos,keyMEDICO))		  
			  continue;
		  
		  _oM= GetMedicoPorID(lMedicos,keyMEDICO);
		  Hashtable lDatosTemp = (Hashtable) thisEntry.getValue();		  		  
		  /* cada subclave del medico, buscamos si tiene el dia DiaMes */
		  Iterator entriesDAYS = lDatosTemp.entrySet().iterator();		  	 	  
		  		 
		   
		  while (entriesDAYS.hasNext()) 
		  {
			  Entry thisEntryDAYS = (Entry) entriesDAYS.next();
			  String keyDAY = "";
			  if (thisEntryDAYS.getKey() instanceof String)  // es un dia o un totalizador
				  keyDAY = (String) thisEntryDAYS.getKey();				  
			  else
				  keyDAY = thisEntryDAYS.getKey().toString();
			  			  
			  if (_oM.getTipo().equals(TipoMedico) && keyDAY.equals(String.valueOf(_DiaMes)))  // lo encuentra
			  {
				  bEncontrado = true;
				  break;
				  
				  
			  }				  
		 }
		} 
						
		return keyMEDICO;
	}
	
	/* PARA LOS DIAS INICIALES QUE SE VERIFICA EL QUE MENOS GUARDIA LOCALIZADA Y REFUERZO, ESTO NOS DA SI NO HAY NINGUNO PREVIO
	 * PARA LO QUE EL ALEATORIO NOS AYUDARA
	 */

	public  static boolean ExisteTipoGuardiaPrevia (HashMap<Long, Hashtable> _ListaGuardiasMedicos,
			Util.eTipoGuardia TipoGuardiaDiaMes) throws ParseException
	{
		boolean _Encontrado = false;
		
		Iterator entries = _ListaGuardiasMedicos.entrySet().iterator();
				
		/* 1=PRESENCIA */
		while (entries.hasNext()) 
		{
		  Entry thisEntry = (Entry) entries.next();		  
		  Hashtable lDatosTemp = (Hashtable) thisEntry.getValue();	
		  		  
		  
		  if (lDatosTemp.containsValue(TipoGuardiaDiaMes.toString()))
		  {	  
			  _Encontrado =true;
			  break;
		  }
		  // residente ?
		 }
				
		return _Encontrado;
		
	}
		

	
	
	
	/* LOS ADJUNTOS PUEDE ESTAR X DIAS SEGUIDOS EXCEPTO PRESENCIA - PRESENCIA  
	 * DIAMES ES EL DIA DE GUARDIA
	 * TipoGuardiaDiaMes ES LA GUARDIA CON LA QUE PUEDE ENTRAR EL DIA 
	 * MaxDiasPuedeAdjunto : LIMITE SI LO HAY QUE TIENE
	 * 
	 * CONSIDERAMOS QUE SE ENVIA LISTA DE DIAS DEL ADJUNTO
	 * 
	 *  
	 *  ERROR, ESTABA REVISANDO HACIA ATRAS, PERO LAS PRESENCIAS ESTÁN YA PUESTAS, CON LO QUE HABRIA QUE MIRAR HACIA ATRAS Y DELANTE */
	  
	public  static boolean ExcedeAdjuntoDiasSeguidos(int _DiaMes, Hashtable _ListaDias, long MaxDiasPuedeAdjunto,
			Util.eTipoGuardia TipoGuardiaDiaMes, int TotalDiasMes ) throws ParseException
	{		
		
		int TOTAL=0;
		
		boolean _result=false;
		
		/* PRESENCIA - PRESENCIA  ---> INCIDENCIA PARA QUE NO PUEDA DARSE */		
		
		Util.eTipoGuardia GuardiaDiaN = null; 
		Util.eTipoGuardia GuardiaDiaN1=null;
		
		GuardiaDiaN  = TipoGuardiaDiaMes;
		
		String KeyValue = "";
		
		/* HACIA ATRAS */
		
		for (int j=_DiaMes-1;j>=1;j--)
		{
			/* si es la primera iteracion, dejamos el valor de guardia N la que llega por parametro */
			if (j!=_DiaMes-1)			
				GuardiaDiaN  = Util.eTipoGuardia.valueOf(KeyValue);
			
			if (_ListaDias.containsKey(new Long(j)))// existe el día
			{				
				// obtenemos el tipo de guardia
				KeyValue = (String) _ListaDias.get(new Long(j));
				TOTAL++;
								
			}				
			else  // si no existe el día n-1, salimos, porque ya no sería secuencial hacia atras
			{	 break; }			
						
			GuardiaDiaN1  = Util.eTipoGuardia.valueOf(KeyValue);
			
			
			/* RESTRICCION PRESENCIA - PRESENCIA ADJUNTOS */
			if (GuardiaDiaN.equals(Util.eTipoGuardia.PRESENCIA) &&
					GuardiaDiaN1.equals(Util.eTipoGuardia.PRESENCIA))
			{
				
				_result= true;				
			}
						
					
		}
		
		/* no es presencia presencia */
		if (!_result)
		{
					
		
			/* HACIA DELANTE POR LAS PRESENCIAS YA PUESTAS DE ANTEMANO */
			for (int j=_DiaMes+1;j<=TotalDiasMes;j++)
			{
				/* si es la primera iteracion, dejamos el valor de guardia N la que llega por parametro */
				if (j!=_DiaMes+1)			
					GuardiaDiaN  = Util.eTipoGuardia.valueOf(KeyValue);
				
				if (_ListaDias.containsKey(new Long(j)))// existe el día
				{				
					// obtenemos el tipo de guardia
					KeyValue = (String) _ListaDias.get(new Long(j));
					TOTAL++;
									
				}				
				else  // si no existe el día n-1, salimos, porque ya no sería secuencial hacia atras
				{	 break; }			
							
				GuardiaDiaN1  = Util.eTipoGuardia.valueOf(KeyValue);
				
				
				/* RESTRICCION PRESENCIA - PRESENCIA ADJUNTOS */
				if (GuardiaDiaN.equals(Util.eTipoGuardia.PRESENCIA) &&
						GuardiaDiaN1.equals(Util.eTipoGuardia.PRESENCIA))
				{
					
					_result= true;				
				}
							
						
			}
		} // fin si no es presencia - presencia
		//System.out.println("GuardiaDiaN: " + GuardiaDiaN + ",GuardiaDiaN1:" + GuardiaDiaN  + ",TOTAL:" + TOTAL + ":MaxDiasPuedeAdjunto:" +  MaxDiasPuedeAdjunto);
		if (TOTAL>= MaxDiasPuedeAdjunto)
		 {
			_result = true;
		 }
				
			return _result;					
	}
	
	
	/* LOS RESIDENTES  PUEDE ESTAR X DIAS SEGUIDOS EXCEPTO PRESENCIA - PRESENCIA  */ 
	public  static int getDiasPreviosConGuardiasSeguidos(int _DiaMes, Hashtable _ListaDias, int TotalDiasMes ) throws ParseException
	{		
		
		int TOTAL=0;
		
		/* OJO, LOS RESIDENTES PUEDEN ESTAR LOS DIAS PREVIOS O ASIGNADOS HACIA DELANTE */
		for (int j=_DiaMes-1;j>=1;j--)
		{
			if (_ListaDias.containsKey(new Long(j)))// existe el día
				TOTAL++;
			else  // si no existe el día n-1, salimos, porque ya no sería secuencial hacia atras
				 break;			
		}
		for (int j=_DiaMes+1;j<=TotalDiasMes;j++)
	
		{
			if (_ListaDias.containsKey(new Long(j)))// existe el día
				TOTAL++;
			else  // si no existe el día n-1, salimos, porque ya no sería secuencial hacia atras
				 break;			
		}
						
		return TOTAL;
	}
	
/*
	[1] --> IDMEDICO
	
		[_NUMERO_GUARDIAS_RESIDENTE_MES]
		[_TOTAL_GUARDIAS_RESIDENTE_FESTIVO]
		[0]  --> DIA GUARDIA
		[1]  --> DIA GUARDIA
		[2]	 --> DIA GUARDIA	
				
				
*/

	
	public static boolean TodosResidentesCupoMaximo (HashMap<Long, Hashtable> _ListaGuardiasMedicos, List<Medico> listaMedico) throws ParseException
	{
		
		Iterator entries = _ListaGuardiasMedicos.entrySet().iterator();
				
		
		while (entries.hasNext()) 
		{
		  Entry thisEntry = (Entry) entries.next();
		  Long keyMEDICO = (Long) thisEntry.getKey();
		  Hashtable lDatosTemp = (Hashtable) thisEntry.getValue();	
		  // residente ?
		  if (lDatosTemp.get("_TIPO").equals(Util.eTipo.RESIDENTE))
		  {
			  /*if (keyMEDICO.longValue()!=_Medico)  // RESTO, vamos comparando para sacar el mínimo de todos.
			  {*/		  
			  Long _TotalMedicoD = Long.parseLong(lDatosTemp.get("_NUMERO_GUARDIAS_RESIDENTE_MES").toString());
			  Long _TotalMedicoF = Long.parseLong(lDatosTemp.get("_TOTAL_GUARDIAS_RESIDENTE_FESTIVO").toString());
			  Long _Total = _TotalMedicoD +_TotalMedicoF;  
			  Medico oMedico = null;
			  /* es el que menos tiene y puede hacer mas porque no supera el margen total*/
			  for (int j=0;j<listaMedico.size();j++)
			  {
				oMedico = listaMedico.get(j);
				if (oMedico.getID().equals(keyMEDICO))				
				{	
					break;				
				}
			  }
			  if (!oMedico.getSubTipoResidente().equals(Util.eSubtipoResidente.SIMULADO))
			  {	  
				  if (_Total.longValue()!=oMedico.getMax_NUM_Guardias().longValue())
				  {	  
					  return false;				  
				  }
				  
			  }		  
		  }
		
		}
		return true;
		
	}
	
	/* recorremos los adjuntos para ver si hay equidad  y si no excede del numero de dias maximo por semana 
	[1] --> IDMEDICO
	
    [_TIPO] --> RESIDENTE
    [_SUBTIPO] --> R1....R2....SIMULADO...ROTANTE
	[_NUMERO_GUARDIAS_RESIDENTE_MES]
	[_TOTAL_GUARDIAS_RESIDENTE_FESTIVO]				
	[0]  --> DIA GUARDIA    o POOL DAY
	[1]  --> DIA GUARDIA    o POOL DAY
	[2]	 --> DIA GUARDIA	o POOL DAY
	
	*
	*[5] --> IDMEDICO

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
	*
	*/
	
	/* ME DA EL NUMERO DE DIAS QUE TIENE LA SEMANA, PARA PODER EXIGIR COMO MAXIMO ESTE  DE NUMERO SIMUILADOS */		
	public static  int  DiasSemanaCursoDentroMes(Calendar FechaActual , int MesActual)
	{
	//	boolean asignarseComoSimulado=false;

		
		/* INICIO Y FIN DE LA SEMANA DEL DIA A CALCULAR , LUNES A DOMINGO */
		int Dias=0;
		
		Calendar cINI = Calendar.getInstance();  // MONDAY  
		Calendar cFIN = Calendar.getInstance();  // SUNDAY
		cINI.setTimeInMillis(FechaActual.getTimeInMillis()); /* NORMALMENTE DE 1 A 8 15...*/
		final int currentDayOfWeek = (cINI.get(Calendar.DAY_OF_WEEK) + 7 - cINI.getFirstDayOfWeek()) % 7;		
		//
		// LUNES 
		cINI.add(Calendar.DAY_OF_YEAR, -currentDayOfWeek);
		// DOMINGO
		cFIN.setTimeInMillis(cINI.getTimeInMillis());
		cFIN.add(Calendar.DATE, 6);		
		int _days = 7;
		
		for (int j=1;j<=_days;j++)	
		{
			// no me salgo del mes en curso cINI.get(Calendar.MONTH)==cFIN.get(Calendar.MONTH) && 
			if (cINI.get(Calendar.MONTH)==MesActual)
				Dias++;
			cINI.add(Calendar.DATE, 1);
			
		}
					
		//System.out.println(_sFormat.format(_Date1) +",dias en esa semana:" + Dias );
		return Dias;
	}
	
	public static  int  NumeroResidentesSemana(Calendar FechaActual, HashMap<Long, Hashtable> _ListaGuardiasMedicos, boolean bSimuladosIncluded, int MesActual)
	{

		//	boolean asignarseComoSimulado=false;

		int simuladosSemana =0;
		
		
		/* INICIO Y FIN DE LA SEMANA DEL DIA A CALCULAR , LUNES A DOMINGO */
		Calendar cINI = Calendar.getInstance();  // MONDAY  
		Calendar cFIN = Calendar.getInstance();  // SUNDAY
		cINI.setTimeInMillis(FechaActual.getTimeInMillis());
		
		
		final int currentDayOfWeek = (cINI.get(Calendar.DAY_OF_WEEK) + 7 - cINI.getFirstDayOfWeek()) % 7;		 
		//calcSemanaCal.set(Calendar., Calendar.WEDNESDAY);
		cINI.add(Calendar.DATE , -currentDayOfWeek);
		int _days  = ProcesarMedicos.DiasSemanaCursoDentroMes(FechaActual, MesActual);
		if (_days<7)
		{
			cINI.setTimeInMillis(FechaActual.getTimeInMillis());
		}
		
		/* DESDE EL LUNES  HASTA EL DIA ACTUAL, SIN CAMBIO DE MES */
		for (int j=1;j<=_days;j++)	
		{
			/* QUE NO CAMBIE DE MES */
			if (cINI.get(Calendar.MONTH)==FechaActual.get(Calendar.MONTH))
			{
		
				Iterator entries = _ListaGuardiasMedicos.entrySet().iterator();	
				while (entries.hasNext()) 
				{
				  Entry thisEntry = (Entry) entries.next();
				  Long keyMEDICO = (Long) thisEntry.getKey();
				  Hashtable lDatosTemp = (Hashtable) thisEntry.getValue();
				  /* ES RESIDENTE Y SIMULADO OPCIONAL PARA EL DIA EN CUESTION DE LA SEMANA */
				  if (lDatosTemp.get("_TIPO").equals(Util.eTipo.RESIDENTE) &&  (!bSimuladosIncluded || (bSimuladosIncluded && lDatosTemp.get("_SUBTIPO").equals(Util.eSubtipoResidente.SIMULADO)))
						  && lDatosTemp.containsKey(new Long(cINI.get(Calendar.DATE))))
				  {
					  simuladosSemana++;
				  }
				
				}
				
				
			} // fin  QUE NO CAMBIE DE MES 
			
			cINI.add(Calendar.DATE, 1);			
		}
					
		
		return simuladosSemana;
	}
	
	
	/* public static  int  NumeroSimuladosSemana(Calendar FechaActual, HashMap<Long, Hashtable> _ListaGuardiasMedicos)
	{
			return NumeroResidentesSemana(FechaActual, _ListaGuardiasMedicos, true);
	}
	*/
	/* LOS ADJUNTOS TIENEN LA CLAVE DE ASIGNACIONES SIMULADAS DIARIAS Y TOTALES PARA SABER POR AQUI CUANTOS SIMULADOS TIENEN 
	 * 
	 * _TOTAL_SIMULADO_DIARIO_MES	
	   _TOTAL_SIMULADO_FESTIVOS_MES
	 * */
	
	
	/* APLICAMOS UN MARGEN O DIFERENCIA O UMBRAL QUE ME PERMITA ASIGNAR SIMULADOS A UN RANGO MAYOR, PARA EVITAR QUE NOS QUEDEMOS SIN HUECOS Y SE ASIGNE AL MISMO */
	
	public static  List<Long>  ListAdjuntoConMenosSimulados(HashMap<Long, Hashtable> _ListaGuardiasMedicos, List<Medico> listaMedico, 
			int _Dia, boolean EsFestivo) throws ParseException
	{		
		

		/* TOTAL Y CLAVE 					
		/* ACCEDEMOS A LAS GUARDIAS POR MEDICO DE MANERA ALEATORIA */

		Map<Long,Long> lUnSortedListaGuardiasMedicos = new HashMap <Long, Long>();
		List<Long> keys = new ArrayList(_ListaGuardiasMedicos.keySet()); 

		String _KeyTOTAL ="";
	    for ( Long obj : keys ) {
			
	    	_KeyTOTAL ="_TOTAL_" + Util.eSubtipoResidente.SIMULADO + "_DIARIO_MES"; 
    		if (EsFestivo)
				_KeyTOTAL= "_TOTAL_" + Util.eSubtipoResidente.SIMULADO + "_FESTIVOS_MES";
    		
    		Hashtable  DatosGuardias = _ListaGuardiasMedicos.get(obj);
    		Long Total =  new Long(0);
    		if (DatosGuardias.containsKey(_KeyTOTAL))   
    		{	
    			Total =  Long.parseLong(DatosGuardias.get(_KeyTOTAL).toString());    		
    			lUnSortedListaGuardiasMedicos.put(obj, Total);
    		}
		   
		}
	    
	    Set<Entry<Long, Long>> mapEntries = lUnSortedListaGuardiasMedicos.entrySet();
        
        List<Map.Entry<Long, Long>> lSortedListaGuardiasMedicos = new ArrayList<Map.Entry<Long, Long>>();
        
        for(Entry<Long, Long> entry : mapEntries) {
       //     System.out.println(entry.getValue() + " - "+ entry.getKey());

            lSortedListaGuardiasMedicos.add(entry);
        }
        
        // used linked list to sort, because insertion of elements in linked list is faster than an array list. 
        

        // sorting the List
        ByTotalesGuardiasDESC _ComparadorPorTotalesDES  = new ByTotalesGuardiasDESC();
        
        Collections.sort(lSortedListaGuardiasMedicos, _ComparadorPorTotalesDES);
        
     // Storing the list into Linked HashMap to preserve the order of insertion. 
        Map<Long,Long> aMapSorted = new LinkedHashMap<Long, Long>();
        for(Entry<Long,Long> entry: lSortedListaGuardiasMedicos) {
        	aMapSorted.put(entry.getKey(), entry.getValue());
        }
        
      	long _MININO_RESTO_MEDICOS = 9999999;
		
		List<Long> lIDMEDICOMenosSimulados = new ArrayList<Long>();
		
		
		java.util.Map<Long, Hashtable> _NewSortedByTotal =   new java.util.LinkedHashMap<Long, Hashtable>();
		 for(Entry<Long,Long> entry : aMapSorted.entrySet()) {
	     //       System.out.println(entry.getValue() + " - " + entry.getKey());
	            _NewSortedByTotal.put(entry.getKey(), _ListaGuardiasMedicos.get(entry.getKey()));
	     }
	        
		
		
		/* FIN ACCEDEMOS A LAS GUARDIAS POR MEDICO DE MANERA ALEATORIA */
		
		
		
		Iterator entries = _NewSortedByTotal.entrySet().iterator();
		
		//Iterator  entries = _ListaGuardiasMedicos.keySet().iterator();
		int Contador=1;
		int MenorTotal = 0;
		while (entries.hasNext()) 
		{
		
		  Entry thisEntry = (Entry) entries.next();
		  Long keyMEDICO = (Long) thisEntry.getKey();
		  Hashtable lDatosTemp = (Hashtable) thisEntry.getValue();
		  
		  if (ExisteMedicoPorId(listaMedico,keyMEDICO))		  
		  {	 		  
			  
			  Long _TotalMedico = Long.parseLong(lDatosTemp.get(_KeyTOTAL).toString());
			  Medico oMedico = GetMedicoPorID(listaMedico,keyMEDICO);			  
			  // del total de adjuntos, sacamos por orden de menor simulados siempre que no puedan estar solo???
			  
			  if (!oMedico.isGuardiaSolo())		  
			  {	  
				  if (Contador==1) { 
					  	MenorTotal = _TotalMedico.intValue();
					  	Contador++;  			
				  
				  }
				  
				  /* 2017-02-02  
				   *  con un distribucion de adjuntos 
				   * 
				   */
				  Long DIFERENCIA_MAX_SIMULADOS_ADJUNTOS = Long.parseLong(ConfigurationDBImpl.GetConfiguration(Util.getoCONST_DIFERENCIA_MAX_SIMULADOS_POR_ADJUNTO_MES()).getValue());
				  
				  
				  if (_TotalMedico.longValue()<=  MenorTotal+DIFERENCIA_MAX_SIMULADOS_ADJUNTOS.intValue())  // devolvemos una lista de adjuntos para poder elegir varios
					  
					  System.out.println("Medico:" + oMedico.getApellidos() + "," + oMedico.getNombre() + "TotalSimulados:" + _TotalMedico + ",_MININO_:" + _MININO_RESTO_MEDICOS);
					  // siempre que esten dentro del margen
					  lIDMEDICOMenosSimulados.add(keyMEDICO);

			  }

		  }	  
		}		
						
		return lIDMEDICOMenosSimulados;
	}
	
	
	/* OJO CONTAMOS AQUELLOS QUE ESTAN ACTIVOS Y PUEDEN HACER GUARDIAS SOLOS */

	public static  Long  AdjuntoMenosGuardiasYHorasSeguidas(boolean EsSimulado, Util.eTipoGuardia _GuardiaTipo, String KeyTipoGuardia, HashMap<Long, Hashtable> _ListaGuardiasMedicos, List<Medico> listaMedico, 
			Long ExcluirIDMedicoPresencia, int _Dia, int DiasMes ) throws ParseException
	{		
		

		/* if (!_ListaGuardiasMedicos.containsKey(_Medico))  // primero que encuentre el registro del medico a buscar
			return _EsConMenosFestivosMes;			
		
		*/
		
		/* INTENTAMOS ORDENAR POR EL  QUE MENOS TOTALES  TENGA  PARA DAR LOS REFUERZOS  DE MANERA EQUITATIVA  */
		/* TOTAL Y CLAVE 					
		/* ACCEDEMOS A LAS GUARDIAS POR MEDICO DE MANERA ALEATORIA */

		Map<Long,Long> lUnSortedListaGuardiasMedicos = new HashMap <Long, Long>();
		List<Long> keys = new ArrayList(_ListaGuardiasMedicos.keySet());

		
		/* PRIMERO, ORDENAMOS POR EL TOTAL QUE MENOS TENGA */
		String _KeyTOTAL ="";
	    for ( Long obj : keys ) {
			
	    	_KeyTOTAL ="_TOTAL_GUARDIAS_MES"; 
    		if (KeyTipoGuardia.toString().contains("_FESTIVOS"))
				_KeyTOTAL= "_TOTAL_FESTIVOS_MES";
    		
    		Hashtable  DatosGuardias = _ListaGuardiasMedicos.get(obj);
    		Long Total =  new Long(0);
    		if (DatosGuardias.containsKey(_KeyTOTAL))    			
    			Total =  Long.parseLong(DatosGuardias.get(_KeyTOTAL).toString());
    		/* else
    			Total = new */
        	
    		lUnSortedListaGuardiasMedicos.put(obj, Total);
		   
		}
	    
	    Set<Entry<Long, Long>> mapEntries = lUnSortedListaGuardiasMedicos.entrySet();
        
       // System.out.println("Values and Keys before sorting :" + _GuardiaTipo  + ",clave a buscar de totales :" + _KeyTOTAL);
      
        List<Map.Entry<Long, Long>> lSortedListaGuardiasMedicos = new ArrayList<Map.Entry<Long, Long>>();
        
        for(Entry<Long, Long> entry : mapEntries) {
       //     System.out.println(entry.getValue() + " - "+ entry.getKey());

            lSortedListaGuardiasMedicos.add(entry);
        }
        
        // used linked list to sort, because insertion of elements in linked list is faster than an array list. 
        

        // sorting the List
        ByTotalesGuardiasDESC _ComparadorPorTotalesDES  = new ByTotalesGuardiasDESC();
        
        Collections.sort(lSortedListaGuardiasMedicos, _ComparadorPorTotalesDES);
        
     // Storing the list into Linked HashMap to preserve the order of insertion. 
        Map<Long,Long> aMapSorted = new LinkedHashMap<Long, Long>();
        for(Entry<Long,Long> entry: lSortedListaGuardiasMedicos) {
        	aMapSorted.put(entry.getKey(), entry.getValue());
        }
        
     // printing values after soring of map
  /*       System.out.println("After Sorted Value " + " - " + "Key");
        for(Entry<Long,Long> entry : aMapSorted.entrySet()) {
            System.out.println(entry.getValue() + " - " + entry.getKey());
        }
        
	 */   
		
		
		long _MININO_RESTO_MEDICOS = 9999999;
		
		Long IDMEDICOMenosSimulados = new Long(-1);
		/* 
		 * 	[_TOTAL_SIMULADO_MES]		
			[_TOTAL_SIMULADO_FESTIVOS_MES]
		 */
		java.util.Map<Long, Hashtable> _NewSortedByTotal =   new java.util.LinkedHashMap<Long, Hashtable>();
		 for(Entry<Long,Long> entry : aMapSorted.entrySet()) {
	     //       System.out.println(entry.getValue() + " - " + entry.getKey());
	            _NewSortedByTotal.put(entry.getKey(), _ListaGuardiasMedicos.get(entry.getKey()));
	     }
	        
		
		
		/* FIN ACCEDEMOS A LAS GUARDIAS POR MEDICO DE MANERA ALEATORIA */
		
		
		
		Iterator entries = _NewSortedByTotal.entrySet().iterator();
		
		//Iterator  entries = _ListaGuardiasMedicos.keySet().iterator();
		
		while (entries.hasNext()) 
		{
		
		  boolean ExcedeHorasSeguidasMedico  = false; 			
			
		  Entry thisEntry = (Entry) entries.next();
		  Long keyMEDICO = (Long) thisEntry.getKey();
		  Hashtable lDatosTemp = (Hashtable) thisEntry.getValue();		  
		  if (ExisteMedicoPorId(listaMedico,keyMEDICO) && !keyMEDICO.equals(ExcluirIDMedicoPresencia))		  
		  {	 		  
			  /* nos aseguramos ya que esta en la lista */
			  Long _TotalMedico = Long.parseLong(lDatosTemp.get(KeyTipoGuardia).toString());
			  Medico oMedico = GetMedicoPorID(listaMedico,keyMEDICO);
			  
			  
			  //int _GuardiasPreviasSeguidas = ProcesarMedicos.getDiasPreviosConGuardiasSeguidos(_Dia, lDatosTemp);
			  
			  /* PROBARRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR*/
			  
			  Long MAX_NUMERO_DIAS_SEGUIDOS_ADJUNTOS = Long.parseLong(ConfigurationDBImpl.GetConfiguration(Util.getoCONST_NUMERO_DIAS_SEGUIDOS_ADJUNTOS()).getValue());
			  
			  ExcedeHorasSeguidasMedico = ProcesarMedicos.ExcedeAdjuntoDiasSeguidos(_Dia, lDatosTemp, MAX_NUMERO_DIAS_SEGUIDOS_ADJUNTOS.longValue(),_GuardiaTipo, DiasMes);
			  
			//  System.out.println("IDMedicoPresencia:" + ExcluirIDMedicoPresencia + "_Dia: " + _Dia +  ",KeyTipoGuardia:" + KeyTipoGuardia + ",IdMedico:" + keyMEDICO    + ",Medico:" + oMedico.getApellidos() + ",ExcedeHorasSeguidasMedico:" +  ExcedeHorasSeguidasMedico + ",GuardiasHechasPreviasParaComparar(ElMenor):" + _TotalMedico + ",datos:" + lDatosTemp);
			  
			  // puede hacer guardias solo solo si es simulado ???
			  if ((!EsSimulado || (EsSimulado && oMedico.isGuardiaSolo())) &&  _TotalMedico.longValue()<_MININO_RESTO_MEDICOS && !ExcedeHorasSeguidasMedico)		  
			  {	  
				  _MININO_RESTO_MEDICOS = _TotalMedico.longValue();
				  IDMEDICOMenosSimulados = keyMEDICO;
				//  System.out.println("Medico:" + oMedico.getApellidos() + "," + oMedico.getNombre() + ",ExcedeHoras:" + ExcedeHorasSeguidasMedico + ",Guardia:" + _GuardiaTipo + ",dia:"+ _Dia + ",_MININO_RESTO_MEDICOS:" + _MININO_RESTO_MEDICOS);
			  }

		  }	  
		}		
						
		return IDMEDICOMenosSimulados;
	}
	
	public static  Long  ResidenteMenosGuardiasyNoExcedeDelTotal(HashMap<Long, Hashtable> _ListaGuardiasMedicos, List<Medico> listaMedico, String _Fecha, int DiaMes, int _TotalDiasMes) throws ParseException
	{
	
		Map<Long,Long> lUnSortedListaGuardiasMedicos = new HashMap <Long, Long>();
		//List<Long> keys = new ArrayList(listaMedico.keySet());
		
		
		
		
		long _TOTAL_GUARDIAS_FESTIVOS_MEDICO = 999999;
		
		long _MININO_GUARDIAS_RESTO_MEDICOS = 9999999;
		
		Long IDResidenteMenosGuardias = new Long(-1);
		
	
		String _KeyTOTAL ="";
	    for (Medico oMedico: listaMedico) {
	    	
	    	Long _TotalDiarias = new Long(0);
			  // DEJAMOS LOS FESTIVOS  SOLO
			  
			Long _TotalFestivos = new Long(0);
			Long _Total = new Long(0);
			
			
			
			boolean bEstaActivo = oMedico.isActivo();
  			boolean NoTieneVacaciones = NoTieneVacaciones(oMedico, _Fecha);
  			boolean ExcedeLimiteGuardiasMes = false;
  			  
  			Long MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS = new Long(0);
  			  
  			boolean ExcedeHorasSeguidas = false;
  			  // dia anterior o siguiente 
  			boolean TienePoolDayAsignadoDiaSgteAnterior = false;
			
  			if (!oMedico.isResidenteSimulado())  // y no simulado
  			{
  			
		    	if (_ListaGuardiasMedicos.containsKey(oMedico.getID()))
		    	{
		    		Hashtable  DatosGuardias = _ListaGuardiasMedicos.get(oMedico.getID());
		    		if (DatosGuardias.get("_TIPO").equals(Util.eTipo.RESIDENTE) && !DatosGuardias.get("_SUBTIPO").equals(Util.eSubtipoResidente.SIMULADO))  // y no simulado 
		    		{
		    		
		    		  
		    		  int _GuardiasPreviasSeguidas = ProcesarMedicos.getDiasPreviosConGuardiasSeguidos(DiaMes, DatosGuardias, _TotalDiasMes);
		   			  
		   			  bEstaActivo = oMedico.isActivo();
		   			  NoTieneVacaciones = NoTieneVacaciones(oMedico, _Fecha);
		   			  ExcedeLimiteGuardiasMes = _Total.longValue() >= oMedico.getMax_NUM_Guardias().longValue();
		   			  
		   			  MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS = Long.parseLong(ConfigurationDBImpl.GetConfiguration(Util.getoCONST_MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS()).getValue());
		   			  
		   			  ExcedeHorasSeguidas = _GuardiasPreviasSeguidas>=MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS.intValue();
		   			  // dia anterior o siguiente 
		   			  TienePoolDayAsignadoDiaSgteAnterior = (DatosGuardias.containsKey(new Long(DiaMes+1)) && DatosGuardias.get(new Long(DiaMes+1)).equals("POOLDAY") || 
		   					  				DatosGuardias.containsKey(new Long(DiaMes-1)) && DatosGuardias.get(new Long(DiaMes-1)).equals("POOLDAY"));
		   			  
		   			  _TotalFestivos = Long.parseLong(DatosGuardias.get("_TOTAL_GUARDIAS_RESIDENTE_FESTIVO").toString());
		    			
		    		}
		    		
		    		
		    	}
		    	
		    	_Total = _TotalDiarias + _TotalFestivos;
		    
		    		
		    	if (_TotalFestivos.longValue()<_MININO_GUARDIAS_RESTO_MEDICOS && 
						  	!ExcedeLimiteGuardiasMes && bEstaActivo && NoTieneVacaciones && !ExcedeHorasSeguidas  && !TienePoolDayAsignadoDiaSgteAnterior)
				{
					  
					  
					  
					  _MININO_GUARDIAS_RESTO_MEDICOS = _Total.longValue();
					  IDResidenteMenosGuardias = oMedico.getID();
					  
	
					  
					  
				}
	    }	// fin de residente simulado
	    		   
		}
	    return IDResidenteMenosGuardias;
	}
/*	public static  Long  ResidenteMenosGuardiasyNoExcedeDelTotal(HashMap<Long, Hashtable> _ListaGuardiasMedicos, List<Medico> listaMedico, String _Fecha, int DiaMes, int _TotalDiasMes) throws ParseException
	{		
		
		Iterator entries = _ListaGuardiasMedicos.entrySet().iterator();
		
		long _TOTAL_GUARDIAS_FESTIVOS_MEDICO = 999999;
		
		long _MININO_GUARDIAS_RESTO_MEDICOS = 9999999;
		
		Long IDResidenteMenosGuardias = new Long(-1);
		
		while (entries.hasNext()) 
		{
		  Entry thisEntry = (Entry) entries.next();
		  Long keyMEDICO = (Long) thisEntry.getKey();		  		 
		  Hashtable lDatosTemp = (Hashtable) thisEntry.getValue();		  
		  

		  if (lDatosTemp.get("_TIPO").equals(Util.eTipo.RESIDENTE) && !lDatosTemp.get("_SUBTIPO").equals(Util.eSubtipoResidente.SIMULADO))   
		  {
			  Long _TotalDiarias = new Long(0);
			  // DEJAMOS LOS FESTIVOS  SOLO
			  
			  Long _TotalFestivos = Long.parseLong(lDatosTemp.get("_TOTAL_GUARDIAS_RESIDENTE_FESTIVO").toString());
			  Long _Total = _TotalDiarias + _TotalFestivos;
			  
			
			  
			  //Long _TotalMedico = Long.parseLong(lDatosTemp.get("_NUMERO_GUARDIAS_RESIDENTE_MES").toString());
			  
			  //Long _Total = _TotalMedicoTempFestivos + _TotalMedico ;
			  Medico oMedico = null;
			
			  for (int j=0;j<listaMedico.size();j++)
			  {
				oMedico = listaMedico.get(j);
				if (oMedico.getID().equals(keyMEDICO))				
				{	
					break;				
				}
			  }
			  

			  int _GuardiasPreviasSeguidas = ProcesarMedicos.getDiasPreviosConGuardiasSeguidos(DiaMes, lDatosTemp, _TotalDiasMes);
			  
			  boolean bEstaActivo = oMedico.isActivo();
			  boolean NoTieneVacaciones = NoTieneVacaciones(oMedico, _Fecha);
			  boolean ExcedeLimiteGuardiasMes = _Total.longValue() >= oMedico.getMax_NUM_Guardias().longValue();
			  
			  Long MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS = Long.parseLong(ConfigurationDBImpl.GetConfiguration(Util.getoCONST_MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS()).getValue());
			  
			  boolean ExcedeHorasSeguidas = _GuardiasPreviasSeguidas>=MAX_NUMERO_DIAS_SEGUIDOS_RESIDENTESS.intValue();  
			  boolean TienePoolDayAsignadoDiaSgte = lDatosTemp.containsKey(new Long(DiaMes+1)) && lDatosTemp.get(new Long(DiaMes+1)).equals("POOLDAY");
			  
			  
			  //System.out.println("Residente:" + oMedico.getID() + ",idres-guardias:" +  IDResidenteMenosGuardias + ",_TotalFestivos:" + _TotalFestivos + ",MINIMO:" + _MININO_GUARDIAS_RESTO_MEDICOS +",POOL:" + TienePoolDayAsignadoDiaSgte) ;
			  
			  if (_TotalFestivos.longValue()<_MININO_GUARDIAS_RESTO_MEDICOS && 
					  	!ExcedeLimiteGuardiasMes && bEstaActivo && NoTieneVacaciones && !ExcedeHorasSeguidas  && !TienePoolDayAsignadoDiaSgte)
			  {
				  
				  
				  
				  _MININO_GUARDIAS_RESTO_MEDICOS = _Total.longValue();
				  IDResidenteMenosGuardias = oMedico.getID();
				  
				//  System.out.println("Residente con menos guardias :" + IDResidenteMenosGuardias + ",medico:" ) ;
				  
				  
			  }
		  }
		}
		
		
		
		//System.out.println("Residente con menos guardias :" + IDResidenteMenosGuardias + ",medico:" + _Borrar.getApellidos()) ;	
		return IDResidenteMenosGuardias;
	}*/
	
	public static Medico GetMedicoPorID(List<Medico> lMedicos, Long IdMedico) throws ParseException
	{		
		
		
				
		Medico oMedico = null;
		for (int j=0;j<lMedicos.size();j++)
		{
			oMedico = lMedicos.get(j);
			if (oMedico.getID().equals(IdMedico))				
			{	
				break;				
			}
		}			
		return 		oMedico;
	}
	
	public static boolean ExisteMedicoPorId(List<Medico> lMedicos, Long IdMedico) throws ParseException
	{		
		
		boolean _bEncontrado = false;
				
		
		for (int j=0;j<lMedicos.size();j++)
		{
			Medico oMedico = lMedicos.get(j);
			if (oMedico.getID().equals(IdMedico))				
			{	
				_bEncontrado = true;
				break; 
			}
		}			
		return 		_bEncontrado;
	}
	
	
	public static List<Medico> getAdjuntos(List<Medico> lMedicos, boolean ordered) throws ParseException
	{		
		
		List<Medico> _lResidentes = new ArrayList();
		
		for (int j=0;j<lMedicos.size();j++)
		{
			Medico oMedico = lMedicos.get(j);
			if (oMedico.isActivo() && oMedico.getTipo().equals(Util.eTipo.ADJUNTO))				
			{	
				_lResidentes.add(oMedico);				
			}
		}
		if (ordered)
			Collections.sort(_lResidentes,new ByOrdenComparator());		
		
		return _lResidentes;
	}
	
	
	public static List<Medico> getResidentes(List<Medico> lMedicos) throws ParseException
	{		
		
		List<Medico> _lResidentes = new ArrayList();
		
		for (int j=0;j<lMedicos.size();j++)
		{
			Medico oMedico = lMedicos.get(j);
			if (oMedico.isActivo() && oMedico.getTipo().equals(Util.eTipo.RESIDENTE))				
			{	
				_lResidentes.add(oMedico);				
			}
		}
				
		
		return _lResidentes;
	}
	
	
	 //2016-01-01
	public  static boolean NoTieneVacaciones(Medico oMedico, String _Date) throws ParseException
	{		
		
		DateFormat _format = new SimpleDateFormat("yyyy-MM-dd");
		
		List<Vacaciones_Medicos> oVacaciones =  VacacionesDBImpl.getVacacionesMedicos(oMedico.getID(), _Date); 
		
		if (oVacaciones.size()==0)				
			return true;
		else		
			return false;
	}
	public void AnadirMedico()
	{
	
	}
	public static void main(String[] args) {
		

		Calendar c = Calendar.getInstance();
		c.set(Calendar.DATE, 16);
		
		//DiasSemanaCursoDentroMes(c);
	/*	/Procesar pMedicos= new Procesar(Util.getStreamXMLDATA());
		java.util.List<Medico> lMedicos = new ArrayList();
		
		lMedicos = pMedicos.getMedicos();
		
		ProcesarMedicos t = new ProcesarMedicos();
		try {
			t.LeerMedicos();
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	*/	
	}
	
}



