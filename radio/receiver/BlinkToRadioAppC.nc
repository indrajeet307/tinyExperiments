

#include <Timer.h>
#include "BlinkToRadio.h"

#define NEW_PRINTF_SEMANTICS
#include "printf.h"

configuration BlinkToRadioAppC {
}
implementation {
	// Singleton components
	components MainC;
	components LedsC;
	components PrintfC,SerialStartC;
	components BlinkToRadioC as App;
	components ActiveMessageC;

	// to get s specific component of a generic component
	components new AMReceiverC(AM_BLINKRAIO);

	App.Boot -> MainC;
	App.Leds -> LedsC;

	App.Receive -> AMReceiverC;
	App.AMControl -> ActiveMessageC;
}
