.386
.model flat,stdcall
option casemap:none

include define.inc

.code
; ----------------------------------------------------
; 游戏主函数
main proc
	call GetMaxXY
	call StartFrame
	call SchoolFrame
	call JudgeDouble	; 判断单球拍/双球拍
GameLoop:
	call	ReadKey	; 把输入读入al
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
; 等待输入
JudgeDouble Proc
	; 阻塞等待输入
	Call ReadChar
	.if(al==87 || al==119)		; W,w
		mov doubleFlag,1	
		ret
	.endif
	mov	doubleFlag,0	;其他情况默认单球拍
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
; 界面主函数
DrawFrame Proc

	;mov	ebx,50				; x坐标
	;mov ecx,50				; y坐标
	;mov	edx,offset ballMsg	; 尝试画球
	;mov	esi,ballWidth
	;call DrawObject

	; 判断是否胜利
	cmp	winFlag,1
	je	Winner

	; 判断是否失败
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
; 初始界面
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
; 校徽
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
; 获胜界面
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
; 失败界面界面
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
; 第一关
GameFrame1 Proc
	;call Clrscr
	call drawBorder				;生成边界
	
	call ClearObjects			; 清除物体
	
	xor ebp,ebp					; 砖块计数
	mov ecx,brickStartY			; y坐标
	mov ebx,brickStartX			; x坐标
	mov edi,offset brickShape	;砖块形状
	mov esi,brickWidth			;砖块厚度
BrickLoop:
	.if(brickLife[ebp] > 0)		;如果砖块存在
		mov edi,offset brickShape	;放入砖块形状
		add ebx,brickLen					;x坐标
		.if(ebp == 0 || ebp == 11 || ebp == 22 || ebp == 33 || ebp == 44 || ebp == 55 || ebp == 66 || ebp == 77 || ebp == 88)
			add ecx, brickWidth		;换行
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
	
	mov	ebx,ballPosX				; x坐标
	mov	ecx,ballPosY				; y坐标
	mov	edi,offset ballMsg			; 画球
	mov	esi,ballWidth
	mov eax,ballColor
	call SetTextColor
	call DrawObject

	mov	ebx,racketPosX				; x坐标
	mov	ecx,racketPosY				; y坐标
	mov	edi,offset racketMsg		; 画球拍1
	mov	esi,racketWidth
	mov eax,racketColor
	call SetTextColor
	call DrawObject
	.if( doubleFlag == 1)
	mov	ebx,racket2PosX				; x坐标
	mov	ecx,racket2PosY				; y坐标
	mov	edi,offset racketMsg		; 画球拍2
	mov	esi,racketWidth
	mov eax,racketColor
	call SetTextColor
	call DrawObject
	.endif
	ret
GameFrame1 Endp
; ----------------------------------------------------
; ----------------------------------------------------
; 第四关 添加固定挡板
GameFrame2 Proc
	;call Clrscr
	mov isBaffle,1
	call drawBorder				;生成边界
	
	call ClearObjects			; 清除物体
	
	xor ebp,ebp					; 砖块计数
	mov ecx,brickStartY			; y坐标
	mov ebx,brickStartX			; x坐标
	mov edi,offset brickShape	;砖块形状
	mov esi,brickWidth			;砖块厚度
	
BrickLoop:
	.if(brickLife[ebp] > 0)		;如果砖块存在
		mov edi,offset brickShape	;放入砖块形状
		add ebx,brickLen					;x坐标
		.if(ebp == 0 || ebp == 11 || ebp == 22 || ebp == 33 || ebp == 44 || ebp == 55 || ebp == 66 || ebp == 77 || ebp == 88)
			add ecx, brickWidth		;换行
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

	
	mov	ebx,baffle1PosX				; x坐标
	mov	ecx,baffle1PosY				; y坐标
	mov	edi,offset baffle1Msg		; 画挡板1
	mov	esi,baffle1Width
	mov eax,baffleColor
	call SetTextColor
	call DrawObject
	mov	ebx,baffle2PosX				; x坐标
	mov	ecx,baffle2PosY				; y坐标
	mov	edi,offset baffle2Msg		; 画挡板2
	mov	esi,baffle2Width
	mov eax,baffleColor
	call SetTextColor
	call DrawObject

	mov	ebx,ballPosX				; x坐标
	mov	ecx,ballPosY				; y坐标
	mov	edi,offset ballMsg			; 画球
	mov	esi,ballWidth
	mov eax,ballColor
	call SetTextColor
	call DrawObject

	mov	ebx,racketPosX				; x坐标
	mov	ecx,racketPosY				; y坐标
	mov	edi,offset racketMsg		; 画球拍1
	mov	esi,racketWidth
	mov eax,racketColor
	call SetTextColor
	call DrawObject

	.if( doubleFlag == 1)
	mov	ebx,racket2PosX				; x坐标
	mov	ecx,racket2PosY				; y坐标
	mov	edi,offset racketMsg		; 画球拍2
	mov	esi,racketWidth
	mov eax,racketColor
	call SetTextColor
	call DrawObject
	.endif
		
	ret
GameFrame2 Endp
; ----------------------------------------------------
; 第五关 添加移动挡板
GameFrame3 Proc
	;call Clrscr
	call drawBorder				;生成边界
	
	call ClearObjects			; 清除物体
	
	xor ebp,ebp					; 砖块计数
	mov ecx,brickStartY			; y坐标
	mov ebx,brickStartX			; x坐标
	mov edi,offset brickShape	;砖块形状
	mov esi,brickWidth			;砖块厚度
	
BrickLoop:
	.if(brickLife[ebp] > 0)		;如果砖块存在
		mov edi,offset brickShape	;放入砖块形状
		add ebx,brickLen					;x坐标
		.if(ebp == 0 || ebp == 11 || ebp == 22 || ebp == 33 || ebp == 44 || ebp == 55 || ebp == 66 || ebp == 77 || ebp == 88)
			add ecx, brickWidth		;换行
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

	
	mov	ebx,baffle1PosX				; x坐标
	mov	ecx,baffle1PosY				; y坐标
	mov	edi,offset baffle1Msg		; 画挡板1
	mov	esi,baffle1Width
	mov eax,baffleColor
	call SetTextColor
	call DrawObject
	mov	ebx,baffle2PosX				; x坐标
	mov	ecx,baffle2PosY				; y坐标
	mov	edi,offset baffle2Msg		; 画挡板2
	mov	esi,baffle2Width
	mov eax,baffleColor
	call SetTextColor
	call DrawObject

	mov	ebx,ballPosX				; x坐标
	mov	ecx,ballPosY				; y坐标
	mov	edi,offset ballMsg			; 画球
	mov	esi,ballWidth
	mov eax,ballColor
	call SetTextColor
	call DrawObject

	mov	ebx,racketPosX				; x坐标
	mov	ecx,racketPosY				; y坐标
	mov	edi,offset racketMsg		; 画球拍1
	mov	esi,racketWidth
	mov eax,racketColor
	call SetTextColor
	call DrawObject

	.if( doubleFlag == 1)
	mov	ebx,racket2PosX				; x坐标
	mov	ecx,racket2PosY				; y坐标
	mov	edi,offset racketMsg		; 画球拍2
	mov	esi,racketWidth
	mov eax,racketColor
	call SetTextColor
	call DrawObject
	.endif
		
	ret
GameFrame3 Endp
; ----------------------------------------------------
; 画物体: ebx，ecx，edi，esi，4个寄存器分别保存要画的物体的x坐标，y坐标，打印字符串的偏移量与宽度
DrawObject Proc
	; 这里假设ebx，ecx中大于8位的地方全是0
	; 其实就算不是0也可以调整
	mov dh,cl	; x坐标
	mov dl,bl	; y坐标
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
; 清除物体：清除小球、球拍、移动挡板
ClearObjects Proc
	; 清除小球
	mov ebx,oldBallPosX
	mov ecx,oldBallPosY
	mov	edi,offset blankBall
	mov esi,ballWidth
	call WriteString

	; 清除球拍
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

	; 清除挡板
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
; 根据输入更新全局参数
; dl传递输入, 无返回值
UpdateParameter Proc
	; 上一时刻可能发生了"通关"或"小球死亡"事件
	; 需要在这个函数中对小球的位置或砖块进行重置
	call	Reset
	; 对输入做出反应
	call	ReactInput
	call	UpdateControl
	cmp		al,1
	je		NoUpdate

Update:	; 与更新相关的函数
	;call	CollisionDetection
	call	UpdateBall
	call	UpdateBaffle
	call	CollisionDetection

NoUpdate:
	; 这次循环不需要更新
	ret
UpdateParameter ENDP


; ----------------------------------------------------
; 更新控制游戏流程相关参数
UpdateControl Proc
	
	cmp	levelFlag,4	; 获胜
	je	WinWin
	cmp	life,0		; 只因
	jle	LoseLose
	cmp	pauseFlag,1	; 暂停
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
; 根据deadFlag和clearFlag设置小球与砖块的位置
; 并且还会调整levelFlag(clear时level+1)
Reset	Proc

	; 检查砖块是否清空
	.if brickNum==0
		mov clearFlag,1
	.endif

	; 检查clearFlag与deadFlag
	cmp	clearFlag,0
	jg	NewLevel
	cmp	deadFlag,0
	jg	ResetBall
	ret

NewLevel:
	mov	clearFlag,0
	mov	brickNum,99
	mov eax,98
LifeLoop:		;重新赋值砖块生命值
	mov brickLife[eax],1
	dec eax
	jge LifeLoop

	add	levelFlag,1
	cmp	levelFlag,2
	jl	ResetBrick
	mov	isBaffle,1	

ResetBrick:
	; 重新设置砖块

ResetBall:
	mov	ballPosX,70
	mov	ballPosY,50

	ret
Reset	ENDP

; ----------------------------------------------------
; 对输入做出反应，包括暂停，球拍移动，退出
; dl作为参数传入输入
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
; 更新球拍位置，edi传入racketPosX的偏移量，bl传入向左(0)或者向右(1)
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
	; 球拍再向左会超出左边界
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
	sub	ecx,ebx		; 右边界减去Len才是真正的右边界
	cmp	eax,ecx
	jle	OKRight
	; 球拍再向右会超出右边界
	mov	eax,ecx
OKRight:
	mov	[edi],eax
	ret

	ret
UpdateRacket Endp


; ----------------------------------------------------
; 根据小球的位置、速度和方向更新小球位置
UpdateBall Proc
	; 若暂停则不更新
	cmp	pauseFlag,0
	jle	UpdateBallX
	ret


UpdateBallX:
	; 更新x坐标位置
	xor	eax,eax
	mov	al,ballVelX
	imul	ballVelK
	mov	ecx,ballPosX
	add	ax,cx
	movzx ecx,ax
	mov eax,ecx
	cmp	ballVelX,0
	; 若速度大于0则小球在向右走, 只会嵌入右墙壁
	jg	JudgeRight

JudgeLeft:	; 判断是否越过左墙壁
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
	; 更新y坐标位置
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
	; 超出下边界
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
; 移动挡板参数更新
UpdateBaffle Proc
	; 是否需要更新Baffle
	; 只有Level5 Baffle的位置才需要更新
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
; 碰撞检测
; 这个函数要更新小球的速度方向和砖块的生命值
CollisionDetection Proc
	call HitWall
	call HitRacket
	call HitBrick
	ret
CollisionDetection ENDP


; ----------------------------------------------------
;检测小球与四面墙壁碰撞
;更新方向向量、小球生命值
HitWall proc
	push eax
	cmp ballVelX,0 ;判断小球运动方向为左/右
	jge right_direction

left_direction: ;小球向左运动
	mov eax,ballPosX
	cmp eax,leftBorder
	jg vertical_check ;不会撞墙
	neg ballVelX ;撞墙则x取反
	jmp vertical_check

right_direction: ;小球向右运动
	mov eax,ballPosX
	add eax,ballWidth
	cmp eax,rightBorder
	jl vertical_check ;不会撞墙
	neg ballVelX ;撞墙则x取反

vertical_check: ;y方向检查
	cmp ballVelY,0
	jge down_direction

up_direction: ;小球向上运动
	mov eax,ballPosY
	cmp eax,upperBorder
	jg done ;不会撞墙
	neg ballVelY ;撞墙则y取反
	jmp done

down_direction: ;小球向下运动
	mov eax,ballPosY
	add eax,ballWidth
	cmp eax,lowerBorder
	jl done ;不会撞墙
	sub ballLife,1 ;撞击下边界
	mov deadFlag,1
	cmp ballLife,0
	jg done
	mov loseFlag,1

done:
	pop eax
	ret
HitWall endp

; ----------------------------------------------------
;检测小球与球拍挡板碰撞
HitRacket proc
	push eax
	push ebx
	push ecx
	push edx

	cmp ballVelY,0 ;判断小球运动方向为上/下
	jl check_sec_racket

down_direction: ;小球向下运动
	mov eax,ballPosY
	add eax,ballWidth ;小球下侧y位置
	cmp eax,racketPosY
	jl check_sec_racket ;小球在球拍上方不会撞击
	mov eax,ballPosY ;小球上侧y位置
	mov ebx,racketPosY
	add ebx,racketWidth ;球拍下侧y位置
	cmp eax,ebx
	jg check_sec_racket ;小球在球拍下方不会撞击
	mov eax,ballPosX
	add eax,ballWidth ;小球右侧x位置
	cmp eax,racketPosX
	jl check_sec_racket ;小球在球拍左侧不会撞击
	mov eax,ballPosX ;小球左侧x位置
	mov ebx,racketPosX
	add ebx,racketLen ;球拍右侧x位置
	cmp eax,ebx
	jg check_sec_racket ;小球在球拍右侧不会撞击

	;小球会撞击球拍，即方形与球拍有交集
	;首先判断小球是否只撞击上表面
	mov eax,ballPosX
	mov ebx,ballWidth
	shr ebx,1
	add eax,ebx ;eax为小球中下点x坐标
	cmp eax,racketPosX
	jl left_right_check
	mov ebx,racketPosX
	add ebx,racketLen
	cmp eax,ebx ;ebx为球拍右侧x坐标
	jg left_right_check
	;小球只撞击上表面
	neg ballVelY
	jmp done

left_right_check: ;判断小球是否只撞击左右表面
	mov eax,ballPosY
	mov ebx,ballWidth
	shr ebx,1
	add eax,ebx ;eax为小球中点y坐标
	cmp eax,racketPosY
	jl hit_corner
	mov ebx,racketPosY
	add ebx,racketWidth
	cmp eax,ebx ;ebx为球拍下侧y坐标
	jg hit_corner
	;小球只撞击左右表面
	neg ballVelX
	jmp done

hit_corner: ;小球撞到边角
	mov eax,ballPosX
	cmp eax,racketPosX
	jl left_corners_check

right_corners_check: ;检查右侧两个边角
	mov eax,ballPosY
	cmp eax,racketPosY
	jg right_up_corner
right_down_corner: ;检查右下角
	;只可能从右上角来撞击右下角
	neg ballVelX
	jmp done
right_up_corner: ;检查右上角
	mov al,ballVelX
	cmp al,0
	jl right_up_corner_negs
	neg ballVelY ;从左上角撞击右上角
	jmp done
right_up_corner_negs: ;从右上角撞击右上角
	neg ballPosX
	neg ballPosY
	jmp done

left_corners_check: ;检查左侧两个边角
	mov eax,ballPosY
	cmp eax,racketPosY
	jg left_up_corner
left_down_corner: ;检查左下角
	;只可能从左上角来撞击左下角
	neg ballVelX
	jmp done
left_up_corner: ;检查左上角
	mov al,ballVelX
	cmp al,0
	jg left_up_corner_negs
	neg ballVelY ;从右上角撞击左上角
	jmp done
left_up_corner_negs: ;从左上角撞击左上角
	neg ballPosX
	neg ballPosY
	jmp done


;检查第二个球拍
check_sec_racket:
	cmp doubleFlag,0
	je check_baffles

	mov eax,ballPosY
	add eax,ballWidth ;小球下侧y位置
	cmp eax,racket2PosY
	jl check_baffles ;小球在挡板上方不会撞击
	mov eax,ballPosY ;小球上侧y位置
	sub eax,1
	mov ebx,racket2PosY
	add ebx,racketWidth ;挡板下侧y位置
	sub ebx,1
	cmp eax,ebx
	jg check_baffles ;小球在挡板下方不会撞击
	mov eax,ballPosX
	add eax,ballWidth ;小球右侧x位置
	cmp eax,racket2PosX
	jl check_baffles ;小球在挡板左侧不会撞击
	mov eax,ballPosX ;小球左侧x位置
	sub eax,1
	mov ebx,racket2PosX
	add ebx,racketLen ;挡板右侧x位置
	sub ebx,1
	cmp eax,ebx
	jg check_baffles ;小球在挡板右侧不会撞击

	;小球会撞击挡板，即方形与挡板有交集
	;首先判断小球是否只撞击上下表面
	mov eax,ballPosX
	mov ebx,ballWidth
	shr ebx,1
	add eax,ebx ;eax为小球中下点x坐标
	cmp eax,racket2PosX
	jl left_right_check0
	mov ebx,racket2PosX
	add ebx,racketLen
	cmp eax,ebx ;ebx为挡板右侧x坐标
	jg left_right_check0
	;小球只撞击上下表面
	neg ballVelY
	jmp done

left_right_check0: ;判断小球是否只撞击左右表面
	mov eax,ballPosY
	mov ebx,ballWidth
	shr ebx,1
	add eax,ebx ;eax为小球中点y坐标
	cmp eax,racket2PosY
	jl hit_corner0
	mov ebx,racket2PosY
	add ebx,racketWidth
	cmp eax,ebx ;ebx为挡板下侧y坐标
	jg hit_corner0
	;小球只撞击左右表面
	neg ballVelX
	jmp done

hit_corner0: ;小球撞到边角
	mov eax,ballPosX
	cmp eax,racket2PosX
	jl left_corners_check0

right_corners_check0: ;检查右侧两个边角
	mov eax,ballPosY
	cmp eax,racket2PosY
	jg right_up_corner0
right_down_corner0: ;检查右下角
	mov al,ballVelX
	cmp al,0
	jl right_down_corner_right0
	neg ballVelY ;从左下角撞击右下角
	jmp done
right_down_corner_right0: ;从右侧撞击右下角
	mov al,ballVelY
	cmp al,0
	jg right_down_corner_up0
	neg ballVelY ;从右下角撞击右下角
right_down_corner_up0: ;从右上角撞击右下角
	neg ballVelX
	jmp done

right_up_corner0: ;检查右上角
	mov al,ballVelX
	cmp al,0
	jl right_up_corner_right0
	neg ballVelY ;从左上角撞击右上角
	jmp done
right_up_corner_right0: ;从右侧撞击右上角
	mov al,ballVelY
	cmp al,0
	jl right_up_corner_down0
	neg ballVelY ;从右上角撞击右上角
right_up_corner_down0: ;从右下角撞击右上角
	neg ballVelX
	jmp done


left_corners_check0: ;检查左侧两个边角
	mov eax,ballPosY
	cmp eax,racket2PosY
	jg left_up_corner0
left_down_corner0: ;检查左下角
	mov al,ballVelX
	cmp al,0
	jg left_down_corner_left0
	neg ballVelY ;从右下角撞击左下角
	jmp done
left_down_corner_left0: ;从左侧撞击左下角
	mov al,ballVelY
	cmp al,0
	jg left_down_corner_up0
	neg ballVelY ;从左下角撞击左下角
left_down_corner_up0: ;从左上角撞击左下角
	neg ballVelX
	jmp done

left_up_corner0: ;检查左上角
	mov al,ballVelX
	cmp al,0
	jg left_up_corner_left0
	neg ballVelY ;从右上角撞击左上角
	jmp done
left_up_corner_left0: ;从左侧撞击左上角
	mov al,ballVelY
	cmp al,0
	jl left_up_corner_down0
	neg ballVelY ;从左上角撞击左上角
left_up_corner_down0: ;从左下角撞击左上角
	neg ballVelX
	jmp done




check_baffles:
	cmp isBaffle,0
	je done

check_baffle1: ;检查第一个挡板
	mov eax,ballPosY
	add eax,ballWidth ;小球下侧y位置
	cmp eax,baffle1PosY
	jl check_baffle2 ;小球在挡板上方不会撞击
	mov eax,ballPosY ;小球上侧y位置
	sub eax,1
	mov ebx,baffle1PosY
	add ebx,baffle1Width ;挡板下侧y位置
	sub ebx,1
	cmp eax,ebx
	jg check_baffle2 ;小球在挡板下方不会撞击
	mov eax,ballPosX
	add eax,ballWidth ;小球右侧x位置
	cmp eax,baffle1PosX
	jl check_baffle2 ;小球在挡板左侧不会撞击
	mov eax,ballPosX ;小球左侧x位置
	sub eax,1
	mov ebx,baffle1PosX
	add ebx,baffle1Len ;挡板右侧x位置
	sub ebx,1
	cmp eax,ebx
	jg check_baffle2 ;小球在挡板右侧不会撞击

	;小球会撞击挡板，即方形与挡板有交集
	;首先判断小球是否只撞击上下表面
	mov eax,ballPosX
	mov ebx,ballWidth
	shr ebx,1
	add eax,ebx ;eax为小球中下点x坐标
	cmp eax,baffle1PosX
	jl left_right_check1
	mov ebx,baffle1PosX
	add ebx,baffle1Len
	cmp eax,ebx ;ebx为挡板右侧x坐标
	jg left_right_check1
	;小球只撞击上下表面
	neg ballVelY
	jmp done

left_right_check1: ;判断小球是否只撞击左右表面
	mov eax,ballPosY
	mov ebx,ballWidth
	shr ebx,1
	add eax,ebx ;eax为小球中点y坐标
	cmp eax,baffle1PosY
	jl hit_corner1
	mov ebx,baffle1PosY
	add ebx,baffle1Width
	cmp eax,ebx ;ebx为挡板下侧y坐标
	jg hit_corner1
	;小球只撞击左右表面
	neg ballVelX
	jmp done

hit_corner1: ;小球撞到边角
	mov eax,ballPosX
	cmp eax,baffle1PosX
	jl left_corners_check1

right_corners_check1: ;检查右侧两个边角
	mov eax,ballPosY
	cmp eax,baffle1PosY
	jg right_up_corner1
right_down_corner1: ;检查右下角
	mov al,ballVelX
	cmp al,0
	jl right_down_corner_right1
	neg ballVelY ;从左下角撞击右下角
	jmp done
right_down_corner_right1: ;从右侧撞击右下角
	mov al,ballVelY
	cmp al,0
	jg right_down_corner_up1
	neg ballVelY ;从右下角撞击右下角
right_down_corner_up1: ;从右上角撞击右下角
	neg ballVelX
	jmp done

right_up_corner1: ;检查右上角
	mov al,ballVelX
	cmp al,0
	jl right_up_corner_right1
	neg ballVelY ;从左上角撞击右上角
	jmp done
right_up_corner_right1: ;从右侧撞击右上角
	mov al,ballVelY
	cmp al,0
	jl right_up_corner_down1
	neg ballVelY ;从右上角撞击右上角
right_up_corner_down1: ;从右下角撞击右上角
	neg ballVelX
	jmp done


left_corners_check1: ;检查左侧两个边角
	mov eax,ballPosY
	cmp eax,baffle1PosY
	jg left_up_corner1
left_down_corner1: ;检查左下角
	mov al,ballVelX
	cmp al,0
	jg left_down_corner_left1
	neg ballVelY ;从右下角撞击左下角
	jmp done
left_down_corner_left1: ;从左侧撞击左下角
	mov al,ballVelY
	cmp al,0
	jg left_down_corner_up1
	neg ballVelY ;从左下角撞击左下角
left_down_corner_up1: ;从左上角撞击左下角
	neg ballVelX
	jmp done

left_up_corner1: ;检查左上角
	mov al,ballVelX
	cmp al,0
	jg left_up_corner_left1
	neg ballVelY ;从右上角撞击左上角
	jmp done
left_up_corner_left1: ;从左侧撞击左上角
	mov al,ballVelY
	cmp al,0
	jl left_up_corner_down1
	neg ballVelY ;从左上角撞击左上角
left_up_corner_down1: ;从左下角撞击左上角
	neg ballVelX
	jmp done

check_baffle2: ;检查第二个挡板
	mov eax,ballPosY
	add eax,ballWidth ;小球下侧y位置
	cmp eax,baffle2PosY
	jl done ;小球在挡板上方不会撞击
	mov eax,ballPosY ;小球上侧y位置
	sub eax,1
	mov ebx,baffle2PosY
	add ebx,baffle2Width ;挡板下侧y位置
	sub ebx,1
	cmp eax,ebx
	jg done ;小球在挡板下方不会撞击
	mov eax,ballPosX
	add eax,ballWidth ;小球右侧x位置
	cmp eax,baffle2PosX
	jl done ;小球在挡板左侧不会撞击
	mov eax,ballPosX ;小球左侧x位置
	sub eax,1
	mov ebx,baffle2PosX
	add ebx,baffle2Len ;挡板右侧x位置
	sub ebx,1
	cmp eax,ebx
	jg done ;小球在挡板右侧不会撞击

	;小球会撞击挡板，即方形与挡板有交集
	;首先判断小球是否只撞击上下表面
	mov eax,ballPosX
	mov ebx,ballWidth
	shr ebx,1
	add eax,ebx ;eax为小球中下点x坐标
	cmp eax,baffle2PosX
	jl left_right_check2
	mov ebx,baffle2PosX
	add ebx,baffle2Len
	cmp eax,ebx ;ebx为挡板右侧x坐标
	jg left_right_check2
	;小球只撞击上下表面
	neg ballVelY
	jmp done

left_right_check2: ;判断小球是否只撞击左右表面
	mov eax,ballPosY
	mov ebx,ballWidth
	shr ebx,1
	add eax,ebx ;eax为小球中点y坐标
	cmp eax,baffle2PosY
	jl hit_corner2
	mov ebx,baffle2PosY
	add ebx,baffle2Width
	cmp eax,ebx ;ebx为挡板下侧y坐标
	jg hit_corner2
	;小球只撞击左右表面
	neg ballVelX
	jmp done

hit_corner2: ;小球撞到边角
	mov eax,ballPosX
	cmp eax,baffle2PosX
	jl left_corners_check2

right_corners_check2: ;检查右侧两个边角
	mov eax,ballPosY
	cmp eax,baffle2PosY
	jg right_up_corner2
right_down_corner2: ;检查右下角
	mov al,ballVelX
	cmp al,0
	jl right_down_corner_right2
	neg ballVelY ;从左下角撞击右下角
	jmp done
right_down_corner_right2: ;从右侧撞击右下角
	mov al,ballVelY
	cmp al,0
	jg right_down_corner_up2
	neg ballVelY ;从右下角撞击右下角
right_down_corner_up2: ;从右上角撞击右下角
	neg ballVelX
	jmp done

right_up_corner2: ;检查右上角
	mov al,ballVelX
	cmp al,0
	jl right_up_corner_right2
	neg ballVelY ;从左上角撞击右上角
	jmp done
right_up_corner_right2: ;从右侧撞击右上角
	mov al,ballVelY
	cmp al,0
	jl right_up_corner_down2
	neg ballVelY ;从右上角撞击右上角
right_up_corner_down2: ;从右下角撞击右上角
	neg ballVelX
	jmp done


left_corners_check2: ;检查左侧两个边角
	mov eax,ballPosY
	cmp eax,baffle2PosY
	jg left_up_corner2
left_down_corner2: ;检查左下角
	mov al,ballVelX
	cmp al,0
	jg left_down_corner_left2
	neg ballVelY ;从右下角撞击左下角
	jmp done
left_down_corner_left2: ;从左侧撞击左下角
	mov al,ballVelY
	cmp al,0
	jg left_down_corner_up2
	neg ballVelY ;从左下角撞击左下角
left_down_corner_up2: ;从左上角撞击左下角
	neg ballVelX
	jmp done

left_up_corner2: ;检查左上角
	mov al,ballVelX
	cmp al,0
	jg left_up_corner_left2
	neg ballVelY ;从右上角撞击左上角
	jmp done
left_up_corner_left2: ;从左侧撞击左上角
	mov al,ballVelY
	cmp al,0
	jl left_up_corner_down2
	neg ballVelY ;从左上角撞击左上角
left_up_corner_down2: ;从左下角撞击左上角
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
;检测小球与砖块碰撞
HitBrick proc
	push eax
	push edx
	push ebx
	push ecx
	push edi
	push esi
	push ebp ;ebp保存唯一撞击的边角对应的砖块号

	mov eax,ballPosY
	cmp eax,brickRegion
	jge done ;下边界之外
	mov eax,ballPosY
	add eax,ballWidth
	sub eax,1
	cmp eax,brickStartY
	jle done ;上边界之外
	mov eax,ballPosX
	add eax,ballWidth
	sub eax,1
	cmp eax,brickStartX
	jle done ;左边界之外
	mov eax,ballPosX
	cmp eax,brickEndX
	jge done ;右边界之外

	;检查是否四个边角只有一个碰撞砖块
	;若是则直接置位方向向量
	;edi为1234分别代表左上左下右下右上
	xor edi,edi ;edi保存最新的撞击砖块的边角号
	xor esi,esi ;esi保存撞击砖块的边角总数


hit_brick_left_up: ;小球左上可能击中砖块
	xor ecx,ecx ;ecx保存小球左上点击中砖块号
	;判断行号
	xor edx,edx
	mov eax,ballPosY
	cmp eax,brickStartY ;---
	jle hit_brick_left_down
	sub eax,brickStartY
	mov ebx,brickWidth
	idiv ebx ;eax为行号
	sub eax,1 ;*****
	imul eax,brickLine
	add ecx,eax
	;判断列号
	xor edx,edx
	mov eax,ballPosX
	cmp eax,brickStartX ;---
	jle hit_brick_left_down
	sub eax,brickStartX
	mov ebx,brickLen
	idiv ebx ;eax为列号
	add ecx,eax ;ecx恒为左上点击中的砖块号
hit_brick_left_up_check: ;判断左上点撞击的砖块
	;若击中砖块生命值为0
	cmp brickLife[ecx],0
	je hit_brick_left_down
	mov edi,1
	add esi,1
	mov ebp,ecx

hit_brick_left_down: ;小球左下可能击中砖块
	xor ecx,ecx ;ecx保存小球左下点击中砖块号
	;判断行号
	xor edx,edx
	mov eax,ballPosY
	add eax,ballWidth
	sub eax,1
	cmp eax,brickRegion ;---
	jge hit_brick_right_down
	sub eax,brickStartY
	mov ebx,brickWidth
	idiv ebx ;eax为行号
	sub eax,1 ;*****
	imul eax,brickLine
	add ecx,eax
	;判断列号
	xor edx,edx
	mov eax,ballPosX
	cmp eax,brickStartX ;---
	jle hit_brick_right_down
	sub eax,brickStartX
	mov ebx,brickLen
	idiv ebx ;eax为列号
	add ecx,eax ;ecx恒为左下点击中的砖块号
hit_brick_left_down_check: ;判断左下点撞击的砖块
	;若击中砖块生命值为0
	cmp brickLife[ecx],0
	je hit_brick_right_down
	mov edi,2
	add esi,1
	mov ebp,ecx

hit_brick_right_down: ;小球右下可能击中砖块
	xor ecx,ecx ;ecx保存小球右下点击中砖块号
	;判断行号
	xor edx,edx
	mov eax,ballPosY
	add eax,ballWidth
	sub eax,1
	cmp eax,brickRegion ;---
	jge hit_brick_right_up
	sub eax,brickStartY
	mov ebx,brickWidth
	idiv ebx ;eax为行号
	sub eax,1 ;*****
	imul eax,brickLine
	add ecx,eax
	;判断列号
	xor edx,edx
	mov eax,ballPosX
	add eax,ballWidth
	sub eax,1
	cmp eax,brickEndX ;---
	jge hit_brick_right_up
	sub eax,brickStartX
	mov ebx,brickLen
	idiv ebx ;eax为列号
	add ecx,eax ;ecx恒为右下点击中的砖块号
hit_brick_rigth_down_check: ;判断右下点撞击的砖块
	;若击中砖块生命值为0
	cmp brickLife[ecx],0
	je hit_brick_right_up
	mov edi,3
	add esi,1
	mov ebp,ecx

hit_brick_right_up: ;小球右上可能击中砖块
	xor ecx,ecx ;ecx保存小球右上点击中砖块号
	;判断行号
	xor edx,edx
	mov eax,ballPosY
	cmp eax,brickStartY ;---
	jle check_four_corners
	sub eax,brickStartY
	mov ebx,brickWidth
	idiv ebx ;eax为行号
	sub eax,1 ;*****
	imul eax,brickLine
	add ecx,eax
	;判断列号
	xor edx,edx
	mov eax,ballPosX
	add eax,ballWidth
	sub eax,1
	cmp eax,brickEndX ;---
	jge check_four_corners
	sub eax,brickStartX
	mov ebx,brickLen
	idiv ebx ;eax为列号
	add ecx,eax ;ecx恒为右上点击中的砖块号
hit_brick_rigth_up_check: ;判断右上点撞击的砖块
	;若击中砖块生命值为0
	cmp brickLife[ecx],0
	je check_four_corners
	mov edi,4
	add esi,1
	mov ebp,ecx

check_four_corners: ;判断撞击哪一个边角
	cmp esi,1
	je hit_one_corner
	jmp hit_brick_up
hit_one_corner:
	;砖块生命值不为0，减1
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
left_up_corner_only: ;撞击左上角，方向向量左上
	cmp ballVelX,0
	jl left_up_y_judge
	neg ballVelX
left_up_y_judge:
	cmp ballVelY,0
	jl done
	neg ballVelY
	jmp done

left_down_corner_only: ;撞击左下角，方向向量左下
	cmp ballVelX,0
	jl left_down_y_judge
	neg ballVelX
left_down_y_judge:
	cmp ballVelY,0
	jg done
	neg ballVelY
	jmp done

right_down_corner_only: ;撞击右下角，方向向量右下
	cmp ballVelX,0
	jg right_down_y_judge
	neg ballVelX
right_down_y_judge:
	cmp ballVelY,0
	jg done
	neg ballVelY
	jmp done

right_up_corner_only: ;撞击右上角，方向向量右上
	cmp ballVelX,0
	jg right_up_y_judge
	neg ballVelX
right_up_y_judge:
	cmp ballVelY,0
	jl done
	neg ballVelY
	jmp done


;非唯一边角碰撞，判断四边中点碰撞情况
hit_brick_up: ;小球中上可能击中砖块
	mov eax,ballPosY
	cmp eax,brickStartY
	jle hit_brick_down ;撞击上边界
	xor ecx,ecx ;ecx保存小球中上点击中砖块号
	;判断行号
	xor edx,edx
	mov eax,ballPosY
	cmp eax,brickStartY ;---
	jle hit_brick_down
	sub eax,brickStartY
	mov ebx,brickWidth
	idiv ebx ;eax为行号
	sub eax,1 ;*****
	imul eax,brickLine
	add ecx,eax
	;判断列号
	xor edx,edx
	mov eax,ballPosX
	mov ebx,ballWidth
	shr ebx,1 ;ebx=ballWidth/2
	add eax,ebx ;eax为小球中间x坐标
	cmp eax,brickEndX ;---
	jge hit_brick_down
	sub eax,brickStartX
	mov ebx,brickLen
	idiv ebx ;eax为列号
	add ecx,eax ;ecx恒为中上点击中的砖块号
midUp_brick: ;判断中上点撞击的砖块
	;若击中砖块生命值为0
	cmp brickLife[ecx],0
	je hit_brick_down
	neg ballVelY ;ballVelY取反
	;砖块生命值不为0，减1
	sub brickLife[ecx],1
	cmp brickLife[ecx],0
	jg hit_brick_down
	sub brickNum,1


hit_brick_down: ;小球中下可能击中砖块
	mov eax,ballPosY
	add eax,ballWidth ;eax保存小球中下点y坐标
	sub eax,1
	cmp eax,brickRegion
	jge hit_brick_left ;下边界不会碰撞砖块
	xor ecx,ecx ;ecx保存小球中下点击中砖块号
	;判断行号
	xor edx,edx
	mov eax,ballPosY
	add eax,ballWidth
	sub eax,1
	cmp eax,brickRegion ;---
	jge hit_brick_left
	sub eax,brickStartY
	mov ebx,brickWidth
	idiv ebx ;eax为行号
	sub eax,1 ;*****
	imul eax,brickLine
	add ecx,eax
	;判断列号
	xor edx,edx
	mov eax,ballPosX
	mov ebx,ballWidth
	shr ebx,1 ;ebx=ballWidth/2
	add eax,ebx ;eax为小球中间x坐标
	cmp eax,brickEndX ;---
	jge hit_brick_left
	sub eax,brickStartX
	mov ebx,brickLen
	idiv ebx ;eax为列号
	add ecx,eax ;ecx为中下点击中的砖块号
midDown_brick: ;判断中下点撞击的砖块
	;若击中砖块生命值为0
	cmp brickLife[ecx],0
	je hit_brick_left
	neg ballVelY ;ballVelY取反
	;砖块生命值不为0，减1
	sub brickLife[ecx],1
	cmp brickLife[ecx],0
	jg hit_brick_left
	sub brickNum,1


hit_brick_left: ;小球中左可能击中砖块
	;判断小球左侧是否为墙壁
	mov eax,ballPosX
	cmp eax,brickStartX
	jle hit_brick_right ;左边界不会碰撞砖块
	xor ecx,ecx ;ecx保存小球中左点击中砖块号
	;判断行号
	xor edx,edx
	mov eax,ballPosY
	mov ebx,ballWidth
	shr ebx,1 ;ebx=ballWidth/2
	add eax,ebx ;eax为小球中间y坐标
	cmp eax,brickRegion ;---
	jge hit_brick_right
	sub eax,brickStartY
	mov ebx,brickWidth
	idiv ebx ;eax为行号
	sub eax,1 ;*****
	imul eax,brickLine
	add ecx,eax
	;判断列号
	xor edx,edx
	mov eax,ballPosX
	cmp eax,brickStartX ;---
	jle hit_brick_right
	sub eax,brickStartX
	mov ebx,brickLen
	idiv ebx ;eax为列号
	add ecx,eax ;ecx为中下点击中的砖块号
midLeft_brick: ;判断中左点撞击的砖块
	;若击中砖块生命值为0
	cmp brickLife[ecx],0
	je hit_brick_right
	neg ballVelX ;ballVelX取反
	;砖块生命值不为0，减1
	sub brickLife[ecx],1
	cmp brickLife[ecx],0
	jg hit_brick_right
	sub brickNum,1


hit_brick_right: ;小球中右可能击中砖块
	;判断小球右侧是否为墙壁
	mov eax,ballPosX
	add eax,ballWidth
	sub eax,1
	cmp eax,brickEndX
	jge done ;右边界不会碰撞砖块
	xor ecx,ecx ;ecx保存小球中右点击中砖块号
	;判断行号
	xor edx,edx
	mov eax,ballPosY
	mov ebx,ballWidth
	shr ebx,1 ;ebx=ballWidth/2
	add eax,ebx ;eax为小球中间y坐标
	cmp eax,brickRegion ;---
	jge done
	sub eax,brickStartY
	mov ebx,brickWidth
	idiv ebx ;eax为行号
	sub eax,1 ;*****
	imul eax,brickLine
	add ecx,eax
	;判断列号
	xor edx,edx
	mov eax,ballPosX
	add eax,ballWidth
	sub eax,1
	cmp eax,brickEndX ;---
	jge done
	sub eax,brickStartX
	mov ebx,brickLen
	idiv ebx ;eax为列号
	add ecx,eax ;ecx为中右点击中的砖块号
midRight_brick:
	;若击中砖块生命值为0
	cmp brickLife[ecx],0
	je done
	neg ballVelX ;ballVelX取反
	;砖块生命值不为0，减1
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


; 播放声音
PlaySound Proc
start:
    ;取偏移地址
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

;播放声音：esi传递要播放的频率的地址，edi传递要播放的音长的地址
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

    ;控制扬声器的开/关
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