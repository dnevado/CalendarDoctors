package com.ibatis.mappers;

import java.util.List;

import com.guardias.cambios.CambiosGuardias;

public interface CambiosGuardiasMapper {
	
	CambiosGuardias getCambiosGuardiasById(int id);
	
	CambiosGuardias getMaxIDCambiosGuardiasID();
	
	void  updateCambiosGuardias(CambiosGuardias cambio);
	
	List<CambiosGuardias> getCambiosGuardiasBySolicitante(int solicitante);
	
	
	List<CambiosGuardias> getCambioGuardiasByMedicoSolicitanteYFecha(CambiosGuardias Cambio);
	
	List<CambiosGuardias> getCambioGuardiasByMedicoSolicitanteYFechaYEstado(CambiosGuardias Cambio);
	
	
	
	void insertCambiosGuardias(CambiosGuardias cambio);

}

