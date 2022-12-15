include Irvine32.inc
includelib Irvine32.lib

.data
; 窗口的长宽像素
windowLen	dw	93
windowWidth	dw	164

; 游戏流程控制属性
levelFlag	db  1	; 游戏关卡标志，1-5为1-5关，6为游戏通关
clearFlag   db  0   ; 砖块清零标志
deadFlag    db  0   ; 生命值减少
exitFlag	db	0	; 是否退出
pauseFlag	db	0	; 是否暂停
; replayFlag	db	0	; 是否重新开始
winFlag		db	1   ; 是否获胜
loseFlag	db	0   ; 是否失败
;propFlag    db  0   ; 道具标志变量: 
doubleFlag	db  0  ; 为0时单球拍，为1时双球拍

int_str		byte	'ballPosX=%d',0ah,0

; 生命值
life	db	3

; 球拍属性
; 注意位置都是"左上角位置"
; 坐标原点在窗口左上角
racketPosX	dd	70   ; 球拍x轴位置 60
racketPosY	dd	80   ; 球拍y轴位置
racketLen	dd	20   ; 球拍长度
racketWidth dd	2	; 球拍宽度
racketVel   db  10  ; 球拍速度
racketColor dd	2	; 绿球拍
oldRacketPosX	dd	70
oldRacketPosY	dd	80

racket2PosX	dd	70   ; 球拍x轴位置 60
racket2PosY	dd	70   ; 球拍y轴位置
racket2Color dd	2	; 绿球拍
oldRacket2PosX	dd	70
oldRacket2PosY	dd	70


; 球属性
ballPosX	dd  70 ;70
ballPosY	dd	50 ;50
ballColor	dd	15 ;白球
;ballVelX	db	1
;ballVelY	db	1
;ballVelK    db  1   ; 速度因子, 用这个参数调节速度
ballVelX	sbyte	1
ballVelY	sbyte	1
ballVelK    sbyte  1   ; 速度因子, 用这个参数调节速度
ballWidth	dd  2;------------
ballLife	db  3;------------
oldBallPosX	dd  200		;上一帧球的位置
oldBallPosY	dd	110		;初值都是随便取的

; 移动挡板相关参数
isBaffle        db  0   ; 第4关之前
baffle1PosX		dd	30
baffle1PosY		dd  30
baffle1Len		dd  20   
baffle1Width	dd  2
baffle2PosX		dd  70
baffle2PosY		dd  45
baffle2Len		dd  25  
baffle2Width	dd  2 
baffleDir       db  0  ; baffle运动方向, 因为只有两个运动方向, 所以设定向左为0向右为1
baffleVel       db  3
oldBaffle1PosX		dd	30	; 上一帧挡板的位置
oldBaffle1PosY		dd  65
oldBaffle2PosX		dd	70
oldBaffle2PosY		dd  65
baffleColor			dd	8 ; 灰色挡板

; 边界位置: 小球运动到左右上边界发生碰撞，运动到下边界就死亡
leftBorder      dd  1
rightBorder     dd  163
upperBorder     dd  1
lowerBorder     dd  95

borderColor		dd	 7 ;棕色边框

; 各关卡砖块初始生命值



; 砖块参数
brickLen    dd  13
brickWidth  dd  1

brickLine	dd 11;-----------------
brickRegion dd 11;-----------------
brickLife	db 99 dup(1);----------
brickNum	db 99;-------------

brickEndX	dd 148
brickStartX dd 5
brickStartY dd 1


; 道具


; 音乐

; 声音
musicFreq dw 392, -1
; 音长
musicTime dw 16h

; 绘图相关

brickMsg	 byte	 " ############ ", 0
brickShape   byte    " ############ ",0
brickShapeEmpty byte "              ",0

ballShape    byte    "**",0
ballMsg		byte	 "##",0
blankBall	byte	 "  ",0

racketMsg		byte	"####################",0
racketShape		byte	"####################",0
blankRacket		byte	"                    ",0


baffle1Msg		byte "####################",0
blankBaffle1	byte "                    ",0

baffle2Msg		byte "#########################",0
blankBaffle2	byte "                         ",0

;界面
borderbk	       byte    "*******************************************************************************************************************************************************************",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0
				   byte    "*                                                                                                                                                                 *",0 
				   byte    "*******************************************************************************************************************************************************************",0



myMessage   BYTE    "                 BREAK OUT                  ",0
createdBy   BYTE    "             CREATED BYE : LBW ZKY LCY XYH",0ah,0


titlebk0	byte	"                                                                                                                                                                    ",0
titlebk1	byte	"                                                                                                                                                                    ",0
titlebk2	byte	"                                                                                                                                                                    ",0
titlebk3	byte	"                                                                                                                                                                    ",0
titlebk4	byte	"                                                                                                                                                                    ",0
titlebk5	byte	"                                                                                                                                                                    ",0
titlebk6	byte	"                                                                                                                                                                    ",0
titlebk7	byte	"                                                                                                                                                                    ",0
titlebk8	byte	"                                                                                                                                                                    ",0
titlebk9	byte	"                                                                               8              88                                                                    ",0
titlebk10	byte	"                                            88888          888888888        8   8            88      88                                                             ",0
titlebk11	byte	"                           888            88888888        8888888888       88   88           88     8&8                                                             ",0
titlebk12	byte	"                        8&8888&8       8&88      88      88                88    &8          88   8&8                                                               ",0
titlebk13	byte	"                     8&88      &      88         88     8                 88     8&          88  888                                                                ",0
titlebk14	byte	"                   88          8    88           8                        8       88        888 888                                                                 ",0
titlebk15	byte	"                 88            8   88           88       8                8       8&        88 888                                                                  ",0
titlebk16	byte	"                 88      8     8   8            &        8               88        8        &8 88                                                                   ",0
titlebk17	byte	"                8       88    888       88    8&         8 8888          88 88888  8       88  88                                                                   ",0
titlebk18	byte	"                        8   888888      8    88          8888            8 88      8       88  888                                                                  ",0
titlebk19	byte	"                        8  &88   8     88  8&8          88       8       8         8       &8   8888                                                                ",0
titlebk20	byte	"                       88888     8     &8 888           8        88     88         8       88    888888                                                             ",0
titlebk21	byte	"                      88 88     &8    8&   &88          88    88&8      88         8      888        88                                                             ",0
titlebk22	byte	"                      88 8     88     88   8&&8         &8    &88       88         8      888                                                                       ",0
titlebk23	byte	"                      &8      88      88     888        88  888          8         8      888                                                                       ",0
titlebk24	byte	"                     888  88888      888       88        88888                             88                                                                       ",0
titlebk25	byte	"                     888  88         88         8                                                                                                                   ",0
titlebk26	byte	"                     &88                                                                                                                                            ",0
titlebk27	byte	"                     88                                                                                                                                             ",0
titlebk28	byte	"                     &8                                                                                                                                             ",0
titlebk29	byte	"                                                                                                                                    8888&888                        ",0
titlebk30	byte	"                                                                                                                             8 8888888888888                        ",0
titlebk31	byte	"                                                                                                  8                      8888888888888888888                        ",0
titlebk32	byte	"                                                                                                   8&                 8&888888888888888                             ",0
titlebk33	byte	"                                                           888888                  8               888              &8888888888                                     ",0
titlebk34	byte	"                                                          88888888                88               888              88888888                                        ",0
titlebk35	byte	"                                                         8      888              888               888                                                              ",0
titlebk36	byte	"                                                                 888            8888               &88                         8                                    ",0
titlebk37	byte	"                                                                  888           8888               8888                       88                                    ",0
titlebk38	byte	"                                                      8            8&           8888              8888                        88                                    ",0
titlebk39	byte	"                                                    8&8            888          8888              8888                       888                                    ",0
titlebk40	byte	"                                                   888             8888         8888              8888                       888                                    ",0
titlebk41	byte	"                                                   888             8888         8888              8888                       &88                                    ",0
titlebk42	byte	"                                                  8888             8888         8888             88888                       &88                                    ",0
titlebk43	byte	"                                                  888              8888         8888             88888                      8888                                    ",0
titlebk44	byte	"                                                 888                888         8888             88888                      888                                     ",0
titlebk45	byte	"                                                 888               8888        88888             8888                       888                                     ",0
titlebk46	byte	"                                                 888               8888        88888             8888                       888                                     ",0
titlebk47	byte	"                                                 &88               8888        88888            88888                       888                                     ",0
titlebk48	byte	"                                                 888               8888         8888           888888                      8888                                     ",0
titlebk49	byte	"                                                8888               8888         8888           888888                      8888                                     ",0
titlebk50	byte	"                                                8888               8888         88888         888888                       8888                                     ",0
titlebk51	byte	"                                                8888              88888         88888         8888&                       88888                                     ",0
titlebk52	byte	"                                                8888              88888         88888        888888                       88888                                     ",0
titlebk53	byte	"                                                8888             888888         888888      888888                        88888                                     ",0
titlebk54	byte	"                                                88888           888888          888888     8888888                        8888                                      ",0
titlebk55	byte	"                                                888888         888888           8888888   8888888                         8888                                      ",0
titlebk56	byte	"                                                 88888        8888888            8888888888888888                        8888&                                      ",0
titlebk57	byte	"                                                 &8888       8888888             888888888888888                         88888                                      ",0
titlebk58	byte	"                                                 8888888  888888888               8888888888888                          88888                                      ",0
titlebk59	byte	"                                                 88888888888888888                 88888888888                           88888                                      ",0
titlebk60	byte	"                                                  888888888888888                   888888888                            8888                                       ",0
titlebk61	byte	"                                                  88888888888888                       8888                               888                                       ",0
titlebk62	byte	"                                                   88&888888888                                                                                                     ",0
titlebk63	byte	"                                                    8888888888                                                                                                      ",0
titlebk64	byte	"                                                                                                                                                                    ",0
titlebk65	byte	"                                                                                                                                                                    ",0
titlebk66	byte	"                                                                                                                                                                    ",0
titlebk67	byte	"                                                                                                                                                                    ",0
titlebk68	byte	"                                                                                                                                                                    ",0
titlebk69	byte	"                                                                                                                                                                    ",0
titlebk70	byte	"                                                                                                                                                                    ",0
titlebk71	byte	"                                                                                                                                                                    ",0
titlebk72	byte	"                                                                                                                                                                    ",0
titlebk73	byte	"               888                                                                                                                                     88           ",0
titlebk74	byte	"              88888                                                                                                                     88             88           ",0
titlebk75	byte	"             888 88                                                                                                                     88             88           ",0
titlebk76	byte	"             88    8                                                                                          888888888888888888        8              88           ",0
titlebk77	byte	"             88                                                                                               888888888888888888        8       8      88           ",0
titlebk78	byte	"             88             8888888888888888888                                                                                        88      88      88           ",0
titlebk79	byte	"             888            8888888888888888888                                                                                        88      8       88           ",0
titlebk80	byte	"             8888           8888888888888888888                                                                                        88      8       88           ",0
titlebk81	byte	"              888888        8888888888888888888                                                                                        88     888      88           ",0
titlebk82	byte	"                 8888                                                                               8888888888888888888                88     888     88            ",0
titlebk83	byte	"                   88                                                                               8888888888888888888                 88   88 8     88            ",0
titlebk84	byte	"                   88                                                                               8888888888888888888                 88  88  888  88             ",0
titlebk85	byte	"              88 8888                                                                                                                    88888   88888              ",0
titlebk86	byte	"              8888888                                                                                                                    8888      888              ",0
titlebk87	byte	"               8888                                                                                                                                                 ",0
titlebk88	byte	"                                                                                                                                                                    ",0
titlebk89	byte	"                                                                                                                                                                    ",0
titlebk90	byte	"                                                                                                                                                                    ",0
titlebk91	byte	"                                                                                                                                                                    ",0
titlebk92	byte	"                                                                                                                                                                    ",0
titleChar dd ?

winbk0	byte	"                                                                                                                                          ",0
winbk1	byte	"                                                                                                           $$$$$                          ",0
winbk2	byte	"                                                                                                        $$$   $$$$                        ",0
winbk3	byte	"                                                                                                      $$$       $$$$                      ",0
winbk4	byte	"                                                                                                   $$$$         $$$$$                     ",0
winbk5	byte	"                                                                                                  $$$        $$$$                         ",0
winbk6	byte	"                                                                                               $$$       $$$                              ",0
winbk7	byte	"                                                                                                $$$   $$$          $$$$                   ",0
winbk8	byte	"                     $$           $$                                                               $$$     $$$$$$     $$                  ",0
winbk9	byte	"                     $$          $$            $   $$                                                   $$$$          $$$                 ",0
winbk10	byte	"                      $$        $$          $       $$             $            $$                    $$            $$$$$$                ",0
winbk11	byte	"                      $$      $$$          $$        $$            $            $$                    $$$  $$$$$$$$$$$ $                  ",0
winbk12	byte	"                      $$$    $$$          $$         $$           $$            $$                                                        ",0
winbk13	byte	"                       $$$  $$            $$         $$           $            $$                                    $   $$$$             ",0
winbk14	byte	"                         $$              $$$        $$$           $            $$                      $$$$$$$$$$$$$$$  $$$$$             ",0
winbk15	byte	"                        $$               $$$       $$$           $$           $$                      $$$                $$$              ",0
winbk16	byte	"                        $$               $$$      $$$            $$         $$$                       $$$$$$$           $$$               ",0
winbk17	byte	"                       $$$               $$$     $$$             $$         $$                            $ $$$$$$$$$$$$$$                ",0
winbk18	byte	"                      $$$                $$$   $$$$               $$      $$                                                              ",0
winbk19	byte	"                      $$$                 $$$$$$$                 $$$   $$$                                                               ",0
winbk20	byte	"                      $$$                                           $$$$                                                                  ",0
winbk21	byte	"                                                                                                                                          ",0
winbk22	byte	"                                                                                                                                          ",0
winbk23	byte	"                                                                                                                                          ",0
winbk24	byte	"                                                                                                                                          ",0
winbk25	byte	"                                                                                                                                          ",0
winbk26	byte	"                                                                                                                                          ",0
winbk27	byte	"                                                                                                                                          ",0
winbk28	byte	"                                                                                                                                          ",0
winbk29	byte	"                                                                                                                                 $$$      ",0
winbk30	byte	"                                                                    $        $$$$$$                                              $$       ",0
winbk31	byte	"                                           $$           $           $$                         $                                $$$       ",0
winbk32	byte	"          $$$$$$$                          $$           $          $$         $               $   $             $$             $$$$       ",0
winbk33	byte	"          $$$$$$$$$$$$$$$$$$$$             $$          $$          $          $              $$   $$            $              $$$        ",0
winbk34	byte	"         $$$                $$              $         $$$         $$         $$             $$     $$          $$             $$$         ",0
winbk35	byte	"        $$$           $$$$$$$$              $        $$$$        $$         $$             $$$     $$$        $$             $$$$         ",0
winbk36	byte	"       $$$$$$$$$$$$$$$$$$$$$                $       $$ $$       $$          $$             $$        $$$     $$$             $$$          ",0
winbk37	byte	"                                            $$    $$    $$    $$$          $$$            $$$         $$$$$$$$$                           ",0
winbk38	byte	"                    $$$$$$$$$$$             $$$ $$$     $$$  $$$           $$$            $$$          $$$$$$               $$$           ",0
winbk39	byte	"          $$$$$$$$$$$$       $$$               $$          $$             $$$$$$$                                            $            ",0
winbk40	byte	"           $$$             $$$$$                                                                                                          ",0
winbk41	byte	"            $$$       $$$$     $$$                                                                                                        ",0
winbk42	byte	"             $$$$$$$$$       $$$$$$$                                                                                                      ",0
winbk43	byte	"               $$        $$$$       $$                                                                                                    ",0
winbk44	byte	"                      $$$$$      $$$                                                                                                      ",0
winbk45	byte	"                $$$$$$         $$$                                                                                                        ",0
winbk46	byte	"                 $$$$        $$$$                                                                                                         ",0
winbk47	byte	"                   $$$    $$$$                                                                                                            ",0
winbk48	byte	"                    $$$$$$$$                                                                                                              ",0
winbk49	byte	"                        $                                                                                                                 ",0
winbk50	byte	"                                                                                                                                          ",0
winbk51	byte	"                                                                                                                                          ",0
winbk52	byte	"                                                                                                                                          ",0
winbk53	byte	"                                                                                                                                          ",0
winbk54	byte	"                                                                                                                                          ",0
winbk55	byte	"                                                                                                                                          ",0

losebk0	byte	"                                                                                                                                          ",0
losebk1	byte	"                                                                                                                                          ",0
losebk2	byte	"                                                                                                                                          ",0
losebk3	byte	"                                                                                                                                          ",0
losebk4	byte	"                                                                                                         $$$$$$$$$$$                      ",0
losebk5	byte	"                                                                                                     $$$$$$$$$  $$$$$$                    ",0
losebk6	byte	"                                                                                                 $$$$$               $$$                  ",0
losebk7	byte	"                                                                                               $$$$                   $$                  ",0
losebk8	byte	"                                                                                             $$$                     $$$                  ",0
losebk9	byte	"                                                                                            $$                      $$$                   ",0
losebk10	byte	"                  $$                                                                       $$                    $$$$                     ",0
losebk11	byte	"                  $$            $                                                         $$$                 $$$$$                       ",0
losebk12	byte	"                  $$$         $$        $$$$$$$$$                      $                  $$             $$$$$$$                          ",0
losebk13	byte	"                   $$        $$        $$      $$           $          $$                  $                                              ",0
losebk14	byte	"                    $$    $$$          $        $$$        $           $$                                                                 ",0
losebk15	byte	"                    $$$  $$$          $$        $$$        $           $$                                                                 ",0
losebk16	byte	"      $$$$$$$           $            $$$        $$$       $$          $$                                                                  ",0
losebk17	byte	"    $$$$$$$$$$         $$            $$$        $$$      $$$          $$                                  $$$$$$$                         ",0
losebk18	byte	"                      $$$            $$$       $$$       $$$         $$$                            $$$          $$$$                     ",0
losebk19	byte	"                      $$$           $$$$      $$$        $$$        $$$                                             $$                    ",0
losebk20	byte	"                      $$$            $$$     $$$         $$$       $$$                                               $$                   ",0
losebk21	byte	"                      $$$            $$$   $$$$          $$$$     $$$$                             $                $$                    ",0
losebk22	byte	"                     $$$              $$$$$$$              $$$$$$$$                               $$$            $$$$                     ",0
losebk23	byte	"                      $$                $$$                  $$$$                                  $$$$$$$$$$$$$$$                        ",0
losebk24	byte	"                                                                                                                                          ",0
losebk25	byte	"                                                                                                                                          ",0
losebk26	byte	"                                                                                                                                          ",0
losebk27	byte	"                                                                                                                                          ",0
losebk28	byte	"                                                                                                                                          ",0
losebk29	byte	"                                                                                                                                          ",0
losebk30	byte	"       $$$$$$$$$$                                                                                                                         ",0
losebk31	byte	"     $$$         $$$$                                                                                                                     ",0
losebk32	byte	"   $$$              $$                                                                                                                    ",0
losebk33	byte	"   $$$                $$                    $                                                                                             ",0
losebk34	byte	"   $$$                 $                   $$                 $$$$$$              $$$$$                                                   ",0
losebk35	byte	"    $$$$                                 $$$               $$$     $$$          $$$      $$          $    $$$$$$                          ",0
losebk36	byte	"      $$$$$$$$$$$$$$$                    $$              $$         $$$         $$         $$       $                                     ",0
losebk37	byte	"             $$$                        $$              $$           $$         $$                 $$                                     ",0
losebk38	byte	"                                       $$               $            $$          $$$              $$                                      ",0
losebk39	byte	"                                       $$              $$           $$$            $$$           $$$  $$$$$$$$           $$$$$$$$         ",0
losebk40	byte	"                 $                    $$$              $$           $$$      $       $$          $$    $                $$$$$$$$$         ",0
losebk41	byte	"             $$$$                    $$$              $$$         $$$$       $         $$$       $$                                       ",0
losebk42	byte	"            $$$                      $$$         $$   $$$        $$$$        $$         $$$      $$                                       ",0
losebk43	byte	"           $$$       $                $$$$  $$$$$$     $$$     $$$$           $$$       $$$      $$          $$                           ",0
losebk44	byte	"             $$$$$$$$$                 $$$$$$$$$        $$$$$$$$$$            $$$$$$$$$$$$       $$$$$   $$$$$                            ",0
losebk45	byte	"                                                          $$$$$                  $$$$$             $$$$$$$$$                              ",0
losebk46	byte	"                                                                                                                                          ",0
losebk47	byte	"                                                                                                                                          ",0
losebk48	byte	"                                                                                                                                          ",0
losebk49	byte	"                                                                                                                                          ",0
losebk50	byte	"                                                                                                                                          ",0
losebk51	byte	"                                                                                                                                          ",0
losebk52	byte	"                                                                                                                                          ",0
losebk53	byte	"                                                                                                                                          ",0
losebk54	byte	"                                                                                                                                          ",0
losebk55	byte	"                                                                                                                                          ",0

schoolbk0	byte	"                                                                                                                                                                    ",0
schoolbk1	byte	"                                                                                                                                                                    ",0
schoolbk2	byte	"                                                                                                                                                                    ",0
schoolbk3	byte	"                                                                      bObbbbbbbbbbbbbbbbbbbbbbb                                                                     ",0
schoolbk4	byte	"                                                               >bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb;                                                              ",0
schoolbk5	byte	"                                                           dbbbbbbbbbbbfcb     bbbbbbbbbbbbbbbbbbbbbbbbbbd'                                                         ",0
schoolbk6	byte	"                                                       pbbbbbbbbbbbbb   d .   dbbbbbbbbbbbbb      bbbbbbbbbbbb                                                      ",0
schoolbk7	byte	"                                                   ]bxbbIbbbbbbbbbbbbb  b    +bbbbbbbbbbbbbbb   bbbbbbbbbbbbbbbbbp                                                  ",0
schoolbk8	byte	"                                                \bbX    +bbbbbbbbbbbb   bb   .bbbbbbbbbbb/.    bbbbbbbbbbbbbbbbbbbbbj                                               ",0
schoolbk9	byte	"                                              bbbbbbd  i QbbbbbbbbbbZ.  b      Qbbbbbbbb>_0m_     bbbbbbbbbbbbbb  bbbbb                                             ",0
schoolbk10	byte	"                                            bbbbbbb  b   bbbbbbbbbbbb bbbbbbbbmQQQQQQQZbbbbbbbbbbbbbbbbbbbbbY      bbbbbbb                                          ",0
schoolbk11	byte	"                                         `bbbbbbbb+lb    Z   bbbbbbbbL                         {dbbbbbbbbbp     bbbbbbbbbbb)                                        ",0
schoolbk12	byte	"                                        bbbbbbbbbbbbbb)m  pbbbbb,      8$$$$$$$$$$$$$$$$$$$$$&      ^bbbbbqwbbb ubbbbbbbbbbbbc                                      ",0
schoolbk13	byte	"                                     'bbbbbbbbbbbbbbbb  I  dl    u$$$$$$$$$$$$$$$$$$$$$$$$$$$$$Z $$k    Ibbbbbbl Qbbbbbbbbbbbbb;                                    ",0
schoolbk14	byte	"                                    bbbbbbbbbbbbbbbbbb}pb.  .Y$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ $C )$$$$$$J    bbbb  ^bbbbbbbbbbbbbb                                   ",0
schoolbk15	byte	"                                  1bbb     bbbbbbbbbbb_   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ wn % &$$$$$$$$$$$    dbbbbbbbbbbbbbbn jbO                                 ",0
schoolbk16	byte	"                                 bbbbbb   nbb)bbbbbb   ($$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ p$ U$  ##$$$$$$$$$$$$$$   bbbbbbbbb      I _b                                ",0
schoolbk17	byte	"                                bbbd   bz     \bbb   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$} p$ .)$$>w$$$$$$$$$$$$$$$$   pbbbbb b  >      qf                              ",0
schoolbk18	byte	"                              `bbbbbb    bb  bbb   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$   $$   $    $$$$$$$$$$$$$$$$$$$$   bbbbb   .    bbbbm                             ",0
schoolbk19	byte	"                             dbbbbbbb     bbbb  .$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$Z    Yk   $$$$$$$$$$$$$$$$$$$$$$$$$$   b   X  bbj'bbbbbb                            ",0
schoolbk20	byte	"                            0bbbbbbbbbbq Qbbb  w$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     $$$adW$$$$$$$$$$$$$$$$$$$$$$$$$$$  }bbbbbbbbbbbbbbbb                           ",0
schoolbk21	byte	"                           pbbbbbbbbbbb  bb.  $$$$$$$$$$$$  !$$$$$$$$$$$$$$$$$$$     $$$$$$$$$$$$$$$$$$(   $$$$$$$$$$$$'  bbbbbbbbbbbbbbbb                          ",0
schoolbk22	byte	"                          Qbbbbbbbbbbbbbbb. u$$$$$$$$$$$$$n         ivp$$$$$$$$$     $$$$$$$ovu'          $$$$$$$$$$$$$$$  bbbbbbbbbbbbbbbb                         ",0
schoolbk23	byte	"                         Zbbbbbbbbbbbbbbb .$$$$$$$$$$$$$$$$^                                             $$$$$$$$$$$$$$$$$  ubbbbbbbbbbbbbb0                        ",0
schoolbk24	byte	"                         bbbbbbbbbbbbbbb  $$$$$$$$$$$$$$$$$$$                                          -$$$$$$$$$$$$$$$$$$$  ]bbbbbbbbbbbbbb~                       ",0
schoolbk25	byte	"                        bbbbbbbbbbbbbbb  $$$$$$$$$$$$$$$$$$$$$$$Y                                  ^$$$$$$$$$$$$$$$$$$$$$$$$  !bbbbbbbbbbbbbb.                      ",0
schoolbk26	byte	"                       0bbbbbbbbbbbbbw  $$$$$$$$$$$$$$$$$$$$$$$$$_                                 $$$$$$$$$$$$$$$$$$$$$$$$$$  vbbbbbbbbbbbbbb                      ",0
schoolbk27	byte	"                       bbbbbbbbbbbbbb  $$$$$$$$$$$$$$$.  +J$$$$$$$n                               $$$$$$Z+     $$$$$$$$$$$$$$$. bbbbbbbbbbbbbbJ                     ",0
schoolbk28	byte	"                      bbbbbbbbbbbbbb^ $$$$$$$$$$$$$$$$$            M$C\/                     Q0$$<            $$$$$$$$$$$$$$$$$  bbbbbbbbbbbbbb                     ",0
schoolbk29	byte	"                      bbbbbbbbbbbbbw !$$$$$$$$$$$$$$$$$$               .$.                 `$               .$$$$$$$$$$$$$$$$$$[ `bbbbbbbbbbbbb?                    ",0
schoolbk30	byte	"                     bbbbbbbbbbbbbb  $$$$$$$$$$$$$$$$$$$$                  ]0c$       $000.                M$$$$$$$$$$$$$$$$$$$$. mbbbbbbbbbbbbb                    ",0
schoolbk31	byte	"                    'bbbbbbbbbbbbbj  $$$$$$$$$$$$$$$$$$$$$$                  ^.        t                  $$$$$$$$$$$$$$$$$$$$$$0  bbbbbbbbbbbbbv                   ",0
schoolbk32	byte	"                    Cbbbbbbbbbbbbb  $$$$$$$$$$$$$$$$$$$$$$$$$                $         $                $$$$$$$$$$$$$$$$$$$$$$$$$  bbbbbbbbbbbbbb                   ",0
schoolbk33	byte	"                    bbbbbbbbbbbbbZ .$$$$$$$$$$$$$$`````````^,;>_             \:l+jCd%$$$              \^```````````$$$$$$$$$$$$$$: +bbbbbbbbbbbbb                   ",0
schoolbk34	byte	"                    bbbbbbbbbbbbb\ p$$$$$$$$$$$$$$$x```````````````'                              '``````````````B$$$$$$$$$$$$$$$@  bbbbbbbbbbbbb                   ",0
schoolbk35	byte	"                    bbbbbbbbbbbbb  $$$$$$$$$$$$$$$$$$'```````````````````''               '''``````````````````Y$$$$$$$$$$$$$$$$$$  bbbbbbbbbbbbbL                  ",0
schoolbk36	byte	"                    bbbbbbbbbbbbb  $$$$$$$$$$$$$$$$$$$$``````````````````````'          `````````````````````C$$$$$$$$$$$$$$$$$$$$  pbbbbbbbbbbbbm                  ",0
schoolbk37	byte	"                   .bbbbbbbbbbbbb  $$$$$$$$$$$$$$$$$$$$$$m'``````````````````           ``````````````````^$$$$$$$$$$$$$$$$$$$$$$$I qbb|.JbbbbbbbZ                  ",0
schoolbk38	byte	"                   >bbbb`bb bdLbb  $$$$$$$$$$$&$$$$$$$$$$$$$$;```````````````           .`````````````'\@$$$$$$$$$@W#Y-k$$$$$$$$$$! qbbbbb    bbbq                  ",0
schoolbk39	byte	"                   `bbbb'bm b'Lbb  $$$$$$$$$$$@___________________````````````````````````````````l___________________$$$$$$$$$$$$! qbb; bbbbbbbbw                  ",0
schoolbk40	byte	"                    bbbbp -bfdbbb  $$$$$$$$$$$$$n_________________________<''``````````';~+_________________________o$$$$$$$$$$$$$, qbbbbbbbbbbbbO                  ",0
schoolbk41	byte	"                    bbbbbbbw!Ibbb  $$$$$$$$$$$$$$$%___________________________`````````._________________________|$$$$$$$$$$$$$$$$  bbb.bb bJ.bbbb                  ",0
schoolbk42	byte	"                    bbbnbbJYb bbb  $$$$$$$$$$$$$$$$$$$Q______________________.``````````-____________________-$$$$$$$$$$$$$$$$$$$$  bbb'bbbbb bbb^                  ",0
schoolbk43	byte	"                    bbbb\bq bnQbb? :$$$$$$$$$$$$$$$$$$$$$$$Q_________________```````````<_______________Y$$$$$$$$$$$$$$$$$$$$$$$$8 \bbb' Xb) bbbb                   ",0
schoolbk44	byte	"                    bbbb bbbbbbbbb  $$$$$$$??????}fXQppppppppppZCX{-________:\'''''''''\:________-????????????????????????$$$$$$$  bbbbbvCbbbbbbb                   ",0
schoolbk45	byte	"                    fbbbbqQ    bbb  M$$$$$$$b?????????????????????????????????__________????????????????????????????????|$$$$$$$$  bbb.bbbb.bbbbc                   ",0
schoolbk46	byte	"                     bbbbbbbbbbbbbb  $$$$$$$$$???????????????????????????????___________???????????????????????????????$$$$$$$$$  Ibbt}bbbbu>bbb                    ",0
schoolbk47	byte	"                     bbbb bbbbbbbbb  $$$$$$$$$$$$ku??????????????????????????___________-????????????????????????}m$$$$$$$$$$$$$  bbbbl.mb) bbbb                    ",0
schoolbk48	byte	"                      bbbU   }bbbbbb  $$$$$$$$$$$$$$$$$$$$%z}???????????????-____________????????????????v#$$$$$$$$$$$$$$$$$$$$  bbbbbbbbbbbbbb]                    ",0
schoolbk49	byte	"                      ZbbbbbbbC  bbbb  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$of}?????-_________-?????|z%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$x !bbbbbbbbb}bbbb                     ",0
schoolbk50	byte	"                       bbb  ^bbbbZbbb  ~$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$O??????????$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$d  bbbQ  dbbb bbb                      ",0
schoolbk51	byte	"                       `bbbbbL  /nbbbb  r$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$???????????W$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  bbbbd_bbd^ bbbQ                      ",0
schoolbk52	byte	"                        CbbbObb.-bbbbbb  &$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$???????????}$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  bbbp bbbf bbbbb                       ",0
schoolbk53	byte	"                         bbbbb.qm  mbbbb  j$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$r????????????$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ .bbbb mbbbb:bbbb                        ",0
schoolbk54	byte	"                          bbb. 0bc   bbbb' .$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$n????????????$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$)  bbbdbb |bbC.bbb                         ",0
schoolbk55	byte	"                           bbbbb.bbbb{(bbbv  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  .bbbbbb )bbbbbbbl                         ",0
schoolbk56	byte	"                            bbbb bY`bJ bbbbb  /$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$t?$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$B  bbbbJYYUJO' bbbb}                          ",0
schoolbk57	byte	"                             bbbJ b) bbbbbbbb.  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$??$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$.  bbbbbb'<bbbbbbbb\                           ",0
schoolbk58	byte	"                              bbbbbbbbbbbbbbbbb   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$??$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$   bbbbbb! bbn bbbbb                             ",0
schoolbk59	byte	"                               bbbbbbbbbbb Xbbbbb   $$$$$$$$$$$$$$$$$$$$$$$$$$????????d$$$$$$$$$$$$$$$$$$$$$$$$$$^  bbbbbbbb( x dbbbbb                              ",0
schoolbk60	byte	"                                Obbbbbbb.tbb  bbbbb   $$$$$$$$$$$$$$$$$$$$}??????????????nB$$$$$$$$$$$$$$$$$$$$   mbbbbbbb. bbbbZbbbb                               ",0
schoolbk61	byte	"                                  bbbb  bb1 bcbbbbbbb   i$$$$$$$$$$$$$$B????<?+??-?\'??!?'??Q$$$$$$$$$$$$$$$|   bbbbb Qbbbbb Qbbbbb                                 ",0
schoolbk62	byte	"                                   mbbbbb.bb bb mbbbbbbq   }$$$$$$$$$B??????<???_?+;.<? ?`???????&$$$$$$$Z.  \bbbbbbb~bbbb>bbbbbbb                                  ",0
schoolbk63	byte	"                                     bbbbbbb  [bb b\ bbbbbv    U??zqmmwOmmwY??fkh*8B$$B{1z$$$$$$$m??dW    ?bbbbb_ bbb' bbb bbbbb                                    ",0
schoolbk64	byte	"                                       bbbbb bb'b nb b .bbbbbb`     -@$q$?$$$$$??X1]Qk$$$$$?$n\b$c    `bbbbbbmC bbd Ubbt,bbbbbm                                     ",0
schoolbk65	byte	"                                        'bbbbbb bb/'bbbb  'bbbbbbbC      ..8$$$X???]?$$$$$.       cbbbbbbb~  bbb  bbbXfbbbbbY                                       ",0
schoolbk66	byte	"                                          'bbbbbf  bbbb bbbj.b\bbbbbbbbbZx                 [0bbbbbbbbbbbbbbbf'bbb;, ]bbbbbJ                                         ",0
schoolbk67	byte	"                                             bbbbbbbbb bbbb bbb,c\ ZYbbbbbbbbbbbbbbbbbbbbbbbbbbbb+ .Obbbbbbbbj.bbbbbbbbbx                                           ",0
schoolbk68	byte	"                                               Jbbbbbbbbbb bbbb bbb bbbb b  .1dbbbbbbbbbbbb jU ;b bbc<bbbbbbbb-bbbbbbq                                              ",0
schoolbk69	byte	"                                                  pbbbbbbbdbbb bbbd bbb bbbb bbb.bbbbbbbbb bbbbv`b bbbbbbbbbbbbbbbb                                                 ",0
schoolbk70	byte	"                                                     wbbbbbbbd}bbbq bbb bbb.YbbX    mbbbbb bbbbr b'Cbbbbbbbbbbbq                                                    ",0
schoolbk71	byte	"                                                         bbbbbbbbbbb;,;bbbb bbb1+bbbbbbbbbb.   Zbbbbbbbbbbbb^                                                       ",0
schoolbk72	byte	"                                                            >pbbbbbbbbbbbbbbbbbbddddQbbbbbbbbbbbbbbbbbbdb                                                           ",0
schoolbk73	byte	"                                                                  mpbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbU                                                                 ",0
schoolbk74	byte	"                                                                           'qqXQdbbbbOX0b\                                                                          ",0
schoolbk75	byte	"                                                                                                                                                                    ",0
schoolbk76	byte	"                                                                                                                                                                    ",0
schoolbk77	byte	"                                                                                                                                                                    ",0
schoolbk78	byte	"                                                                                                                                             $$  $1                 ",0
schoolbk79	byte	"                                                  $$$$$                                                                                 $ $ $$' $$$                 ",0
schoolbk80	byte	"                                                   $$$  $B                       ?                                    $$                $B$  $$$$$                  ",0
schoolbk81	byte	"                      $$$$   $$$$$               $@$$$$$$$$           @$$  $$$$$$$$$                $$$$             $$$$               $ $$$$ $$                   ",0
schoolbk82	byte	"                      $$$$   $$$$          $$$$$$$$$$             $$$$$$q$$$v$# $$$           $$$$$$$$$$             $$$$$$$$         & $  .$$$$$$$$                ",0
schoolbk83	byte	"                      $$$$   $$$$$$$        $      $$$$$          $$$$$  $$$$$Q$$$            $$$$$$$           0$$$$$$$$$           $$$$$   $@$$$$$                ",0
schoolbk84	byte	"                  $$$$$$$8  B$$$$%             $$$$Yn$$$            $$$  $$$$$$$$               @$$$             %$ $$$$             $$$ $$$$$$                     ",0
schoolbk85	byte	"                  $$$$$$$@  $$$$               $$$$$$$@           $$$$$$  $$$$BB                $$$$               $$$$$$                  $$$M$                    ",0
schoolbk86	byte	"                     $$$$$  $$$$               $$$$$$$            @$$$    |$$$$$$            l$$$$$$$$$$$$        $$$   $$$            @&$$$$$$$$                   ",0
schoolbk87	byte	"                    $$$$$   $$$$$$$$              $$$ $$$$$       $$$$$$   $$$$          $$$$$$$$$$$$$$$$$     $$$$L      $$$$         $$$$$$$                      ",0
schoolbk88	byte	"                 $$$$$$      $$$$$$$        $$$$  $$$  $$B      $$$$$%  $$$$$$$$$$$      $$$                   $W          $$$$$@          $$$                      ",0
schoolbk89	byte	"                 $$$                        $$  $$$$             $#     &pq                                                              $$$$                       ",0
schoolbk90	byte	"                                                  %                                                                                                                 ",0
schoolbk91	byte	"                                                                                                                                                                    ",0
schoolbk92	byte	"                                                                                                                                                                    ",0
