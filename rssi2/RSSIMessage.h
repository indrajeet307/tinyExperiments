#ifndef __RSSIMessage_H_
#define __RSSIMessage_H_
enum{
	AM_BLINKTORADIO = 6,
	TIMER_PERIOD_MILLI = 15,
};

typedef nx_struct link{
	nx_uint8_t srcnid;
	nx_uint8_t dstnid;
}link_t;

typedef nx_struct RSSIMsg{
	link_t links;
}RSSIMsg;

#endif
