package com.guardias;

public class Guardias {

	private Long  ID = new Long(1);	
	private Long  IdMedico = new Long(1);
	private Long  Festivo =  new Long(0);
	private String  Tipo = "";  // localizada , presencia...
	private String DiaGuardia;
	
	public Long getIdMedico() {
		return IdMedico;
	}
	public void setIdMedico(Long idMedico) {
		IdMedico = idMedico;
	}
	public Long isEsFestivo() {
		return Festivo;
	}
	public void setEsFestivo(Long esFestivo) {
		Festivo = esFestivo;
	}
	public String getTipo() {
		return Tipo;
	}
	public void setTipo(String tipo) {
		Tipo = tipo;
	}
	public void setDiaGuardia(String diaGuardia) {
		DiaGuardia = diaGuardia;
	}
	
	public Long getID() {
		return ID;
	}
	public void setID(Long iD) {
		ID = iD;
	}
	public String getDiaGuardia() {
		return DiaGuardia;
	}

}
