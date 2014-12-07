Main:

TTime:
	timer = 10000	;set timer count to 10 seconds
Nine:
	High 3	;output BCD 9 to display 9 on 7seg
	Low 2
	Low 1
	High 0
	Pause timer 	;pause for 10 sec
	
Eight:
	High 3	;output BCD 8 to display 8 on 7seg
	Low 2
	Low 1
	Low 0
	Pause timer 	;pause for 10 sec
	
Seven:
	Low 3	;output BCD 7 to display 7 on 7seg
	High 2
	High 1
	High 0
	Pause timer 	;pause for 10 sec
	
Six:
	Low 3	;output BCD 6 to display 6 on 7seg
	High 2
	High 1
	Low 0
	Pause timer 	;pause for 10 sec
	
Five:
	Low 3	;output BCD 5 to display 5 on 7seg
	High 2
	Low 1
	High 0
	Pause timer 	;pause for 10 sec
	
Four:
	Low 3	;output BCD 4 to display 4 on 7seg
	High 2
	Low 1
	Low 0
	Pause timer 	;pause for 10 sec
	
Three:
	Low 3	;putput BCD 3 to display 3 on 7seg
	Low 2
	High 1
	High 0
	Pause timer 	;pause for 10 sec
	
Two:
	Low 3	;output BCD 2 to display 2 on 7seg
	Low 2
	High 1
	Low 0
	Pause timer 	;pause for 10 sec
	
One:
	Low 3	;output BCD 1 to display 1 on 7seg
	Low 2
	Low 1
	High 0
	Pause timer 	;pause for 10 sec
	
Zero:
	Low 3	;output BCD 0 to display 0 on 7seg
	Low 2
	Low 1
	Low 0
	Pause timer 	;pause for 10 sec
	
	Goto Main	;loop for debugging purposes