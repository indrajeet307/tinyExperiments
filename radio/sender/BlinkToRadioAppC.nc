
#include <Timer.h>
#include "BlinkToRadio.h"

configuration BlinkToRadioAppC {
}
implementation {
	// Singleton components
	components MainC;
	components LedsC;
	components BlinkToRadioC as App;
	components ActiveMessageC;
	components new TimerMilliC() as Timer0;

	// to get s specific component of a generic component
	components new AMSenderC(AM_BLINKRAIO);

	App.Boot -> MainC;
	App.Leds -> LedsC;
	App.Timer0 -> Timer0;

	App.Packet -> AMSenderC;
	App.AMPacket -> AMSenderC;
	App.AMSend -> AMSenderC;
	App.AMControl -> ActiveMessageC;
}
