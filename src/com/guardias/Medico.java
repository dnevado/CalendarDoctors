package com.guardias;

import java.util.ArrayList;

import com.guardias.Util.eSubtipoResidente;
import com.guardias.Util.eTipo;

public class Medico {
	private String Nombre;
	private Long  ID;
	private Long  IDMEDICO = new Long(1);
	
	private String Apellidos;
	private boolean Activo=true;	
	private boolean GuardiaSolo=false;  // puede hacer guardia solo 
	private eSubtipoResidente SubTipoResidente=eSubtipoResidente.R1; // tipo de residente r1 R... 
	//private boolean ResidenteSimulado; // no tiene nombre adjudicado, como comodin para las series de asignacion
	
	private eTipo Tipo = eTipo.ADJUNTO;
	
	private Long Max_Guardias = new Long(6);
	private Long Orden = new Long(1);
	
	private String Email = "";
	private String PassWord = "";
	
	
	private boolean Administrator=false;
	private boolean Confirmado=false;
		
	public boolean isConfirmado() {
		return Confirmado;
	}
	public void setConfirmado(boolean confirmado) {
		Confirmado = confirmado;
	}
	public boolean isAdministrator() {
		return Administrator;
	}
	public void setAdministrator(boolean administrator) {
		Administrator = administrator;
	}
	public String getPassWord() {
		return PassWord;
	}
	public void setPassWord(String passWord) {
		PassWord = passWord;
	}
	public String getEmail() {
		return Email;
	}
	public void setEmail(String email) {
		Email = email;
	}
	public Long getMax_NUM_Guardias() {
		return Max_Guardias;
	}
	public void setMax_NUM_Guardias(Long max_NUM_Guardias) {
		Max_Guardias = max_NUM_Guardias;
	}
	public Long getIDMEDICO() {
		return IDMEDICO;
	}
	public void setIDMEDICO(Long iDMEDICO) {
		IDMEDICO = iDMEDICO;
	}
	
	public Long getOrden() {
		return Orden;
	}
	public void setOrden(Long orden) {
		Orden = orden;
	}
	private  java.util.List<String> lAusencias = new ArrayList(); //2016-01-01
	private  java.util.List<String> lGuardias = new ArrayList(); //2016-01-01; //2016-01-01	
	public java.util.List<String> getlGuardias() {
		return lGuardias;
	}
	public void setlGuardias(java.util.List<String> lGuardias) {
		this.lGuardias = lGuardias;
	}
	public String getNombre() {
		return Nombre;
	}
	public void setNombre(String nombre) {
		Nombre = nombre;
	}
	public String getApellidos() {
		return Apellidos;
	}
	public boolean isActivo() {
		return Activo;
	}
	public void setActivo(boolean activo) {
		Activo = activo;
	}
	public boolean isGuardiaSolo() {
		return GuardiaSolo;
	}
	public void setGuardiaSolo(boolean guardiaSolo) {
		GuardiaSolo = guardiaSolo;
	}
	public eSubtipoResidente getSubTipoResidente() {
		return SubTipoResidente;
	}
	public void setSubTipoResidente(eSubtipoResidente subTipoResidente) {
		SubTipoResidente = subTipoResidente;
	}
	public boolean isResidenteSimulado() {
		return SubTipoResidente.equals(eSubtipoResidente.SIMULADO);
	}
	
	public void setApellidos(String apellidos) {
		Apellidos = apellidos;
	}
	public java.util.List<String> getlVacaciones() {
		return lAusencias;
	}
	public void setlVacaciones(java.util.List<String> lVacaciones) {
		this.lAusencias = lVacaciones;
	}	
	public Long getID() {
		return ID;
	}
	public void setID(Long iD) {
		ID = iD;
	}
	public eTipo getTipo() {
		return Tipo;
	}
	public void setTipo(eTipo tipo) {
		Tipo = tipo;
	}

}
