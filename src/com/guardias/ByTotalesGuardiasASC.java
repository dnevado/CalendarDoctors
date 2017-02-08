package com.guardias;

import java.util.Comparator;
import java.util.Map;
import java.util.Map.Entry;

public class ByTotalesGuardiasASC implements Comparator<Entry<Long,Long>>{
    
	 @Override
     public int compare(Entry<Long, Long> ele1,
             Entry<Long, Long> ele2) {
      if (ele1.getValue()< ele2.getValue())
          	return 1;
          else
             return -1;	
        
     }
}