#ifndef __RSSIMessage_H_
#define __RSSIMessage_H_
enum{
	AM_BLINKTORADIO = 6,
	TIMER_PERIOD_MILLI = 15,
};

typedef nx_struct RSSIMsg{
	nx_uint16_t srcnodeid;
	nx_uint16_t dstnodeid;
}RSSIMsg;

#endif
