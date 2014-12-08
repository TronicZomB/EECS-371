Init:
	pwmout pwmdiv16,1,255,500	;PWM to drive decimal point 
	pwmout pwmdiv16,2,255,500	;PWM to drive 7seg (reduces current)

Idle:
	;*******
	;*	idle operation is to just continuously display the
	;*	time-cycle setting set by a single-turn potentiometer
	;*******
	
	;readadc10 1,w1
	;debug w1
	
	pwmduty 1, 0	;turn off decimal PWM until ToastStart
	
	readadc 0,b0	;read the val of the potentiometer
	select case b0
	case > 224	;display 9
		gosub Nine
	case > 196	;display 8
		gosub Eight
	case > 168	;display 7
		gosub Seven
	case > 140	;display 6
		gosub Six
	case > 112	;display 5
		gosub Five
	case > 84	;display 4
		gosub Four
	case > 56	;display 3
		gosub Three
	case > 28	;display 2
		gosub Two
	else 	;display 1
		gosub One
	endselect
	
	goto Idle

ToastStart:
	pwmduty 1,500	;turn on decimal point to show toasting start
	timer = 10000	;set timer count to 10 seconds
	
	;pause timer 	;pause for 10 sec
	
Nine:
	high B.3	;output BCD 9 to display 9 on 7seg
	low B.2
	low B.1
	high B.0
	return
	
Eight:
	high B.3	;output BCD 8 to display 8 on 7seg
	low B.2
	low B.1
	low B.0
	return
	
Seven:
	low B.3	;output BCD 7 to display 7 on 7seg
	high B.2
	high B.1
	high B.0
	return
	
Six:
	low B.3	;output BCD 6 to display 6 on 7seg
	high B.2
	high B.1
	low B.0
	return
	
Five:
	low B.3	;output BCD 5 to display 5 on 7seg
	high B.2
	low B.1
	high B.0
	return
	
Four:
	low B.3	;output BCD 4 to display 4 on 7seg
	high B.2
	low B.1
	low B.0
	return
	
Three:
	low B.3	;putput BCD 3 to display 3 on 7seg
	low B.2
	high B.1
	high B.0
	return
	
Two:
	low B.3	;output BCD 2 to display 2 on 7seg
	low B.2
	high B.1
	low B.0
	return
	
One:
	low B.3	;output BCD 1 to display 1 on 7seg
	low B.2
	low B.1
	high B.0
	return
	
Zero:
	low B.3	;output BCD 0 to display 0 on 7seg
	low B.2
	low B.1
	low B.0
	return