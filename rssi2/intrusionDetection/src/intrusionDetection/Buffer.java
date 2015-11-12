package intrusionDetection;

public class Buffer {
	private int N;  
    private int iWrite = 0;
    private int iRead = 0;
    private double buffer[];      
    private  double sample;
   
    public Buffer(int N){           
      this.N = N;    
      init();
    }
       
    private void init(){                      
      iRead = 0;
      iWrite = 0;    
      buffer = new double[N];
    }
       
    public void put(double newSample){
      buffer[iWrite] = newSample;
      iRead = iWrite;
      iWrite++;
      if(iWrite == N){
          iWrite = 0;
      }
    }
   
    public double get(){
      sample = buffer[iRead];
      iRead--;
      if(iRead<0){
          iRead = N-1;
      }    
      return sample;
    }
  
    public int getLength(){
      return N;
    }

}
