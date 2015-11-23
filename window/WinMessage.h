#ifndef __WinMessage_H_
#define __WinMessage_H_
enum{
	AM_BLINKTORADIO = 6,
	TIMER_PERIOD_MILLI = 15,
};

typedef nx_struct link{
	nx_uint8_t srcnid;
	nx_uint8_t dstnid;
}link_t;

typedef nx_struct WinMsg{
	link_t links;
}WinMsg;

#endif
