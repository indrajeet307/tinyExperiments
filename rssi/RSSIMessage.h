#ifndef __RSSIMessage_H_
#define __RSSIMessage_H_
enum{
	AM_BLINKTORADIO = 6,
	TIMER_PERIOD_MILLI = 10,
	RADIO_POWER = 5 // TODO: reduce the radio power so it reduces power
};

typedef nx_struct RSSIMsg{
	nx_uint16_t nodeid;
	nx_uint16_t counter; // XXX: you don't need this
}RSSIMsg;

#endif
