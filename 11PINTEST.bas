5 REM FOR G850
10 OPEN "COM1:"
20 DIM X$(0)*68
30*LOOP00: A=INP(&H6E)
40 IF (A AND 16)=0 THEN "RXRDY"
50 IF (A AND 8)=0 THEN "TXRDY"
60 IF (A AND 4)=0 THEN "TXEMP"
70 IF (A AND 32)=0 THEN "PERR"
80 IF (A AND 64)=0 THEN "OVWR"
90 IF (A AND 128)=0 THEN "FRME"
100*RXRDY: LOCATE 0,3: PRINT "Rx: "
110 INPUT # 1,X$(0)
120 LOCATE 0,4: PRINT X$(0)
130 PRINT #1, "Received "+X$(0)
140 GOTO "LOOP00"
150*TXRDY: LOCATE 0,4
160 PRINT #1, "TXRDY "
170 GOTO "LOOP00"
180*TXEMP: LOCATE 0,4
190 PRINT #1, "TXEMP "
200 GOTO "LOOP00"
210*PERR: LOCATE 0,4
220 PRINT #1, "PERR "
230 GOTO "LOOP00"
240*OVWR: LOCATE 0,4
250 PRINT #1, "OVWR "
260 GOTO "LOOP00"
270*FRME: LOCATE 0,4
280 PRINT #1, "FRME "
290 GOTO "LOOP00"

