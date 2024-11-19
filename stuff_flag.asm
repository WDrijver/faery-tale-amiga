
	XDEF	_stuff_flag
	XREF	_stuff

_stuff_flag
		moveq	#8,d0
		move.l	_stuff,a0
		add.l	4(sp),a0
		tst.b	(a0)
		beq.s	1$
		moveq	#10,d0
1$		rts
