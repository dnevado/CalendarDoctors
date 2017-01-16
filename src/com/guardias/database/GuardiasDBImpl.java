package com.guardias.database;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.guardias.Guardias;
import com.guardias.Medico;
import com.guardias.Util;


public class GuardiasDBImpl {

	public static  boolean DeleteGuardia(Long IdMedico, String Day)
	 {	  
		
		 
	  List<Medico> lMedicos = new ArrayList<Medico>();	 
		 
	  PreparedStatement stmt = null;	 
	  Connection MiConexion =ConexionGuardias.GetConexionGuardias();
	  
	  
			  
	  
	  String stSQL = "DELETE FROM guardias_medicos WHERE FGuardia=(?)";
	  
	  if (!IdMedico.equals(new Long(-1)))
	  {
			stSQL+=" and  IdMedico=" + IdMedico;
	  }
	  	   
	 try
	 {
	 
		 stmt = MiConexion.prepareStatement(stSQL);
		 stmt.setString(1, Day);
		  if (!IdMedico.equals(new Long(-1)))
		  {
			  stmt.setLong(2, IdMedico);
		  }
		  
		  
			  	  
	
	  MiConexion.setAutoCommit(true);
	 stmt.executeUpdate();
   stmt.close();
   
   MiConexion.close();
   
   
   
	  } catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			try {
				if (!MiConexion.isClosed())
					MiConexion.close();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
	
	  return true;    		 
	  }
	
	public static  boolean AddGuardia(Guardias _oG)
	 {	  
				 	  
		 
	  PreparedStatement stmt = null;	 
	  Connection MiConexion =ConexionGuardias.GetConexionGuardias();
	  
	  
	  String stSQL = "INSERT INTO guardias_medicos (IdMedico , FGuardia , Festivo, Tipo " +
	  ") VALUES (" +
	  " (?) ,  (?),  (?) , (?) ) ";
	  	  
	  
	  
	  
	 try
	 {
	 
		  stmt = MiConexion.prepareStatement(stSQL);
		  stmt.setLong(1, _oG.getIdMedico());
		  stmt.setString(2, _oG.getDiaGuardia());	
		  stmt.setLong(3, _oG.isEsFestivo());
		  stmt.setString(4, _oG.getTipo());
		  
	  //System.out.println(stSQL + ",IdMedico:" + IdMedico + "," + 	_oMedico.getNombre() + ",setAutoCommit(true);") ;  
	
		  MiConexion.setAutoCommit(true);
		  stmt.executeUpdate();
		  stmt.close();
    
    MiConexion.close();
    
    
    
	  } catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			try {
				if (!MiConexion.isClosed())
					MiConexion.close();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
	
	  return true;    		 
	  }
	
	
	public static  List<Guardias>  getGuardiasMedicoFecha(Long IdMedico, String _FGuardia)
	{
		return getGuardias(IdMedico, _FGuardia, "", new Long(-1));
				
	}
	
	 public static  List<Guardias>  getGuardiasPorFecha(String _FGuardia)
	 {
		 return getGuardias(new Long(-1), _FGuardia,  "", new Long(-1));
	 }
	 
	 /* HISTORICO 
	  * _TipoGuardia --> presencia, localizada , refuerzo
	  * 	si es residente, ""
	  * */
	 public static  int  getTotalGuardiasPorMedicoTipo(Long IdMedico, String _TipoGuardia, Long Festivo)
	 {
		 return getGuardias(IdMedico, "", _TipoGuardia,Festivo).size();
	 }	  
	
	 
	 public static  List<Guardias>  getGuardiasPorMedico(Long IdMedico)
	 {
		 return getGuardias(IdMedico, "", "", new Long(-1));
	 }	  
	
	 private  static  List<Guardias>  getGuardias(Long IdMedico, String _FGuardia , String _TipoGuardia, Long Festivo)
	 {	  
		
		 
	  List<Guardias> lGuardias = new ArrayList<Guardias>();	 
		 
	  Statement stmt = null;	 
	  Connection MiConexion =ConexionGuardias.GetConexionGuardias();
		
	  	  
	  
	  try {
		  
		
		  
		stmt = MiConexion.createStatement();
		
		String stSQL= "SELECT * FROM guardias_medicos";
		boolean ExisteId = false;
		
		if (!IdMedico.equals(new Long(-1)))
		{
			stSQL+=" WHERE IdMedico=" + IdMedico;
		}
		if (!_FGuardia.equals(""))
			if (ExisteId)							
				stSQL+=" and  FGuardia=" + _FGuardia; 
			else
				stSQL+=" WHERE  FGuardia='" + _FGuardia + "'";
		
		if (!_TipoGuardia.equals(""))		
			stSQL+=" AND Tipo = '" + _TipoGuardia + "'";
		
		if (!Festivo.equals(new Long(-1)))
		{
			stSQL+=" AND  Festivo=" + Festivo;
		}
		
		stSQL+=" ORDER BY Id desc";
		
		ResultSet rs = stmt.executeQuery( stSQL);
		
		
       while ( rs.next() ) {
    	  
    	 Guardias oGuardias = new Guardias(); 
    	  
         int id = rs.getInt("id");
         int idmedico  = rs.getInt("idmedico");
         String  fguardia = rs.getString("fguardia");         
         String  tipo = rs.getString("tipo");         
         int festivo   = rs.getInt("festivo");         
         
         oGuardias.setID(new Long(id));
         oGuardias.setIdMedico(new Long(idmedico));
         oGuardias.setDiaGuardia(fguardia);
         oGuardias.setTipo(tipo);
         oGuardias.setEsFestivo(new Long(festivo));
         
         lGuardias.add(oGuardias);
         
         
      
      }
      rs.close();
      stmt.close();
      MiConexion.close();
      
      
      
	  } catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			try {
				if (!MiConexion.isClosed())
					MiConexion.close();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
	
	  return lGuardias;    		 
	  } 
	
	 
	 public static  Medico  getUltimoIDMedico()
	 {	  
			
		 
		  Medico Medicos = new Medico();	 
			 
		  Statement stmt = null;	 
		  Connection MiConexion =ConexionGuardias.GetConexionGuardias();
			
		  	  
		  
		  try {
			  
			
			  
			stmt = MiConexion.createStatement();
			
			String stSQL= "SELECT max(ID) ID FROM medicos";
						
			
			ResultSet rs = stmt.executeQuery( stSQL);
			
			
			  
			
	      while ( rs.next() ) {
	    	  
	    	 Medico MedicoDatabase = new Medico(); 
	    	  
	         int id = rs.getInt("ID");
	        	         
	         MedicoDatabase.setID(new Long(id));
	        
	      //   lMedicos.add(MedicoDatabase);
	         
	         
	      
	      }
	      rs.close();
	      stmt.close();
	      MiConexion.close();
	      
	      
	      
		  } catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				try {
					if (!MiConexion.isClosed())
						MiConexion.close();
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
		
		  return Medicos;    		 
		  } 
	
	
	 

public static void main( String args[] )
{
	
}
}