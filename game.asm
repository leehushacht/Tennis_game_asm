IDEAL
MODEL small

STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------


	stopison db,0
	controlerloop db 0

	x dw ?
	y dw ?
	color1 db ?
	lenth dw ?
	highet dw ?
	;;;;;;;;gamecontrol
	player1wins dw 0
	player2wins dw 0
	msgplayer1wins db "p1 wins:$ "
	msgplayer2wins db "p2 wins:$ "
	
	
	isneedtogohome db 0
	
	
	
	whichline db 1;;control on which line to call
	
	gotspace db 0
	
	serve db 0
	whoserving db 0
	
	changespeedp2 db 1
	changespeed db 4;;משתנה לבדיקה מתי להגביר מהירות
	fory dw 0
	
	rnd1 db 1,2,5     ;;;;מגריל איזה מסלולי כדור כל האפשרויות שאפשר לבצע
	rnd2 db 1,4,5
	rnd3 db 1,4,3
	
	isbackhome db 0 
	isagain db 0
	escapebottom db 0
	exitmsg db "Exit$"
	
	forcross db 0
	turn db 0
	ballspeed dw 3
	whichcourt db 1;;;;1-usopen 2-wimbledon 3-rolland garros
	
	afterhit db 0
	
	game1v1on db 0
	game2v2on db 0
	;;;;;;;;gamecontrol
	forrestor db 0
	
	line4placetobe db 0
	line5placetobe db 0
	drawthem db 0 
;;;;;;;;position data	
	p1x dw ?
	p1y dw 60

	p2x dw ?
	p2y dw 110
	
	ballx dw 35
	bally dw 95
;;;;;;;;position data

;;;;;;;;;;;;;;;ran 1 or 2
	p1ran db 0
	p2ran db 0
;;;;;;;;;;;;;;;ran 1 or 2
	swOarrow db 2
;;;;;;;;score
	score1 db 0
	score2 db 0
	
	needtoprint db 0
	hitnow dw 0
	MaxHit dw 0;השמות הפוכים ביני לבין מי שמעלי
	maxmsg db "You Hit:$"
	maxscoremsg db "max Hit:$"
;;;;;;;;score
	twenty db "15%$"
	fourty db "42%$"
	seventy db "68%$"
	hundred db "100%$"
;;;;;;;;files
	courtplayerchoose db "choose court$"
	isplayerchose db 0
	
	playbottum db "plag.bmp",0

	onel db "oneload.bmp",0
	twol db "twoload.bmp",0
	threel db "load3.bmp",0
	fourl db "loadlast.bmp",0

	zero db "zero.bmp",0
	one db "one.bmp",0
	two db "two.bmp",0
	three db "three.bmp",0
	four db "four.bmp",0
	five db "five.bmp",0
	six db "six.bmp",0
	seven db "seven.bmp",0
	eight db "eight.bmp",0
	nine db "nine.bmp",0
	ten db "ten.bmp",0
	
	ran1p1 db "ran1p1.bmp",0
	ran2p1 db "ran2p1.bmp",0
	ran1p2 db "ran1p2.bmp",0
	ran2p2 db "ran2p2.bmp",0

	hscreen db "hom.bmp",0
	ball db "pingpong.bmp",0
	fireball1 db "bestball.bmp",0
	fireball2 db "esh.bmp",0
	
	hemarchoose db "xlxl.bmp",0
	greenchoose db "glgl.bmp",0
	bluechoose db "blbl.bmp",0
	bluesmaller db "yoy.bmp",0
	decide db "decide.bmp",0
	vvv db "vvv.bmp",0
	
	
	court db "court20.bmp",0
	court32 db "wimi.bmp",0
	yarok db "yarok.bmp",0

	court2 db "court10.bmp",0
	hemar db "hemar.bmp",0

	court3 db "court21.bmp",0
	asfalt db "asfalt.bmp",0

	player1 db "player10.bmp",0
	player2 db "player9.bmp",0
	
	massage db "alarm.bmp",0
	stop db "wait.bmp",0
	
	win1 db "win1.bmp",0
	win2 db "wintwo.bmp",0

	train db "train.bmp",0
	
	formenu db "formenu.bmp",0
	menu db "howplay.bmp",0
	showmenu db 0
;;;;;;;;files
	

	savep2yforrestore dw 110
	savep1yforrestore dw 110
	backp2 db 961 dup(0)
	backp1 db 961 dup(0)
	
	courtBuffer db 51200 dup(0)
	timetorestorecourt db 0
	
	timetorestore db 0
	timetorestore2 db 0
	
	
	saveballyforrestore dw 35
	saveballxforrestore dw 95
	
	BackgroundBuffer db 81 dup(0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	ScrLine 	db 324 dup (0)  ; One Color line read buffer
	ErrorFile           db 0

	FileHandle dw ?
	BmpColSize dw ?
	BmpLeft dw ?
	BmpRowSize dw ?
	BmpTop dw ?
	Header 	    db 54 dup(0)
	Palette 	db 400h dup (0)
	RndCurrentPos dw start

CODESEG	
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
	mov ax,13h
	int 10h


	call drawhomescreen
	call loading

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

	mov ax,1
	int 33h
	push cs
	pop es
	mov ax,0ch
	mov cx ,2
	mov dx, offset checkrishum;נרשמים ללחיצת מקש שמאלי בעכבר
	int 33h
mainscreendraw:
	mov ax,1
	int 33h
	mov [isneedtogohome],0;משתנים אלה חייבים להיות מאופסים בהתחלה למקרה שחוזרים למקום זה
	mov [isbackhome],0
	mov [isagain],0
	mov [stopison],0
	mov [showmenu],0
	call drawmainscreen
mainscreen:
	cmp [escapebottom],1;יוצאים ממשחק בקליק על יציאה
	je lplp
	cmp [showmenu],1;רואים הוראות משחק בלחיצה על תפריט ונשארים שם עד שמקליק על איקס
	je howtoplay
	cmp [game1v1on],1;אם נבחר משחק 2 שחקנים
	je game1v1
	cmp [game2v2on],1;אם נבחר משחק שחקן 1
	je gmae22
	jmp mainscreen
howtoplay:
	mov ax,2
	int 33h
	mov [BmpLeft],0
	mov [BmpTop],0
	mov [BmpRowSize],200
	mov [BmpColSize],320
	mov dx, offset menu
	call OpenShowBmp;הוראות
	mov ax,1
	int 33h
	mov [isplayerchose],0
secondloop:	
	cmp [showmenu],0
	je mainscreendraw	
	jmp secondloop;far
lplp:
	jmp close
gmae22:
	jmp game2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





game1v1:;משחק 2 שחקנים
;-------------------------------------------------------------
	call emptyKeyBoard
	call ClearScreen
	mov ax,2
	int 33h
	;מדפיס הכל למשחק 1 על 1 ומכין הכל לפני
	call basecourtback
	call drawcourt
	call SaveUnderPlayer1
	call SaveUnderPlayer2
	call forran
	call realtimescore
	
mainloop:	


waitforpress:;מחכה ללחיצה 
	inc [controlerloop]

	call LoopDelay01Sec;דיליי

	cmp [gotspace],0;כל עוד לא נלחץ אנטר לא מתחילים נקודה
	je nostart
	call realtimescore;תוצאה בזמן אמת של 2 שחקנים
	mov [afterhit],0
	test [controlerloop],1
	jz dilug
	call chooseline ;מזיז כדור
dilug:
	call checkhit;בודק אם יש חבטה או שנגמרה הנקודה
	cmp [isneedtogohome],1;משתנה זה מחליט אם לחזור למסך בית(ראו בהמשך)
	je colcol
nostart:
	jmp locloc
colcol:
	jmp mainscreendraw
locloc:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;arrows - תזוזה למעלה למטה
;----------------------------------------------------------------------

	mov ah,1
	int 16h
	
	jz waitforpress
	mov ah,0
	int 16h
	cmp [gotspace],1;אם נלחץ אנטר אפשר לזוז
	je arrows
	cmp ah,1ch;בדיקת מקש אנטר
	je startpoint
	jmp waitforpress
startpoint:
	mov [gotspace],1
arrows:
	cmp ah,50h;שחקן 1 למטה
	je moveclose123
	cmp ah,48h;שחקן 1 למעלה
	je moveclose12
	
	cmp ah,11h;שחקן 2 למעלה
	je moveclose1
	cmp ah,1fh;שחקן 2 למטה
	je moveclose
	cmp ah,39h
	je stop1;אם נלחץ רווח בזמן משחק המשחק נעצר וניתן להשתמש בעכבר
	jmp close1
moveclose123:
	mov [swOarrow],0;משפיע על איזה שחקן יש לצייר עושה צעד לפי מי שזז
	jmp movedown2
moveclose12:
	mov [swOarrow],0;משפיע על איזה שחקן יש לצייר עושה צעד לפי מי שזז
	jmp moveup2
moveclose1:
	mov [swOarrow],1;משפיע על איזה שחקן יש לצייר עושה צעד לפי מי שזז
	jmp moveup1
moveclose:
	mov [swOarrow],1;משפיע על איזה שחקן יש לצייר עושה צעד לפי מי שזז
	jmp movedown1
close:
	call emptyKeyBoard
	
	jmp outofloop
stop1:
	mov [BmpLeft],0
	mov [BmpTop],0
	mov [BmpRowSize],200
	mov [BmpColSize],320
	mov dx, offset stop
	call OpenShowBmp;מסך עצירה
	mov ax,1
	int 33h
	mov [stopison],1;משתנים המכריזים על מצב 
	mov [isbackhome],1;משתנים המכריזים על מצב
	mov [isagain],1;משתנים המכריזים על מצב
stoplop:
	cmp [stopison],0;אם נלחץ המשך משחק
	je bclose1
	cmp [isbackhome],0;אם נלחץ חזור למסך בית
	je mainscreendraw1
	cmp [isagain],0;אם נלחץ משחק חוזר
	je restartgame
	mov ah,1
	int 16h
	jz stoplop
	mov ah,0
	int 16h
	cmp ah,39h
	jne stoplop
	mov [stopison],0
	mov ax,2
	int 33h
	call ClearScreen	
	call basecourtback
	mov [swOarrow],2
	call forran
	call realtimescore
	call chooseline
	mov ax,1
	int 33h
	jmp bclose1
	;jmp stoplop222
restartgame:
	mov [isbackhome],0
	mov [stopison],0
	jmp game1v1
mainscreendraw1:
	mov [isagain],0
	mov ax,2
	int 33h
	jmp mainscreendraw
bclose1:;;;;;;;;;;;;;;;;;;;;
	call emptyKeyBoard
	mov ax,2
	int 33h
close1:
	jmp waitforpress
movedown2:;מזיז מיקום שחקן 2 למטה
	mov [afterhit],1
	inc [p2ran]
	cmp [p2y],140
	ja drawall
	add [p2y],10
	jmp drawall
moveup2:;מזיז מיקום שחקן 2 למעלה
	mov [afterhit],1
	inc [p2ran]
	cmp [p2y],30
	jb drawall
	sub [p2y],10
	jmp drawall
moveup1:;מזיז מיקום שחקן 1 למעלה
	mov [afterhit],1
	inc [p1ran]
	cmp [p1y],30
	jb drawall
	sub [p1y],10
	jmp drawall
movedown1:;מזיז מיקום שחקן 1 למטה
	mov [afterhit],1
	inc [p1ran]
	cmp [p1y],140
	ja drawall
	add [p1y],10
	jmp drawall
;----------------------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;arrows - תזוזה למעלה למטה
drawall:
	cmp [afterhit],0;אם הייתה חבטה לא לצייר שחקן עושה צעד כי הרגע צויר שחקן חובט ואנחנו לא רוצים לצייר מעליו ישר
	je notnot
	call forran
notnot:
	
	jmp mainloop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-------------------------------------------------------------
outofloop:
	jmp outofloop222
	
	
	
	
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
game2:	;משחק שחקן יחיד
;-------------------------------------------------------------
	;מכין הכל לפני כניסה ללולאת המשחק - מצייר מה שצריך ושומר מה שצריך
	call emptyKeyBoard
	call ClearScreen
	mov ax,2
	int 33h
	call basecourtback
	call drawcourt
	call SaveUnderPlayer1 
	call SaveUnderPlayer2
	call forran
	call realtimemaxhit;ניקוד של כמות חבטות
mainloop222:	


waitforpress222:
	inc [controlerloop]

	call LoopDelay01Sec

	cmp [gotspace],0;אם לא נלחץ אנטר לא מתחילים נקודה
	je nostart222
	call realtimemaxhit;ניקוד של כמות חבטות

	mov [afterhit],0
	test [controlerloop],1;בודק אם זה הזמן להזיז כדור
	jz dilug222
	call chooseline;מזיז כדור
dilug222:
	call checkhit;בודק אם הייתה חבטה או שנגמר נקודה ופועל בהתאם
	cmp [isneedtogohome],1;משתנה המצביע אם לחזור למסך הבית - בדומה למשחק של 2 שחקנים
	je mainscreendraw11
	jmp nostart222
mainscreendraw11:
	jmp mainscreendraw
nostart222:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;arrows - תזוזה למעלה למטה
;----------------------------------------------------------------------

	test [controlerloop],7;בודק אם זה הזמן למחשב להזיז את השחקן שלו
	jnz noforan
	call forcomputerplace;המחשב מזיז את השחקן שלו בהתאם לתנאים
	cmp [drawthem],1;אם המחשב זז אז המשתנה יכיל אחד ויצייר את השחקן עושה צעד
	jne noforan
	mov [swOarrow],1
	call forran;לבדוק מתי לצייר ומתי לא ליין 1!! לבדוק מיקומים לא נכונים זיהוי
	
noforan:
	mov ah,1
	int 16h
	jz waitforpress222
	mov ah,0
	int 16h
	cmp [gotspace],1;אם נלחץ אנטר ניתן לזוז
	je arrows222
	cmp ah,1ch;בדיקת מקש אנטר
	je startpoint222
	jmp waitforpress222
startpoint222:
	mov [gotspace],1
arrows222:
	cmp ah,50h;שחקן 1 למטה
	je moveclose123222
	cmp ah,48h;שחקן 1 למעלה
	je moveclose12222
	cmp ah,39h;אם נלחץ רווח משחק עוצר ועכבר שב לפעולה במסך עצירה
	je stop1222
	jmp close1222
moveclose123222:
	mov [swOarrow],0;משפיע על איזה שחקן יש לצייר עושה צעד לפי מי שזז
	jmp movedown2222
moveclose12222:
	mov [swOarrow],0;משפיע על איזה שחקן יש לצייר עושה צעד לפי מי שזז
	jmp moveup2222


close222:
	jmp outofloop222
stop1222:
	mov [BmpLeft],0
	mov [BmpTop],0
	mov [BmpRowSize],200
	mov [BmpColSize],320
	mov dx, offset stop
	call OpenShowBmp;מסך עצירה
	mov ax,1
	int 33h
	mov [stopison],1;משתנים המכריזים על מצב 
	mov [isbackhome],1;משתנים המכריזים על מצב 
	mov [isagain],1;משתנים המכריזים על מצב 
stoplop222:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	cmp [stopison],0;אם נלחץ להמשיך משחק
	je bclose1222
	cmp [isbackhome],0;אם לחזור למסך בית
	je mainscreendraw1222
	cmp [isagain],0;אם נלחץ משחק חוזר
	je restartgame222
	mov ah,1
	int 16h
	jz stoplop222
	mov ah,0
	int 16h
	cmp ah,39h
	jne stoplop222
	mov [stopison],0
	mov ax,2
	int 33h
	call ClearScreen	
	call basecourtback
	mov [swOarrow],2
	call forran
	call realtimescore
	call chooseline
	mov ax,1
	int 33h
	jmp bclose1222
restartgame222:
	mov [isbackhome],0
	mov [stopison],0
	jmp game2
mainscreendraw1222:
	mov [isagain],0
	mov ax,2
	int 33h
	jmp mainscreendraw
bclose1222:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	call emptyKeyBoard
	mov ax,2
	int 33h
close1222:
	jmp waitforpress222
movedown2222:;מזיז מיקום שחקן לטה
	mov [afterhit],1
	inc [p2ran]
	cmp [p2y],140
	ja drawall222
	add [p2y],10
	jmp drawall222
moveup2222:;מזיז מיקום שחקן למעלה
	mov [afterhit],1
	inc [p2ran]
	cmp [p2y],30
	jb drawall222
	sub [p2y],10
	jmp drawall222


;----------------------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;arrows - תזוזה למעלה למטה
drawall222:
	cmp [afterhit],0;בודק אם שחקן בדיוק חבט כדי שלא נצייר ישר אחרי
	je notnot222
	call forran;מצייר שחקן אשר עשה צעד
notnot222:
	
	jmp mainloop222
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-------------------------------------------------------------
outofloop222:
	mov ax,2
	int 10h
	
exit:

	mov ax, 4c00h
	int 21h
;---------------------------------------------------------------------------------------------------
;מזיז את דמות המחשב תזוזה אחת למעלה או למטה לפי מסלול הכדור, אם הוא כבר נמצא במקום הנכון הוא נשאר במקום
;----------------------------------------------------------------------------------------------------
proc forcomputerplace
	mov [drawthem],0
	test [turn],1;אם תור שחקן דלג
	jz playerturnclose
	;בודק מסלולי כדור כדי שהמחשב ידע לאן עליו להגיע
	cmp [whichline],1
	je line11
	cmp [whichline],2
	je lin22close
	cmp [whichline],3
	je lin33close
	cmp [whichline],4
	je lin44close
	jmp line55
lin22close:
	jmp line22
lin44close:
	jmp line44
lin33close:
	jmp line33
line11:
	;בודקים מאיפה יוצא הכדור למסלול 1 כדי שנדע היכן מסיים
	;בהתאם לזה החמחשב בחליט לאן לזוז או אם בכלל להשאר במקומו
	cmp [bally],130
	jb  middle1
	cmp [p1y],130
	je playerturnclose
	jb subb111
	sub [p1y],10
	mov [drawthem],1

	jmp playerturnclose
subb111:
	add [p1y],10
	mov [drawthem],1
	jmp playerturnclose
middle1:
	cmp [bally],60
	ja  middle11
	cmp [p1y],40
	je playerturnclose
	jb subb1
	sub [p1y],10
	mov [drawthem],1
	jmp playerturnclose
subb1:
	add [p1y],10
	mov [drawthem],1
	jmp playerturnclose
playerturnclose:
	jmp playerturn
middle11:		
	cmp [p1y],80
	je playerturnclose
	jb subb11
	sub [p1y],10
	mov [drawthem],1
	jmp playerturnclose
subb11:
	add [p1y],10
	mov [drawthem],1
	jmp playerturnclose
		
		
line22:
	;מסלול 2 הוא קבוע לכן יודעים היכן מסתיים והמחשב יודע לאן לזוז 
	cmp [p1y],130
	je playerturnclose
	jb subb2
	sub [p1y],10
	mov [drawthem],1
	jmp playerturnclose
subb2:
	add [p1y],10
	mov [drawthem],1
	jmp playerturnclose
line33:
	cmp [p1y],40
	je playerturnclose
	ja addd3
	add [p1y],10
	mov [drawthem],1
	jmp playerturn
addd3:
	;מסלול 3 הוא קבוע לכן יודעים היכן מסתיים והמחשב יודע לאן לזוז 

	sub [p1y],10
	mov [drawthem],1
	jmp playerturn;
line44:;חצי למעלה
	;בודקים מאיפה יוצא הכדור למסלול 4 כדי שנדע היכן מסיים
	;בהתאם לזה החמחשב בחליט לאן לזוז או אם בכלל להשאר במקומו
	cmp [line4placetobe],1
	je downn
	cmp [p1y],80
	je playerturnclose
	ja addd4
	add [p1y],10
	mov [drawthem],1
	jmp playerturn
addd4:
	sub [p1y],10
	mov [drawthem],1
	jmp playerturn
downn:
	cmp [p1y],40
	je playerturn
	ja addd44
	add [p1y],10
	mov [drawthem],1
	jmp playerturn
addd44:
	sub [p1y],10
	mov [drawthem],1
	jmp playerturn
line55:;חצי למטה
	;בודקים מאיפה יוצא הכדור למסלול 5 כדי שנדע היכן מסיים
	;בהתאם לזה החמחשב בחליט לאן לזוז או אם בכלל להשאר במקומו
	cmp [line5placetobe],1
	je downnn
	cmp [p1y],80
	je playerturn
	ja addd444
	add [p1y],10
	mov [drawthem],1
	jmp playerturn
addd444:
	sub [p1y],10
	mov [drawthem],1
	jmp playerturn
downnn:
	cmp [p1y],130
	je playerturn
	ja addd44444
	add [p1y],10
	mov [drawthem],1
	jmp playerturn
addd44444:
	sub [p1y],10
	mov [drawthem],1
	jmp playerturn
playerturn:
	cmp [drawthem],1
	jne @@sof
	inc [p1ran]
@@sof:
	ret
endp forcomputerplace
;---------------------------------------------------------------------------------------------------
;מצייר מסך בית כללי
;---------------------------------------------------------------------------------------------------
proc drawmainscreen
	mov ax,2
	int 33h
	mov [BmpLeft],0
	mov [BmpTop],0
	mov [BmpRowSize],200
	mov [BmpColSize],320
	mov dx, offset bluechoose
	call OpenShowBmp
	push 200
	push 0
	push 0
	push 320
	push 3
	call DrawRect
	push 198
	push 1
	push 1
	push 318
	push 0
	call DrawRect
	push 196
	push 2
	push 2
	push 316
	push 3
	call DrawRect
	mov [BmpLeft],141
	mov [BmpTop],90
	mov [BmpRowSize],20
	mov [BmpColSize],37
	mov dx, offset playbottum
	call OpenShowBmp

	mov [BmpLeft],141
	mov [BmpTop],65
	mov [BmpRowSize],20
	mov [BmpColSize],37
	mov dx, offset train
	call OpenShowBmp
;--------------------------------------------------------------
	mov [BmpLeft],5
	mov [BmpTop],100
	mov [BmpRowSize],18
	mov [BmpColSize],63
	mov dx, offset decide
	call OpenShowBmp
	call drawcourtchoose
	call drawresults
;--------------------------------------------------------------
	mov [lenth],42
	mov [highet],19
	mov [x],2;
	mov [y],2
	mov [color1],0
	call DrawFullRect
	push 19
	push 2
	push 2
	push 42
	push 3
	call DrawRect
	push 15
	push 4
	push 4
	push 38
	push 3
	call DrawRect
	mov ah, 2      ; שירות 02h של INT 10h – הזזת הסמן
	mov bh, 0   
	mov dh, 1      ; מספר שורה 
	mov dl, 1     ; מספר עמודה 
	int 10h   
	mov dx,offset exitmsg
	mov ah,9
	int 21h
	mov [BmpLeft],306
	mov [BmpTop],2
	mov [BmpRowSize],12
	mov [BmpColSize],11
	mov dx, offset formenu
	call OpenShowBmp
	
	mov ax,1
	int 33h
	ret
endp drawmainscreen
;---------------------------------------------------------------------------------------------------
;מצייר תוצאות וניקוד עד עכשיו על מסך הבית
;---------------------------------------------------------------------------------------------------
proc drawresults
	mov [lenth],90
	mov [highet],24
	mov [x],227
	mov [y],92
	mov [color1],0
	call DrawFullRect
	push 24
	push 227
	push 92
	push 90
	push 3
	call DrawRect
	push 20
	push 229
	push 94
	push 86
	push 3
	call DrawRect
	mov ah, 2      ; שירות 02h של INT 10h – הזזת הסמן
	mov bh, 0    
	mov dh, 12      ; מספר שורה 
	mov dl, 29     ; מספר עמודה 
	int 10h 
	mov dx, offset msgplayer1wins
	mov ah,9
	int 21h
	mov ax,[player1wins]
	call ShowAxDecimal
	mov ah, 2      ; שירות 02h של INT 10h – הזזת הסמן
	mov bh, 0    
	mov dh, 13      ; מספר שורה 
	mov dl, 29     ; מספר עמודה
	int 10h    
	mov dx, offset msgplayer2wins
	mov ah,9
	int 21h
	mov ax,[player2wins]
	call ShowAxDecimal

	mov [lenth],90
	mov [highet],16
	mov [x],227
	mov [y],76
	mov [color1],0
	call DrawFullRect
	push 16
	push 227
	push 76
	push 90
	push 3
	call DrawRect
	push 12 
	push 229
	push 78
	push 86
	push 3
	call DrawRect
	mov ah, 2      ; שירות 02h של INT 10h – הזזת הסמן
	mov bh, 0     
	mov dh, 10     ; מספר שורה 
	mov dl, 29     ; מספר עמודה 
	int 10h       
	mov dx, offset maxscoremsg
	mov ah,9
	int 21h
	mov ax,[hitnow]
	cmp ax,100
	jb @@keep
	mov ax,0
@@keep:
	call ShowAxDecimal
	ret
endp drawresults
;---------------------------------------------------------------------------------------------------
;מצייר במסך הבית את המגרשים בהם ניתן לבחור
;---------------------------------------------------------------------------------------------------
proc drawcourtchoose
	mov [lenth],314
	mov [highet],72
	mov [x],3
	mov [y],125
	mov [color1],7
	call DrawFullRect
	push 72
	push 3
	push 125
	push 314
	push 0
	call DrawRect
	push 68
	push 5
	push 127
	push 310
	push 0
	call DrawRect

	mov [BmpLeft],8
	mov [BmpTop],129
	mov [BmpRowSize],62
	mov [BmpColSize],100
	mov dx, offset hemarchoose
	call OpenShowBmp

	mov [BmpLeft],110
	mov [BmpTop],129
	mov [BmpRowSize],62
	mov [BmpColSize],100
	mov dx, offset greenchoose
	call OpenShowBmp

	mov [BmpLeft],212
	mov [BmpTop],129
	mov [BmpRowSize],62
	mov [BmpColSize],100
	mov dx, offset bluesmaller
	call OpenShowBmp
	ret
endp drawcourtchoose
;---------------------------------------------------------------------------------------------------
;פעולה אסינכרונית בעלת פיצ'רים רבים
;בודק לפי מצב במשחק מיקום לחיצה
;למשל: אם אני במסך הבית הוא יבדוק אם לחצתי על פליי
;למשל: אם אני באמצע משחק הוא לא יבדוק שום לחיצה
;---------------------------------------------------------------------------------------------------
proc checkrishum far
	mov ax,2
	int 33h
	shr cx,1
	cmp [game1v1on],1;אם משחק התחיל לבטל לחיצת עכבר ולדלג
	je @@bde
	cmp [game2v2on],1;אם משחק התחיל לבטל לחיצת עכבר ןלדלג
	je @@bde
	jmp @@bbb
@@bde:
	jmp @@different
@@bbb:
	cmp [showmenu],1;אם מסתכל על הוראות משחק אז יש לזהות מיקומי עכבר שונים
	je @@waitoclose
	;בודק אם נלחץ יציאה ממשחק
	cmp dx,2
	jna @@mabyplay
	cmp dx,22
	jnb @@mabyplay
	cmp cx,2
	jna @@mabyplay
	cmp cx,43
	jnb @@mabyplay
	mov [escapebottom],1
	jmp @@ret
@@waitoclose:
	cmp dx,2
	jna @@bbbbbb
	cmp dx,15
	jnb @@bbbbbb
	cmp cx,305
	jna @@bbbbbb
	cmp cx,317
	jnb @@bbbbbb
	mov [showmenu],0
@@bbbbbb:
	jmp @@ret
@@mabyplay:
	;בודק אם נלחץ על תפריט
	cmp dx,2
	jna @@mabyplay1
	cmp dx,14
	jnb @@mabyplay1
	cmp cx,305
	jna @@mabyplay1
	cmp cx,317
	jnb @@mabyplay1
	mov [showmenu],1
	jmp @@ret
@@mabyplay1:
	
	;בודק אם נלחץ על שחק משחק 1 על 1
	cmp dx,89
	jna @@mabycourt
	cmp dx,111
	jnb @@mabycourt
	cmp cx,140
	jna @@mabycourt
	cmp cx,178
	jnb @@mabycourt
	;אם עוד לא נבחר מגרש מציגים הודעה ולא מתחילי עדיין
	cmp [isplayerchose],0
	je @@massage
	
	mov [game1v1on],1
	jmp @@bret
@@massage:
	mov [BmpLeft],5
	mov [BmpTop],100
	mov [BmpRowSize],24
	mov [BmpColSize],63
	mov dx, offset massage
	call OpenShowBmp
	
	jmp @@ret
@@mabycourt:
	;בודק אם נלחץ על שחק משחק אימון

	cmp dx,64
	jna @@mabycourt1
	cmp dx,86
	jnb @@mabycourt1
	cmp cx,140
	jna @@mabycourt1
	cmp cx,178
	jnb @@mabycourt1
	;אם עוד לא נבחר מגרש מציגים הודעה ולא מתחילי עדיין

	cmp [isplayerchose],0
	je @@massage
	
	mov [game2v2on],1
	jmp @@bret
@@mabycourt1:
	;בודק אם נבחר מגרש ואיזה ומסמן לפי הצורך
	cmp dx,128
	jna @@bret
	cmp dx,182
	jnb @@bret
	cmp cx,7
	jna @@bret	
	cmp cx,109
	jnb @@2	
	call drawcourtchoose
	mov [BmpLeft],38
	mov [BmpTop],150
	mov [BmpRowSize],23
	mov [BmpColSize],28
	mov dx, offset vvv
	call OpenShowBmp
	mov [isplayerchose],1
	mov [whichcourt],3
	jmp @@ret
@@2:
	jmp @@aret
@@bbret:
	
@@bret:
	jmp @@ret
@@aret:
	cmp cx,109
	jna @@bret
	cmp cx,211
	jnb @@3
	call drawcourtchoose
	mov [BmpLeft],142
	mov [BmpTop],150
	mov [BmpRowSize],23
	mov [BmpColSize],28
	mov dx, offset vvv
	call OpenShowBmp
	mov [isplayerchose],1
	mov [whichcourt],2
	jmp @@ret
@@3:
	cmp cx,211
	jna @@bret
	cmp cx,313
	jnb @@bret
	call drawcourtchoose
	mov [BmpLeft],246
	mov [BmpTop],150
	mov [BmpRowSize],23
	mov [BmpColSize],28
	mov dx, offset vvv
	call OpenShowBmp
	mov [isplayerchose],1
	mov [whichcourt],1
	jmp @@ret
@@different:
	
	cmp [stopison],1;בודק אם המשחק נעצר
	jne @@bret
	;אם משחק נעצר בודקים על מה השחקן הקיש - מסך בית, המשך משחק או משחק חוזר
	cmp dx,90
	jna @@mabyhome1
	cmp dx,110
	jnb @@mabyhome1
	cmp cx,150
	jna @@mabyhome1
	cmp cx,170
	jnb @@mabyhome1
	jmp @@oo
@@mabyhome1:
	jmp @@mabyhome
@@oo:
	mov [stopison],0
	call ClearScreen
	
	call basecourtback
	mov [swOarrow],2
	call forran
	call realtimescore
	call chooseline
	jmp @@ret
@@mabyhome:
	cmp dx,5
	jna @@mabyagain
	cmp dx,23
	jnb @@mabyagain
	cmp cx,296
	jna @@mabyagain
	cmp cx,314
	jnb @@mabyagain
	call resetalltohomescreen
	
	
	jmp @@ret
@@mabyagain:
	cmp dx,23
	jna @@ret
	cmp dx,42
	jnb @@ret
	cmp cx,296
	jna @@ret
	cmp cx,314
	jnb @@ret
	mov [isagain],0
	call resetallagain

@@ret:
	mov ax,1
	int 33h
   retf
endp checkrishum 
;---------------------------------------------------------------------------------------------------
;מאתחל את כל המשתנים הקשורים למשחק חדש כדי שהשחקן ישחק מחדש
;נקרא לאחר לחיצה על משחק חוזר
;---------------------------------------------------------------------------------------------------
proc resetallagain
	mov [drawthem],0

	mov [turn],0
	mov [ballx],35
	mov [bally],95
	mov [p1ran],0
	mov [p2ran],0
	mov [whichline],1	
	mov [controlerloop], 0
	mov [gotspace],0
	mov [serve],0
	mov [whoserving],0	
	mov [changespeedp2],1
	mov [changespeed],4;;משתנה לבדיקה מתי להגביר מהירות
	mov [fory],0
	mov [forcross],0
	mov [turn],0
	mov [afterhit],0

	mov [forrestor],0

	mov [p1y],60

	mov [p2y],110
	
	mov [p1ran],0
	mov [p2ran],0
	mov [score1],0
	mov [score2],0
	mov [needtoprint],0
	mov [swOarrow],2

	mov [savep2yforrestore],110
	mov [savep1yforrestore],110
	mov [MaxHit],0
	mov [timetorestorecourt],0
	mov [timetorestore],0
	mov [timetorestore2],0
	mov [saveballyforrestore],35
	mov [saveballxforrestore],95
	call RefreshBack1
	call RefreshBack2
	call Refreshbackbuffer
	
	ret
endp resetallagain
;---------------------------------------------------------------------------------------------------
;מאפס את כל המשתנים והדברים הקשורים למסך הבית בהתחלה כדי שהשחקן יוכל להתחיל הכל כמו בהתחלה
;נקרא לאחר לחיצה על חזרה למסך בית - לא מאפס תוצאות וניקוד שצריך לשמור
;---------------------------------------------------------------------------------------------------
proc resetalltohomescreen
	mov [swOarrow],2

	mov [showmenu],0
	mov [escapebottom],0
	mov [needtoprint],0 
	mov [MaxHit],0

	mov [drawthem],0
	mov [game1v1on],0
	mov [game2v2on],0
	mov [isplayerchose],0
	mov [isbackhome],0

	mov [turn],0
	mov [ballx],35
	mov [bally],95;
	mov [p1ran],0
	mov [p2ran],0
	mov [whichline],1	
	mov [controlerloop], 0
	mov [gotspace],0
	mov [serve],0
	mov [whoserving],0	
	mov [changespeedp2],1
	mov [changespeed],4;;משתנה לבדיקה מתי להגביר מהירות
	mov [fory],0
	mov [forcross],0
	mov [turn],0
	mov [afterhit],0

	mov [forrestor],0

	mov [p1y],60

	mov [p2y],110
	
	mov [p1ran],0
	mov [p2ran],0
	mov [score1],0
	mov [score2],0
	
	mov [savep2yforrestore],110
	mov [savep1yforrestore],110

	mov [timetorestorecourt],0
	mov [timetorestore],0
	mov [timetorestore2],0
	mov [saveballyforrestore],35
	mov [saveballxforrestore],95
	call RefreshBack1
	call RefreshBack2
	call Refreshbackbuffer
	
	ret
endp resetalltohomescreen
;---------------------------------------------------------------------------------------------------
;מצייר מגרש בסיס - הכי גדול בעזרת BMP
;לפי בחירת השחקן
;---------------------------------------------------------------------------------------------------
proc basecourtback
	cmp [whichcourt],1
	je @@usopengame
	cmp [whichcourt],2
	je @@wimbledongame
@@rolandgarrosgame:
	mov [BmpLeft],0
	mov [BmpTop],5
	mov [BmpRowSize],189
	mov [BmpColSize],320
	mov dx, offset court2
	call OpenShowBmp
	jmp @@skip
@@wimbledongame:
	mov [BmpLeft],0
	mov [BmpTop],5
	mov [BmpRowSize],189
	mov [BmpColSize],320
	mov dx, offset court
	call OpenShowBmp	
	jmp @@skip
@@usopengame:	
	mov [BmpLeft],0
	mov [BmpTop],5
	mov [BmpRowSize],189
	mov [BmpColSize],320
	mov dx, offset court3
	call OpenShowBmp
@@skip:
	ret
endp basecourtback
;---------------------------------------------------------------------------------------------------
;מציג ניקוד של שני השחקנים על המסך
;---------------------------------------------------------------------------------------------------
proc realtimescore
	mov ah,2
	mov bh,0
	mov dh, 1 ; line number
	mov dl, 18; column number
	int 10h
	mov ah,0
	mov al, [score1]
	add al, '0'
	mov ah, 09h
	mov bh, 0
	mov bl, 4fh
	mov cx, 1
	int 10h         
	mov ah,2
	mov bh,0
	mov dh, 1 ; line number
	mov dl, 19; column number
	int 10h
	mov al, ':'     
	mov ah, 09h
	mov bh, 0
	mov bl, 0ffh
	mov cx, 1
	int 10h         
	mov ah,2
	mov bh,0
	mov dh, 1 ; line number
	mov dl, 20; column number
	int 10h
	mov al, [score2]
	add al, '0'
	mov ah, 09h
	mov bh, 0
	mov bl, 4fh
	mov cx, 1
	int 10h   
	ret
endp realtimescore
;---------------------------------------------------------------------------------------------------
;מציג כמה חבטות השחקן הצליח להחזיר מול המחשב באותו נסיון ובנוסף מציג גם את שיא החבטות עד עכשיו
;---------------------------------------------------------------------------------------------------
proc realtimemaxhit
	push ax
	
	mov ah,2
	mov bh,0
	mov dh, 1 ; line number
	mov dl, 15; column number
	int 10h
	mov dx,offset maxmsg
	mov ah,9
	int 21h
	mov ax,[MaxHit]
	call ShowAxDecimal
	mov ah,2
	mov bh,0
	mov dh, 23; line number
	mov dl, 15; column number
	int 10h
	mov dx,offset maxscoremsg
	mov ah,9
	int 21h
	mov ax,[hitnow]
	call ShowAxDecimal
	pop ax
	ret
endp realtimemaxhit
;---------------------------------------------------------------------------------------------------
;מסך טעינה עד מאה אחוז
;---------------------------------------------------------------------------------------------------
proc loading

	call bigdelay
	mov [BmpLeft],0
	mov [BmpTop],190
	mov [BmpRowSize],10
	mov [BmpColSize],50
	mov dx, offset onel
	call OpenShowBmp
	mov ah,2
	mov bh,0
	mov dh, 22; line number
	mov dl, 18; column number
	int 10h
	mov ah,9
	mov dx, offset twenty
	int 21h
	call bigdelay
	mov [BmpLeft],0
	mov [BmpTop],190
	mov [BmpRowSize],10
	mov [BmpColSize],120
	mov dx, offset twol
	call OpenShowBmp
	mov ah,2
	mov bh,0
	mov dh, 22; line number
	mov dl, 18; column number
	int 10h
	mov ah,9
	mov dx, offset fourty
	int 21h
	call bigdelay
	call bigdelay
	mov [BmpLeft],0
	mov [BmpTop],190
	mov [BmpRowSize],10
	mov [BmpColSize],210
	mov dx, offset threel
	call OpenShowBmp
	mov ah,2
	mov bh,0
	mov dh, 22; line number
	mov dl, 18; column number
	int 10h
	mov ah,9
	mov dx, offset seventy
	int 21h
	call bigdelay
	mov [BmpLeft],0
	mov [BmpTop],190
	mov [BmpRowSize],10
	mov [BmpColSize],320
	mov dx, offset fourl
	call OpenShowBmp
	mov ah,2
	mov bh,0
	mov dh, 22; line number
	mov dl, 18; column number
	int 10h
	mov ah,9
	mov dx, offset hundred
	int 21h
	call bigdelay
	call ClearScreen
	ret
endp loading
;---------------------------------------------------------------------------------------------------
;מצייר צעד של שחקן(ימן או שמאל) שזז - לפי זיהוי איזה שחקן זז ניתן לדעת איזה שחקן צריך לעשות צעד
;הפעולה לא מזיזה את השחקן - רק מציירת
;---------------------------------------------------------------------------------------------------
proc forran
	;בדיקת איזה צעד ימין או שמאל
	;בודק מי עשה צעד
	cmp [swOarrow],2
	jne @@notstart
	test [p2ran],1
	jz @@ran11
	call drawran2p2
	jmp @@move1
@@ran11:	
	call drawran1p2
@@move1:
	test [p1ran],1
	jz @@ran22
	call drawran2p1
	jmp @@pass
@@ran22:
	call drawran1p1
	jmp @@pass
	
@@notstart:
	cmp [swOarrow],1
	je @@move
	test [p2ran],1
	jz @@ran1
	call drawran2p2
	jmp @@pass
@@ran1:	
	call drawran1p2
	jmp @@pass
@@move:
	test [p1ran],1
	jz @@ran2
	call drawran2p1
	jmp @@pass
@@ran2:
	call drawran1p1
@@pass:
	ret
endp forran
;---------------------------------------------------------------------------------------------------
;נקראת בלולאה לאחר תזוזת הכדור
;בודק לפי מיקום הכדור והשחקן אם הם באות איזור ומחליט אם יש לבצע חבטה - אם חבטה אז משנה כיוון של כדור ומצייר את כל המסך מחדש למש שחקנים ומגרש
;בודק אם שחקן לא הספיק לחבוט בכדור והוא עבר אותו ואז נגמרת הנקודה, משנים ניקוד, וקוראים לפעולת נקודה חדשה
;בודק אם ניקוד הגיע ל10 ואז משחק נגמר - מציג הודעת ניצחון מתאימה 
;אותו דבר אם שחקן מול מחשב רק שהניקוד שונה ואין ניצחון
;
;---------------------------------------------------------------------------------------------------
proc checkhit
	;משווה מיקומי שחקן וכדור איזוריים
	test [turn],1
	jz @@p1turn

	mov ax,[p1y]	
	cmp [bally],ax
	ja @@fine
	jmp @@noty
@@fine:
	mov ax,[p1y]	
	add ax,20
	cmp [bally],ax
	jb @@checkx
	jmp @@noty
@@p1turn:
	mov ax,[p2y]

	cmp [bally],ax
	ja @@fine2
	jmp @@noty
@@fine2:
	mov ax,[p2y]	

	add ax,20
	cmp [bally],ax
	jb @@checkx

@@noty:	
	;בודק אם נגמרה נקודה
	cmp [ballx],305
	jnb @@oooo
	cmp [ballx],15
	jna @@oooo
	jmp @@yet
@@checkx:

	cmp [ballx],305
	jnb @@oooo
	cmp [ballx],15
	jna @@oooo
	jmp @@gggggg
@@oooo:
	jmp @@isover
@@gggggg:
	cmp [ballx],285;אם הגיע לשנות כיוון
	ja @@changedir
	cmp [ballx],35;אם הגיע לשנות כיוון
	jb @@changedir
	jmp @@yet
@@changedir:	
	call drawcourt;;;;;;;all 3 here is for ater hit to reset problems
	call RefreshBack1;;;;all 3 here is for ater hit to reset problems
	call RefreshBack2;;;;all 3 here is for ater hit to reset problems
	;בודק מי חבט ומצייר לפי זה
	test [turn],1
	jz @@p2hit
	call drawplayer1
	mov [ballx],35
	call correcty
	inc [changespeed]
	inc [changespeedp2]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-------------------------------------
	test [p2ran],1
	jz @@other
	call drawran2p2
	jmp @@incr
@@other:	
	call drawran1p2
;-------------------------------------
	jmp @@incr
@@p2hit:
	mov [ballx],285

	call drawplayer2
	call correcty
	inc [changespeed]
	inc [changespeedp2]
	cmp [game2v2on],0
	je @@NoincMax
	inc [MaxHit]
	cmp [MaxHit],9
	jna @@noprint
	mov [needtoprint],1
@@noprint:
	mov ax,[hitnow]
	cmp [MaxHit],ax
	jbe @@NoincMax
	inc [hitnow]
@@NoincMax:
;-------------------------------------
	test [p1ran],1
	jz @@other2

	call drawran2p1
	jmp @@incr
@@other2:

	call drawran1p1
;-------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@@incr:
	call randomline
@@incturn:
	inc [turn]
	;מזיז כדור אחרי חבטה כדי שיצא מחום הזיהוי
	call chooseline
	call chooseline
	call chooseline	
	call chooseline
	call drawcourt
	
	call checkhitter
	jmp @@yet
@@isover:;נגמרה נקודה
	cmp [game2v2on],1
	je @@Continue
	test [turn],1
	jz @@p11
	inc [score2]
	jmp @@cmp
@@p11:	
	inc [score1]
@@cmp:
	;בודק אם ניקוד הגיע לקצה ובדיוק מי הגיע ואז מציג הודעת ניצחון מתאימה
	cmp [score1],10
	je @@p1win
	cmp [score2],10
	je @@p2win
	jmp @@Continue
@@p1win:
	call p1win
	jmp @@yet
@@p2win:
	call p2win
	jmp @@yet
@@Continue:
;;;;;reset!!!!!!!!!!!!!!!!!!!!!!!!
;---------------------------------	
	call Refreshbackbuffer
	call newpoint
@@yet:
	ret
endp checkhit
;---------------------------------------------------------------------------------------------------
;מצייר הודעת ניצחון של שחקן 1 וחוזר למסך הבית
;---------------------------------------------------------------------------------------------------
proc p1win

	mov dx, offset win1
	mov [BmpLeft],80
	mov [BmpTop],50
	mov [BmpRowSize],100
	mov [BmpColSize],160
	call OpenShowBmp
	inc [player1wins]
	mov [isneedtogohome],1
	call bigdelay
	call bigdelay
	call bigdelay
	call bigdelay
	call bigdelay
	call bigdelay
	call resetalltohomescreen

	ret
endp p1win
;---------------------------------------------------------------------------------------------------
;מצייר הודעת ניצחון של שחקן 2 וחוזר למסך בית
;---------------------------------------------------------------------------------------------------
proc p2win
	mov dx, offset win2
	mov [BmpLeft],80
	mov [BmpTop],50
	mov [BmpRowSize],100
	mov [BmpColSize],160
	call OpenShowBmp
	mov [isneedtogohome],1
	inc [player2wins]
	call bigdelay
	call bigdelay
	call bigdelay
	call bigdelay
	call bigdelay
	call bigdelay
	call resetalltohomescreen

	ret
endp p2win
;---------------------------------------------------------------------------------------------------
;בזמן חבטה - מודפס שחקן חובט
;הפעולה מציירת שחקן שחובט לפי מי שחבט ומצייר את השחקן השני  בצורתו הרגילה
;---------------------------------------------------------------------------------------------------
proc checkhitter
	test [turn],1
	jz @@p2hit

	call drawplayer2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-------------------------------------
	test [p1ran],1
	jz @@other
	call drawran2p1
	jmp @@incr
@@other:	
	call drawran1p1
;-------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	jmp @@incr
@@p2hit:
	call drawplayer1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-------------------------------------
	test [p2ran],1
	jz @@other2
	call drawran2p2
	jmp @@incr
@@other2:
	call drawran1p2
;-------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@@incr:
	ret
endp checkhitter
;---------------------------------------------------------------------------------------------------
;לאחר סיום נקודה יש להתחיל נקודה חדשה
;הפעולה מאתחלת משתנים לאיך שהם היו כמו בנקודה הראשונה
;ומדפיסה הכל במקום ההתחלתי לפי מי שמגיש
;מדפיסה ניקוד לפי מצב המשחק - תלוי אם שחקן יחיד או שני שחקנים
;---------------------------------------------------------------------------------------------------
proc newpoint
	mov [swOarrow],2

	mov [timetorestore],0
	mov [timetorestore2],0
	mov [MaxHit],0
	mov [gotspace],0
	call drawcourt
	cmp [game2v2on],1
	je @@trainig
	
@@showscore:
	call showscore
	
	inc [whoserving]
@@trainig:
	mov [changespeedp2],1
	mov [changespeed],4
	mov al,[whoserving]
	
	mov [turn],al
	mov [forcross],0
	
	test [serve],1
	jz @@different1	
	mov [p1y],60
	mov [p2y],110
	jmp @@jump
@@different1:
	mov [p2y],60
	mov [p1y],110
@@jump:	
	inc [serve]
	
	test [turn],1
	jz @@different2	
	mov [ballx],282
	mov [bally],95
	jmp @@jump1
@@different2:
	mov [ballx],35
	mov [bally],95
@@jump1:

	mov [p1ran],0
	mov [p2ran],0
	call drawcourt
	call forran
	mov [whichline],1
	cmp [game2v2on],1
	je @@trainig1
	call realtimescore
	jmp @@ret
@@trainig1:
	cmp [needtoprint],1
	jne @@noprint
	mov [needtoprint],0
	call basecourtback
	call forran
	
@@noprint:
	call realtimemaxhit
@@ret:
	ret
endp newpoint
;---------------------------------------------------------------------------------------------------
;מתקן את מיקום הטור של הכדור לפי מסלולו לאחר כל חבטה
;---------------------------------------------------------------------------------------------------
proc correcty
	cmp [whichline],1
	je @@ret
	cmp [whichline],2
	je @@line2
	cmp [whichline],3
	je @@line3
	cmp [whichline],4
	je @@line4
	cmp [whichline],5
	je @@line5

@@line2:

	mov [bally],137

	jmp @@ret
@@line3:

	mov [bally],53

	jmp @@ret
@@line4:
	cmp [bally],60

	ja @@middle

	mov [bally],53

	jmp @@ret
@@middle:

	mov [bally],95

	jmp @@ret
@@line5:
	cmp [bally],130
	jb @@middle2

	mov [bally],137

	jmp @@ret
@@middle2:

	mov [bally],95

	jmp @@ret
@@ret:
	ret
endp correcty
;---------------------------------------------------------------------------------------------------
;קןרא למסלול של הכדור לפי משתנה שמכיל את מספר המסלול
;---------------------------------------------------------------------------------------------------
proc chooseline
	cmp [whichline],1;,2,3,4,5 - choose which line to hit
	je @@line1
	cmp [whichline],2;,2,3,4,5 - choose which line to hit 
	je @@line2
	cmp [whichline],3;,2,3,4,5 - choose which line to hit
	je @@line3
	cmp [whichline],4;,2,3,4,5 - choose which line to hit
	je @@line4
	cmp [whichline],5;,2,3,4,5 - choose which line to hit
	je @@line5
	
@@line1:
	call line1
	jmp @@ret
@@line2:
	call line2
	jmp @@ret
@@line3:
	call line3
	jmp @@ret
@@line4:
	call line4
	jmp @@ret
@@line5:
	call line5
	jmp @@ret
@@ret:
	ret
endp chooseline
;---------------------------------------------------------------------------------------------------
;מגריל מסלול רנדומלי אפשרי* לכדור לפי מיקומו
;---------------------------------------------------------------------------------------------------
proc randomline
	cmp [bally],53
	je @@random1
	jmp @@place2
@@random1:
	mov [line5placetobe],0
	mov bl,0
	mov bh,2
	call RandomByCs
	mov ah,0
	mov si,ax
	mov dl,[rnd1+si];מערך עם מספר מסלול
	mov [whichline],dl
	jmp @@incturn

@@place2:
	cmp [bally],95 
	je @@random2
	jmp @@place3;???
@@random2:
	mov [line4placetobe],1
	mov [line5placetobe],1

	mov bl,0
	mov bh,2
	call RandomByCs
	mov ah,0
	mov si,ax
	mov dl,[rnd2+si];מערך עם מספר מסלול
	mov [whichline],dl
	jmp @@incturn

@@place3:	
	cmp [bally],137 
	je @@random3
	jmp @@incturn
@@random3:
	mov [line4placetobe],0

	mov bl,0
	mov bh,2
	call RandomByCs
	mov ah,0
	mov si,ax
	mov dl,[rnd3+si];מערך עם מספר מסלול
	mov [whichline],dl
	
@@incturn:
	ret
endp randomline
;---------------------------------------------------------------------------------------------------
;פעולה המציירת מגרש לפי בחירת השחקן
;ההדפסה היא דרך פעולה ששומרת את הצבעים במסך ופעולה שמדפיסה אותה מהמשתנה שבו שמרנו את הצבעים

;בפעם הראשונה נדפיס מגרש מקובץ bmp
;ואז נשמור מהמסך את הצבעים ולא נצטרך יותר להדפיס בBMP

;---------------------------------------------------------------------------------------------------
Proc drawcourt
	cmp [timetorestorecourt],0;בפעם הראשונה לא להחזיר כי לא שמרנו עוד ואז יש להדפיס BMP
	je @@dilug1
	call Restorecourt
	jmp @@dilug2
@@dilug1:	
	
	cmp [whichcourt],1
	je @@usopengame
	cmp [whichcourt],2
	je @@wimbledongame
@@rolandgarrosgame:
	call drawrolandgarros
	jmp @@mainloop
@@wimbledongame:
	call drawwimbledon
	jmp @@mainloop
@@usopengame:
	
	call drawusopen
@@mainloop:
	cmp [timetorestorecourt],1
	je @@dilug2
	call Savecourt
	mov [timetorestorecourt],1
@@dilug2:
	ret
endp drawcourt
;---------------------------------------------------------------------------------------------------
;בודקת אם זה הזמן לשנות את מהירות הכדור ואם כן משנה
;---------------------------------------------------------------------------------------------------
proc ballchange1
	cmp [changespeedp2],18
	ja @@incspeed
	test [changespeedp2],7
	jz @@incspeed
	test [changespeed],7
	jz @@incspeed
	jmp @@nothing
@@incspeed:
	shl ax,1
@@nothing:
	ret
endp ballchange1
;---------------------------------------------------------------------------------------------------
;בודקת אם זה הזמן לשנות את מהירות הכדור ואם כן משנה
;בנוסף משנה גם את הקפיצת הטור של הכדור
;נועד למסלולי כדור לא ישרים
;---------------------------------------------------------------------------------------------------
proc ballchange2
	cmp [changespeedp2],18
	ja @@incspeed
	test [changespeedp2],7
	jz @@incspeed
	test [changespeed],7
	jz @@incspeed
	jmp @@nothing
@@incspeed:
	shl ax,1
	shl [fory],1
@@nothing:
	ret
endp ballchange2
;---------------------------------------------------------------------------------------------------
;מסלול ישר של הכדור 
;מזיז את הכדור ומדפיס אותו לפי מהירותו
;---------------------------------------------------------------------------------------------------
proc line1;;;;;;;;;;;; קו ישר 
	test [turn],1
	jz @@p1turn

	mov ax,[ballspeed]
	call ballchange1

	sub [ballx],ax

	jmp @@drawbl
@@p1turn:
	mov ax,[ballspeed]
	call ballchange1

	add [ballx],ax
@@drawbl:
	call drawball
	ret
endp line1
;---------------------------------------------------------------------------------------------------
;מסלול קו אלכסון ממש למטה
;;מזיז את הכדור ומדפיס אותו לפי מהירות
;---------------------------------------------------------------------------------------------------
proc line2;;קו אלכסון ממש למטה
	test [turn],1
	jz @@p1turn
	mov ax,[ballspeed]
	mov [fory],1
	call ballchange2

	sub [ballx],ax
	mov ax,[fory]
	add [bally],ax
	jmp @@drawbl
@@p1turn:
	mov ax,[ballspeed]
	mov [fory],1
	call ballchange2

	add [ballx],ax
	mov ax,[fory]
	add [bally],ax
@@drawbl:
	call drawball
	ret
endp line2
;---------------------------------------------------------------------------------------------------
;מסלול קו אלכסון ממש למעלה
;;מזיז את הכדור ומדפיס אותו לפי מהירות
;---------------------------------------------------------------------------------------------------
proc line3;;קו אלכון ממש מעלה
	test [turn],1
	jz @@p1turn
	mov ax,[ballspeed]
	mov [fory],1
	call ballchange2

	sub [ballx],ax
	mov ax,[fory]
	sub [bally],ax
	jmp @@drawbl
@@p1turn:
	mov ax,[ballspeed]
	mov [fory],1
	call ballchange2

	add [ballx],ax
	mov ax,[fory]
	sub [bally],ax
@@drawbl:
	call drawball
	ret
endp line3
;---------------------------------------------------------------------------------------------------
;מסלול קו אלכסון חצי למעלה
;;מזיז את הכדור ומדפיס אותו לפי מהירות
;---------------------------------------------------------------------------------------------------
proc line4;;קו אלכסון חצי למעלה
	test [turn],1
	jz @@p1turn
	mov ax,[ballspeed]
	mov [fory],1
	call ballchange2

	sub [ballx],ax
	test [forcross],1
	jz @@nodown
	mov ax,[fory]
	sub [bally],ax
@@nodown:
	jmp @@drawbl
@@p1turn:
	mov ax,[ballspeed]
	mov [fory],1
	call ballchange2

	add [ballx],ax
	test [forcross],1
	jz @@drawbl
	mov ax,[fory]
	sub [bally],ax
	
@@drawbl:
	call drawball
	inc [forcross]
	ret
endp line4
;---------------------------------------------------------------------------------------------------
;מסלול קו אלכסון חצי למטה
;;מזיז את הכדור ומדפיס אותו לפי מהירות
;---------------------------------------------------------------------------------------------------
proc line5;;קו אלכסון חצי למטה
	test [turn],1
	jz @@p1turn
	mov ax,[ballspeed]
	mov [fory],1
	call ballchange2

	sub [ballx],ax
	test [forcross],1
	jz @@noup
	mov ax,[fory]
	add [bally],ax
@@noup:
	jmp @@drawbl
@@p1turn:
	mov ax,[ballspeed]
	mov [fory],1
	call ballchange2

	add [ballx],ax
	test [forcross],1
	jz @@drawbl
	mov ax,[fory]
	add [bally],ax
	
@@drawbl:
	call drawball
	inc [forcross]
	ret
endp line5	
;;;;;;;;;;;;;;;;;;;;;;;;ball lines		
;---------------------------------------------------------------------------------------------------
;מצייר מסך ביתBMP
;---------------------------------------------------------------------------------------------------
proc drawhomescreen
	mov [BmpLeft],0
	mov [BmpTop],10
	mov [BmpRowSize],180
	mov [BmpColSize],320
	mov dx, offset hscreen
	call OpenShowBmp
	ret
endp drawhomescreen
;---------------------------------------------------------------------------------------------------
;מצייר מגרש דשאBMP
;---------------------------------------------------------------------------------------------------
proc drawwimbledon;;;;;;;;;;;;מגרש דשא
	mov [BmpLeft],0
	mov [BmpTop],20
	mov [BmpRowSize],160
	mov [BmpColSize],320
	mov dx, offset yarok
	call OpenShowBmp
	ret
endp drawwimbledon
;---------------------------------------------------------------------------------------------------
;מצייר מגרש חימר BMP
;---------------------------------------------------------------------------------------------------
proc drawrolandgarros;;;;;;;;;מגרש חימר
	mov [BmpLeft],0
	mov [BmpTop],20
	mov [BmpRowSize],160
	mov [BmpColSize],320
	mov dx, offset hemar
	call OpenShowBmp
	ret
endp drawrolandgarros
;---------------------------------------------------------------------------------------------------
;מצייר מגרש אספלט BMP
;---------------------------------------------------------------------------------------------------
proc drawusopen;;;;;;;;;מגרש כחול
	mov [BmpLeft],0
	mov [BmpTop],20
	mov [BmpRowSize],160
	mov [BmpColSize],320
	mov dx, offset asfalt
	call OpenShowBmp
	ret
endp drawusopen
;---------------------------------------------------------------------------------------------------
;מחזיר את מה שהיה מאחורי השחקן מקודם, שומר את מה שמאחורי המיקום החדש של השחקן ומצייר את שחקן 1 חובט
;---------------------------------------------------------------------------------------------------
proc drawplayer1
	call RestoreUnderPlayer1
	call SaveUnderPlayer1
	mov [BmpLeft],5	
	mov ax,[p1y]
	mov [BmpTop],ax
	mov [BmpRowSize],30
	mov [BmpColSize],30
	mov dx, offset player1
	call OpenShowBmp
	ret
endp drawplayer1
;---------------------------------------------------------------------------------------------------
;מחזיר את מה שהיה מאחורי השחקן מקודם, שומר את מה שמאחורי המיקום החדש של השחקן ומצייר את שחקן 1 עושה צעד
;---------------------------------------------------------------------------------------------------
proc drawran1p1
	call RestoreUnderPlayer1
	call SaveUnderPlayer1
	mov ax,[p1y]
	mov [BmpLeft],5
	mov [BmpTop],ax
	mov [BmpRowSize],30
	mov [BmpColSize],30
	mov dx, offset ran1p1
	call OpenShowBmp
	ret
endp drawran1p1
;---------------------------------------------------------------------------------------------------
;מחזיר את מה שהיה מאחורי השחקן מקודם, שומר את מה שמאחורי המיקום החדש של השחקן ומצייר את שחקן 1 עושה צעד 
;---------------------------------------------------------------------------------------------------
proc drawran2p1
	call RestoreUnderPlayer1
	call SaveUnderPlayer1
	mov ax,[p1y]
	mov [BmpLeft],5
	mov [BmpTop],ax
	mov [BmpRowSize],30
	mov [BmpColSize],30
	mov dx, offset ran2p1
	call OpenShowBmp
	ret
endp drawran2p1
;---------------------------------------------------------------------------------------------------
;מחזיר את מה שהיה מאחורי השחקן מקודם, שומר את מה שמאחורי המיקום החדש של השחקן ומצייר את שחקן 2 עושה צעד
;---------------------------------------------------------------------------------------------------
proc drawran1p2
	call RestoreUnderPlayer2
	call SaveUnderPlayer2
	mov ax,[p2y]
	mov [BmpLeft],285
	mov [BmpTop],ax
	mov [BmpRowSize],30
	mov [BmpColSize],30
	mov dx, offset ran1p2
	call OpenShowBmp
	ret
endp drawran1p2
;---------------------------------------------------------------------------------------------------
;מחזיר את מה שהיה מאחורי השחקן מקודם, שומר את מה שמאחורי המיקום החדש של השחקן ומצייר את שחקן 2 עושה צעד
;---------------------------------------------------------------------------------------------------
proc drawran2p2
	call RestoreUnderPlayer2
	call SaveUnderPlayer2
	mov ax,[p2y]
	mov [BmpLeft],285
	mov [BmpTop],ax
	mov [BmpRowSize],30
	mov [BmpColSize],30
	mov dx, offset ran2p2
	call OpenShowBmp
	ret
endp drawran2p2
;---------------------------------------------------------------------------------------------------
;שומר את הצבעים מהמסך במיקום של הכדור - בעצם קוראים לפעולה לפני שמציירים את הכדור בכדי שנוכל לשמור את מאחורי הכדור שלא ימרח
;את הצבעים שומרים במשתנה
;---------------------------------------------------------------------------------------------------	
proc SaveUnderBall 
    mov ax, 0A000h
    mov es, ax  ; ES = video memory
    mov si, 0   ; SI = index into BackgroundBuffer

    mov bx, [ballx] ; bx = ballx
    mov dx, [bally] ; dx = bally
	mov [saveballxforrestore],bx
	mov [saveballyforrestore],dx 
    mov cx, 9       
@@SaveRowLoop:
    push cx

    mov ax, dx       ; ax = BallY
    mov cx, ax       ; שומרים עותק ב־cx

    shl ax, 8     
    shl cx, 6       
    add ax, cx       

    add ax, bx       
    mov di, ax       ; di = offset in video memory
    mov cx, 9                    
@@SaveColLoop:

    mov al, [byte es:di]
    mov [BackgroundBuffer + si], al
    inc di
    inc si
	
    loop @@SaveColLoop

    inc dx; next row
    pop cx
    loop @@SaveRowLoop
    ret
endp SaveUnderBall
;---------------------------------------------------------------------------------------------------
;מצייר מחדש את מה ששמרנו מתוך המשתנה ששמר את הצבעים(למסך)
;---------------------------------------------------------------------------------------------------
proc RestoreUnderBall

push ax
    mov ax, 0A000h
    mov es, ax
    mov si, 0

    mov bx, [saveballxforrestore]    ; bx = BallX
    mov dx, [saveballyforrestore]    ; dx = BallY

    mov cx, 9
@@RestoreRowLoop:
    push cx

    mov ax, dx       ; ax = BallY
    mov cx, ax       ; שומרים עותק ב־cx

    shl ax, 8        
    shl cx, 6      
    add ax, cx       

    add ax, bx       ; ax = BallY * 320 + BallX
    mov di, ax
	
    mov cx, 9
@@RestoreColLoop:
    mov al, [BackgroundBuffer + si]
	cmp al,0
	je @@dilug
    mov [es:di], al
@@dilug:
    inc si
    inc di
    loop @@RestoreColLoop

    inc dx  
    pop cx
    loop @@RestoreRowLoop
pop ax
    ret
endp RestoreUnderBall

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;|
;---------------------------------------------------------------------------------------------------
;מצייר את הכדור - לפי זה הוא שמצייר את מה שהוא שמר מאחורי הכדור מקודם ושומר את מאחורי הכדור במיקומו החדש
;מצייר כדור אש במקרה שמהירותו הוכפלה - כדור אש שונה בין כל כיוון 
;---------------------------------------------------------------------------------------------------	
proc drawball

	
	call RestoreUnderBall;מחזיר מתחת לכדור
	call SaveUnderBall;שומר רקע כדור חדש
	;מצייר כדור לפי מהירותו וכיוונו
	mov ax,[ballx]
	mov [BmpLeft],ax
	mov ax,[bally]
	mov [BmpTop],ax
	mov [BmpRowSize],8
	mov [BmpColSize],8
	
	cmp [changespeedp2],18
	ja @@incspeed
	
	test [changespeedp2],7
	jz @@incspeed
	test [changespeed],7
	jz @@incspeed
	jmp @@nothing
@@incspeed:
	test [turn],1
	jz @@p1turn
	mov dx, offset fireball2
	jmp @@show
@@p1turn:
	mov dx, offset fireball1
	jmp @@show
@@nothing:
	mov dx, offset ball
@@show:		
	call OpenShowBmp
@@retrt:
	ret
endp drawball
;---------------------------------------------------------------------------------------------------
;מחזיר את מה שהיה מאחורי השחקן מקודם, שומר את מה שמאחורי המיקום החדש של השחקן ומצייר את שחקן 2 חובט
;---------------------------------------------------------------------------------------------------
proc drawplayer2
	call RestoreUnderPlayer2
	call SaveUnderPlayer2
	mov [BmpLeft],285
	mov ax,[p2y]
	mov [BmpTop],ax
	mov [BmpRowSize],30
	mov [BmpColSize],30
	mov dx, offset player2
	call OpenShowBmp
	ret
endp drawplayer2
;---------------------------------------------------------------------------------------------------
;מצייר על המסך את הניקוד במשחק של שני שחקנים לאחר שמישהו ניצח נקודה - לא בזמן אמת!
;---------------------------------------------------------------------------------------------------
proc showscore
	cmp [score1],0
	je @@0
	cmp [score1],1
	je @@1
	cmp [score1],2
	je @@2
	cmp [score1],3
	je @@3
	cmp [score1],4
	je @@4
	cmp [score1],5
	je @@5
	cmp [score1],6
	je @@6
	cmp [score1],7
	je @@7
	cmp [score1],8
	je @@8
	cmp [score1],9
	je @@9
	cmp [score1],10
	je @@10
@@0:
	mov dx, offset zero
	jmp @@next
@@1:
	mov dx, offset one
	jmp @@next	
@@2:
	mov dx, offset two
	jmp @@next	
@@3:
	mov dx, offset three
	jmp @@next	
@@4:
	mov dx, offset four
	jmp @@next	
@@5:
	mov dx, offset five
	jmp @@next	
@@6:
	mov dx, offset six
	jmp @@next	
@@7:
	mov dx, offset seven
	jmp @@next	
@@8:
	mov dx, offset eight
	jmp @@next	
@@9:
	mov dx, offset nine
	jmp @@next	
@@10:
	mov dx, offset ten
@@next:
	mov [BmpLeft],35
	mov [BmpTop],50
	mov [BmpRowSize],100
	mov [BmpColSize],100
	call OpenShowBmp
	
	cmp [score2],0
	je @@zero
	cmp [score2],1
	je @@one
	cmp [score2],2
	je @@two
	cmp [score2],3
	je @@three
	cmp [score2],4
	je @@four
	cmp [score2],5
	je @@five
	cmp [score2],6
	je @@six
	cmp [score2],7
	je @@seven
	cmp [score2],8
	je @@eight
	cmp [score2],9
	je @@nine
	cmp [score2],10
	je @@ten
@@zero:
	mov dx, offset zero
	jmp @@next1
@@one:
	mov dx, offset one
	jmp @@next1	
@@two:
	mov dx, offset two
	jmp @@next1	
@@three:
	mov dx, offset three
	jmp @@next1	
@@four:
	mov dx, offset four
	jmp @@next1	
@@five:
	mov dx, offset five
	jmp @@next1	
@@six:
	mov dx, offset six
	jmp @@next1	
@@seven:
	mov dx, offset seven
	jmp @@next1
@@eight:
	mov dx, offset eight
	jmp @@next1	
@@nine:
	mov dx, offset nine
	jmp @@next1	
@@ten:
	mov dx, offset ten
@@next1:
	mov [BmpLeft],175
	mov [BmpTop],50
	mov [BmpRowSize],100
	mov [BmpColSize],100
	call OpenShowBmp
	call bigdelay;שיהיה זמן לראות ניקוד
@@out:

	call emptyKeyBoard;ניקוי מקלדת למקרה שנלחץ בזמן ההצגה
	ret
endp showscore
;---------------------------------------------------------------------------------------------------
;מרוקן מחסנית של מקלדת 
;---------------------------------------------------------------------------------------------------
proc emptyKeyBoard
@@FlushKeyboard:
    mov ah, 01h
    int 16h
    jz @@DoneFlush   
    mov ah, 00h
    int 16h          
    jmp @@FlushKeyboard
@@DoneFlush:
	ret
endp emptyKeyBoard
;---------------------------------------------------------------------------------------------------
;דיליי גדול יחסית
;---------------------------------------------------------------------------------------------------
proc bigdelay
	push cx
	mov cx ,1750
@@Self1:
	push cx
	mov cx,3000   
@@Self2:	
	loop @@Self2
	pop cx
	loop @@Self1
	pop cx
	ret
endp bigdelay
;---------------------------------------------------------------------------------------------------
;ניקוי מסך בצבע אפור
;---------------------------------------------------------------------------------------------------
proc ClearScreen
	push bp
	mov bp,sp
	mov ax, 0A000h
	mov es, ax
	mov di,0
	mov cx,64000
@@loopfill:
	mov ax,di
	mov [byte es:di],7
	inc di
	loop @@loopfill
	pop bp 
	ret 
endp ClearScreen
;---------------------------------------------------------------------------------------------------
;דיליי קטן
;---------------------------------------------------------------------------------------------------
proc LoopDelay01Sec
	push cx
	mov cx ,25
@@Self1:
	push cx
	mov cx,3000   
@@Self2:	
	loop @@Self2
	pop cx
	loop @@Self1
	pop cx
	ret
endp LoopDelay01Sec

proc OpenShowBmp near
	
	 
	call OpenBmpFile
	cmp [ErrorFile],1
	je @@ExitProc
	
	call ReadBmpHeader
	
	call ReadBmpPalette
	
	call CopyBmpPalette
	
	call  ShowBmp
	
	 
	call CloseBmpFile

@@ExitProc:
	ret
endp OpenShowBmp
; input dx filename to open
proc OpenBmpFile	near						 
	mov ah, 3Dh
	xor al, al
	int 21h
	jc @@ErrorAtOpen
	mov [FileHandle], ax
	jmp @@ExitProc
	
@@ErrorAtOpen:
	mov [ErrorFile],1
@@ExitProc:	
	ret
endp OpenBmpFile
; Read 54 bytes the Header
proc ReadBmpHeader	near					
	push cx
	push dx
	
	mov ah,3fh
	mov bx, [FileHandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	
	pop dx
	pop cx
	ret
endp ReadBmpHeader
proc ReadBmpPalette near ; Read BMP file color palette, 256 colors * 4 bytes (400h)
						 ; 4 bytes for each color BGR + null)			
	push cx
	push dx
	
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	
	pop dx
	pop cx
	
	ret
endp ReadBmpPalette
; Will move out to screen memory the colors
; video ports are 3C8h for number of first color
; and 3C9h for all rest
proc CopyBmpPalette		near					
										
	push cx
	push dx
	
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0  ; black first							
	out dx,al ;3C8h
	inc dx	  ;3C9h
CopyNextColor:
	mov al,[si+2] 		; Red				
	shr al,2 			; divide by 4 Max (cos max is 63 and we have here max 255 ) (loosing color resolution).				
	out dx,al 						
	mov al,[si+1] 		; Green.				
	shr al,2            
	out dx,al 							
	mov al,[si] 		; Blue.				
	shr al,2            
	out dx,al 							
	add si,4 			; Point to next color.  (4 bytes for each color BGR + null)				
								
	loop CopyNextColor
	
	pop dx
	pop cx
	
	ret
endp CopyBmpPalette
proc ShowBMP 
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpRowSize lines in VGA format),
; displaying the lines from bottom to top.
	push cx
	
	mov ax, 0A000h
	mov es, ax
	
	mov cx,[BmpRowSize]
	
 
	mov ax,[BmpColSize] ; row size must dived by 4 so if it less we must calculate the extra padding bytes
	xor dx,dx
	mov si,4
	div si
	cmp dx,0
	mov bp,0
	jz @@row_ok
	mov bp,4
	sub bp,dx

@@row_ok:	
	mov dx,[BmpLeft]
	
@@NextLine:
	push cx
	push dx
	
	mov di,cx  ; Current Row at the small bmp (each time -1)
	add di,[BmpTop] ; add the Y on entire screen
	
 
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	mov cx,di
	shl cx,6
	shl di,8
	add di,cx
	add di,dx
	 
	; small Read one line
	mov ah,3fh
	mov cx,[BmpColSize]  
	add cx,bp  ; extra  bytes to each row must be divided by 4
	mov dx,offset ScrLine
	int 21h
	; Copy one line into video memory
	
	mov cx,[BmpColSize]  
	mov si,offset ScrLine
@@lop:
	mov al,[byte ds:si]
	cmp [byte ds:si],0h
	je @@dilug
	mov [byte es:di],al
@@dilug:
	inc si
	inc di
	loop @@lop;Copy line to the screen;
	
	pop dx
	pop cx
	 
	loop @@NextLine
	
	pop cx
	ret
endp ShowBMP 
proc CloseBmpFile near
	mov ah,3Eh
	mov bx, [FileHandle]
	int 21h
	ret
endp CloseBmpFile
	

;================================================
; Description - Write on screen the value of ax (decimal)
;               the practice :  
;				Divide AX by 10 and put the Mod on stack 
;               Repeat Until AX smaller than 10 then print AX (MSB) 
;           	then pop from the stack all what we kept there and show it. 
; INPUT: AX
; OUTPUT: Screen 
; Register Usage: AX  
;================================================
proc ShowAxDecimal
       push ax
	   push bx
	   push cx
	   push dx
	    
	   push ax
	   
	   pop ax
	   
	   
	   ; check if negative
	   test ax,08000h
	   jz PositiveAx
			
	   ;  put '-' on the screen
	   push ax
	   mov dl,'-'
	   mov ah,2
	   int 21h
	   pop ax

	   neg ax ; make it positive
PositiveAx:
       mov cx,0   ; will count how many time we did push 
       mov bx,10  ; the divider
   
put_mode_to_stack:
       xor dx,dx
       div bx
       add dl,30h
	   ; dl is the current LSB digit 
	   ; we cant push only dl so we push all dx
       push dx    
       inc cx
       cmp ax,9   ; check if it is the last time to div
       jg put_mode_to_stack

	   cmp ax,0
	   jz pop_next  ; jump if ax was totally 0
       add al,30h  
	   mov dl, al    
  	   mov ah, 2h
	   int 21h        ; show first digit MSB
	       
pop_next: 
       pop ax    ; remove all rest LIFO (reverse) (MSB to LSB)
	   mov dl, al
       mov ah, 2h
	   int 21h        ; show all rest digits
       loop pop_next
		
	   
   
	   pop dx
	   pop cx
	   pop bx
	   pop ax
	   ret 
endp ShowAxDecimal
; Description  : get RND between any bl and bh includs (max 0 -255)
; Input        : 1. Bl = min (from 0) , BH , Max (till 255)
; 			     2. RndCurrentPos a  word variable,   help to get good rnd number
; 				 	Declre it at DATASEG :  RndCurrentPos dw ,0
;				 3. EndOfCsLbl: is label at the end of the program one line above END start		
; Output:        Al - rnd num from bl to bh  (example 50 - 150)
; More Info:
; 	Bl must be less than Bh 
; 	in order to get good random value again and agin the Code segment size should be 
; 	at least the number of times the procedure called at the same second ... 
; 	for example - if you call to this proc 50 times at the same second  - 
; 	Make sure the cs size is 50 bytes or more 
; 	(if not, make it to be more) 
proc RandomByCs
    push es
	push si
	push di
	
	mov ax, 40h ; segment for 40:6c
	mov	es, ax
	
	sub bh,bl  ; we will make rnd number between 0 to the delta between bl and bh
			   ; Now bh holds only the delta
	cmp bh,0
	jz @@ExitP
 
	mov di, [word RndCurrentPos]
	call MakeMask ; will put in si the right mask according the delta (bh) (example for 28 will put 31)
	
RandLoop: ;  generate random number 
	mov ax, [es:06ch] ; read timer counter
	mov ah, [byte cs:di] ; read one byte from memory (from semi random byte at cs)
	xor al, ah ; xor memory and counter
	
	; Now inc di in order to get a different number next time
	inc di
	cmp di,(EndOfCsLbl - start - 1)
	jb @@Continue
	mov di, offset start
@@Continue:
	mov [word RndCurrentPos], di
	
	and ax, si ; filter result between 0 and si (the nask)
	cmp al,bh    ;do again if  above the delta
	ja RandLoop
	
	add al,bl  ; add the lower limit to the rnd num
		 
@@ExitP:	
	pop di
	pop si
	pop es
	ret
endp RandomByCs


; Description  : get RND between any bl and bh includs (max 0 - 65535)
; Input        : 1. BX = min (from 0) , DX, Max (till 64k -1)
; 			     2. RndCurrentPos a  word variable,   help to get good rnd number
; 				 	Declre it at DATASEG :  RndCurrentPos dw ,0
;				 3. EndOfCsLbl: is label at the end of the program one line above END start		
; Output:        AX - rnd num from bx to dx  (example 50 - 1550)
; More Info:
; 	BX  must be less than DX 
; 	in order to get good random value again and again the Code segment size should be 
; 	at least the number of times the procedure called at the same second ... 
; 	for example - if you call to this proc 50 times at the same second  - 
; 	Make sure the cs size is 50 bytes or more 
; 	(if not, make it to be more) 
proc RandomByCsWord
    push es
	push si
	push di
 
	
	mov ax, 40h
	mov	es, ax
	
	sub dx,bx  ; we will make rnd number between 0 to the delta between bx and dx
			   ; Now dx holds only the delta
	cmp dx,0
	jz @@ExitP
	
	push bx
	
	mov di, [word RndCurrentPos]
	call MakeMaskWord ; will put in si the right mask according the delta (bh) (example for 28 will put 31)
	
@@RandLoop: ;  generate random number 
	mov bx, [es:06ch] ; read timer counter
	
	mov ax, [word cs:di] ; read one word from memory (from semi random bytes at cs)
	xor ax, bx ; xor memory and counter
	
	; Now inc di in order to get a different number next time
	inc di
	inc di
	cmp di,(EndOfCsLbl - start - 2)
	jb @@Continue
	mov di, offset start
@@Continue:
	mov [word RndCurrentPos], di
	
	and ax, si ; filter result between 0 and si (the nask)
	
	cmp ax,dx    ;do again if  above the delta
	ja @@RandLoop
	pop bx
	add ax,bx  ; add the lower limit to the rnd num
		 
@@ExitP:
	
	pop di
	pop si
	pop es
	ret
endp RandomByCsWord

; make mask acording to bh size 
; output Si = mask put 1 in all bh range
; example  if bh 4 or 5 or 6 or 7 si will be 7
; 		   if Bh 64 till 127 si will be 127
Proc MakeMask    
    push bx

	mov si,1
    
@@again:
	shr bh,1
	cmp bh,0
	jz @@EndProc
	
	shl si,1 ; add 1 to si at right
	inc si
	
	jmp @@again
	
@@EndProc:
    pop bx
	ret
endp  MakeMask


Proc MakeMaskWord    
    push dx
	
	mov si,1
    
@@again:
	shr dx,1
	cmp dx,0
	jz @@EndProc
	
	shl si,1 ; add 1 to si at right
	inc si
	
	jmp @@again
	
@@EndProc:
    pop dx
	ret
endp  MakeMaskWord
;---------------------------------------------------------------------------------------------------
;מצייר קו אופקי בגודל וצבע מתאים
;---------------------------------------------------------------------------------------------------
proc DrawHorizonalLine
	push bp
	mov bp,sp
	
	mov cx,[lenth]
	push [x]
@@loopa:
	mov bh,0
	push cx
	mov cx,[x]
	mov dx,[y]
	mov al,[color1]
	mov ah,0ch
	int 10h
	inc [x]
	pop cx
	loop @@loopa
	pop [x]

	pop bp
	ret 8
endp DrawHorizonalLine

;---------------------------------------------------------------------------------------------------
;מצייר קו אנכי בגודל וצבע מתאים
;---------------------------------------------------------------------------------------------------
proc VerticalLine
	push bp
	mov bp,sp
	
	mov cx,[highet]
	push [y]
@@loopa:
	mov bh,0
	push cx
	mov cx,[x]
	mov dx,[y]
	mov al,[color1]
	mov ah,0ch
	int 10h
	inc [y]
	pop cx
	loop @@loopa
	pop [y]



	pop bp
	ret 8
endp VerticalLine
;;;;;;;;
;;;מקבלת: lenth,highet x,y,color
;;;;;;;
;---------------------------------------------------------------------------------------------------
;מצייר ריבוע לא מלא
;---------------------------------------------------------------------------------------------------
proc DrawRect
	push bp
	mov bp,sp
	mov ax,[bp+10]
	mov [x],ax;x
	mov ax,[bp+8]
	mov [y],ax;y
	mov ax,[bp+4]
	mov [color1],al;צבע
	mov ax,[bp+6]
	mov [lenth],ax;אורך
	mov ax,[bp+12]
	mov [highet],ax;גובה
	mov al,[color1]
	mov ah,0
	push [x];x
	push [y];y
	push [lenth];length
	push ax;color
	call DrawHorizonalLine
	mov al,[color1]
	mov ah,0

	push [x];x
	push [y];y
	push [highet];length
	push ax;color
	call VerticalLine
	mov dx,[lenth]
	dec dx
	mov al,[color1]
	mov ah,0
	add [x],dx
	push [x];x
	push [y];y
	push [highet];length
	push ax;color
	call VerticalLine
	mov dx,[lenth]
	dec dx
	sub [x],dx
	mov al,[color1]
	mov ah,0
	mov dx,[highet]
	dec dx
	add [y],dx
	push [x];x
	push [y];y
	push [highet];length
	push ax;color
	call DrawHorizonalLine


	
	pop bp
	ret 10
endp DrawRect
;;;;;;;;
;;;מקבלת: lenth,highet x,y,color
;;;;;;;
;---------------------------------------------------------------------------------------------------
;מצייר ריבוע מלא
;---------------------------------------------------------------------------------------------------
proc DrawFullRect
	push bp 
	mov bp,sp
	push [y]
	push [x]
	mov cx,[lenth]
@@loppp:
	mov al,[color1]
	mov ah,0
	push cx
	push [x];x
	push [y];y
	push [highet];length
	push ax;color
	call VerticalLine
	inc [x]
	pop cx
	loop @@loppp
	
	pop [x]
	pop [y]
	pop bp
	ret 
endp DrawFullRect
;---------------------------------------------------------------------------------------------------
;שומר מהמסך את הצבעים למשתנה - משומש לשמירת מאחורי השחקן כדי שהוא זז לא תמרח התמונה(שחקן 2)
;---------------------------------------------------------------------------------------------------
proc SaveUnderPlayer2 
	mov [timetorestore2],1
    mov ax, 0A000h
    mov es, ax                      ; ES = video memory
    mov si, 0                       ; SI = index into BackgroundBuffer

    mov bx, 285                   ; bx = ballx
    mov dx, [p2y]                 ; dx = bally
	mov [savep2yforrestore],dx 
    mov cx, 30        
@@SaveRowLoop:
    push cx

    mov ax, dx       ; ax = BallY
    mov cx, ax       ; שומרים עותק ב־cx

    shl ax, 8       
    shl cx, 6       
    add ax, cx       

    add ax, bx       ; ax = BallY * 320 + BallX
    mov di, ax       ; di = offset in video memory
    mov cx, 30
@@SaveColLoop:

    mov al, [byte es:di]
    mov [backp2 + si], al
    inc di
    inc si
	
    loop @@SaveColLoop

    inc dx        ; next row
    pop cx
    loop @@SaveRowLoop
    ret
endp SaveUnderPlayer2
;---------------------------------------------------------------------------------------------------
;מצייר למסר מתוך המשתנה שאליו הכנסנו את הרקע שמאחורי השחקן 2
;---------------------------------------------------------------------------------------------------
proc RestoreUnderPlayer2
	cmp [timetorestore2],0
	je @@wrongtime
push ax
    mov ax, 0A000h
    mov es, ax
    mov si, 0

    mov bx, 285    ; bx = BallX
    mov dx, [savep2yforrestore]    ; dx = BallY

    mov cx, 30
@@RestoreRowLoop:
    push cx

    mov ax, dx       ; ax = BallY
    mov cx, ax       ; שומרים עותק ב־cx

    shl ax, 8     
    shl cx, 6        
    add ax, cx       

    add ax, bx       ; ax = BallY * 320 + BallX
    mov di, ax
	
    mov cx, 30
@@RestoreColLoop:
    mov al, [backp2 + si]
	cmp al,0
	je @@dilug
    mov [es:di], al
@@dilug:
	inc si
    inc di
    loop @@RestoreColLoop

    inc dx       
    pop cx
    loop @@RestoreRowLoop
pop ax
@@wrongtime:
    ret
endp RestoreUnderPlayer2
;---------------------------------------------------------------------------------------------------
;שומר מהמסך את הצבעים למשתנה - משומש לשמירת מאחורי השחקן כדי שהוא זז לא תמרח התמונה(שחקן 1)
;---------------------------------------------------------------------------------------------------
proc SaveUnderPlayer1
	mov [timetorestore],1
    mov ax, 0A000h
    mov es, ax      ; ES = video memory
    mov si, 0       ; SI = index into BackgroundBuffer

    mov bx, 5        ; bx = ballx
    mov dx, [p1y]                 ; dx = bally
	mov [savep1yforrestore],dx 
    mov cx, 30                  
@@SaveRowLoop:
    push cx

    mov ax, dx       ; ax = BallY
    mov cx, ax       ; שומרים עותק ב־cx

    shl ax, 8     
    shl cx, 6    
    add ax, cx       

    add ax, bx       ; ax = BallY * 320 + BallX
    mov di, ax       ; di = offset in video memory
    mov cx, 30                     
@@SaveColLoop:

    mov al, [byte es:di]
    mov [backp1 + si], al
    inc di
    inc si
	
    loop @@SaveColLoop

    inc dx         ; next row
    pop cx
    loop @@SaveRowLoop
    ret
endp SaveUnderPlayer1
;---------------------------------------------------------------------------------------------------
;מצייר למסר מתוך המשתנה שאליו הכנסנו את הרקע שמאחורי השחקן 1
;---------------------------------------------------------------------------------------------------
proc RestoreUnderPlayer1
	cmp [timetorestore],0
	je @@wrongtime
push ax
    mov ax, 0A000h
    mov es, ax
    mov si, 0

    mov bx, 5    ; bx = BallX
    mov dx, [savep1yforrestore]    ; dx = BallY

    mov cx, 30
@@RestoreRowLoop:
    push cx

    mov ax, dx       ; ax = BallY
    mov cx, ax       ; שומרים עותק ב־cx

    shl ax, 8   
    shl cx, 6      
    add ax, cx

    add ax, bx       ; ax = BallY * 320 + BallX
    mov di, ax
	
    mov cx, 30
@@RestoreColLoop:
    mov al, [backp1 + si]
	cmp al,0
	je @@dilug
    mov [es:di], al
@@dilug:
	inc si
    inc di
    loop @@RestoreColLoop

    inc dx
    pop cx
    loop @@RestoreRowLoop
pop ax
@@wrongtime:
    ret
endp RestoreUnderPlayer1
;---------------------------------------------------------------------------------------------------
;מאתחל באפסים את המשתנה שמכיל את הרקע של שחקן 1
;---------------------------------------------------------------------------------------------------
proc RefreshBack1
	mov cx,961
	mov si,0
@@lop:
	mov [backp1+si],0
	inc si
	loop @@lop
	ret
endp RefreshBack1
;---------------------------------------------------------------------------------------------------
;מאתחל באפסים את המשתנה שמכיל את הרקע של שחקן 2
;---------------------------------------------------------------------------------------------------
proc RefreshBack2
	mov cx,961
	mov si,0
@@lop:
	mov [backp2+si],0
	inc si
	loop @@lop
	ret
endp RefreshBack2

;---------------------------------------------------------------------------------------------------
;שומר את הצבעים של המגרש מהמסך לתוך משתנה
;---------------------------------------------------------------------------------------------------
proc Savecourt
    mov ax, 0A000h
    mov es, ax       ; ES = video memory
    mov si, 0        ; SI = index into BackgroundBuffer

    mov bx, 0                 ; bx = ballx
    mov dx, 20                 ; dx = bally
    mov cx, 160             
@@SaveRowLoop:
    push cx

    mov ax, dx       ; ax = BallY
    mov cx, ax       ; שומרים עותק ב־cx

    shl ax, 8        
    shl cx, 6        
    add ax, cx      

    add ax, bx       ; ax = BallY * 320 + BallX
    mov di, ax       ; di = offset in video memory
    mov cx, 320            
@@SaveColLoop:

    mov al, [byte es:di]
    mov [courtBuffer + si], al
    inc di
    inc si
	
    loop @@SaveColLoop

    inc dx     ; next row
    pop cx
    loop @@SaveRowLoop
    ret
endp Savecourt
;---------------------------------------------------------------------------------------------------
;מצייר את המגרש על המסך מתוך משתנה המכיל את הצבעים של המגרש
;---------------------------------------------------------------------------------------------------
proc Restorecourt
push ax
    mov ax, 0A000h
    mov es, ax
    mov si, 0

    mov bx, 0   ; bx = BallX
    mov dx, 20    ; dx = BallY

    mov cx, 160
@@RestoreRowLoop:
    push cx

    mov ax, dx       ; ax = BallY
    mov cx, ax       ; שומרים עותק ב־cx

    shl ax, 8        
    shl cx, 6       
    add ax, cx      

    add ax, bx       ; ax = BallY * 320 + BallX
    mov di, ax
	
    mov cx, 320
@@RestoreColLoop:
    mov al, [courtBuffer + si]
	cmp al,0
	je @@dilug
    mov [es:di], al
@@dilug:
	inc si
    inc di
    loop @@RestoreColLoop

    inc dx     
    pop cx
    loop @@RestoreRowLoop
pop ax

    ret
endp Restorecourt
;---------------------------------------------------------------------------------------------------
;מאתחל באפסים את המשתנה שמכיל את הרקע של הכדור
;---------------------------------------------------------------------------------------------------
proc Refreshbackbuffer
	mov cx,81
	mov si,0
@@lop:
	mov [BackgroundBuffer+si],0
	inc si
	loop @@lop
	ret
endp Refreshbackbuffer

EndOfCsLbl:
END start


