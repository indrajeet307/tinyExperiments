#include<Timer.h>
#include<stdio.h>
#include<string.h>
#include "RSSIMessage.h"
#define NEW_PRINTF_SEMANTICS // for printing
#include "printf.h"

module RSSIC{
	uses interface Boot;
	uses interface Leds;
	uses interface Timer<TMilli> as Timer0;
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface SplitControl as AMControl;
	uses interface Receive;
	uses interface CC2420Packet;
}
implementation{

	RSSIMsg message;
	bool busy=FALSE;
	message_t pkt;
	
	event void Boot.booted(){
		call AMControl.start();
	}

	event void AMControl.startDone(error_t error){
		if( error == SUCCESS && TOS_NODE_ID != 1){ // Node 1 transmitter
			call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
		}
	}

	event void AMControl.stopDone(error_t error){}

	event void Timer0.fired(){

		if(!busy){
			RSSIMsg* bufpkt = (RSSIMsg*) (call
			Packet.getPayload(&pkt,sizeof(RSSIMsg)));
			
			if(TOS_NODE_ID == 2)
			{
				bufpkt->links.srcnid = 2;
				bufpkt->links.dstnid = 1;
				if( call AMSend.send(1,&pkt,sizeof(RSSIMsg)) == SUCCESS){
					busy = TRUE;
					call Leds.led0Toggle(); // packet sent
				}				
			}
			
		}
	}

	event void AMSend.sendDone(message_t *m,error_t error){
		if( &pkt == m){
			printf("Sent Packet\n");
			//call Leds.led1Toggle();
			busy = FALSE;
		}
	}

	event message_t * Receive.receive(message_t *msg,void *payload, uint8_t len){
		if( len == sizeof(RSSIMsg) ){
			if( TOS_NODE_ID == 1){
				
				RSSIMsg* bufpkt = (RSSIMsg*) (call
				Packet.getPayload(msg,sizeof(RSSIMsg)));
				// get the rssi value from the packet and display it
				//printf("Link1: %2d == %4d ==%2d.\n", bufpkt->links[0].srcnid,bufpkt->rssi1,bufpkt->links[0].dstnid);
				printf("%d %d %d\n", bufpkt->links.srcnid,call CC2420Packet.getRssi(msg),bufpkt->links.dstnid);
				call Leds.led1Toggle();
			}
		}
		return msg;
	}
}

