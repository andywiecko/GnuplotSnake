#!/bin/gnuplot

# ===== SETTINGS =====
BORDER_R=+10
BORDER_L=-10
BORDER_T=+10
BORDER_B=-10
BORDER_OFFSET = 0.5

GAME_SPEED = 0.1
INITIAL_LENGTH = 5
POINTS = 0

POINTS = 0
TITLE ='set title  sprintf("Points: %g", POINTS)'
X=0.;
Y=0.
gx=1000
gy=1000

# ===== GNUPLOT SETTINGS =====
set macros
set key noautotitle
unset tics
set border dt 2
set size ratio 1
set xrange[BORDER_L-BORDER_OFFSET:BORDER_R+BORDER_OFFSET]
set yrange[BORDER_B-BORDER_OFFSET:BORDER_T+BORDER_OFFSET]


PLOT='p 1/0'
HEAD='set label 1 at X,Y point pointtype 5 ps 2'
XM='X=X-1;if (X<BORDER_L){X=BORDER_R}; XX[1] = X'
XP='X=X+1;if (X>BORDER_R){X=BORDER_L}; XX[1] = X'
YM='Y=Y-1;if (Y<BORDER_B){Y=BORDER_T}; YY[1] = Y'
YP='Y=Y+1;if (Y>BORDER_T){Y=BORDER_B}; YY[1] = Y'

EAT='if (X==gx && Y==gy) {POINTS = POINTS+1; unset label 9999; @TITLE; @gen }

GoLeft= '@XM;@HEAD;@UPDATE;@CANIBAL;@COPY_ARRAY;@PLOT;@EAT'
GoRight='@XP;@HEAD;@UPDATE;@CANIBAL;@COPY_ARRAY;@PLOT;@EAT'
GoUp=   '@YP;@HEAD;@UPDATE;@CANIBAL;@COPY_ARRAY;@PLOT;@EAT'
GoDown= '@YM;@HEAD;@UPDATE;@CANIBAL;@COPY_ARRAY;@PLOT;@EAT'

array XX[99];
array YY[99];
array OLD_XX[99];
array OLD_YY[99];

XX[1] = X
YY[1] = Y

# ===== GAME OVER =====
GAME_OVER='SPEED_X=0;SPEED_Y=0;\
 set label 10000 "GAME OVER" at graph 0.5,graph 0.55 center tc rgb "red";'

# ===== CANIBAL =====
CANIBAL='HITYOURSELF=0;\
do for [i=2:POINTS+INITIAL_LENGTH]{\
if (X==XX[i] && Y==YY[i]){ print "Game over!";@GAME_OVER}\
}'


# ===== INITIAL SNAKE =====
do for [i=2:INITIAL_LENGTH]{
 XX[i] = X-i+1;
 YY[i] = Y
 set label i at XX[i],YY[i] point pt 5 ps 2
}


COPY_ARRAY ='do for [i=1:99]{OLD_XX[i] = XX[i];OLD_YY[i] = YY[i];}'
@COPY_ARRAY

# ===== UPDATE TAIL =====
UPDATE='\
do for [i=2:INITIAL_LENGTH+POINTS]{\
 XX[i] = OLD_XX[i-1];\
 YY[i] = OLD_YY[i-1];\
 set label i at XX[i],YY[i] point pt 5 ps 2 front;\
}'



gen = 'gx=ceil((BORDER_R-BORDER_L)*rand(0))-BORDER_R;\
       gy=ceil((BORDER_T-BORDER_B)*rand(0))-BORDER_T;\
       set label 9999 at gx,gy point pt 7 lc rgb "green" back'


TURN_LEFT= 'if(SPEED_Y!=0){SPEED_Y=0;SPEED_X=-1};'
TURN_RIGHT='if(SPEED_Y!=0){SPEED_Y=0;SPEED_X=+1};'
TURN_UP=   'if(SPEED_X!=0){SPEED_X=0;SPEED_Y=+1};'
TURN_DOWN= 'if(SPEED_X!=0){SPEED_X=0;SPEED_Y=-1};'

# ===== KEY BINDING =====
bind Left  TURN_LEFT
bind Right TURN_RIGHT
bind Up    TURN_UP
bind Down  TURN_DOWN

@TITLE
@HEAD
@gen

SPEED_X = 1
SPEED_Y = 0

while (1){

 if (SPEED_X == 1) {@GoRight;}
 if (SPEED_X ==-1) {@GoLeft;}
 if (SPEED_Y == 1) {@GoUp;}
 if (SPEED_Y ==-1) {@GoDown;}
 pause GAME_SPEED

}

pause -1
