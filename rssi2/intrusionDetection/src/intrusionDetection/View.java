package intrusionDetection;

import javax.swing.JFrame;

public class View extends JFrame{            
         
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private SignalPanel signalPanel;
                     
    public View(){                     
        setTitle("Draw real-time signal");      
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(400, 200);       
        signalPanel = new SignalPanel();                 
        getContentPane().add(signalPanel);               
        setVisible(true);        
    }
   
    public SignalPanel getSignalPanel(){
        return signalPanel;
    }
}