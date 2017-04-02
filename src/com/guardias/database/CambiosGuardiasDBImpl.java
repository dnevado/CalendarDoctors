package com.guardias.database;

import java.io.IOException;
import java.io.Reader;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.cursor.Cursor;
import org.apache.ibatis.executor.BatchResult;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.Configuration;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import com.guardias.Guardias;
import com.guardias.Medico;
import com.guardias.Util;
import com.guardias.cambios.CambiosGuardias;


public class CambiosGuardiasDBImpl {

	
	public static  void AddCambioGuardias(CambiosGuardias oCambioG) 
	{
		SqlSession _oSession = _createSession();
		try
		{
			 //_oSession.selectOne("CambiosGuardias.insertCambiosGuardias", oCambioG);
			
			 _oSession.insert("CambiosGuardias.insertCambiosGuardias", oCambioG);
			 _oSession.commit(); 
			 //_oSession.s
			 
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		 finally {
			 _oSession.close();
		 }

		
		
	}
	
	public static  void UpdateCambioGuardias(CambiosGuardias oCambioG) 
	 {	  
		SqlSession _oSession = _createSession();
		int _return=0; 
		try
		{
			  //org.apache.ibatis.logging.LogFactory.useLog4JLogging();

			 _return =  _oSession.update("CambiosGuardias.updateCambiosGuardias", oCambioG);
			 _oSession.commit(); 			
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		 finally {
			 _oSession.close();
		 }
	//	return _return;
		
	 }
	
	public static  int getMaxIDCambiosGuardiasID() 
	 {	  
		SqlSession _oSession = _createSession();
		CambiosGuardias olCambio = null;
		try
		{
			 olCambio =  _oSession.selectOne("CambiosGuardias.getMaxIDCambiosGuardiasID");
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		 finally {
			 _oSession.close();
		 }
		
		 return (olCambio!=null ? olCambio.getIdCambio().intValue() +1 : 1);
	 }
	
	public static  CambiosGuardias getCambioGuardiasById(Integer IdCambio) 
	 {	  
		SqlSession _oSession = _createSession();
		CambiosGuardias olCambio = null;
		try
		{
			 olCambio =  _oSession.selectOne("CambiosGuardias.getCambiosGuardiasById", IdCambio);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		 finally {
			 _oSession.close();
		 }
		 return olCambio;
	 }
	public static  List<CambiosGuardias> getCambioGuardiasByMedicoSolicitante(Integer IdMedico) 
	 {
		SqlSession _oSession = _createSession();
		List<CambiosGuardias> olCambio = null;
		try
		{
			 olCambio =  _oSession.selectList("CambiosGuardias.getCambiosGuardiasBySolicitante", IdMedico);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		 finally {
			 _oSession.close();
		 }
		 return olCambio;
	 }
	public static List<CambiosGuardias>   getCambioGuardiasByMedicoSolicitanteYFecha(CambiosGuardias _Cambio) 
	 {	  
		SqlSession _oSession = _createSession();
		List<CambiosGuardias> olCambio = null;  
		try
		{ 
			 olCambio =  _oSession.selectList("CambiosGuardias.getCambioGuardiasByMedicoSolicitanteYFecha", _Cambio);
		}
		catch (Exception e)
		{
			
		}
		 finally {
			 _oSession.close();
		 }
		 return olCambio;
	 }
	public static List<CambiosGuardias>   getCambioGuardiasByMedicoSolicitanteYFechaYEstado(CambiosGuardias _Cambio) 
	 {	  
		SqlSession _oSession = _createSession();
		List<CambiosGuardias> olCambio = null;
		try
		{
			 olCambio =  _oSession.selectList("CambiosGuardias.getCambioGuardiasByMedicoSolicitanteYFechaYEstado", _Cambio);
		}
		catch (Exception e)
		{
			
		}
		 finally {
			 _oSession.close();
		 }
		 return olCambio;
	 }
	public static  List<CambiosGuardias> getCambioGuardiasByMedicoAprobacion(Integer IdMedicoApr) 
	 {	  
		SqlSession _oSession = _createSession();
		List<CambiosGuardias> olCambio = null;
		try
		{
			 olCambio =  _oSession.selectOne("CambiosGuardias.getCambiosGuardiasById", IdMedicoApr);
		}
		catch (Exception e)
		{
			
		}
		 finally {
			 _oSession.close();
		 }
		 return olCambio;
	 }
	
	 private static SqlSession _createSession()
	 {
		 	SqlSession session=null;
			String resource = "com/guardias/persistence/ConfigurationIBATIS.xml";
			try 
			{ 
				Reader reader = Resources.getResourceAsReader(resource);
				SqlSessionFactory sqlMapper = new SqlSessionFactoryBuilder().build(reader);
				session = sqlMapper.openSession(true);  // autocommit;
			
			}
			 catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} 
			return session;
			
	 }
	
}	
		 
	   
	  	
	 
