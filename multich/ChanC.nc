#include<Timer.h>
#include<stdio.h>
#include<string.h>
#include "ChanMessage.h"
#define NEW_PRINTF_SEMANTICS // for printing
#include "printf.h"

module ChanC{
	uses interface Boot;
	uses interface Leds;
	uses interface Timer<TMilli> as Timer0;
	uses interface Timer<TMilli> as Timer1; // timer to set channel
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface SplitControl as AMControl;
	uses interface Receive;
	uses interface CC2420Packet;
	uses interface CC2420Config;
}
implementation{

	ChanMsg message;
	bool busy=FALSE;
	message_t pkt;
	bool chng=FALSE;

	event void Boot.booted(){
		call AMControl.start();
	}

	event void AMControl.startDone(error_t error){
		if( error == SUCCESS && TOS_NODE_ID != 1){ // Node 1 transmitter
			call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
		}
		call Timer1.startPeriodic(TIMER_PERIOD_MILLI * 100); // Both set a timer to expire at same time
	}

	event void AMControl.stopDone(error_t error){}
	event void CC2420Config.syncDone(error_t error){
		call Leds.led1Toggle();	// make sure that channel has changed
	}

	event void Timer1.fired(){	// when timer expires change the channel
		if (!chng){
			call CC2420Config.setChannel(20);
			call CC2420Config.sync();
			chng = TRUE;
		}
	}
	event void Timer0.fired(){

		if(!busy){
			ChanMsg* bufpkt = (ChanMsg*) (call
					Packet.getPayload(&pkt,sizeof(ChanMsg)));
			bufpkt->srcnodeid = TOS_NODE_ID;
			bufpkt->dstnodeid = TOS_NODE_ID-1;
			if( call AMSend.send(TOS_NODE_ID-1,&pkt,sizeof(ChanMsg)) == SUCCESS){
				busy = TRUE;
				call Leds.led0Toggle(); // packet sent
			}
		}
	}

	event void AMSend.sendDone(message_t *m,error_t error){
		if( &pkt == m){
			printf("Sent Packet\n");
			busy = FALSE;
		}
	}

	event message_t * Receive.receive(message_t *msg,void *payload, uint8_t len){
		if( len == sizeof(ChanMsg) ){
			if( TOS_NODE_ID == 1){
				ChanMsg* bufpkt = (ChanMsg*) (call
						Packet.getPayload(msg,sizeof(ChanMsg)));
				// get the rssi value from the packet and display it
				printf("%2d %4d %2d %2d \n",bufpkt->srcnodeid,call CC2420Packet.getRssi(msg),bufpkt->dstnodeid,call CC2420Config.getChannel());
				call Leds.led0Toggle();
			}
			else{
				if( call AMSend.send(TOS_NODE_ID-1,msg,sizeof(ChanMsg)) == SUCCESS){
					busy = TRUE;
					call Leds.led2Toggle();
				}
			}
		}
		return msg;
	}
}
