package intrusionDetection;
/*
 * MOST OF THIS CODE TAKEN FROM http://shulgadim.blogspot.in/2012/07/real-time-signal-drawing.html
 * THANK YOU Dmitry Shulga  
 * */
import javax.swing.Timer;
import intrusionDetection.Buffer;
import intrusionDetection.Model;
import intrusionDetection.View;
import java.awt.event.*;
public class Controller {
	 private Timer timer;
     private Model model;
     private View view;
     private Buffer b;
    
     public Controller(Model model, View view){                    
          this.model = model;
          this.view = view;
          this.b = new Buffer(1000);          
          timer = new Timer(30, new ActionListener(){
                public void actionPerformed(ActionEvent e){
                     processing();}
                });
          timer.start();
      }   
    
     private void processing(){
          double sample = model.getSignalSample();
          b.put(sample);
          view.getSignalPanel().drawData(b);
     }    
}
