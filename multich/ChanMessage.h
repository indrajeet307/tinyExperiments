#ifndef __ChanMessage_H_
#define __ChanMessage_H_
enum{
	AM_BLINKTORADIO = 6,
	TIMER_PERIOD_MILLI = 15,
};

typedef nx_struct ChanMsg{
	nx_uint16_t srcnodeid;
	nx_uint16_t dstnodeid;
}ChanMsg;

#endif
