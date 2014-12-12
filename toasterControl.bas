let b9 = %00000000
symbol potentiometer = b0
symbol toastTimeDuration = b1
symbol toastTimeCounter = b2
symbol decimalCounter = b3
symbol thermistor = w2
symbol button1 = b6 	;button1-3: dummy button vars for 'button' command
symbol button2 = b7
symbol button3 = b8
symbol inMask = b9
symbol timeElapsed = b10
symbol pauseCounter = b11
symbol bcd0 = b.0
symbol bcd1 = b.1
symbol bcd2 = b.2
symbol bcd3 = b.3
symbol decimal = b.4
symbol triac = b.7
symbol start = 4
symbol cancel = 5

Init:
	pwmout 2,32,67	;PWM to drive 7seg (reduces current), 30kHz @ 50% DC
	pwmout 1,24,0	;PWM electromagnet to reduce current @40kHz, set to 0 DC to turn off initially
	high decimal 	;set B.4 high to turn off decimal point
	high triac	;set B.7 high to turn off triac to begin
	
Idle:
	;*******
	;*	idle operation is to just continuously display the
	;*	time-cycle setting set by a single-turn potentiometer
	;*******
	
	;TODO read thermistor to adjust heat setting
	;readadc10 1,thermistor
	;debug thermistor
	
	;has the start lever been pressed, then start toasting
	button start,1,255,0,button3,1,ToastStart
	
	readadc 0,potentiometer	;read the val of the potentiometer
	select case potentiometer
	case > 224	;display 9
		toastTimeDuration = 9
		gosub Nine
	case > 196	;display 8
		toastTimeDuration = 8
		gosub Eight
	case > 168	;display 7
		toastTimeDuration = 7
		gosub Seven
	case > 140	;display 6
		toastTimeDuration = 6
		gosub Six
	case > 112	;display 5
		toastTimeDuration = 5
		gosub Five
	case > 84	;display 4
		toastTimeDuration = 4
		gosub Four
	case > 56	;display 3
		toastTimeDuration = 3
		gosub Three
	case > 28	;display 2
		toastTimeDuration = 2
		gosub Two
	else 	;display 1
		toastTimeDuration = 1
		gosub One
	endselect
	
	goto Idle

interrupt:
	pause 2 	;pause to align zero cross trigger with zero cross
	pulsout triac,10	;pulse the fet to in turn pulse triac gate to trigger the triac
	inMask = inMask ^  %01000000	;check for the next edge, rising or falling
	setint inMask,%01000000	;set interrupt for zero cross on pin 7
	
	return
	
ToastStart:
	pwmduty 1,55	;turn on the electromagnet @40kHz @55% DC
	setint inMask,%01000000	;set interrupt for zero cross on pin 7
	
	for toastTimeCounter = toastTimeDuration to 0 step -1
		if toastTimeCounter = 0 then exit	;exit when 0 like this or cycles will last 10s more than they should
		select case toastTimeCounter	;display the number for time left
		case 9
			gosub Nine
		case 8
			gosub Eight
		case 7
			gosub Seven
		case 6
			gosub Six
		case 5
			gosub Five
		case 4
			gosub Four
		case 3
			gosub Three
		case 2
			gosub Two
		case 1
			gosub One
		endselect
		;blink decimal for 10s before decrementing count to next display number
		;should have used zero cross 60Hz as timing instead of loops and pauses but this is what happens at 4am...
		for decimalCounter = 0 to 70
			;check for cancel button pressed
			button cancel,1,255,0,button1,1,endCycle
			;has the start lever been released manually, then exit
			button start,0,255,0,button2,1,endCycle
			;blink decimal
			toggle decimal 	;blink decimal
			for pauseCounter = 0 to 15
				readadc10 1,thermistor
				if thermistor < 45 then
					setint off
				else 
					setint inMask,%01000000
				endif
				pause 4 	;break the pause into multiple smaller ones so interrupt does not disturb the timing 
			next pauseCounter
		next decimalCounter
	next toastTimeCounter
	
endCycle:
	setint off	;turn off the triac trigger interrupt
	pwmduty 1,0	;turn off electromagnet
	high decimal	;make sure the decimal is off
	goto Idle
	
;Display numbers
Nine:
	high bcd3	;output BCD 9 to display 9 on 7seg
	low bcd2
	low bcd1
	high bcd0
	return
	
Eight:
	high bcd3	;output BCD 8 to display 8 on 7seg
	low bcd2
	low bcd1
	low bcd0
	return
	
Seven:
	low bcd3	;output BCD 7 to display 7 on 7seg
	high bcd2
	high bcd1
	high bcd0
	return
	
Six:
	low bcd3	;output BCD 6 to display 6 on 7seg
	high bcd2
	high bcd1
	low bcd0
	return
	
Five:
	low bcd3	;output BCD 5 to display 5 on 7seg
	high bcd2
	low bcd1
	high bcd0
	return
	
Four:
	low bcd3	;output BCD 4 to display 4 on 7seg
	high bcd2
	low bcd1
	low bcd0
	return
	
Three:
	low bcd3	;putput BCD 3 to display 3 on 7seg
	low bcd2
	high bcd1
	high bcd0
	return
	
Two:
	low bcd3	;output BCD 2 to display 2 on 7seg
	low bcd2
	high bcd1
	low bcd0
	return
	
One:
	low bcd3	;output BCD 1 to display 1 on 7seg
	low bcd2
	low bcd1
	high bcd0
	return
	
Zero:
	low bcd3	;output BCD 0 to display 0 on 7seg
	low bcd2
	low bcd1
	low bcd0
	return