#include <Timer.h>
#include "BlinkToRadio.h"

module BlinkToRadioC @safe() {
	uses interface Boot;
	uses interface Leds;
	uses interface Timer<TMilli> as Timer0;	

	// interfaces used by the radio control
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface SplitControl as AMControl;
}

implementation {
	uint16_t counter = 0;
	message_t pkt;		// holds the data for transmission
	bool busy = FALSE;	// is the if radio is busy sending
	
	event void Boot.booted() {
		//call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
		// we need to start the timer only when the radio has booted 
		// so implement AMControl.startDone and AMControl.stopDone
		call AMControl.start();
	}

	event void AMControl.startDone( error_t err){
		if(err == SUCCESS){
			call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
		}
		else
			call AMControl.start();
	}

	event void AMControl.stopDone(error_t err){
		// Nothing to be done
	}

	event void Timer0.fired() {
		counter++;
		call Leds.set(counter);
		// check if the radio is busy
		if(!busy){
			// get the payload 
			BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg*) (call Packet.getPayload(&pkt, sizeof(BlinkToRadioMsg)));
			
			// Append Node ID ans Counter to the payload
			btrpkt->nodeid = TOS_NODE_ID;
			btrpkt->counter = counter;
			
			// Try sending the data to other nodes
			// AM_BROADCAST_ADDR tells the radio to broadcast the data to all 
			// neighbouring nodes
			if( call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(BlinkToRadioMsg)) == SUCCESS) {
				busy = TRUE;
			}
		}
	}

	event void AMSend.sendDone(message_t* msg,error_t err){
		// be sure that your msg is sent
		// in case of multiplexing of radio AMsend will raise this event on ever
		// message sent
		if(&pkt == msg){
			busy = FALSE;
		}
	}
}
