.386
.model flat,stdcall
option casemap:none

include define.inc

.code
; ----------------------------------------------------
; ��Ϸ������
main proc
	call GetMaxXY
	call StartFrame
	call SchoolFrame
	call JudgeDouble	; �жϵ�����/˫����
GameLoop:
	call	ReadKey	; ���������al
	xor		edi,edi
	mov		dl,al
	call	UpdateParameter
	call	DrawFrame
	mov eax, 50
	call	Delay
	jmp		GameLoop

	exit
main endp

; ----------------------------------------------------
; �ȴ�����
JudgeDouble Proc
	; �����ȴ�����
	Call ReadChar
	.if(al==87 || al==119)		; W,w
		mov doubleFlag,1	
		ret
	.endif
	mov	doubleFlag,0	;�������Ĭ�ϵ�����
	ret
JudgeDouble Endp

writeStrWithSP proc									
	Call WriteString
	Call Crlf
	ret
writeStrWithSP endp

valuesToDrawBorder PROC
	mov dx, 0
	Call Gotoxy
	mov eax, borderColor
	Call SetTextColor
	mov edx, offset borderbk-164							
ret
valuesToDrawBorder ENDP

drawBorder proc			
	mov dx, 0
	Call Gotoxy
	mov eax, 9			
	Call SetTextColor
	mov edx, offset borderbk-164
	Call valuesToDrawBorder
	mov ecx, 93									
	printMap:
		add edx, 164								
		Call writeStrWithSP							
	loop printMap
	doneWithMap:
	ret
drawBorder endp

; ----------------------------------------------------
; ����������
DrawFrame Proc

	;mov	ebx,50				; x����
	;mov ecx,50				; y����
	;mov	edx,offset ballMsg	; ���Ի���
	;mov	esi,ballWidth
	;call DrawObject

	; �ж��Ƿ�ʤ��
	cmp	winFlag,1
	je	Winner

	; �ж��Ƿ�ʧ��
	cmp	loseFlag,1
	je	Loser

	.if(levelFlag==1)
		call GameFrame1
		ret
	.endif
	
	
	.if(levelFlag==2)
		
		call GameFrame2
		ret
	.endif
	
	
	.if(levelFlag==3)
		call GameFrame3
		ret
	.endif

Winner:
	mov eax, 200
	call Delay
	call WinFrame
Loser:
	mov eax, 200
	Call Delay
	Call LoseFrame
	ret

DrawFrame Endp


text PROC							
		Call SetTextColor
		mov al, bl
		Call WriteChar
ret
text ENDP
yellowText PROC							;SetTextToYellow
	
yellowText ENDP

; ----------------------------------------------------
; ��ʼ����
StartFrame Proc
	xor bl,bl
	mov eax, 14					
	Call SetTextColor
	mov edx,offset titlebk0
SFLoop:
	mov eax,10
	call Delay
	.if ( bl < 29)
		add edx,165
		call WriteString
		call Crlf
		inc bl
	.endif
	.if ( bl == 29)
		mov eax,200
		call Delay
	.endif
	.if ( bl > 27 && bl < 69)
		mov eax,4
		call SetTextColor
		add edx,165
		call WriteString
		call Crlf
		inc bl
	.endif
	
	.if ( bl > 68 )
		mov eax,8
		call SetTextColor
		add edx,165
		call WriteString
		call Crlf
		inc bl
	.endif
	.if	bl <= 92
		jmp SFLoop
	.endif
	xor ecx,ecx
	ret
StartFrame Endp

; ----------------------------------------------------
; У��
SchoolFrame Proc
	mov eax,15
	call SetTextColor
	xor bl,bl
	mov edx,offset schoolbk0
SHFLoop:
	mov eax,10
	call Delay
	mov dl,170
	mov dh,bl
	call Gotoxy
	mov edx,offset schoolbk0
	mov eax,165
	mul bl
	add edx,eax
	call WriteString
	inc bl
	.if	bl <= 92
		jmp SHFLoop
	.endif
	xor ecx,ecx
	ret
SchoolFrame Endp

; ----------------------------------------------------
; ��ʤ����
WinFrame Proc
	call Clrscr
	xor bl,bl
	mov edx,offset winbk0
WFLoop:
	add edx,139
	call WriteString
	call Crlf
	inc bl
	.if	bl<=55
		jmp WFLoop
	.endif
	xor ecx,ecx

	mov eax, 1000						
	call Delay
	exit
WinFrame Endp

; ----------------------------------------------------
; ʧ�ܽ������
LoseFrame Proc
	call Clrscr
	xor bl,bl
	mov edx,offset losebk0
LFLoop:
	add edx,139
	call WriteString
	call Crlf
	inc bl
	.if	bl <= 55
		jmp LFLoop
	.endif
	xor ecx,ecx
	
	mov eax, 1000	
	call Delay
	exit
LoseFrame Endp

; ----------------------------------------------------
; ��һ��
GameFrame1 Proc
	;call Clrscr
	call drawBorder				;���ɱ߽�
	
	call ClearObjects			; �������
	
	xor ebp,ebp					; ש�����
	mov ecx,brickStartY			; y����
	mov ebx,brickStartX			; x����
	mov edi,offset brickShape	;ש����״
	mov esi,brickWidth			;ש����
BrickLoop:
	.if(brickLife[ebp] > 0)		;���ש�����
		mov edi,offset brickShape	;����ש����״
		add ebx,brickLen					;x����
		.if(ebp == 0 || ebp == 11 || ebp == 22 || ebp == 33 || ebp == 44 || ebp == 55 || ebp == 66 || ebp == 77 || ebp == 88)
			add ecx, brickWidth		;����
			mov ebx,5
		.endif
		mov eax,5
		call RandomRange
		inc eax
		call SetTextColor
		call DrawObject

		;mov edx, edi
		;call WriteString
	.else
		mov edi,offset brickShapeEmpty
		add ebx,brickLen
		.if(ebp == 0 || ebp == 11 || ebp == 22 || ebp == 33 || ebp == 44 || ebp == 55 || ebp == 66 || ebp == 77 || ebp == 88)
			add ecx, brickWidth
			mov ebx,5
		.endif
		call DrawObject

		;mov edx, edi
		;call WriteString
	.endif
	inc ebp
	
	.if(ebp < 99)
		jmp BrickLoop

	.endif
	
	mov	ebx,ballPosX				; x����
	mov	ecx,ballPosY				; y����
	mov	edi,offset ballMsg			; ����
	mov	esi,ballWidth
	mov eax,ballColor
	call SetTextColor
	call DrawObject

	mov	ebx,racketPosX				; x����
	mov	ecx,racketPosY				; y����
	mov	edi,offset racketMsg		; ������1
	mov	esi,racketWidth
	mov eax,racketColor
	call SetTextColor
	call DrawObject
	.if( doubleFlag == 1)
	mov	ebx,racket2PosX				; x����
	mov	ecx,racket2PosY				; y����
	mov	edi,offset racketMsg		; ������2
	mov	esi,racketWidth
	mov eax,racketColor
	call SetTextColor
	call DrawObject
	.endif
	ret
GameFrame1 Endp
; ----------------------------------------------------
; ----------------------------------------------------
; ���Ĺ� ��ӹ̶�����
GameFrame2 Proc
	;call Clrscr
	mov isBaffle,1
	call drawBorder				;���ɱ߽�
	
	call ClearObjects			; �������
	
	xor ebp,ebp					; ש�����
	mov ecx,brickStartY			; y����
	mov ebx,brickStartX			; x����
	mov edi,offset brickShape	;ש����״
	mov esi,brickWidth			;ש����
	
BrickLoop:
	.if(brickLife[ebp] > 0)		;���ש�����
		mov edi,offset brickShape	;����ש����״
		add ebx,brickLen					;x����
		.if(ebp == 0 || ebp == 11 || ebp == 22 || ebp == 33 || ebp == 44 || ebp == 55 || ebp == 66 || ebp == 77 || ebp == 88)
			add ecx, brickWidth		;����
			mov ebx,5
		.endif
		mov eax,5
		call RandomRange
		inc eax
		call SetTextColor
		call DrawObject

		;mov edx, edi
		;call WriteString
	.else
		mov edi,offset brickShapeEmpty
		add ebx,brickLen
		.if(ebp == 0 || ebp == 11 || ebp == 22 || ebp == 33 || ebp == 44 || ebp == 55 || ebp == 66 || ebp == 77 || ebp == 88)
			add ecx, brickWidth
			mov ebx,5
		.endif
		call DrawObject

		;mov edx, edi
		;call WriteString
	.endif
	inc ebp
	
	.if(ebp < 99)
		jmp BrickLoop

	.endif

	
	mov	ebx,baffle1PosX				; x����
	mov	ecx,baffle1PosY				; y����
	mov	edi,offset baffle1Msg		; ������1
	mov	esi,baffle1Width
	mov eax,baffleColor
	call SetTextColor
	call DrawObject
	mov	ebx,baffle2PosX				; x����
	mov	ecx,baffle2PosY				; y����
	mov	edi,offset baffle2Msg		; ������2
	mov	esi,baffle2Width
	mov eax,baffleColor
	call SetTextColor
	call DrawObject

	mov	ebx,ballPosX				; x����
	mov	ecx,ballPosY				; y����
	mov	edi,offset ballMsg			; ����
	mov	esi,ballWidth
	mov eax,ballColor
	call SetTextColor
	call DrawObject

	mov	ebx,racketPosX				; x����
	mov	ecx,racketPosY				; y����
	mov	edi,offset racketMsg		; ������1
	mov	esi,racketWidth
	mov eax,racketColor
	call SetTextColor
	call DrawObject

	.if( doubleFlag == 1)
	mov	ebx,racket2PosX				; x����
	mov	ecx,racket2PosY				; y����
	mov	edi,offset racketMsg		; ������2
	mov	esi,racketWidth
	mov eax,racketColor
	call SetTextColor
	call DrawObject
	.endif
		
	ret
GameFrame2 Endp
; ----------------------------------------------------
; ����� ����ƶ�����
GameFrame3 Proc
	;call Clrscr
	call drawBorder				;���ɱ߽�
	
	call ClearObjects			; �������
	
	xor ebp,ebp					; ש�����
	mov ecx,brickStartY			; y����
	mov ebx,brickStartX			; x����
	mov edi,offset brickShape	;ש����״
	mov esi,brickWidth			;ש����
	
BrickLoop:
	.if(brickLife[ebp] > 0)		;���ש�����
		mov edi,offset brickShape	;����ש����״
		add ebx,brickLen					;x����
		.if(ebp == 0 || ebp == 11 || ebp == 22 || ebp == 33 || ebp == 44 || ebp == 55 || ebp == 66 || ebp == 77 || ebp == 88)
			add ecx, brickWidth		;����
			mov ebx,5
		.endif
		mov eax,5
		call RandomRange
		inc eax
		call SetTextColor
		call DrawObject

		;mov edx, edi
		;call WriteString
	.else
		mov edi,offset brickShapeEmpty
		add ebx,brickLen
		.if(ebp == 0 || ebp == 11 || ebp == 22 || ebp == 33 || ebp == 44 || ebp == 55 || ebp == 66 || ebp == 77 || ebp == 88)
			add ecx, brickWidth
			mov ebx,5
		.endif
		call DrawObject

		;mov edx, edi
		;call WriteString
	.endif
	inc ebp
	
	.if(ebp < 99)
		jmp BrickLoop

	.endif

	
	mov	ebx,baffle1PosX				; x����
	mov	ecx,baffle1PosY				; y����
	mov	edi,offset baffle1Msg		; ������1
	mov	esi,baffle1Width
	mov eax,baffleColor
	call SetTextColor
	call DrawObject
	mov	ebx,baffle2PosX				; x����
	mov	ecx,baffle2PosY				; y����
	mov	edi,offset baffle2Msg		; ������2
	mov	esi,baffle2Width
	mov eax,baffleColor
	call SetTextColor
	call DrawObject

	mov	ebx,ballPosX				; x����
	mov	ecx,ballPosY				; y����
	mov	edi,offset ballMsg			; ����
	mov	esi,ballWidth
	mov eax,ballColor
	call SetTextColor
	call DrawObject

	mov	ebx,racketPosX				; x����
	mov	ecx,racketPosY				; y����
	mov	edi,offset racketMsg		; ������1
	mov	esi,racketWidth
	mov eax,racketColor
	call SetTextColor
	call DrawObject

	.if( doubleFlag == 1)
	mov	ebx,racket2PosX				; x����
	mov	ecx,racket2PosY				; y����
	mov	edi,offset racketMsg		; ������2
	mov	esi,racketWidth
	mov eax,racketColor
	call SetTextColor
	call DrawObject
	.endif
		
	ret
GameFrame3 Endp
; ----------------------------------------------------
; ������: ebx��ecx��edi��esi��4���Ĵ����ֱ𱣴�Ҫ���������x���꣬y���꣬��ӡ�ַ�����ƫ��������
DrawObject Proc
	; �������ebx��ecx�д���8λ�ĵط�ȫ��0
	; ��ʵ���㲻��0Ҳ���Ե���
	mov dh,cl	; x����
	mov dl,bl	; y����
DrawLoop:
	push edx
	call Gotoxy
	mov edx,edi
	call WriteString
	pop edx
	inc dh
	dec	esi
	jg	DrawLoop
	ret
DrawObject Endp


; ----------------------------------------------------
; ������壺���С�����ġ��ƶ�����
ClearObjects Proc
	; ���С��
	mov ebx,oldBallPosX
	mov ecx,oldBallPosY
	mov	edi,offset blankBall
	mov esi,ballWidth
	call WriteString

	; �������
	mov ebx,oldRacketPosX
	mov ecx,oldRacketPosY
	mov	edi,offset blankRacket
	mov esi,racketWidth
	call WriteString

	mov ebx,oldRacket2PosX
	mov ecx,oldRacket2PosY
	mov	edi,offset blankRacket
	mov esi,racketWidth
	call WriteString

	; �������
	.if	levelFlag==1
		ret
	.endif
	mov ebx,oldBaffle1PosX
	mov ecx,oldBaffle1PosY
	mov	edi,offset blankBaffle1
	mov esi,baffle1Width
	call WriteString

	mov ebx,oldBaffle2PosX
	mov ecx,oldBaffle2PosY
	mov	edi,offset blankBaffle2
	mov esi,baffle2Width
	call WriteString


	ret
ClearObjects Endp

; ----------------------------------------------------
; �����������ȫ�ֲ���
; dl��������, �޷���ֵ
UpdateParameter Proc
	; ��һʱ�̿��ܷ�����"ͨ��"��"С������"�¼�
	; ��Ҫ����������ж�С���λ�û�ש���������
	call	Reset
	; ������������Ӧ
	call	ReactInput
	call	UpdateControl
	cmp		al,1
	je		NoUpdate

Update:	; �������صĺ���
	;call	CollisionDetection
	call	UpdateBall
	call	UpdateBaffle
	call	CollisionDetection

NoUpdate:
	; ���ѭ������Ҫ����
	ret
UpdateParameter ENDP


; ----------------------------------------------------
; ���¿�����Ϸ������ز���
UpdateControl Proc
	
	cmp	levelFlag,4	; ��ʤ
	je	WinWin
	cmp	life,0		; ֻ��
	jle	LoseLose
	cmp	pauseFlag,1	; ��ͣ
	je	Skip
	mov	al,0
	ret

WinWin:
	mov	winFlag,1
	jmp	Skip

LoseLose:
	mov	loseFlag,1
	jmp	Skip

Skip:	
	mov	al,1
	ret

UpdateControl ENDP


; ----------------------------------------------------
; ����deadFlag��clearFlag����С����ש���λ��
; ���һ������levelFlag(clearʱlevel+1)
Reset	Proc

	; ���ש���Ƿ����
	.if brickNum==0
		mov clearFlag,1
	.endif

	; ���clearFlag��deadFlag
	cmp	clearFlag,0
	jg	NewLevel
	cmp	deadFlag,0
	jg	ResetBall
	ret

NewLevel:
	mov	clearFlag,0
	mov	brickNum,99
	mov eax,98
LifeLoop:		;���¸�ֵש������ֵ
	mov brickLife[eax],1
	dec eax
	jge LifeLoop

	add	levelFlag,1
	cmp	levelFlag,2
	jl	ResetBrick
	mov	isBaffle,1	

ResetBrick:
	; ��������ש��

ResetBall:
	mov	ballPosX,70
	mov	ballPosY,50

	ret
Reset	ENDP

; ----------------------------------------------------
; ������������Ӧ��������ͣ�������ƶ����˳�
; dl��Ϊ������������
ReactInput Proc

	.if(dl==65 ||dl== 97 )		;A a
		mov bl,0
		mov edi,offset racketPosX
		call UpdateRacket
	.endif

	.if(dl==74 ||dl==106 )		;J j
		mov bl,0
		mov edi,offset racket2PosX
		call UpdateRacket
	.endif

	.if(dl==68 ||dl==100 )		;D d
		mov bl,1
		mov edi,offset racketPosX
		call UpdateRacket
	.endif

	.if(dl==76 ||dl==108 )		;L l
		mov bl,1
		mov edi,offset racket2PosX
		call UpdateRacket
	.endif

JudgeInput:
	cmp	dl,27	;esc
	je 	Exit
	cmp	dl,32	;space
	je	OnPause
	ret

OnPause:
	cmp pauseFlag,0
	jg	UnPause
	mov	pauseFlag,1
	ret
UnPause:
	mov	pauseFlag,0
	ret

Exit:
	mov	exitFlag,1
	ret
ReactInput ENDP


; ----------------------------------------------------
; ��������λ�ã�edi����racketPosX��ƫ������bl��������(0)��������(1)
UpdateRacket Proc
	mov	eax,[edi]
	cmp bl,1
	je  GoRight
GoLeft:
	xor ebx,ebx
	;mov	eax,racketPosX
	mov	bl,racketVel
	sub	eax,ebx
	mov	ecx,leftBorder
	cmp	eax,ecx
	jge	OKLeft
	; ����������ᳬ����߽�
	mov	eax,ecx
OKLeft:
	mov	[edi],eax
	ret

GoRight:
	xor ebx,ebx
	;mov	eax,racketPosX
	mov	bl,racketVel
	add	eax,ebx
	mov	ecx,rightBorder
	mov	ebx,racketLen
	sub	ecx,ebx		; �ұ߽��ȥLen�����������ұ߽�
	cmp	eax,ecx
	jle	OKRight
	; ���������һᳬ���ұ߽�
	mov	eax,ecx
OKRight:
	mov	[edi],eax
	ret

	ret
UpdateRacket Endp


; ----------------------------------------------------
; ����С���λ�á��ٶȺͷ������С��λ��
UpdateBall Proc
	; ����ͣ�򲻸���
	cmp	pauseFlag,0
	jle	UpdateBallX
	ret


UpdateBallX:
	; ����x����λ��
	xor	eax,eax
	mov	al,ballVelX
	imul	ballVelK
	mov	ecx,ballPosX
	add	ax,cx
	movzx ecx,ax
	mov eax,ecx
	cmp	ballVelX,0
	; ���ٶȴ���0��С����������, ֻ��Ƕ����ǽ��
	jg	JudgeRight

JudgeLeft:	; �ж��Ƿ�Խ����ǽ��
	cmp	eax,leftBorder
	jge	UpdateBallY
	mov	eax,leftBorder
	add eax,1
	jmp	UpdateBallY

JudgeRight:
	mov	ecx,rightBorder
	xor	ebx,ebx
	mov	ebx,ballWidth
	sub	ecx,ebx
	cmp	eax,ecx
	jle	UpdateBallY
	mov	eax,ecx
	dec	eax

UpdateBallY:
	mov	ballPosX,eax
	; ����y����λ��
	xor eax,eax
	mov	al,ballVelY
	imul	ballVelK
	mov	ecx,ballPosY
	add	ax,cx
	movzx ecx,ax
	mov eax,ecx
	cmp	ballVelY,0
	jg	JudgeDown

JudgeUp:
	cmp	eax,upperBorder
	jg	UPDownOK
	mov	eax,upperBorder
	dec eax
	jmp UPDownOK

JudgeDown:
	mov ecx,lowerBorder
	sub	ecx,ballWidth
	cmp eax,ecx
	jl	UPDownOK
	; �����±߽�
	mov	ballPosX,50
	mov	ballPosY,70
	mov	ballVelX,-1
	mov	ballVelY,-1
	sub	life,1
	ret

UPDownOK:
	mov	ballPosY,eax
	ret
	
UpdateBall ENDP


; ----------------------------------------------------
; �ƶ������������
UpdateBaffle Proc
	; �Ƿ���Ҫ����Baffle
	; ֻ��Level5 Baffle��λ�ò���Ҫ����
	cmp	levelFlag,3
	je	BaffleMove
	ret

BaffleMove:

	cmp	baffleDir,0
	jle	BaffleGoLeft

BaffleGoRight:
	xor	ecx,ecx
	xor	ebx,ebx
	mov	eax,baffle1PosX
	mov	edx,baffle2PosX
	mov	cl,baffleVel
	add	eax,ecx
	add	edx,ecx
	mov	ecx,rightBorder
	mov	ebx,baffle2Len
	sub	ecx,ebx
	cmp	edx,ecx
	jle	Return
	sub	ecx,edx
	add	eax,ecx
	add	edx,ecx
	mov	baffleDir,0
	jmp	Return

BaffleGoLeft:
	xor	ecx,ecx
	mov	eax,baffle1PosX
	mov	edx,baffle2PosX
	mov	cl,baffleVel
	sub	eax,ecx
	sub	edx,ecx
	cmp	eax,leftBorder
	jge	Return
	mov	ecx,leftBorder
	sub	ecx,eax
	add	eax,ecx
	add	edx,ecx
	mov	baffleDir,1
	
Return:
	mov	baffle1PosX,eax
	mov	baffle2PosX,edx
	ret

UpdateBaffle ENDP 

; ----------------------------------------------------
; ��ײ���
; �������Ҫ����С����ٶȷ����ש�������ֵ
CollisionDetection Proc
	call HitWall
	call HitRacket
	call HitBrick
	ret
CollisionDetection ENDP


; ----------------------------------------------------
;���С��������ǽ����ײ
;���·���������С������ֵ
HitWall proc
	push eax
	cmp ballVelX,0 ;�ж�С���˶�����Ϊ��/��
	jge right_direction

left_direction: ;С�������˶�
	mov eax,ballPosX
	cmp eax,leftBorder
	jg vertical_check ;����ײǽ
	neg ballVelX ;ײǽ��xȡ��
	jmp vertical_check

right_direction: ;С�������˶�
	mov eax,ballPosX
	add eax,ballWidth
	cmp eax,rightBorder
	jl vertical_check ;����ײǽ
	neg ballVelX ;ײǽ��xȡ��

vertical_check: ;y������
	cmp ballVelY,0
	jge down_direction

up_direction: ;С�������˶�
	mov eax,ballPosY
	cmp eax,upperBorder
	jg done ;����ײǽ
	neg ballVelY ;ײǽ��yȡ��
	jmp done

down_direction: ;С�������˶�
	mov eax,ballPosY
	add eax,ballWidth
	cmp eax,lowerBorder
	jl done ;����ײǽ
	sub ballLife,1 ;ײ���±߽�
	mov deadFlag,1
	cmp ballLife,0
	jg done
	mov loseFlag,1

done:
	pop eax
	ret
HitWall endp

; ----------------------------------------------------
;���С�������ĵ�����ײ
HitRacket proc
	push eax
	push ebx
	push ecx
	push edx

	cmp ballVelY,0 ;�ж�С���˶�����Ϊ��/��
	jl check_sec_racket

down_direction: ;С�������˶�
	mov eax,ballPosY
	add eax,ballWidth ;С���²�yλ��
	cmp eax,racketPosY
	jl check_sec_racket ;С���������Ϸ�����ײ��
	mov eax,ballPosY ;С���ϲ�yλ��
	mov ebx,racketPosY
	add ebx,racketWidth ;�����²�yλ��
	cmp eax,ebx
	jg check_sec_racket ;С���������·�����ײ��
	mov eax,ballPosX
	add eax,ballWidth ;С���Ҳ�xλ��
	cmp eax,racketPosX
	jl check_sec_racket ;С����������಻��ײ��
	mov eax,ballPosX ;С�����xλ��
	mov ebx,racketPosX
	add ebx,racketLen ;�����Ҳ�xλ��
	cmp eax,ebx
	jg check_sec_racket ;С���������Ҳ಻��ײ��

	;С���ײ�����ģ��������������н���
	;�����ж�С���Ƿ�ֻײ���ϱ���
	mov eax,ballPosX
	mov ebx,ballWidth
	shr ebx,1
	add eax,ebx ;eaxΪС�����µ�x����
	cmp eax,racketPosX
	jl left_right_check
	mov ebx,racketPosX
	add ebx,racketLen
	cmp eax,ebx ;ebxΪ�����Ҳ�x����
	jg left_right_check
	;С��ֻײ���ϱ���
	neg ballVelY
	jmp done

left_right_check: ;�ж�С���Ƿ�ֻײ�����ұ���
	mov eax,ballPosY
	mov ebx,ballWidth
	shr ebx,1
	add eax,ebx ;eaxΪС���е�y����
	cmp eax,racketPosY
	jl hit_corner
	mov ebx,racketPosY
	add ebx,racketWidth
	cmp eax,ebx ;ebxΪ�����²�y����
	jg hit_corner
	;С��ֻײ�����ұ���
	neg ballVelX
	jmp done

hit_corner: ;С��ײ���߽�
	mov eax,ballPosX
	cmp eax,racketPosX
	jl left_corners_check

right_corners_check: ;����Ҳ������߽�
	mov eax,ballPosY
	cmp eax,racketPosY
	jg right_up_corner
right_down_corner: ;������½�
	;ֻ���ܴ����Ͻ���ײ�����½�
	neg ballVelX
	jmp done
right_up_corner: ;������Ͻ�
	mov al,ballVelX
	cmp al,0
	jl right_up_corner_negs
	neg ballVelY ;�����Ͻ�ײ�����Ͻ�
	jmp done
right_up_corner_negs: ;�����Ͻ�ײ�����Ͻ�
	neg ballPosX
	neg ballPosY
	jmp done

left_corners_check: ;�����������߽�
	mov eax,ballPosY
	cmp eax,racketPosY
	jg left_up_corner
left_down_corner: ;������½�
	;ֻ���ܴ����Ͻ���ײ�����½�
	neg ballVelX
	jmp done
left_up_corner: ;������Ͻ�
	mov al,ballVelX
	cmp al,0
	jg left_up_corner_negs
	neg ballVelY ;�����Ͻ�ײ�����Ͻ�
	jmp done
left_up_corner_negs: ;�����Ͻ�ײ�����Ͻ�
	neg ballPosX
	neg ballPosY
	jmp done


;���ڶ�������
check_sec_racket:
	cmp doubleFlag,0
	je check_baffles

	mov eax,ballPosY
	add eax,ballWidth ;С���²�yλ��
	cmp eax,racket2PosY
	jl check_baffles ;С���ڵ����Ϸ�����ײ��
	mov eax,ballPosY ;С���ϲ�yλ��
	sub eax,1
	mov ebx,racket2PosY
	add ebx,racketWidth ;�����²�yλ��
	sub ebx,1
	cmp eax,ebx
	jg check_baffles ;С���ڵ����·�����ײ��
	mov eax,ballPosX
	add eax,ballWidth ;С���Ҳ�xλ��
	cmp eax,racket2PosX
	jl check_baffles ;С���ڵ�����಻��ײ��
	mov eax,ballPosX ;С�����xλ��
	sub eax,1
	mov ebx,racket2PosX
	add ebx,racketLen ;�����Ҳ�xλ��
	sub ebx,1
	cmp eax,ebx
	jg check_baffles ;С���ڵ����Ҳ಻��ײ��

	;С���ײ�����壬�������뵲���н���
	;�����ж�С���Ƿ�ֻײ�����±���
	mov eax,ballPosX
	mov ebx,ballWidth
	shr ebx,1
	add eax,ebx ;eaxΪС�����µ�x����
	cmp eax,racket2PosX
	jl left_right_check0
	mov ebx,racket2PosX
	add ebx,racketLen
	cmp eax,ebx ;ebxΪ�����Ҳ�x����
	jg left_right_check0
	;С��ֻײ�����±���
	neg ballVelY
	jmp done

left_right_check0: ;�ж�С���Ƿ�ֻײ�����ұ���
	mov eax,ballPosY
	mov ebx,ballWidth
	shr ebx,1
	add eax,ebx ;eaxΪС���е�y����
	cmp eax,racket2PosY
	jl hit_corner0
	mov ebx,racket2PosY
	add ebx,racketWidth
	cmp eax,ebx ;ebxΪ�����²�y����
	jg hit_corner0
	;С��ֻײ�����ұ���
	neg ballVelX
	jmp done

hit_corner0: ;С��ײ���߽�
	mov eax,ballPosX
	cmp eax,racket2PosX
	jl left_corners_check0

right_corners_check0: ;����Ҳ������߽�
	mov eax,ballPosY
	cmp eax,racket2PosY
	jg right_up_corner0
right_down_corner0: ;������½�
	mov al,ballVelX
	cmp al,0
	jl right_down_corner_right0
	neg ballVelY ;�����½�ײ�����½�
	jmp done
right_down_corner_right0: ;���Ҳ�ײ�����½�
	mov al,ballVelY
	cmp al,0
	jg right_down_corner_up0
	neg ballVelY ;�����½�ײ�����½�
right_down_corner_up0: ;�����Ͻ�ײ�����½�
	neg ballVelX
	jmp done

right_up_corner0: ;������Ͻ�
	mov al,ballVelX
	cmp al,0
	jl right_up_corner_right0
	neg ballVelY ;�����Ͻ�ײ�����Ͻ�
	jmp done
right_up_corner_right0: ;���Ҳ�ײ�����Ͻ�
	mov al,ballVelY
	cmp al,0
	jl right_up_corner_down0
	neg ballVelY ;�����Ͻ�ײ�����Ͻ�
right_up_corner_down0: ;�����½�ײ�����Ͻ�
	neg ballVelX
	jmp done


left_corners_check0: ;�����������߽�
	mov eax,ballPosY
	cmp eax,racket2PosY
	jg left_up_corner0
left_down_corner0: ;������½�
	mov al,ballVelX
	cmp al,0
	jg left_down_corner_left0
	neg ballVelY ;�����½�ײ�����½�
	jmp done
left_down_corner_left0: ;�����ײ�����½�
	mov al,ballVelY
	cmp al,0
	jg left_down_corner_up0
	neg ballVelY ;�����½�ײ�����½�
left_down_corner_up0: ;�����Ͻ�ײ�����½�
	neg ballVelX
	jmp done

left_up_corner0: ;������Ͻ�
	mov al,ballVelX
	cmp al,0
	jg left_up_corner_left0
	neg ballVelY ;�����Ͻ�ײ�����Ͻ�
	jmp done
left_up_corner_left0: ;�����ײ�����Ͻ�
	mov al,ballVelY
	cmp al,0
	jl left_up_corner_down0
	neg ballVelY ;�����Ͻ�ײ�����Ͻ�
left_up_corner_down0: ;�����½�ײ�����Ͻ�
	neg ballVelX
	jmp done




check_baffles:
	cmp isBaffle,0
	je done

check_baffle1: ;����һ������
	mov eax,ballPosY
	add eax,ballWidth ;С���²�yλ��
	cmp eax,baffle1PosY
	jl check_baffle2 ;С���ڵ����Ϸ�����ײ��
	mov eax,ballPosY ;С���ϲ�yλ��
	sub eax,1
	mov ebx,baffle1PosY
	add ebx,baffle1Width ;�����²�yλ��
	sub ebx,1
	cmp eax,ebx
	jg check_baffle2 ;С���ڵ����·�����ײ��
	mov eax,ballPosX
	add eax,ballWidth ;С���Ҳ�xλ��
	cmp eax,baffle1PosX
	jl check_baffle2 ;С���ڵ�����಻��ײ��
	mov eax,ballPosX ;С�����xλ��
	sub eax,1
	mov ebx,baffle1PosX
	add ebx,baffle1Len ;�����Ҳ�xλ��
	sub ebx,1
	cmp eax,ebx
	jg check_baffle2 ;С���ڵ����Ҳ಻��ײ��

	;С���ײ�����壬�������뵲���н���
	;�����ж�С���Ƿ�ֻײ�����±���
	mov eax,ballPosX
	mov ebx,ballWidth
	shr ebx,1
	add eax,ebx ;eaxΪС�����µ�x����
	cmp eax,baffle1PosX
	jl left_right_check1
	mov ebx,baffle1PosX
	add ebx,baffle1Len
	cmp eax,ebx ;ebxΪ�����Ҳ�x����
	jg left_right_check1
	;С��ֻײ�����±���
	neg ballVelY
	jmp done

left_right_check1: ;�ж�С���Ƿ�ֻײ�����ұ���
	mov eax,ballPosY
	mov ebx,ballWidth
	shr ebx,1
	add eax,ebx ;eaxΪС���е�y����
	cmp eax,baffle1PosY
	jl hit_corner1
	mov ebx,baffle1PosY
	add ebx,baffle1Width
	cmp eax,ebx ;ebxΪ�����²�y����
	jg hit_corner1
	;С��ֻײ�����ұ���
	neg ballVelX
	jmp done

hit_corner1: ;С��ײ���߽�
	mov eax,ballPosX
	cmp eax,baffle1PosX
	jl left_corners_check1

right_corners_check1: ;����Ҳ������߽�
	mov eax,ballPosY
	cmp eax,baffle1PosY
	jg right_up_corner1
right_down_corner1: ;������½�
	mov al,ballVelX
	cmp al,0
	jl right_down_corner_right1
	neg ballVelY ;�����½�ײ�����½�
	jmp done
right_down_corner_right1: ;���Ҳ�ײ�����½�
	mov al,ballVelY
	cmp al,0
	jg right_down_corner_up1
	neg ballVelY ;�����½�ײ�����½�
right_down_corner_up1: ;�����Ͻ�ײ�����½�
	neg ballVelX
	jmp done

right_up_corner1: ;������Ͻ�
	mov al,ballVelX
	cmp al,0
	jl right_up_corner_right1
	neg ballVelY ;�����Ͻ�ײ�����Ͻ�
	jmp done
right_up_corner_right1: ;���Ҳ�ײ�����Ͻ�
	mov al,ballVelY
	cmp al,0
	jl right_up_corner_down1
	neg ballVelY ;�����Ͻ�ײ�����Ͻ�
right_up_corner_down1: ;�����½�ײ�����Ͻ�
	neg ballVelX
	jmp done


left_corners_check1: ;�����������߽�
	mov eax,ballPosY
	cmp eax,baffle1PosY
	jg left_up_corner1
left_down_corner1: ;������½�
	mov al,ballVelX
	cmp al,0
	jg left_down_corner_left1
	neg ballVelY ;�����½�ײ�����½�
	jmp done
left_down_corner_left1: ;�����ײ�����½�
	mov al,ballVelY
	cmp al,0
	jg left_down_corner_up1
	neg ballVelY ;�����½�ײ�����½�
left_down_corner_up1: ;�����Ͻ�ײ�����½�
	neg ballVelX
	jmp done

left_up_corner1: ;������Ͻ�
	mov al,ballVelX
	cmp al,0
	jg left_up_corner_left1
	neg ballVelY ;�����Ͻ�ײ�����Ͻ�
	jmp done
left_up_corner_left1: ;�����ײ�����Ͻ�
	mov al,ballVelY
	cmp al,0
	jl left_up_corner_down1
	neg ballVelY ;�����Ͻ�ײ�����Ͻ�
left_up_corner_down1: ;�����½�ײ�����Ͻ�
	neg ballVelX
	jmp done

check_baffle2: ;���ڶ�������
	mov eax,ballPosY
	add eax,ballWidth ;С���²�yλ��
	cmp eax,baffle2PosY
	jl done ;С���ڵ����Ϸ�����ײ��
	mov eax,ballPosY ;С���ϲ�yλ��
	sub eax,1
	mov ebx,baffle2PosY
	add ebx,baffle2Width ;�����²�yλ��
	sub ebx,1
	cmp eax,ebx
	jg done ;С���ڵ����·�����ײ��
	mov eax,ballPosX
	add eax,ballWidth ;С���Ҳ�xλ��
	cmp eax,baffle2PosX
	jl done ;С���ڵ�����಻��ײ��
	mov eax,ballPosX ;С�����xλ��
	sub eax,1
	mov ebx,baffle2PosX
	add ebx,baffle2Len ;�����Ҳ�xλ��
	sub ebx,1
	cmp eax,ebx
	jg done ;С���ڵ����Ҳ಻��ײ��

	;С���ײ�����壬�������뵲���н���
	;�����ж�С���Ƿ�ֻײ�����±���
	mov eax,ballPosX
	mov ebx,ballWidth
	shr ebx,1
	add eax,ebx ;eaxΪС�����µ�x����
	cmp eax,baffle2PosX
	jl left_right_check2
	mov ebx,baffle2PosX
	add ebx,baffle2Len
	cmp eax,ebx ;ebxΪ�����Ҳ�x����
	jg left_right_check2
	;С��ֻײ�����±���
	neg ballVelY
	jmp done

left_right_check2: ;�ж�С���Ƿ�ֻײ�����ұ���
	mov eax,ballPosY
	mov ebx,ballWidth
	shr ebx,1
	add eax,ebx ;eaxΪС���е�y����
	cmp eax,baffle2PosY
	jl hit_corner2
	mov ebx,baffle2PosY
	add ebx,baffle2Width
	cmp eax,ebx ;ebxΪ�����²�y����
	jg hit_corner2
	;С��ֻײ�����ұ���
	neg ballVelX
	jmp done

hit_corner2: ;С��ײ���߽�
	mov eax,ballPosX
	cmp eax,baffle2PosX
	jl left_corners_check2

right_corners_check2: ;����Ҳ������߽�
	mov eax,ballPosY
	cmp eax,baffle2PosY
	jg right_up_corner2
right_down_corner2: ;������½�
	mov al,ballVelX
	cmp al,0
	jl right_down_corner_right2
	neg ballVelY ;�����½�ײ�����½�
	jmp done
right_down_corner_right2: ;���Ҳ�ײ�����½�
	mov al,ballVelY
	cmp al,0
	jg right_down_corner_up2
	neg ballVelY ;�����½�ײ�����½�
right_down_corner_up2: ;�����Ͻ�ײ�����½�
	neg ballVelX
	jmp done

right_up_corner2: ;������Ͻ�
	mov al,ballVelX
	cmp al,0
	jl right_up_corner_right2
	neg ballVelY ;�����Ͻ�ײ�����Ͻ�
	jmp done
right_up_corner_right2: ;���Ҳ�ײ�����Ͻ�
	mov al,ballVelY
	cmp al,0
	jl right_up_corner_down2
	neg ballVelY ;�����Ͻ�ײ�����Ͻ�
right_up_corner_down2: ;�����½�ײ�����Ͻ�
	neg ballVelX
	jmp done


left_corners_check2: ;�����������߽�
	mov eax,ballPosY
	cmp eax,baffle2PosY
	jg left_up_corner2
left_down_corner2: ;������½�
	mov al,ballVelX
	cmp al,0
	jg left_down_corner_left2
	neg ballVelY ;�����½�ײ�����½�
	jmp done
left_down_corner_left2: ;�����ײ�����½�
	mov al,ballVelY
	cmp al,0
	jg left_down_corner_up2
	neg ballVelY ;�����½�ײ�����½�
left_down_corner_up2: ;�����Ͻ�ײ�����½�
	neg ballVelX
	jmp done

left_up_corner2: ;������Ͻ�
	mov al,ballVelX
	cmp al,0
	jg left_up_corner_left2
	neg ballVelY ;�����Ͻ�ײ�����Ͻ�
	jmp done
left_up_corner_left2: ;�����ײ�����Ͻ�
	mov al,ballVelY
	cmp al,0
	jl left_up_corner_down2
	neg ballVelY ;�����Ͻ�ײ�����Ͻ�
left_up_corner_down2: ;�����½�ײ�����Ͻ�
	neg ballVelX
	jmp done

done:
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
HitRacket endp


; ----------------------------------------------------
;���С����ש����ײ
HitBrick proc
	push eax
	push edx
	push ebx
	push ecx
	push edi
	push esi
	push ebp ;ebp����Ψһײ���ı߽Ƕ�Ӧ��ש���

	mov eax,ballPosY
	cmp eax,brickRegion
	jge done ;�±߽�֮��
	mov eax,ballPosY
	add eax,ballWidth
	sub eax,1
	cmp eax,brickStartY
	jle done ;�ϱ߽�֮��
	mov eax,ballPosX
	add eax,ballWidth
	sub eax,1
	cmp eax,brickStartX
	jle done ;��߽�֮��
	mov eax,ballPosX
	cmp eax,brickEndX
	jge done ;�ұ߽�֮��

	;����Ƿ��ĸ��߽�ֻ��һ����ײש��
	;������ֱ����λ��������
	;ediΪ1234�ֱ��������������������
	xor edi,edi ;edi�������µ�ײ��ש��ı߽Ǻ�
	xor esi,esi ;esi����ײ��ש��ı߽�����


hit_brick_left_up: ;С�����Ͽ��ܻ���ש��
	xor ecx,ecx ;ecx����С�����ϵ����ש���
	;�ж��к�
	xor edx,edx
	mov eax,ballPosY
	cmp eax,brickStartY ;---
	jle hit_brick_left_down
	sub eax,brickStartY
	mov ebx,brickWidth
	idiv ebx ;eaxΪ�к�
	sub eax,1 ;*****
	imul eax,brickLine
	add ecx,eax
	;�ж��к�
	xor edx,edx
	mov eax,ballPosX
	cmp eax,brickStartX ;---
	jle hit_brick_left_down
	sub eax,brickStartX
	mov ebx,brickLen
	idiv ebx ;eaxΪ�к�
	add ecx,eax ;ecx��Ϊ���ϵ���е�ש���
hit_brick_left_up_check: ;�ж����ϵ�ײ����ש��
	;������ש������ֵΪ0
	cmp brickLife[ecx],0
	je hit_brick_left_down
	mov edi,1
	add esi,1
	mov ebp,ecx

hit_brick_left_down: ;С�����¿��ܻ���ש��
	xor ecx,ecx ;ecx����С�����µ����ש���
	;�ж��к�
	xor edx,edx
	mov eax,ballPosY
	add eax,ballWidth
	sub eax,1
	cmp eax,brickRegion ;---
	jge hit_brick_right_down
	sub eax,brickStartY
	mov ebx,brickWidth
	idiv ebx ;eaxΪ�к�
	sub eax,1 ;*****
	imul eax,brickLine
	add ecx,eax
	;�ж��к�
	xor edx,edx
	mov eax,ballPosX
	cmp eax,brickStartX ;---
	jle hit_brick_right_down
	sub eax,brickStartX
	mov ebx,brickLen
	idiv ebx ;eaxΪ�к�
	add ecx,eax ;ecx��Ϊ���µ���е�ש���
hit_brick_left_down_check: ;�ж����µ�ײ����ש��
	;������ש������ֵΪ0
	cmp brickLife[ecx],0
	je hit_brick_right_down
	mov edi,2
	add esi,1
	mov ebp,ecx

hit_brick_right_down: ;С�����¿��ܻ���ש��
	xor ecx,ecx ;ecx����С�����µ����ש���
	;�ж��к�
	xor edx,edx
	mov eax,ballPosY
	add eax,ballWidth
	sub eax,1
	cmp eax,brickRegion ;---
	jge hit_brick_right_up
	sub eax,brickStartY
	mov ebx,brickWidth
	idiv ebx ;eaxΪ�к�
	sub eax,1 ;*****
	imul eax,brickLine
	add ecx,eax
	;�ж��к�
	xor edx,edx
	mov eax,ballPosX
	add eax,ballWidth
	sub eax,1
	cmp eax,brickEndX ;---
	jge hit_brick_right_up
	sub eax,brickStartX
	mov ebx,brickLen
	idiv ebx ;eaxΪ�к�
	add ecx,eax ;ecx��Ϊ���µ���е�ש���
hit_brick_rigth_down_check: ;�ж����µ�ײ����ש��
	;������ש������ֵΪ0
	cmp brickLife[ecx],0
	je hit_brick_right_up
	mov edi,3
	add esi,1
	mov ebp,ecx

hit_brick_right_up: ;С�����Ͽ��ܻ���ש��
	xor ecx,ecx ;ecx����С�����ϵ����ש���
	;�ж��к�
	xor edx,edx
	mov eax,ballPosY
	cmp eax,brickStartY ;---
	jle check_four_corners
	sub eax,brickStartY
	mov ebx,brickWidth
	idiv ebx ;eaxΪ�к�
	sub eax,1 ;*****
	imul eax,brickLine
	add ecx,eax
	;�ж��к�
	xor edx,edx
	mov eax,ballPosX
	add eax,ballWidth
	sub eax,1
	cmp eax,brickEndX ;---
	jge check_four_corners
	sub eax,brickStartX
	mov ebx,brickLen
	idiv ebx ;eaxΪ�к�
	add ecx,eax ;ecx��Ϊ���ϵ���е�ש���
hit_brick_rigth_up_check: ;�ж����ϵ�ײ����ש��
	;������ש������ֵΪ0
	cmp brickLife[ecx],0
	je check_four_corners
	mov edi,4
	add esi,1
	mov ebp,ecx

check_four_corners: ;�ж�ײ����һ���߽�
	cmp esi,1
	je hit_one_corner
	jmp hit_brick_up
hit_one_corner:
	;ש������ֵ��Ϊ0����1
	sub brickLife[ebp],1
	cmp brickLife[ebp],0
	jg skip
	sub brickNum,1
skip:
	cmp edi,1
	je left_up_corner_only
	cmp edi,2
	je left_down_corner_only
	cmp edi,3
	je right_down_corner_only
	cmp edi,4
	je right_up_corner_only
left_up_corner_only: ;ײ�����Ͻǣ�������������
	cmp ballVelX,0
	jl left_up_y_judge
	neg ballVelX
left_up_y_judge:
	cmp ballVelY,0
	jl done
	neg ballVelY
	jmp done

left_down_corner_only: ;ײ�����½ǣ�������������
	cmp ballVelX,0
	jl left_down_y_judge
	neg ballVelX
left_down_y_judge:
	cmp ballVelY,0
	jg done
	neg ballVelY
	jmp done

right_down_corner_only: ;ײ�����½ǣ�������������
	cmp ballVelX,0
	jg right_down_y_judge
	neg ballVelX
right_down_y_judge:
	cmp ballVelY,0
	jg done
	neg ballVelY
	jmp done

right_up_corner_only: ;ײ�����Ͻǣ�������������
	cmp ballVelX,0
	jg right_up_y_judge
	neg ballVelX
right_up_y_judge:
	cmp ballVelY,0
	jl done
	neg ballVelY
	jmp done


;��Ψһ�߽���ײ���ж��ı��е���ײ���
hit_brick_up: ;С�����Ͽ��ܻ���ש��
	mov eax,ballPosY
	cmp eax,brickStartY
	jle hit_brick_down ;ײ���ϱ߽�
	xor ecx,ecx ;ecx����С�����ϵ����ש���
	;�ж��к�
	xor edx,edx
	mov eax,ballPosY
	cmp eax,brickStartY ;---
	jle hit_brick_down
	sub eax,brickStartY
	mov ebx,brickWidth
	idiv ebx ;eaxΪ�к�
	sub eax,1 ;*****
	imul eax,brickLine
	add ecx,eax
	;�ж��к�
	xor edx,edx
	mov eax,ballPosX
	mov ebx,ballWidth
	shr ebx,1 ;ebx=ballWidth/2
	add eax,ebx ;eaxΪС���м�x����
	cmp eax,brickEndX ;---
	jge hit_brick_down
	sub eax,brickStartX
	mov ebx,brickLen
	idiv ebx ;eaxΪ�к�
	add ecx,eax ;ecx��Ϊ���ϵ���е�ש���
midUp_brick: ;�ж����ϵ�ײ����ש��
	;������ש������ֵΪ0
	cmp brickLife[ecx],0
	je hit_brick_down
	neg ballVelY ;ballVelYȡ��
	;ש������ֵ��Ϊ0����1
	sub brickLife[ecx],1
	cmp brickLife[ecx],0
	jg hit_brick_down
	sub brickNum,1


hit_brick_down: ;С�����¿��ܻ���ש��
	mov eax,ballPosY
	add eax,ballWidth ;eax����С�����µ�y����
	sub eax,1
	cmp eax,brickRegion
	jge hit_brick_left ;�±߽粻����ײש��
	xor ecx,ecx ;ecx����С�����µ����ש���
	;�ж��к�
	xor edx,edx
	mov eax,ballPosY
	add eax,ballWidth
	sub eax,1
	cmp eax,brickRegion ;---
	jge hit_brick_left
	sub eax,brickStartY
	mov ebx,brickWidth
	idiv ebx ;eaxΪ�к�
	sub eax,1 ;*****
	imul eax,brickLine
	add ecx,eax
	;�ж��к�
	xor edx,edx
	mov eax,ballPosX
	mov ebx,ballWidth
	shr ebx,1 ;ebx=ballWidth/2
	add eax,ebx ;eaxΪС���м�x����
	cmp eax,brickEndX ;---
	jge hit_brick_left
	sub eax,brickStartX
	mov ebx,brickLen
	idiv ebx ;eaxΪ�к�
	add ecx,eax ;ecxΪ���µ���е�ש���
midDown_brick: ;�ж����µ�ײ����ש��
	;������ש������ֵΪ0
	cmp brickLife[ecx],0
	je hit_brick_left
	neg ballVelY ;ballVelYȡ��
	;ש������ֵ��Ϊ0����1
	sub brickLife[ecx],1
	cmp brickLife[ecx],0
	jg hit_brick_left
	sub brickNum,1


hit_brick_left: ;С��������ܻ���ש��
	;�ж�С������Ƿ�Ϊǽ��
	mov eax,ballPosX
	cmp eax,brickStartX
	jle hit_brick_right ;��߽粻����ײש��
	xor ecx,ecx ;ecx����С����������ש���
	;�ж��к�
	xor edx,edx
	mov eax,ballPosY
	mov ebx,ballWidth
	shr ebx,1 ;ebx=ballWidth/2
	add eax,ebx ;eaxΪС���м�y����
	cmp eax,brickRegion ;---
	jge hit_brick_right
	sub eax,brickStartY
	mov ebx,brickWidth
	idiv ebx ;eaxΪ�к�
	sub eax,1 ;*****
	imul eax,brickLine
	add ecx,eax
	;�ж��к�
	xor edx,edx
	mov eax,ballPosX
	cmp eax,brickStartX ;---
	jle hit_brick_right
	sub eax,brickStartX
	mov ebx,brickLen
	idiv ebx ;eaxΪ�к�
	add ecx,eax ;ecxΪ���µ���е�ש���
midLeft_brick: ;�ж������ײ����ש��
	;������ש������ֵΪ0
	cmp brickLife[ecx],0
	je hit_brick_right
	neg ballVelX ;ballVelXȡ��
	;ש������ֵ��Ϊ0����1
	sub brickLife[ecx],1
	cmp brickLife[ecx],0
	jg hit_brick_right
	sub brickNum,1


hit_brick_right: ;С�����ҿ��ܻ���ש��
	;�ж�С���Ҳ��Ƿ�Ϊǽ��
	mov eax,ballPosX
	add eax,ballWidth
	sub eax,1
	cmp eax,brickEndX
	jge done ;�ұ߽粻����ײש��
	xor ecx,ecx ;ecx����С�����ҵ����ש���
	;�ж��к�
	xor edx,edx
	mov eax,ballPosY
	mov ebx,ballWidth
	shr ebx,1 ;ebx=ballWidth/2
	add eax,ebx ;eaxΪС���м�y����
	cmp eax,brickRegion ;---
	jge done
	sub eax,brickStartY
	mov ebx,brickWidth
	idiv ebx ;eaxΪ�к�
	sub eax,1 ;*****
	imul eax,brickLine
	add ecx,eax
	;�ж��к�
	xor edx,edx
	mov eax,ballPosX
	add eax,ballWidth
	sub eax,1
	cmp eax,brickEndX ;---
	jge done
	sub eax,brickStartX
	mov ebx,brickLen
	idiv ebx ;eaxΪ�к�
	add ecx,eax ;ecxΪ���ҵ���е�ש���
midRight_brick:
	;������ש������ֵΪ0
	cmp brickLife[ecx],0
	je done
	neg ballVelX ;ballVelXȡ��
	;ש������ֵ��Ϊ0����1
	sub brickLife[ecx],1
	cmp brickLife[ecx],0
	jg done
	sub brickNum,1


done:
	pop ebp
	pop esi
	pop edi
	pop ecx
	pop ebx
	pop edx
	pop eax
	ret
HitBrick endp


; ��������
PlaySound Proc
start:
    ;ȡƫ�Ƶ�ַ
    mov esi,offset musicFreq
    mov edi,offset musicTime

play:
    mov edx, [esi]
    cmp edx, -1
    je end_play
    ;call Sound
    add si, 2
    add di, 2
    jmp play

end_play:
    mov eax, 4c00h
    ;int 21h
	ret
PlaySound Endp

;����������esi����Ҫ���ŵ�Ƶ�ʵĵ�ַ��edi����Ҫ���ŵ������ĵ�ַ
Sound proc
    push eax
    push edx
    push ecx

    mov al,0b6h
    out 43h,al
    mov dx,12h
    mov ax,34dch
    div word ptr [esi]
    out 42h, al	
    mov al, ah
    out 42h, al	

    ;�����������Ŀ�/��
    ;in al,61h
    mov ah,al
    or al,3 
    ;out 61h,al
    mov edx, [edi]
wait1:
    mov ecx, 28000
delay:
    nop
    loop delay
    dec dx
    jnz wait1
    mov al, ah 
    ;out 61h, al
    pop ecx
    pop edx
    pop eax

    ret
Sound Endp

end main