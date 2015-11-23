package intrusionDetection;
/*
 * MOST OF THIS CODE TAKEN FROM http://shulgadim.blogspot.in/2012/07/real-time-signal-drawing.html
 * THANK YOU Dmitry Shulga  
 * */
import java.awt.*;
import java.awt.image.*;
import java.awt.geom.Line2D;
import intrusionDetection.Buffer;
import javax.swing.JPanel;
public class SignalPanel extends JPanel{
	 /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private BufferedImage bufferedImage;
     private Graphics2D graphics2d;       
     private int width;
     private int height; 
     private double sampleOld;
    
    @Override
    protected void paintComponent(Graphics graphics) {
        super.paintComponent(graphics);   
        if (bufferedImage == null) {
          initBuffer();
        }
        graphics.drawImage(bufferedImage, 0, 0, this);
    }
   
    private void initBuffer(){
        width = getWidth();
        height = getHeight();                      
        bufferedImage = new BufferedImage(width, height,
               BufferedImage.TYPE_INT_ARGB);                       
        graphics2d = bufferedImage.createGraphics();
        graphics2d.setBackground(Color.WHITE); 
        graphics2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                                  RenderingHints.VALUE_ANTIALIAS_ON); 
    }
       
    public void drawData(Buffer buffer){      
    graphics2d.setColor(Color.DARK_GRAY);    
    graphics2d.clearRect(0, 0, width, height);         
    graphics2d.setStroke(new BasicStroke(5));
    for(int i=0; i<buffer.getLength(); i++){
          double sample = (-1)*buffer.get()*4;
          if(sample - sampleOld > 5)
        	  graphics2d.setColor(Color.RED);
          else
        	  graphics2d.setColor(Color.DARK_GRAY);
          graphics2d.draw(new Line2D.Double(
                           buffer.getLength()-i, 
                           sampleOld +height/1.5,
                           buffer.getLength()-(i+1),
                           sample+ height/1.5));                           
           sampleOld = sample;                      
    }    
    repaint();            
    }
}