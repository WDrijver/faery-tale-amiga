
* msg(start,num) register char *start; register long num;
* {	while (num) if (*start++ == 0) num--;
*	extract(start);
* }

		XDEF 	_event,_speak,_msg
		XREF	_extract

_event
		lea		_event_msg,a0
		*move.l	4(sp),d0
		bra		msg1
_speak
		lea		_speeches,a0
		*move.l	4(sp),d0
		bra		msg1
_msg
		*move.l	4(sp),a0
		*move.l	8(sp),d0

msg1	beq		msgx
1$		tst.b	(a0)+
		bne.s	1$
		subq.w	#1,d0
		bne.s	1$
msgx	move.l	a0,4(sp)
*		bra		_extract
