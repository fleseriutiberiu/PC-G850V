10 ORG 100H
20 JP MAIN
30INKEY EQU 089BEH
40PUTCHR EQU 08440H
50INITSR EQU 0871AH
60AOUT EQU 0BD09H
70OPENSR EQU 0BCE8H
80CLOSSR EQU 0BCEBH
90LRDSR EQU 0BD15H
100WAITK EQU 0BFCDH
110WCHRSR EQU 0BFAFH
120WSTSR EQU 0BFB2H
130A2HEX EQU 0F9BDH
140RPTCHR EQU 0BFEEH
150MAIN: CALL INITSR
160 CALL OPENSR
170 CALL CLS
180 LD HL, GREET
190 CALL STRLN
200 LD HL, GREET
210 CALL WSTSR
220 LD HL, GREET
230 LD DE, 00004H
240 CALL DSPSTR
250 LD HL, MENUM0
260 CALL STRLN
270 LD HL, MENUM0
280 LD DE, 00100H
290 CALL DSPSTR
300 LD HL, MENUM1
310 CALL STRLN
320 LD HL, MENUM1
330 LD DE, 00200H
340 CALL DSPSTR
350 LD HL, MENUM2
360 CALL STRLN
370 LD HL, MENUM2
380 LD DE, 00300H
390 CALL DSPSTR
400MAIN0: CALL WAITK
410 CP 002H
420 JP Z, THEEND
430 CP 005H
440 JP Z, RECV
450 JP MAIN0


980THEEND: CALL CLOSSR
990 RET

1000RECV: LD HL, RECVMS
1010 CALL STRLN
1020 LD HL, RECVMS
1030 LD DE, 00300H
1040 CALL DSPSTR
1050 LD HL, BUFFER
1060 CALL LRDSR
1070 LD HL, BUFFER
1080 CALL STRLN
1090 LD HL, BUFFER
1100 LD DE, 00400H
1110 CALL DSPSTR
1120 LD DE, 00300H
1130 CALL CLS1
1140 JP MAIN0
1150NM2DEC: LD BC,-10000
1160 CALL NMDC1
1170 LD BC,-1000
1180 CALL NMDC1
1190 LD BC,-100
1200 CALL NMDC1
1210 LD C,-10
1220 CALL NMDC1
1230 LD C,B
1240NMDC1: LD A,-1
1250NMDC2: INC A
1260 ADD HL,BC
1270 JR C, NMDC2
1280 SBC HL,BC
1290 ADD A,48
1300 LD (DE),A
1310 INC DE
1320 RET

1330CLS: LD B, 6
1340 LD DE, 0
1350CLS0: PUSH BC
1355 CALL CLS1
1360 INC D
1365 POP BC
1370 DJNZ CLS0
1380 RET

1390CLS1: LD B, 24
1400 LD A, 32
1410 CALL RPTCHR
1420 RET

1500DSPSTR: LD A, (HL)
1510 INC HL
1520 PUSH BC
1530 PUSH DE
1540 PUSH HL
1550 CALL PUTCHR
1560 POP HL
1570 POP DE
1580 POP BC
1590 INC E
1600 LD A, E
1610 SUB 24
1620 JP M, SKIP0
1630 INC D
1640 LD E, 0
1650SKIP0: DJNZ DSPSTR
1660 RET
1670BYTE: PUSH AF
1680 AND 0F0H
1690 RRCA
1700 RRCA
1710 RRCA
1720 RRCA
1730 CALL NIBBLE
1740 INC HL
1750 POP AF
1760 AND 15
1770 CALL NIBBLE
1780 INC HL
1790 RET
1800NIBBLE: SUB 10
1810 JP M, ZERO9
1820 ADD A, 7
1830ZERO9: ADD A, 58
1840 LD (HL), A
1850 RET
1860STRLN: LD B, 0
1870STRLN0: LD A, (HL)
1880 CP 0
1890 JP Z, STRLN1
1900 INC HL
1910 INC B
1920 JP STRLN0
1930STRLN1: RET


3000GREET: DB '- LoRa Messenger -',13,10,0
3010MENUM0: DB '[s]end    se[t]tings',13,10,0
3020MENUM1: DB '[r]eceive [q]uit',13,10,0
3030MENUM2: DB 'SELECT MENU',13,10,0
3030RECVMS: DB 'receiving...',0

3040BUFFER: DEFS 64
3050 DB 0,0,0,0


