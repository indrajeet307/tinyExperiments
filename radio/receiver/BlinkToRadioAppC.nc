
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

	// to get s specific component of a generic component
	components new AMReceiverC(AM_BLINKRAIO);

	App.Boot -> MainC;
	App.Leds -> LedsC;

	App.Receive -> AMReceiverC;
	App.AMControl -> ActiveMessageC;
}
