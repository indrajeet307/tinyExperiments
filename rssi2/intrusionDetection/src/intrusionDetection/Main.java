package intrusionDetection;
/*
 * MOST OF THIS CODE TAKEN FROM http://shulgadim.blogspot.in/2012/07/real-time-signal-drawing.html
 * THANK YOU Dmitry Shulga  
 * */
import javax.swing.*;
import net.tinyos.message.MoteIF;
import net.tinyos.packet.BuildSource;
import net.tinyos.packet.PhoenixSource;
import net.tinyos.util.PrintStreamMessenger;

public class Main {
	public static void main(String[] args) {
    	String source = null;
        if (args.length == 2) {
          if (!args[0].equals("-comm")) {
    	       //usage();
    	       System.exit(1);
          }
          source = args[1];
        }
        
        PhoenixSource phoenix;
        if (source == null) {
          phoenix = BuildSource.makePhoenix(PrintStreamMessenger.err);
        }
        else {
          phoenix = BuildSource.makePhoenix(source, PrintStreamMessenger.err);
        }
        System.out.print(phoenix);
        final MoteIF mif = new MoteIF(phoenix);
        //PrintfClient client = new PrintfClient(mif);
      
        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run() {                                 
                Model model = new Model(mif);               
                View view = new View();             
                new Controller(model, view);                                    
            }
        });                         
    }
}