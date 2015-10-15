#ifndef BLINKTORADIO_H
#define BLINKTORADIO_H
	
enum{	
	AM_BLINKRAIO = 6,
	TIMER_PERIOD_MILLI = 1250
};

// struct to hold the payload
typedef nx_struct BlinkToRadioMsg{
	nx_uint16_t nodeid;
	nx_uint16_t counter;
}BlinkToRadioMsg;


#endif
