package intrusionDetection;
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
          this.b = new Buffer(400);          
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
