
/* OJO, USAMOS SAX PARA LEER Y DOM PARSER PARA EDITAR */


package com.guardias.xml;


import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;


import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import com.guardias.Medico;
import com.guardias.Util;

public class Procesar extends DefaultHandler {
    List<Medico> lMedicos;
    File  MedicoXmlFileName;
    String tmpValue;
    Medico medicoTmp;
    SimpleDateFormat sdf= new SimpleDateFormat("yy-MM-dd");
    
   /*  public Procesar()
    {
    	
    }
    */
   
    public Procesar(File  MedicoXmlFileName) {
    	
        this.MedicoXmlFileName = MedicoXmlFileName;
        lMedicos = new ArrayList<Medico>();
        parseDocument();              
    }
    public List<Medico>  getMedicos()
    {
    	return lMedicos;
    }
    
    public void updateElementValue(Medico _medicoAgrabar) {
    	
    	
    
    	try {
    		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
    		DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
    		Document doc = docBuilder.parse(MedicoXmlFileName);

    		// Get the root element
    		Node _root = doc.getFirstChild();

    		// Get the staff element , it may not working if tag has spaces, or
    		// whatever weird characters in front...it's better to use
    		// getElementsByTagName() to get it directly.
    		// Node staff = company.getFirstChild();

    		// Get the staff element by tag name directly
    		NodeList medicos  = doc.getElementsByTagName("medico");
    		for(int i = 0; i < medicos.getLength(); i++) {
    			
    			Node _medico = medicos.item(i);
    			NamedNodeMap attr = _medico.getAttributes();
	    		Node nodeAttr = attr.getNamedItem("id");
	    		
	    		if (nodeAttr.getNodeValue().equals(_medicoAgrabar.getID().toString()))  // encontrado
	    		{
	    			
	    			
	    			// update staff attribute
		    		
		    		Node nodeAttrN = attr.getNamedItem("nombre");
		    		Node nodeAttrA = attr.getNamedItem("apellidos");
		    		Node nodeAttrT = attr.getNamedItem("tipo");
		    		Node nodeAttrAC = attr.getNamedItem("active");
		    		Node nodeAttrGS = attr.getNamedItem("GuardiaSolo");
		    		Node nodeAttrSTR = attr.getNamedItem("subtipores");
		    		Node nodeAttrGRD = attr.getNamedItem("Max_Guardias");
		    		Node nodeAttrIDMEDICO= attr.getNamedItem("idmedico");
		    		Node nodeAttrORDEN= attr.getNamedItem("orden");
		    		
		    			   
	    			
	    			
	    			nodeAttrN.setNodeValue(_medicoAgrabar.getNombre());
	    			nodeAttrA.setNodeValue(_medicoAgrabar.getApellidos());
	    			nodeAttrT.setNodeValue(_medicoAgrabar.getTipo().toString());
	    			nodeAttrAC.setNodeValue("S");
	    			if (!_medicoAgrabar.isActivo())
	    				nodeAttrAC.setNodeValue("N");
	    			nodeAttrGS.setNodeValue("S");
	    			if (!_medicoAgrabar.isGuardiaSolo())
	    				nodeAttrGS.setNodeValue("N");	    				    			
	    			nodeAttrSTR.setNodeValue(_medicoAgrabar.getSubTipoResidente().toString());
	    		//	nodeAttrRS.setNodeValue(_medicoAgrabar.getTipo().toString());	    			
	    			nodeAttrGRD.setNodeValue(_medicoAgrabar.getMax_NUM_Guardias().toString());
	    			nodeAttrIDMEDICO.setNodeValue(_medicoAgrabar.getIDMEDICO().toString());
	    			nodeAttrORDEN.setNodeValue(_medicoAgrabar.getOrden().toString());
	    			
	    		}
    		}
    		
    		// 
    		// write the content into xml file
    		TransformerFactory transformerFactory = TransformerFactory.newInstance();
    		Transformer transformer = transformerFactory.newTransformer();
    		DOMSource source = new DOMSource(doc);
    		StreamResult result = new StreamResult(MedicoXmlFileName);
    		transformer.transform(source, result);

    		System.out.println("Done");

    	   } catch (ParserConfigurationException pce) {
    		pce.printStackTrace();
    	   } catch (TransformerException tfe) {
    		tfe.printStackTrace();
    	   } catch (IOException ioe) {
    		ioe.printStackTrace();
    	   } catch (SAXException sae) {
    		sae.printStackTrace();
    	   }
    	
        
    }

    
    private void parseDocument() {
        // parse
        SAXParserFactory factory = SAXParserFactory.newInstance();
        try {
            SAXParser parser = factory.newSAXParser();
            parser.parse(MedicoXmlFileName, this);
        } catch (ParserConfigurationException e) {
            System.out.println("ParserConfig error");
        } catch (SAXException e) {
            System.out.println("SAXException : xml not well formed");
        } catch (IOException e) {
            System.out.println("IO error");
        }
    }
    private void printDatas() {
       // System.out.println(bookL.size());
        for (Medico tmpB : lMedicos) {
            System.out.println(tmpB.toString());
        }
    }
    @Override
    public void startElement(String s, String s1, String elementName, Attributes attributes) throws SAXException {
        // if current element is book , create new book
        // clear tmpValue on start of element

        if (elementName.equalsIgnoreCase("medico")) {
        	medicoTmp = new Medico();
        	medicoTmp.setID(new Long(attributes.getValue("id")));
        	medicoTmp.setIDMEDICO(new Long(attributes.getValue("idmedico")));
        	medicoTmp.setApellidos(attributes.getValue("apellidos"));
        	medicoTmp.setNombre(attributes.getValue("nombre"));
        	medicoTmp.setActivo(attributes.getValue("active").equals("S") ? true : false);
        	medicoTmp.setGuardiaSolo(attributes.getValue("GuardiaSolo").equals("S") ? true : false);
        	medicoTmp.setOrden(new Long(attributes.getValue("orden")));
        	medicoTmp.setMax_NUM_Guardias(new Long(attributes.getValue("Max_Guardias")));        	        	
        	medicoTmp.setSubTipoResidente(Util.eSubtipoResidente.valueOf(attributes.getValue("subtipores")));
        	
        	//<medico orden="1" id="1" nombre="DAVID" apellidos="NEVADO" tipo="RESIDENTE" activo="true" GuardiaSolo='S' subtipores='R1' Max_Guardias='6'>
        	
        	if (attributes.getValue("tipo").equals(Util.eTipo.ADJUNTO.toString()))
        		medicoTmp.setTipo(Util.eTipo.ADJUNTO);
        	else
        		medicoTmp.setTipo(Util.eTipo.RESIDENTE);        		
        	
        	
        }
        if (elementName.equalsIgnoreCase("ausencias")) {
        	/* medicoTmp = new Medico();
        	medicoTmp.setID(new Long(attributes.getValue("id")));
        	medicoTmp.setApellidos(attributes.getValue("apellidos"));
        	medicoTmp.setNombre(attributes.getValue("nombre"));
        	medicoTmp.setActive(Boolean.getBoolean(attributes.getValue("activo")));
        	
        	
        	if (attributes.getValue("tipo").equals(Util.eTipo.ADJUNTO.toString()))
        		medicoTmp.setTipo(Util.eTipo.ADJUNTO);
        	else
        		medicoTmp.setTipo(Util.eTipo.RESIDENTE);        		
        	*/
        	
        }
        
    }
    @Override
    public void endElement(String s, String s1, String element) throws SAXException {
        // if end of book element add to list
        if (element.equals("medico")) {
        	lMedicos.add(medicoTmp);
        }
        /* if (element.equalsIgnoreCase("isbn")) {
            bookTmp.setIsbn(tmpValue);
        }
        if (element.equalsIgnoreCase("title")) {
            bookTmp.setTitle(tmpValue);
        }
        if(element.equalsIgnoreCase("author")){
           bookTmp.getAuthors().add(tmpValue);
        }
        if(element.equalsIgnoreCase("price")){
            bookTmp.setPrice(Integer.parseInt(tmpValue));
        }
        if(element.equalsIgnoreCase("regDate")){
            try {
                bookTmp.setRegDate(sdf.parse(tmpValue));
            } catch (ParseException e) {
                System.out.println("date parsing error");
            }
        }*/
    }
    @Override
    public void characters(char[] ac, int i, int j) throws SAXException {
        tmpValue = new String(ac, i, j);
    }
    public static void main(String[] args) {
    	//dateElementValue()
    }
}