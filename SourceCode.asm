INCLUDE Irvine32.inc

BoxWidth = 20
BoxHeight = 7
mouseWidth = 3
mouseHeight = 4

.data
highestScoreString BYTE "歷史最高分數: ",0
highestScore DWORD 0
fileName BYTE "score.txt",0
fileHandle HANDLE ?
redPopProbability DWORD 5
menuTitle BYTE "***打地鼠***",0
menuTurtorialTitle BYTE "按1~9打對應格子的地鼠",0dh,0ah,0;
menuTutorialGraph BYTE "-------------------",0dh,0ah,
					   "|  7  |  8  |  9  |",0dh,0ah,
					   "|  4  |  5  |  6  |",0dh,0ah,
					   "|  1  |  2  |  3  |",0dh,0ah,
					   "-------------------",0dh,0ah,0
menuStartMessage BYTE "按W開始",0

endTitle BYTE "你的分數: ", 0
endRestart BYTE "按W重新開始，按其他按鍵離開", 0
totalTime DWORD ?
divisor DWORD 1000
gameStartTime DWORD ?
timeString BYTE "     time: ",0
score DWORD 0
scoreString BYTE "score: ",0
lastUpdatePopTime DWORD ?
popBaseTime DWORD ?
lastUpdateDrawTime DWORD ?
popUp byte 0,0,0,0,0,0,0,0,0
redPopUp byte 0,0,0,0,0,0,0,0,0
counter byte 0						;給loop用的counter
mousePicture BYTE "***"				;地鼠的1/3
keyBuffer BYTE ?				
baseTime DWORD ?						;遊戲一開始就記住系統時間
currentTime DWORD 0
boxTop    BYTE BoxWidth DUP('*')
boxBody   BYTE '*',(BoxWidth - 2)DUP(' '),'*'
boxBottom BYTE BoxWidth DUP('*')
fps BYTE 33
outputHandle DWORD 0
bytesWritten DWORD 0
count DWORD 0
mousePosition COORD <BoxWidth+8,BoxHeight+2>, <BoxWidth+28,BoxHeight+2>, <BoxWidth+48,BoxHeight+2>, <BoxWidth+8,BoxHeight+9>, <BoxWidth+28,BoxHeight+9>, <BoxWidth+48,BoxHeight+9>, <BoxWidth+8,BoxHeight+16>, <BoxWidth+28,BoxHeight+16>, <BoxWidth+48,BoxHeight+16>
position COORD <BoxWidth,BoxHeight>,<BoxWidth*2,BoxHeight>,<BoxWidth*3,BoxHeight>,<BoxWidth*1,BoxHeight*2>,<BoxWidth*2,BoxHeight*2>,<BoxWidth*3,BoxHeight*2>,<BoxWidth*1,BoxHeight*3>,<BoxWidth*2,BoxHeight*3>,<BoxWidth*3,BoxHeight*3>
cellsWritten DWORD ?
attributesNotHit0 WORD BoxWidth DUP(0Ah)
attributesNotHit1 WORD 0Ah, (BoxWidth-2) DUP(0), 0Ah
attributesNotHit2 WORD BoxWidth DUP(0Ah)
attributesHit0 WORD BoxWidth DUP(0Ch)
attributesHit1 WORD 0Ch, (BoxWidth-2) DUP(0), 0Ch
attributesHit2 WORD BoxWidth DUP(0Ch)
.code 
setRedPop PROC USES eax edx ebx
	call Randomize
	mov eax, redPopProbability
	INVOKE RandomRange
	.IF eax ==  0 && popUp[0] == 0
		mov redPopUp[0], 1                 ;if eax is 0, the red rat at redPopUp[i] shows up.
	.ELSE
		mov redPopUp[0],0                  ;if eax is 1, the rat rat at redDopUp[i] hides. 
	.ENDIF

	mov eax, redPopProbability
	INVOKE RandomRange
	.IF eax ==  0 && popUp[1] == 0
		mov redPopUp[1], 1                 ;if eax is 0, the red rat at redPopUp[i] shows up.
	.ELSE
		mov redPopUp[1],0                  ;if eax is 1, the rat rat at redDopUp[i] hides. 
	.ENDIF

	mov eax, redPopProbability
	INVOKE RandomRange
	.IF eax ==  0 && popUp[2] == 0
		mov redPopUp[2], 1                 ;if eax is 0, the red rat at redPopUp[i] shows up.
	.ELSE
		mov redPopUp[2],0                  ;if eax is 1, the rat rat at redDopUp[i] hides. 
	.ENDIF

	mov eax, redPopProbability
	INVOKE RandomRange
	.IF eax ==  0 && popUp[3] == 0
		mov redPopUp[3], 1                 ;if eax is 0, the red rat at redPopUp[i] shows up.
	.ELSE
		mov redPopUp[3],0                  ;if eax is 1, the rat rat at redDopUp[i] hides. 
	.ENDIF

	mov eax, redPopProbability
	INVOKE RandomRange
	.IF eax ==  0 && popUp[4] == 0
		mov redPopUp[4], 1                 ;if eax is 0, the red rat at redPopUp[i] shows up.
	.ELSE                  
		mov redPopUp[4],0                  ;if eax is 1, the rat rat at redDopUp[i] hides. 
	.ENDIF                        

	mov eax, redPopProbability
	INVOKE RandomRange
	.IF eax ==  0 && popUp[5] == 0
		mov redPopUp[5], 1                 ;if eax is 0, the red rat at redPopUp[i] shows up.
	.ELSE
		mov redPopUp[5],0                  ;if eax is 1, the rat rat at redDopUp[i] hides. 
	.ENDIF

	mov eax, redPopProbability
	INVOKE RandomRange
	.IF eax ==  0 && popUp[6] == 0
		mov redPopUp[6], 1                 ;if eax is 0, the red rat at redPopUp[i] shows up.
	.ELSE
		mov redPopUp[6],0                  ;if eax is 1, the rat rat at redDopUp[i] hides. 
	.ENDIF

	mov eax, redPopProbability
	INVOKE RandomRange
	.IF eax ==  0 && popUp[7] == 0
		mov redPopUp[7], 1                 ;if eax is 0, the red rat at redPopUp[i] shows up.
	.ELSE
		mov redPopUp[7],0                  ;if eax is 1, the rat rat at redDopUp[i] hides. 
	.ENDIF

	mov eax, redPopProbability
	INVOKE RandomRange
	.IF eax ==  0 && popUp[8] == 0
		mov redPopUp[8], 1                 ;if eax is 0, the red rat at redPopUp[i] shows up.
	.ELSE
		mov redPopUp[8],0                  ;if eax is 1, the rat rat at redDopUp[i] hides. 
	.ENDIF
	ret
setRedPop ENDP
setPop PROC USES eax edx ebx			;讓地鼠陣列隨機出現0 or 1   
	call Randomize  
	mov eax, 2							;set the range of random number [0,2)
	INVOKE RandomRange                  ;store a randon number in eax
	.IF eax ==  0
		mov popUp[0], 1                 ;if eax is 0, the rat at popUp[i] shows up.
	.ELSE
		mov popUp[0],0                  ;if eax is 1, the rat at popUp[i] hides. 
	.ENDIF

	mov eax, 2				
	INVOKE RandomRange
	.IF eax ==  0
		mov popUp[1], 1
	.ELSE
		mov popUp[1],0
	.ENDIF

	mov eax, 2				
	INVOKE RandomRange
	.IF eax ==  0
		mov popUp[2], 1
	.ELSE
		mov popUp[2],0
	.ENDIF

	mov eax, 2				
	INVOKE RandomRange
	.IF eax ==  0
		mov popUp[3], 1
	.ELSE
		mov popUp[3],0
	.ENDIF

	mov eax, 2				
	INVOKE RandomRange
	.IF eax ==  0
		mov popUp[4], 1
	.ELSE
		mov popUp[4],0
	.ENDIF

	mov eax, 2				
	INVOKE RandomRange
	.IF eax ==  0
		mov popUp[5], 1
	.ELSE
		mov popUp[5],0
	.ENDIF

	mov eax, 2				
	INVOKE RandomRange
	.IF eax ==  0
		mov popUp[6], 1
	.ELSE
		mov popUp[6],0
	.ENDIF

	mov eax, 2				
	INVOKE RandomRange
	.IF eax ==  0
		mov popUp[7], 1
	.ELSE
		mov popUp[7],0
	.ENDIF

	mov eax, 2				;set the range of random number [0,2)
	INVOKE RandomRange		;store a randon number in eax
	.IF eax ==  0
		mov popUp[8], 1	    ;if eax is 0, the rat at popUp[i] shows up.
	.ELSE
		mov popUp[8],0		;if eax is 1, the rat at popUp[i] hides. 
	.ENDIF
	;mov popUp[0],0
	ret
setPop ENDP

drawMouse PROC USES eax ecx edx,
    xyPosition:COORD,
    attributes0:PTR WORD,
    attributes1:PTR WORD,
    attributes2:PTR WORD
	mov counter, 3

	push xyPosition
L1:  INVOKE WriteConsoleOutputAttribute,
      outputHandle, 
      attributes0,
      mouseWidth, 
      xyPosition,
      addr bytesWritten
    INVOKE WriteConsoleOutputCharacter,
       outputHandle,    ; console output handle
       addr mousePicture,    ; pointer to the mouse
       mouseWidth,    ; size of box line
       xyPosition,    ; coordinates of first char
       addr count     ; output count
	inc xyPosition.Y
	dec counter
	cmp counter, 0
	jne L1
	pop xyPosition
	   ret
drawMouse ENDP

drawBackGround PROC USES eax ecx,
	xyPosition:COORD,
	attributes0:PTR WORD,
	attributes1:PTR WORD,
	attributes2:PTR WORD
	invoke getStdHandle, STD_OUTPUT_HANDLE
	mov outputHandle, eax	; save console handle
	;call Clrscr
	; draw top of the box
	INVOKE WriteConsoleOutputAttribute,
	  outputHandle, 
	  attributes0,
	  BoxWidth, 
	  xyPosition,
	  addr bytesWritten
	INVOKE WriteConsoleOutputCharacter,
	   outputHandle,	; console output handle
	   addr boxTop,	    ; pointer to the top box line
	   BoxWidth,	    ; size of box line
	   xyPosition,	    ; coordinates of first char
	   addr count	    ; output count	
	inc xyPosition.y	; next line
	; draw body of the box
	mov ecx, BoxHeight-2	; number of lines in body
L1:	push ecx	; save counter

	INVOKE WriteConsoleOutputAttribute,
	  outputHandle, 
	  attributes1,
	  BoxWidth, 
	  xyPosition,
	  addr bytesWritten

	INVOKE WriteConsoleOutputCharacter,
	   outputHandle,	; console output handle
	   addr boxBody,	; pointer to the box body
	   BoxWidth,	; size of box line
	   xyPosition,	; coordinates of first char
	   addr count	; output count
	inc xyPosition.y	; next line
	pop ecx	; restore counter
	loop L1
	; draw bottom of the box
	INVOKE WriteConsoleOutputAttribute,
	  outputHandle, 
	  attributes2,
	  BoxWidth, 
	  xyPosition,
	  addr bytesWritten
	  	
	INVOKE WriteConsoleOutputCharacter,
	   outputHandle,	; console output handle
	   addr boxBottom,	; pointer to the bottom of the box
	   BoxWidth,	; size of box line
	   xyPosition,	; coordinates of first char
	   addr count	; output count
	   ;call WaitMsg
	   ;call Clrscr
	   ret
drawBackGround ENDP

menuPage MACRO 
		call Clrscr
		mov edx, OFFSET menuTitle 
		INVOKE WriteString
		mov edx, OFFSET menuTurtorialTitle 
		INVOKE Crlf
		INVOKE WriteString
		mov edx, OFFSET menuTutorialGraph
		INVOKE WriteString
		INVOKE Crlf
		mov edx, OFFSET menuStartMessage
		INVOKE WriteString
		INVOKE Crlf
		INVOKE ReadChar
		.IF al == 'w' || al == 'W'
			jmp startPrepare
		.ELSE
			jmp EX
		.ENDIF
ENDM

initialize MACRO
INVOKE GetTickCount
	mov baseTime, eax
	mov popBaseTime, eax
	mov gameStartTime, eax ;紀錄遊戲開始時間
	mov totalTime, 20
	mov score, 0
	mov popUp[0],0
	mov popUp[1],0
	mov popUp[2],0
	mov popUp[3],0
	mov popUp[4],0
	mov popUp[5],0
	mov popUp[6],0
	mov popUp[7],0
	mov popUp[8],0
	mov redPopUp[0],0
	mov redPopUp[1],0
	mov redPopUp[2],0
	mov redPopUp[3],0
	mov redPopUp[4],0
	mov redPopUp[5],0
	mov redPopUp[6],0
	mov redPopUp[7],0
	mov redPopUp[8],0
ENDM

updateRatArray MACRO
	INVOKE GetTickCount
	sub eax, popBaseTime  ;將距離上一次更新畫面的時間存入eax
	mov lastUpdatePopTime, eax       ;將距離上一次更新畫面的時間存入edx	
	.IF lastUpdatePopTime>2000
		INVOKE setPop
		INVOKE setRedPop
		INVOKE GetTickCount
		mov popBaseTime, eax
	.ENDIF
ENDM

updateDrawBackground MACRO
		INVOKE drawBackGround, position[sizeof coord*0], addr attributesNotHit0, addr attributesNotHit1, addr attributesNotHit2
		INVOKE drawBackGround, position[sizeof coord*1], addr attributesNotHit0, addr attributesNotHit1, addr attributesNotHit2
		INVOKE drawBackGround, position[sizeof coord*2], addr attributesNotHit0, addr attributesNotHit1, addr attributesNotHit2
		INVOKE drawBackGround, position[sizeof coord*3], addr attributesNotHit0, addr attributesNotHit1, addr attributesNotHit2
		INVOKE drawBackGround, position[sizeof coord*4], addr attributesNotHit0, addr attributesNotHit1, addr attributesNotHit2
		INVOKE drawBackGround, position[sizeof coord*5], addr attributesNotHit0, addr attributesNotHit1, addr attributesNotHit2
		INVOKE drawBackGround, position[sizeof coord*6], addr attributesNotHit0, addr attributesNotHit1, addr attributesNotHit2
		INVOKE drawBackGround, position[sizeof coord*7], addr attributesNotHit0, addr attributesNotHit1, addr attributesNotHit2
		INVOKE drawBackGround, position[sizeof coord*8], addr attributesNotHit0, addr attributesNotHit1, addr attributesNotHit2
ENDM

updateDrawRat MACRO
	.IF popUp[0] == 1
			INVOKE drawMouse, mousePosition[sizeof coord*0], addr attributesNotHit0, addr attributesNotHit1, addr attributesNotHit2
		.ENDIF
		.IF popUp[1] == 1
			INVOKE drawMouse, mousePosition[sizeof coord*1], addr attributesNotHit0, addr attributesNotHit1, addr attributesNotHit2
		.ENDIF
		.IF popUp[2] == 1
			INVOKE drawMouse, mousePosition[sizeof coord*2], addr attributesNotHit0, addr attributesNotHit1, addr attributesNotHit2
		.ENDIF
		.IF popUp[3] == 1
			INVOKE drawMouse, mousePosition[sizeof coord*3], addr attributesNotHit0, addr attributesNotHit1, addr attributesNotHit2
		.ENDIF
		.IF popUp[4] == 1
			INVOKE drawMouse, mousePosition[sizeof coord*4], addr attributesNotHit0, addr attributesNotHit1, addr attributesNotHit2
		.ENDIF
		.IF popUp[5] == 1
			INVOKE drawMouse, mousePosition[sizeof coord*5], addr attributesNotHit0, addr attributesNotHit1, addr attributesNotHit2
		.ENDIF
		.IF popUp[6] == 1
			INVOKE drawMouse, mousePosition[sizeof coord*6], addr attributesNotHit0, addr attributesNotHit1, addr attributesNotHit2
		.ENDIF
		.IF popUp[7] == 1
			INVOKE drawMouse, mousePosition[sizeof coord*7], addr attributesNotHit0, addr attributesNotHit1, addr attributesNotHit2
		.ENDIF
		.IF popUp[8] == 1
			INVOKE drawMouse, mousePosition[sizeof coord*8], addr attributesNotHit0, addr attributesNotHit1, addr attributesNotHit2
		.ENDIF
ENDM

updateDrawRedRat MACRO
.IF redPopUp[0] == 1
			INVOKE drawMouse, mousePosition[sizeof coord*0], addr attributesHit0, addr attributesHit1, addr attributesHit2
		.ENDIF
		.IF redPopUp[1] == 1
			INVOKE drawMouse, mousePosition[sizeof coord*1], addr attributesHit0, addr attributesHit1, addr attributesHit2
		.ENDIF
		.IF redPopUp[2] == 1
			INVOKE drawMouse, mousePosition[sizeof coord*2], addr attributesHit0, addr attributesHit1, addr attributesHit2
		.ENDIF
		.IF redPopUp[3] == 1
			INVOKE drawMouse, mousePosition[sizeof coord*3], addr attributesHit0, addr attributesHit1, addr attributesHit2
		.ENDIF
		.IF redPopUp[4] == 1
			INVOKE drawMouse, mousePosition[sizeof coord*4], addr attributesHit0, addr attributesHit1, addr attributesHit2
		.ENDIF
		.IF redPopUp[5] == 1
			INVOKE drawMouse, mousePosition[sizeof coord*5], addr attributesHit0, addr attributesHit1, addr attributesHit2
		.ENDIF
		.IF redPopUp[6] == 1
			INVOKE drawMouse, mousePosition[sizeof coord*6], addr attributesHit0, addr attributesHit1, addr attributesHit2
		.ENDIF
		.IF redPopUp[7] == 1
			INVOKE drawMouse, mousePosition[sizeof coord*7], addr attributesHit0, addr attributesHit1, addr attributesHit2
		.ENDIF
		.IF redPopUp[8] == 1
			INVOKE drawMouse, mousePosition[sizeof coord*8], addr attributesHit0, addr attributesNotHit1, addr attributesNotHit2
		.ENDIF
ENDM

handleGameInformation MACRO
		mov edx, OFFSET scoreString 
		INVOKE WriteString			;在畫面賞顯示"score: "
		mov eax, score
		INVOKE WriteDec				;在畫面上顯示目前分數
		mov edx, OFFSET timeString  
		INVOKE WriteString          ;在畫面上顯示"  time: "
		
		INVOKE GetTickCount
		sub eax, gameStartTime
		mov edx,0
		div divisor
		sub totalTime, eax
		.IF totalTime <= 0
			jmp endGame
		.ENDIF
		mov eax, totalTime
		mov totalTime, 20
		INVOKE WriteDec
		
		INVOKE GetTickCount         
		mov baseTime, eax
		jmp notEnd
ENDM

endGameMenu MACRO
	call Clrscr
		mov edx, OFFSET endTitle 
		INVOKE WriteString
		mov eax, score
		INVOKE WriteDec
		INVOKE Crlf
		mov edx, OFFSET endRestart
		INVOKE WriteString
		INVOKE Crlf
		;mov edx, OFFSET highestScoreString 
		;INVOKE WriteString
		;mov eax, highestScore
		;INVOKE WriteDec
		;INVOKE Crlf
		INVOKE ReadChar
		.IF al == 'w' || al == 'W'
			INVOKE GetTickCount
			jmp startPrepare
		.ELSE
			jmp EX
		.ENDIF
	.ENDIF
ENDM


readKeyboard MACRO
INVOKE ReadKey
	.IF al == '1'
		.IF popUp[6] == 1
			mov popUp[6], 0
			inc score
		.ELSEIF redPopUp[6] == 1
			mov redPopUp[6], 0
			.IF score > 0
				dec score
			.ENDIF
		.ENDIF
	.ENDIF
	.IF al == '2'
		.IF popUp[7] == 1
			mov popUp[7], 0
			inc score
		.ELSEIF redPopUp[7] == 1
			mov redPopUp[7], 0
			.IF score > 0
				dec score
			.ENDIF
		.ENDIF
	.ENDIF
	.IF al == '3'
		.IF popUp[8] == 1
			mov popUp[8], 0
			inc score
		.ELSEIF redPopUp[8] == 1
			mov redPopUp[8], 0
			.IF score > 0
				dec score
			.ENDIF
		.ENDIF
	.ENDIF
	.IF al == '4'
		.IF popUp[3] == 1
			mov popUp[3], 0
			inc score
		.ELSEIF redPopUp[3] == 1
			mov redPopUp[3], 0
			.IF score > 0
				dec score
			.ENDIF
		.ENDIF
	.ENDIF
	.IF al == '5'
		.IF popUp[4] == 1
			mov popUp[4], 0
			inc score
		.ELSEIF redPopUp[4] == 1
			mov redPopUp[4], 0
			.IF score > 0
				dec score
			.ENDIF
		.ENDIF
	.ENDIF
	.IF al == '6'
		.IF popUp[5] == 1
			mov popUp[5], 0
			inc score
		.ELSEIF redPopUp[5] == 1
			mov redPopUp[5], 0
			.IF score > 0
				dec score
			.ENDIF
		.ENDIF
	.ENDIF
	.IF al == '7'
		.IF popUp[0] == 1
			mov popUp[0], 0
			inc score
		.ELSEIF redPopUp[0] == 1
			mov redPopUp[0], 0
			.IF score > 0
				dec score
			.ENDIF
		.ENDIF
	.ENDIF
	.IF al == '8'
		.IF popUp[1] == 1
			mov popUp[1], 0
			inc score
		.ELSEIF redPopUp[1] == 1
			mov redPopUp[1], 0
			.IF score > 0
				dec score
			.ENDIF
		.ENDIF
	.ENDIF
	.IF al == '9'
		.IF popUp[2] == 1
			mov popUp[2], 0
			inc score
		.ELSEIF redPopUp[2] == 1
			mov redPopUp[2], 0
			.IF score > 0
				dec score
			.ENDIF
		.ENDIF
	.ENDIF
ENDM
main PROC
menu:
	menuPage

startPrepare:
	initialize
startGame: 
;--------------------------每?秒更新一次地鼠start-----------------------------------
	updateRatArray
;--------------------------每?秒更新一次地鼠end--------------------------------------

;--------------------------畫面更新start-------------------------------------------
	INVOKE GetTickCount
	sub eax, baseTime  ;將距離上一次更新畫面的時間存入eax
	mov lastUpdateDrawTime, eax       ;將距離上一次更新畫面的時間存入edx
	.IF lastUpdateDrawTime>33
		call Clrscr
		updateDrawBackground
		updateDrawRat
		updateDrawRedRat
		handleGameInformation
endGame:
	endGameMenu	
;----------------------------------------------------------------畫面更新end---------------------------------------------------------
notEnd:
	readKeyboard
	jmp startGame
EX:
	exit
main ENDP
END main