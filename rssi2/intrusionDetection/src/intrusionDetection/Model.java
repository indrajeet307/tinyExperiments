package intrusionDetection;

import net.tinyos.message.Message;
import net.tinyos.message.MessageListener;
import net.tinyos.message.MoteIF;
import net.tinyos.tools.PrintfMsg;
/*
 * MOST OF THIS CODE TAKEN FROM http://shulgadim.blogspot.in/2012/07/real-time-signal-drawing.html
 * THANK YOU Dmitry Shulga  
 * */
public class Model implements MessageListener {
	 private int wcounter = 0;
	 private int rcounter = 0;
	 //private int type = 0;
	 private MoteIF moteIF; 
	 private int buff[];
	 
	 public Model(MoteIF mi){
		 this.moteIF = mi;
		 this.moteIF.registerListener(new PrintfMsg(), this);
		 this.buff = new int[128];
	 }
     public double getSignalSample(){         
    	 if(rcounter==0 && wcounter==0)
    		 return 0;
    	 else if(rcounter == wcounter)
    		 return buff[rcounter];
    	 else {
    		 return buff[rcounter++%128];
    	 }
    		 
     }
	@Override
	public void messageReceived(int to, Message m) {
		PrintfMsg msg = (PrintfMsg)m;     
		boolean rf=false;
		int val=0;
	    for(int i=0; i<PrintfMsg.totalSize_buffer(); i++) {
	      char nextChar = (char)(msg.getElement_buffer(i));      
	      if(nextChar == '-'){
	    	 rf=!rf;    	 
	      }
	      if((nextChar == ' ' && rf)){
	    	  rf=!rf;
	    	  System.out.println(val);
	    	  buff[wcounter%128]=val;	    	  
	    	  wcounter++;
	    	  val=0;
	      }
	      if(nextChar !=0 && nextChar != '-' && rf ){
	    	  val = val*10+(nextChar-48);
	      }     
	    }
	}
}

