// Used for non top level applications
// Can specify interfaces that this application provides
// or the interfaces this app implements
configuration BlinkAppC{
}
// The actual configuration goes here
// Set of components this app actually references
implementation{
	components MainC,BlinkC,LedsC;
	components new TimerMilliC() as Timer0;
	// wiring
	// <App>.<interface> -> <TinyOs>.<interface>
	// <Object> on either side is enough if no ambiguity
	BlinkC -> MainC.Boot;
	BlinkC.Timer0 -> Timer0;
	BlinkC.Leds -> LedsC;

}
