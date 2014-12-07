Main:

Idle:
	;this will change based on potentiometer input
	high 3	;continuously disply 9 on 7seg
	low 2
	low 1
	high 0
	
	readadc 0,b0
	debug b0
	
	goto Idle

ToastStart:
	timer = 10000	;set timer count to 10 seconds
Nine:
	high 3	;output BCD 9 to display 9 on 7seg
	low 2
	low 1
	high 0
	pause timer 	;pause for 10 sec
	
Eight:
	high 3	;output BCD 8 to display 8 on 7seg
	low 2
	low 1
	low 0
	pause timer 	;pause for 10 sec
	
Seven:
	low 3	;output BCD 7 to display 7 on 7seg
	high 2
	high 1
	high 0
	pause timer 	;pause for 10 sec
	
Six:
	low 3	;output BCD 6 to display 6 on 7seg
	high 2
	high 1
	low 0
	pause timer 	;pause for 10 sec
	
Five:
	low 3	;output BCD 5 to display 5 on 7seg
	high 2
	low 1
	high 0
	pause timer 	;pause for 10 sec
	
Four:
	low 3	;output BCD 4 to display 4 on 7seg
	high 2
	low 1
	low 0
	pause timer 	;pause for 10 sec
	
Three:
	low 3	;putput BCD 3 to display 3 on 7seg
	low 2
	high 1
	high 0
	pause timer 	;pause for 10 sec
	
Two:
	low 3	;output BCD 2 to display 2 on 7seg
	low 2
	high 1
	low 0
	pause timer 	;pause for 10 sec
	
One:
	low 3	;output BCD 1 to display 1 on 7seg
	low 2
	low 1
	high 0
	pause timer 	;pause for 10 sec
	
Zero:
	low 3	;output BCD 0 to display 0 on 7seg
	low 2
	low 1
	low 0
	pause timer 	;pause for 10 sec
	
	goto Idle	;loop for debugging purposes