
		XDEF _prq
        *XREF _prec,_pplay,_print_que
        
_prq
		movem.l	d2,-(sp)
		*move.w	_prec,d0
		*move.w	_pplay,d1
		move.w d0,d2
		addq	#1,d0
		and.w	#31,d0
		cmp.w	d0,d1
		beq.s	prqx
		move.w	d2,d1
		*move.w	d0,_prec
		*lea	_print_que,a1
		move.b	3+4+12(sp),(a1,d1)
prqx	movem.l	(sp)+,d2
		rts