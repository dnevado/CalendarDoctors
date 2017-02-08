package com.guardias.database;

import java.sql.*;

class ConexionGuardias  
{
  
	private static Connection cConnection = null;  		
	 public static  void  CerrarConexionGuardias()	  
	  {
		  if (cConnection!=null)
		  {
			  try {
				cConnection.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		  }
		  
	  }
  public static  Connection  GetConexionGuardias()
  {	  
	  if (cConnection==null)
	  {
		  Connection c = null;
		    try {
		      Class.forName("org.sqlite.JDBC");
		      // 
		      c = DriverManager.getConnection("jdbc:sqlite:" + System.getProperty("catalina.home") + "\\BBDD_sqllite\\guardias.db");
		    } catch ( Exception e ) {
		      System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		      System.exit(0);
		    }
		    return c;
		    //System.out.println("Opened database successfully");
	  }
	  else		  
		  return cConnection;
  }
  
	
  public static void main( String args[] )
  {
    Connection c = null;
    try {
      Class.forName("org.sqlite.JDBC");
      c = DriverManager.getConnection("jdbc:sqlite:d:\\test.db");
    } catch ( Exception e ) {
      System.err.println( e.getClass().getName() + ": " + e.getMessage() );
      System.exit(0);
    }
    System.out.println("Opened database successfully");
  }
}