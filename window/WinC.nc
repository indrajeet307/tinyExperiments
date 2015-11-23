#include<Timer.h>
#include<stdio.h>
#include<string.h>
#include "WinMessage.h"
#define NEW_PRINTF_SEMANTICS // for printing
#include "printf.h"
#define BSIZE 10
module WinC{
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
	WinMsg message;
	bool busy=FALSE;
	int buffer[BSIZE];
	int bptr=0;
	message_t pkt;
	int total=0,num=BSIZE;
	int avg=0;
	bool flag=FALSE;
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
			WinMsg* bufpkt = (WinMsg*) (call
			Packet.getPayload(&pkt,sizeof(WinMsg)));
			if(TOS_NODE_ID == 2)
			{
				bufpkt->links.srcnid = 2;
				bufpkt->links.dstnid = 1;
				if( call AMSend.send(1,&pkt,sizeof(WinMsg)) == SUCCESS){
					busy = TRUE;
					call Leds.led0Toggle(); // packet sent
				}
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
		if( len == sizeof(WinMsg) ){
			if( TOS_NODE_ID == 1){
				WinMsg* bufpkt = (WinMsg*) (call
				Packet.getPayload(msg,sizeof(WinMsg)));
				// added code here to check the window of BSIZE
				// take averge in this window to decide intrusion
				// TODO experiment and decide how much OFFSET is acceptable
				//		MULTICHANNEL	:)
				//		MULTIHOP		:)
				int rval = call CC2420Packet.getRssi(msg);
				if(flag)
				{
					total = total-buffer[bptr];
				}
				buffer[bptr++] = rval;
				total = total + rval;
				if(bptr  >= BSIZE) {
					bptr = 0;
					flag = TRUE;
				}
				if(flag)
				{
					avg = total / BSIZE;
				}
				// get the rssi value from the packet and display it
				printf("%d %d %d\n", bufpkt->links.srcnid,avg,bufpkt->links.dstnid);
				call Leds.led1Toggle();
			}
		}
		return msg;
	}
}

