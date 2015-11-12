#include<Timer.h>
#include "RSSIMessage.h"

#define NEW_PRINTF_SEMANTICS
#include "printf.h"

configuration RSSIAppC{
}
implementation{
	components MainC;	// to get the .booted event
	components LedsC;	// to get the LED controls
	components RSSIC as App;	// get the current app
	components new TimerMilliC() as Timer0; // timer Component
	components ActiveMessageC;	// Message Packet
	components new AMReceiverC(AM_BLINKTORADIO);
	components new AMSenderC(AM_BLINKTORADIO);
	components PrintfC,SerialStartC;
	components CC2420PacketC;	// Specific Radio Module to get RSSI value

	App.Boot -> MainC;
	App.Leds -> LedsC;
	App.Timer0 -> Timer0;
	App.Packet -> AMSenderC;
	App.AMPacket -> AMSenderC;
	App.AMControl -> ActiveMessageC;
	App.Receive -> AMReceiverC;
	App.AMSend -> AMSenderC;
	App.CC2420Packet -> CC2420PacketC;
}
