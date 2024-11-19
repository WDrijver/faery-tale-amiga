Move		=	$FFFFFF10
Text		=	$FFFFFFC4
SetAPen	    =	$FFFFFEAA
SetBPen	    =	$FFFFFEA4

			XREF	_GfxBase
			XDEF	_cursor,_xx,_yy,_answr,_rp

_cursor
			movem.l	a0-a6/d0-d7,-(sp)

			move.l	_GfxBase,a6
			
			clr.l	d0					// set B pen color = 0
			jsr		SetBPen(a6)

			clr.l	d0					// d0 already clear
			clr.l	d1
			move.w	_xx,d0
			move.w	_yy,d1
			jsr		Move(a6)

			lea		_answr,a0			// string = answr
			move.l	60+4(sp),d0			// length of string = arg 1
			jsr		Text(a6)

			move.l	_rp,a1
			
			move.l	60+8(sp),d0			// set B pen color = arg 2
			jsr		SetBPen(a6)

			move.w	#$2020,-(sp)		// push spaces

			move.l	sp,a0				// address to print = stack
			moveq	#1,d0				
			jsr		Text(a6)			// length = 1

			clr.l	d0					// set B pen color = 0
			jsr		SetBPen(a6)

			move.l	sp,a0				// address to print = stack
			moveq	#1,d0				
			jsr		Text(a6)			// length = 1

			addq.l	#2,sp				// pop string from stack

			movem.l	(sp)+,a0-a6/d0-d7
			rts