* set_course(object,target_x,target_y,mode)
*	unsigned short object, target_x, target_y, mode;
* {	short xdif, ydif, deviation, j;
*	register long xabs, yabs, xdir, ydir;

	XDEF	_set_course

_set_course

* shape structure - anim_list

abs_x       = 0
abs_y       = 2
rel_x       = 4
rel_y       = 6
type        = 8
race        = 9
index       = 10
visible     = 11
weapon      = 12
environ     = 13
goal        = 14
tactic      = 15
state       = 16
facing      = 17
vitality    = 18
vel_x       = 20
vel_y       = 21
l_shape	    = 22

com2	dc.b	0,1,2,7,9,3,6,5,4

		movem.l	d0-d7/a0-a1,-(sp)
		move.l	40+4(sp),d2		    * object #
		move.l	40+8(sp),d0		    * target x
		move.l	40+12(sp),d1		* target_y
		move.l	40+16(sp),d3		* mode

		lea		_anim_list,a1		* start of anim_list
		mulu.w	#l_shape,d2		    * object # times length of struct
		add.l	d2,a1				* a1 = start of anim_list[object]

*	if (mode == 6) { xdif = target_x; ydif = target_y; }

		cmp.b	#6,d3				* if mode != 6
		beq.s	1$					* calculate offset normally

*	else
*	{	xdif = anim_list[object].abs_x - target_x;
*		ydif = anim_list[object].abs_y - target_y;
*	}

		neg.w	d0					* d0 = -target_x
		neg.w	d1					* d1 = -target_y
		add.w	abs_x(a1),d0		* d0 = x difference
		add.w	abs_y(a1),d1		* d1 = y difference
1$

*	xabs = yabs = xdir = ydir = 0;

		clr.l	d6					* xdir = 0;
		clr.l	d7					* ydir = 0;

*	if (xdif > 0) { xabs = xdif; xdir = 1; }

		tst.w	d0					* if (xdif > 0)
		beq		3$					* if xdif = 0, do nothing
		bmi		2$					* if xdif < 0
		moveq	#1,d6				* xdir = 1; xabs = xdif
		bra		3$

*	if (xdif < 0) { xabs = -xdif; xdir = -1; }

2$		neg.w	d0					* xabs = -xdif
		moveq	#-1,d6				* xdir = -1;
3$

*	if (ydif > 0) { yabs = ydif; ydir = 1; }

		tst.w	d1					* if (ydif > 0)
		beq		5$					* if ydif = 0, do nothing
		bmi		4$					* if ydif < 0
		moveq	#1,d7				* ydir = 1; yabs = ydif
		bra		5$

*	if (ydif < 0) { yabs = -ydif; ydir = -1; }

4$		neg.w	d1					* yabs = -ydif
		moveq	#-1,d7				* ydir = -1;
5$

*	if (mode != 4)

		cmp.b	#4,d3				* if mode 4
		beq		6$					* then dont do

*	{	if ((xabs>>1) > yabs) ydir = 0	* SMART_SEEK

		move.w	d0,d4				* copy xabs
		lsr.w	#1,d4				* d4 = xabs >> 1
		cmp.w	d4,d1				* if (xabs>>1) > yabs
		bge.s	55$
		clr.l	d7
55$

*		if ((yabs>>1) > xabs) xdir = 0;

		move.w	d1,d4				* copy yabs
		lsr.w	#1,d4				* d4 = yabs >> 1
		cmp.w	d4,d0				* if (yabs>>1) > xabs
		bge.s	6$
		clr.l	d6					* xdir = 0
6$

*	deviation = 0;

		clr.l	d4					* d4 = deviation = 0

*	if (mode==1 && (xabs+yabs) < 40) deviation = 1;

		move.w	d0,d5				* d5 = xabs
		add.w	d1,d5				* d5 = xabs + yabs

		cmp.b	#1,d3				* if (mode == 1)
		bne.s	7$
		cmp.w	#40,d5				* and (dist < 40)
		bge.s	7$
		moveq	#1,d4				* deviation = 1;
7$

*	else if (mode==2 && (xabs+yabs) < 30) deviation = 2;

		cmp.b	#2,d3				* if (mode == 2)
		bne.s	8$
		cmp.w	#30,d5				* and (dist < 30)
		bge.s	8$
		moveq	#1,d4				* deviation = 1;
8$
*	else if (mode==3) { xdir = -xdir; ydir = -ydir; }

		cmp.b	#3,d3
		bne.s	81$
		neg.b	d6					* xdir = -xdir;
		neg.b	d7					* ydir = -ydir

*	j = com2[4 - ydir - ydir - ydir - xdir];
81$
		moveq	#4,d5				* d4 = 4
		sub.b	d7,d5
		sub.b	d7,d5
		sub.b	d7,d5
		sub.b	d6,d5				* d4 - 4 - ydir - ydir - ydir - xdir
		lea		com2(pc),a0
		move.b	(a0,d5.w),d5		* d5 = j = com2[d5]

*	if (j == 9) anim_list[object].state = STILL;

		cmp.b	#9,d5
		bne.s	9$
		move.b	#13,state(a1)		* #STILL -> anim_list[object].state
		bra		99$
9$

*	else 
*	{	if (rand()&1) j += deviation; else j -= deviation;

		jsr		_rand				* go left or right
		btst	#1,d0				* test a bit
		beq		10$
		add.b	d4,d5				* j += deviation
		bra		11$
10$	sub.b	d4,d5				* j -= deviation

*		anim_list[object].facing = j & 7;

11$	and.b	#7,d5				* and j with 7
		move.b	d5,facing(a1)		* move to facing

*		if (mode != 5) anim_list[object].state = WALKING;

		cmp.b	#5,d3				* if mode != 5
		beq		99$				* move #WALKING to state
		move.b	#12,state(a1)
99$	movem.l	(sp)+,d0-d7/a0-a1
		rts