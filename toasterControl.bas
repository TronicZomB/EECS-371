symbol potentiometer = b0
symbol toastTimeDuration = b1
symbol toastTimeCounter = b2
symbol decimalCounter = b3
symbol thermistor = w2
symbol bcd0 = b.0
symbol bcd1 = b.1
symbol bcd2 = b.2
symbol bcd3 = b.3
symbol decimal = b.4
symbol start = 4
symbol cancel = 5

Init:
	pwmout 2,32,67	;PWM to drive 7seg (reduces current), 30kHz @ 50% DC
	pwmout 1,32,0	;PWM electromagnet to reduce current, set to 0 DC to turn off initially
	setint %00000000,%00010000	;set interrupt for falling edge on pin In 4 to start toasting cycle
	high decimal 	;set B.4 high to turn off decimal point
	
Idle:
	;*******
	;*	idle operation is to just continuously display the
	;*	time-cycle setting set by a single-turn potentiometer
	;*******
	
	;TODO read thermistor to adjust heat setting
	;readadc10 1,thermistor
	;debug thermistor
	
	toggle b.7
	
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
ToastStart:
	;TODO start triac
	pwmduty 1,67	;turn on the electromagnet @30kHz
	
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
		for decimalCounter = 0 to 100
			;check for cancel button pressed
			button cancel,0,255,0,b6,1,lb1
			;has the start lever been release manually, then exit
			button start,1,255,0,b7,1,lb1
			;blink decimal
			toggle B.4 	;blink decimal
			pause 100	;pause 100 ms to produce 5Hz signal
		next decimalCounter
	next toastTimeCounter
	
lb1:
	gosub endCycle
	return
	
endCycle:
	;TODO release toaster cycle (triac)
	pwmduty 1,0	;turn off electromagnet
	high decimal	;make sure the decimal is off
	pause 100	;pause long enough for electromagnet to release and not trigger another "cycle"
	setint %00000000,%00010000	;set interrupt for falling edge on pin In 4 to start toasting cycle
	return
	
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