#include <Timer.h>
#include "BlinkToRadio.h"

module BlinkToRadioC @safe() {
	uses interface Boot;
	uses interface Leds;

	// interfaces used by the radio control
	uses interface Packet;
	uses interface AMPacket;
	uses interface SplitControl as AMControl;
	uses interface Receive;
}

implementation {
	uint16_t counter = 0;
	bool busy = FALSE;	// is the if radio is busy sending
	
	event void Boot.booted() {
		//call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
		// we need to start the timer only when the radio has booted 
		// so implement AMControl.startDone and AMControl.stopDone
		call AMControl.start();
	}

	event void AMControl.startDone( error_t err){
		if(err == SUCCESS){

		}
		else
			call AMControl.start();
	}

	event void AMControl.stopDone(error_t err){
		// Nothing to be done
	}

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
		// if we receive a message of appropriate type set the accordingly
		if(len == sizeof(BlinkToRadioMsg)){
			BlinkToRadioMsg *btrpkt = (BlinkToRadioMsg*) payload;
			call Leds.set(btrpkt->counter);
		}
		return msg;
	}

}
