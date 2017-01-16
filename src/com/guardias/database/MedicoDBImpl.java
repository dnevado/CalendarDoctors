package com.guardias.database;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.guardias.Medico;
import com.guardias.Util;


public class MedicoDBImpl {

	
	public static  boolean AddMedico(Medico _oMedico)
	 {	  
				 	  
		 
	  PreparedStatement stmt = null;	 
	  Connection MiConexion =ConexionGuardias.GetConexionGuardias();
	  
	  
	  String stSQL = "INSERT INTO medicos (nombre , idmedico , maxguardias , " +
	  "guardiassolo , orden , apellidos , tipo , subtipo, activo, email ) VALUES (" +
	  " (?) ,  (?),  (?) , (?) ,  (?),  (?),  (?) ,  (?),  (?),(?) ) ";
	  	  
	  
	  
	  
	 try
	 {
	 
		  stmt = MiConexion.prepareStatement(stSQL);
		  stmt.setString(1, _oMedico.getNombre());	
		  stmt.setLong(2, _oMedico.getIDMEDICO());
		  stmt.setLong(3, _oMedico.getMax_NUM_Guardias());
		  stmt.setLong(4, _oMedico.isGuardiaSolo() ? new Long(1): new Long(0));
		  stmt.setLong(5, _oMedico.getOrden());
		  stmt.setString(6, _oMedico.getApellidos());
		  stmt.setString(7, _oMedico.getTipo().toString());
		  stmt.setString(8, _oMedico.getSubTipoResidente().toString());
		  stmt.setLong(9, _oMedico.isActivo()? new Long(1): new Long(0));	
		  stmt.setString(10, _oMedico.getEmail());
	
		  
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
	
	
	public static  boolean UpdateMedico(Long IdMedico, Medico _oMedico)
	 {	  
		
		 
	  List<Medico> lMedicos = new ArrayList<Medico>();	 
		 
	  PreparedStatement stmt = null;	 
	  Connection MiConexion =ConexionGuardias.GetConexionGuardias();
	  
	  
			  
	  
	  String stSQL = "UPDATE medicos SET nombre = (?), idmedico = (?), maxguardias = (?), " +
	  "guardiassolo = (?), orden = (?), apellidos = (?), tipo = (?), subtipo= (?), activo = (?), Email=(?)" +
	   " WHERE id=(?)"		  ;
	  
	  
	  
	  
	  
	 try
	 {
	 
		  stmt = MiConexion.prepareStatement(stSQL);
		  stmt.setString(1, _oMedico.getNombre());	
		  stmt.setLong(2, _oMedico.getIDMEDICO());
		  stmt.setLong(3, _oMedico.getMax_NUM_Guardias());
		  stmt.setLong(4, _oMedico.isGuardiaSolo() ? new Long(1): new Long(0));
		  stmt.setLong(5, _oMedico.getOrden());
		  stmt.setString(6, _oMedico.getApellidos());
		  stmt.setString(7, _oMedico.getTipo().toString());
		  stmt.setString(8, _oMedico.getSubTipoResidente().toString());
		  stmt.setLong(9, _oMedico.isActivo()? new Long(1): new Long(0));
		  stmt.setString(10, _oMedico.getEmail());
		  stmt.setLong(11,IdMedico);
	
		  
	  System.out.println(stSQL + ",IdMedico:" + IdMedico + "," + 	_oMedico.getNombre() + ",setAutoCommit(true);") ;  
	
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
	
	/* PONEMOS LOS ULTIMOS INSERTADOS PARA QUE SEAN LOS ULTIMOS EN EL SIGUIENTE MES */
	public static  boolean OrdenarSecuenciasMedicoUltimaGuardia(Long OrdenHasta, Long MaxOrden, String TipoMedico)
	 {	  
		
	  PreparedStatement stmt = null;	 
	  Connection MiConexion =ConexionGuardias.GetConexionGuardias();
	  
	  
			  
	  
	  String stSQL = "UPDATE medicos SET orden = orden + (?) where orden <= (?) and tipo=(?)";	   
	  
	  
	 try
	 {
	 
		  stmt = MiConexion.prepareStatement(stSQL);
		  stmt.setLong(1, MaxOrden);
		  stmt.setLong(2, OrdenHasta);	
		  stmt.setString(3, TipoMedico);
		  
	  System.out.println(stSQL) ;  
	
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
	
	
	
	 public static  List<Medico>  getMedicos(Long IdMedico)
	 {	  
		
		 
	  List<Medico> lMedicos = new ArrayList<Medico>();	 
		 
	  Statement stmt = null;	 
	  Connection MiConexion =ConexionGuardias.GetConexionGuardias();
		
	  	  
	  
	  try {
		  
		
		  
		stmt = MiConexion.createStatement();
		
		String stSQL= "SELECT * FROM medicos";
		
		if (!IdMedico.equals(new Long(-1)))
			stSQL+=" WHERE id=" + IdMedico; 
		
		ResultSet rs = stmt.executeQuery( stSQL);
		
		
		  
		
      while ( rs.next() ) {
    	  
    	 Medico MedicoDatabase = new Medico(); 
    	  
         int id = rs.getInt("id");
         String  name = rs.getString("nombre");
         int idmedico  = rs.getInt("idmedico");
         int maxguardias  = rs.getInt("maxguardias");
         int guardiassolo  = rs.getInt("guardiassolo");
         int orden  = rs.getInt("orden");
         String  apellidos = rs.getString("apellidos");
         String  tipo = rs.getString("tipo") !=null ? rs.getString("tipo") : "";
         String  subtipo = rs.getString("subtipo")!=null && !rs.getString("subtipo").equals("") ? rs.getString("subtipo") : "";
         String  email = rs.getString("email")!=null && !rs.getString("email").equals("") ? rs.getString("email") : "";
         int activo  = rs.getInt("activo");
         
         MedicoDatabase.setID(new Long(id));
         MedicoDatabase.setNombre(name);
         MedicoDatabase.setActivo(activo==0 ? false : true);
         MedicoDatabase.setApellidos(apellidos);
         MedicoDatabase.setGuardiaSolo(guardiassolo==0 ? false : true);
         MedicoDatabase.setMax_NUM_Guardias(new Long(maxguardias));
         MedicoDatabase.setIDMEDICO(new Long(idmedico));
         MedicoDatabase.setTipo(Util.eTipo.valueOf(tipo));         
         MedicoDatabase.setEmail(email);
         MedicoDatabase.setOrden(new Long(orden));
         if (!subtipo.equals(""))
        	 MedicoDatabase.setSubTipoResidente(Util.eSubtipoResidente.valueOf(subtipo));
         
         
         lMedicos.add(MedicoDatabase);
         
         
      
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
	
	  return lMedicos;    		 
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
	
	
	 public static  List<Medico>  getMedicos()
	 {	  
			 
			 return getMedicos(new Long(-1)); 
		 
	 }
	 //return lMedicos;
	 
	 public static  Long  getUltimoOrden(String TipoMedico)
	 {	  
			
		 
		  Long _MX_ORDEN = new Long(99999); 	 
			 
		  Statement stmt = null;	 
		  Connection MiConexion =ConexionGuardias.GetConexionGuardias();
			
		  	  
		  
		  try {
			  
			
			  
			stmt = MiConexion.createStatement();
			
			String stSQL= "SELECT max(orden) orden FROM medicos where tipo='" + TipoMedico + "'";
						
			
			ResultSet rs = stmt.executeQuery( stSQL);
			
			
			  
			
	      while ( rs.next() ) {
	    	  _MX_ORDEN= rs.getLong("orden");
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
		
		  return _MX_ORDEN;	        	         
    		 
		  } 
	

public static void main( String args[] )
{
	
}
}