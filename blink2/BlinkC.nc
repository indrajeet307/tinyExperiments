module BlinkC @safe()
{
	uses interface Timer<TMilli> as Timer0;
	uses interface Leds;
	uses interface Boot;
}
implementation
{
	uint16_t counter = 0;
	event void Boot.booted()
	{
		call Timer0.startPeriodic( 250 );
	}

	event void Timer0.fired()
	{
		counter++;
		if(counter & 0x1){
			call Leds.led0On();
		}
		else{
			call Leds.led0Off();
		}
		if(counter & 0x2){
			call Leds.led1On();
		}
		else{
			call Leds.led1Off();
		}
		if(counter & 0x4){
			call Leds.led2On();
		}
		else{
			call Leds.led2Off();
		}
	}	

}
