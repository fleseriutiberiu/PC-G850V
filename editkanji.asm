10 ORG 400H
20 ; leaving space for RAMDISK.ASM
30 ; used as a debug tool
40 JP MAIN
50WSTSR EQU 0BFB2H
60CLOSSR EQU 0BCEBH
70OPENSR EQU 0BCE8H
80INITSR EQU 0871AH
90REGOUT EQU 0BD03H
100PUTSTR EQU 0BFF1H
110INKEY EQU 0BE53H
120PUTCHR EQU 0BE62H
130WAITK EQU 0BFCDH
140RPTCHR EQU 0BFEEH
150GPF EQU 0BFD0H
160LDPSTR EQU 0BD00H

170MAIN: CALL CLS
180 LD HL,FIRST
190 LD A,15
200 LD (KNUM),A ; CHAR #
210 LD (COLUMN),A ; COLUMN #
220 CALL INITSR
230 CALL OPENSR
240 LD HL,GREET
250 CALL WSTSR

260MAIN00: LD A,(KNUM)
270 CP 0
280 JP Z,MAIN01
290 LD B,A
300 LD DE,12
310MAIN02: ADD HL,DE
320 DJNZ MAIN02
330MAIN01: XOR A
340 LD (ROW),A
350 LD BC,12
360 LD DE,DBUF
370 LDIR
380MAIN06: LD HL,DBUF
390 LD DE,BUFFER
400 XOR A
410 LD (COLUMN),A
420MAIN05: LD A,(HL) ; CHAR DATA
430 AND 3
440 PUSH HL ; SAVE BACK DATA PTR
450 LD HL,PATERN
460 CP 0
470 JP Z,MAIN03
480 LD B,A
490MAIN04: INC HL
500 DJNZ MAIN04 ; INCREMENT PATERN PTR
510MAIN03: LD A,(HL) ; GET PATERN
520 POP HL ; GET BACK DATA PTR
530 LD (DE),A
540 INC DE
550 LD (DE),A
560 INC DE
570 LD (DE),A
580 INC DE
590 LD (DE),A
600 INC DE ; 4 COLUMNS
610 LD A,(HL) ; CHAR DATA
620 RRCA
630 RRCA ; 10765432
640 LD (HL),A
650 INC HL
660 LD A,(COLUMN) ; COLUMN COUNT
670 INC A
680 LD (COLUMN),A
690 CP 12
700 JP NZ,MAIN05
710 LD HL,BUFFER
720 LD B,48
730 LD E,0
740 LD A,(ROW)
750 LD D,A
760 CALL GPF ; DISPLAY

770 LD A,(ROW)
780 INC A
790 LD (ROW),A
800 CP 4 ; NIBBLE COUNT
810 JP NZ,MAIN06

820 LD HL,SECOND
830MAIN10: LD A,(KNUM)
840 CP 0
850 JP Z,MAIN11
860 LD B,A
870 LD DE,6
880MAIN12: ADD HL,DE
890 DJNZ MAIN12
900MAIN11: EX DE,HL
910 CALL UNPACK
920 LD A,4
930MAIN16: LD (ROW),A
940 LD HL,DBUF
950 LD DE,BUFFER
960 XOR A
970 LD (COLUMN),A

980MAIN15: LD A,(HL) ; CHAR DATA
990 AND 3
1000 PUSH HL ; SAVE BACK DATA PTR
1010 LD HL,PATERN
1020 CP 0
1030 JP Z,MAIN13
1040 LD B,A
1050MAIN14: INC HL
1060 DJNZ MAIN14 ; INCREMENT PATERN PTR
1070MAIN13: LD A,(HL) ; GET PATERN
1080 POP HL ; GET BACK DATA PTR
1090 LD (DE),A
1100 INC DE
1110 LD (DE),A
1120 INC DE
1130 LD (DE),A
1140 INC DE
1150 LD (DE),A
1160 INC DE ; 4 COLUMNS
1170 LD A,(HL) ; CHAR DATA
1180 RRCA
1190 RRCA ; 10765432

1200 LD (HL),A
1210 INC HL
1220 LD A,(COLUMN) ; COLUMN COUNT
1230 INC A
1240 LD (COLUMN),A
1250 CP 12
1260 JP NZ,MAIN15
1270 LD HL,BUFFER
1280 LD B,48
1290 LD E,0
1300 LD A,(ROW)
1310 LD D,A
1320 CALL GPF ; DISPLAY

1330 LD A,(ROW)
1340 INC A
1350 CP 6
1360 JP NZ,MAIN16 ; NIBBLE COUNT
1365 CALL WAITK

1370 LD HL,BUFFER
1380 LD B,48
1390 LD DE,0
1400 XOR A
1410 LD (POSX),A
1420 LD (POSX+1),A
1430 LD (POSY),A
1440 CALL LDPSTR
1450EDIT00: LD HL,BUFFER
1460 LD BC,(POSX)
1470 ADD HL,BC
1480 LD A,(POSY)
1490 AND 1
1500 CP 1 ; ODD LINE
1510 JP Z,EDIT01
1520 ; EVEN LINE: PRESERVE HIGH NIBBLE
1530 LD A,(HL)
1540 LD (TMP),A
1550 AND 0F0H
1560 LD B,A
1570 LD A,(HL)
1580 AND 0FH
1590 XOR 0FH
1600 OR B
1610 JP EDIT02
1620EDIT01: ; ODD LINE: PRESERVE LOW NIBBLE
1630 LD A,(HL)
1640 AND 0FH
1650 LD B,A
1660 LD A,(HL)
1670 AND 0F0H
1680 XOR 0F0H
1690 OR B
1700EDIT02: LD (HL),A
1710 INC HL
1720 LD (HL),A
1730 INC HL
1740 LD (HL),A
1750 INC HL
1760 LD (HL),A
1770 LD HL,BUFFER
1780 LD E,0
1790 LD A,(POSY)
1800 RRCA
1810 AND 0FH
1820 LD D,A
1830 LD B,48
1840 CALL GPF
1850 CALL VBWEHT

2080EDIT05: LD HL,BUFFER
2090 LD BC,(POSX)
2100 ADD HL,BC
2110 LD A,(TMP)
2120 LD (HL),A
2130 INC HL
2140 LD (HL),A
2150 INC HL
2160 LD (HL),A
2170 INC HL
2180 LD (HL),A
2190 LD HL,BUFFER
2200 LD E,0
2210 LD A,(POSY)
2220 RRCA
2230 AND 0FH
2240 LD D,A
2250 LD B,48
2260 CALL GPF
2270 CALL VBWEHT

2290 CALL INKEY
2300 CP 0
2310 JP Z,EDIT00
2320 CP 50H
2330 RET Z
2340 CP 51H
2350 RET Z
2360 CP 1
2370 RET Z
2380 CP 3AH
2390 RET Z
2400 CP 1FH ; DOWN
2410 JP Z,GODOWN
2420 CP 20H ; UP
2430 JP Z,GOUP
2440 CP 21H ; LEFT
2450 JP Z,GOLEFT
2460 CP 20H ; RIGHT
2470 JP Z,GORITE
2480 CP 1EH ; SPACE
2490 JP Z,SPACE

2500EDIT08: LD HL,AFTER1
2510 LD A,(POSY)
2520 CALL BYTE
2530 LD HL,AFTER0
2540 CALL WSTSR
2550 JP EDIT00

2560GODOWN: LD HL,BFR01
2570 LD A,(POSY)
2580 CALL BYTE
2590 LD HL,BFR00
2600 CALL WSTSR

2610 LD A,(POSY)
2620 INC A
2630 LD (POSY),A
2640 CP 12
2650 JP M,EDIT08
2660 XOR A
2670 LD (POSY),A
2680 JP EDIT08

2690GORITE: LD A,(POSX)
2700 INC A
2710 LD (POSX),A
2720 CP 12
2730 JP M,EDIT00
2740 XOR A
2750 LD (POSX),A
2760 JP EDIT00

2770GOUP: LD HL,BFR01
2780 LD A,(POSY)
2790 CALL BYTE
2800 LD HL,BFR00
2810 CALL WSTSR

2820 LD A,(POSY)
2830 DEC A
2840 LD (POSY),A
2850 CP 0FFH
2860 JP NZ,EDIT08
2870 LD A,11
2880 LD (POSY),A
2890 JP EDIT08

2900GOLEFT: LD A,(POSX)
2910 DEC A
2920 LD (POSX),A
2930 CP 0FFH
2940 JP NZ,EDIT00
2950 LD A,11
2960 LD (POSX),A
2970 JP EDIT00

2980SPACE: LD A,(POSY)
2990 AND 1
3000 CP 1 ; ODD LINE
3010 JP Z,EDIT03
3020 ; EVEN LINE: PRESERVE HIGH NIBBLE
3030 LD A,(TMP)
3040 AND 0F0H
3050 LD B,A
3060 LD A,(TMP)
3070 AND 0FH
3080 XOR 0FH
3090 OR B
3100 JP EDIT04
3110EDIT03: ; ODD LINE: PRESERVE LOW NIBBLE
3120 LD A,(TMP)
3130 AND 0FH
3140 LD B,A
3150 LD A,(TMP)
3160 AND 0F0H
3170 XOR 0F0H
3180 OR B
3190EDIT04: LD (TMP),A
3200 JP EDIT00

3210VBWEHT: LD B,250
3220BWEHT: PUSH BC
3230 CALL WEHT ; ~1 millisec
3240 POP BC
3250 DJNZ BWEHT
3260 RET

3270WEHT: LD B,241
3280WEHT0: NOP
3290 NOP
3300 NOP
3310 NOP
3320 NOP
3330 DJNZ WEHT0
3340 RET

3350CLS: LD B,144
3360 LD DE,0
3370CLS0: LD A,32
3380 CALL RPTCHR
3390 RET
3400CLLN: LD B,24
3410 LD E,0
3420 JP CLS0

3430UNPACK: ; HL = BUFFER
3440 LD HL,DBUF
3450 LD B,6 ; specific to this code
3460UNPAK0: LD A,(DE) ; DE = DATA
3470 AND 0F0H
3480 RLCA
3490 RLCA
3500 RLCA
3510 RLCA
3520 LD (HL),A
3530 INC HL
3540 LD A,(DE)
3550 AND 0FH
3560 LD (HL),A
3570 INC HL
3580 INC DE
3590 DJNZ UNPAK0
3600 RET

3610BYTE: PUSH AF
3620 AND 0F0H
3630 RRCA
3640 RRCA
3650 RRCA
3660 RRCA
3670 CALL NIBBLE
3680 INC HL
3690 POP AF
3700 AND 15
3710 CALL NIBBLE
3720 INC HL
3730 RET
3740NIBBLE: SUB 10
3750 JP M,ZERO9
3760 ADD A,7
3770ZERO9: ADD A,58
3780 LD (HL),A
3790 RET


3800FIRST:
3810 DB 020H,020H,020H,020H,020H,020H,020H,020H,020H,020H,020H,00H ; 一
3820 DB 02H,02H,02H,02H,02H,0FEH,0FEH,02H,02H,02H,02H,00H ; 丁
3830 DB 020H,020H,020H,0FFH,0FEH,010H,010H,010H,010H,010H,018H,00H ; 七
3840 DB 0CH,0CH,07CH,0CCH,0CH,08CH,0FFH,0EH,0CH,0CH,0CH,00H ; 丈
3850 DB 00H,02H,062H,062H,062H,062H,062H,062H,062H,02H,00H,00H ; 三
3860 DB 00H,00H,00H,00H,0FEH,0FFH,010H,010H,010H,010H,00H,00H ; 上
3870 DB 02H,02H,02H,02H,02H,0FEH,032H,022H,062H,0C2H,02H,00H ; 下
3880 DB 082H,0C2H,062H,032H,01AH,0FEH,016H,032H,062H,042H,082H,00H ; 不
3890 DB 00H,00H,0FEH,092H,092H,092H,092H,092H,0FEH,00H,00H,00H ; 且
3900 DB 08H,018H,0FEH,08H,08H,0FFH,088H,088H,0FFH,018H,08H,00H ; 世
3910 DB 00H,00H,0FEH,022H,022H,022H,022H,0E2H,021H,020H,020H,00H ; 丘
3920 DB 0F2H,012H,012H,092H,0D2H,07EH,0D2H,092H,012H,012H,0F2H,00H ; 丙
3930 DB 0FCH,0CCH,084H,084H,084H,0FFH,084H,084H,084H,0CCH,0FCH,00H ; 中
3940 DB 08H,028H,072H,0E8H,0BFH,08H,08H,08H,0F8H,00H,00H,00H ; 丸
3950 DB 040H,0E0H,07EH,042H,04EH,04AH,052H,042H,0FEH,0FEH,040H,00H ; 丹
3960 DB 00H,072H,072H,072H,0C9H,0FEH,0CEH,072H,072H,072H,00H,00H ; 主
3970 DB 060H,030H,0CH,07H,084H,0C4H,0FCH,08CH,00H,00H,00H,00H ; 久
3980 DB 02H,012H,012H,012H,012H,01EH,092H,0D2H,073H,031H,00H,00H ; 乏
3990 DB 020H,0AAH,0FAH,0AAH,0AAH,0FEH,0AAH,0ABH,0F9H,0A9H,0A8H,00H ; 乗
4000 DB 02H,082H,0C2H,062H,032H,01AH,0EH,06H,06H,00H,00H,00H ; 乙
4010 DB 08H,08H,08H,0FCH,01FH,08H,08H,0F8H,0F0H,00H,00H,00H ; 九
4020 DB 01EH,092H,0DEH,0F1H,0B9H,085H,0FEH,0FFH,00H,00H,00H,00H ; 乳
4030 DB 0FAH,0AAH,0AFH,0AAH,0FAH,018H,02EH,0A7H,0E4H,064H,04H,00H ; 乾
4040 DB 092H,092H,0FEH,0FFH,091H,091H,00H,0FFH,00H,00H,00H,00H ; 乱
4050 DB 02H,02H,02H,02H,02H,0F2H,012H,0AH,0EH,06H,00H,00H ; 了
4060 DB 082H,0DAH,0DAH,0D2H,0D6H,0FFH,0D2H,0D2H,0DAH,0DAH,082H,00H ; 事
4070 DB 00H,04H,04H,04H,04H,04H,04H,04H,04H,04H,00H,00H ; 二
4080 DB 02H,02H,0F2H,09EH,092H,092H,092H,092H,0F2H,02H,02H,00H ; 互
4090 DB 00H,022H,022H,0E2H,07EH,026H,022H,022H,0E2H,02H,00H,00H ; 五
4100 DB 088H,088H,0CCH,0FFH,088H,088H,088H,0FFH,0CCH,088H,088H,00H ; 井
4110 DB 02H,0FAH,09AH,0FEH,09AH,09AH,0FEH,09AH,09AH,0FAH,02H,00H ; 亜
4120 DB 08H,0F8H,08H,08H,0CH,0FH,0CH,08H,08H,08H,08H,00H ; 亡
4130 DB 064H,024H,014H,06CH,0C4H,07H,0C4H,06CH,01CH,034H,024H,00H ; 交
4140 DB 02H,05AH,07AH,06AH,06AH,06BH,0EAH,0EAH,0FAH,05AH,02H,00H ; 享
4150 DB 06H,076H,0F6H,096H,096H,097H,096H,096H,0D6H,076H,06H,00H ; 京
4160 DB 00H,00H,00H,0C0H,078H,01FH,070H,080H,00H,00H,00H,00H ; 人
4170 DB 00H,00H,0FEH,062H,022H,022H,022H,022H,022H,062H,0FEH,00H ; 日
4180 DB 00H,08H,088H,0C8H,068H,038H,0FFH,038H,068H,0C8H,088H,08H ; 本
4190 DB 00H,0D5H,0D5H,0D5H,055H,020H,0A9H,0BFH,0AFH,0A9H,0B9H,0A1H ; 語
4200 DB 00H,00H,00H,02H,082H,072H,03EH,070H,0C0H,00H,00H,00H ; 入
4210 DB 00H,08H,08H,08H,088H,0FFH,0CH,08H,08H,08H,0C8H,0F8H ; 力

4220SECOND:
4230 DB 00H,00H,00H,00H,00H,00H ; 一
4240 DB 00H,088H,08FH,030H,00H,00H ; 丁
4250 DB 00H,07H,07CH,0CCH,0C4H,070H ; 七
4260 DB 08CH,046H,033H,064H,0C8H,080H ; 丈
4270 DB 044H,044H,044H,044H,044H,040H ; 三
4280 DB 044H,044H,077H,044H,044H,040H ; 上
4290 DB 00H,00H,0FH,00H,00H,00H ; 下
4300 DB 00H,00H,0FH,00H,00H,00H ; 不
4310 DB 044H,074H,044H,044H,074H,040H ; 且
4320 DB 00H,0F4H,045H,044H,044H,040H ; 世
4330 DB 044H,074H,044H,047H,044H,040H ; 丘
4340 DB 0F3H,031H,00H,09H,09DH,070H ; 丙
4350 DB 00H,00H,0FH,00H,00H,00H ; 中
4360 DB 0C6H,031H,011H,00H,0F8H,0C6H ; 丸
4370 DB 0C3H,00H,00H,088H,0F7H,00H ; 丹
4380 DB 0CCH,0CCH,0CFH,0CCH,0CCH,0C0H ; 主
4390 DB 0C4H,063H,010H,01H,034H,0C0H ; 久
4400 DB 0C3H,036H,079H,088H,088H,080H ; 乏
4410 DB 0C4H,063H,01FH,013H,064H,0C0H ; 乗
4420 DB 075H,044H,044H,044H,044H,070H ; 乙
4430 DB 0C6H,031H,00H,07H,0F8H,0C6H ; 九
4440 DB 019H,0F1H,00H,03FH,088H,0E2H ; 乳
4450 DB 022H,0F2H,020H,0E9H,088H,0C2H ; 乾
4460 DB 0F4H,044H,04FH,0FH,088H,0E2H ; 乱
4470 DB 00H,088H,08FH,00H,00H,00H ; 了
4480 DB 02H,02AH,0AFH,022H,027H,00H ; 事
4490 DB 066H,066H,066H,066H,066H,060H ; 二
4500 DB 044H,054H,044H,047H,044H,040H ; 互
4510 DB 044H,047H,044H,044H,074H,040H ; 五
4520 DB 084H,030H,00H,0FH,00H,00H ; 井
4530 DB 045H,047H,054H,075H,045H,040H ; 亜
4540 DB 07H,044H,0CCH,0CCH,0CCH,040H ; 亡
4550 DB 08CH,046H,033H,036H,04CH,080H ; 交
4560 DB 033H,03BH,0BFH,033H,033H,030H ; 享
4570 DB 046H,018H,08FH,00H,016H,040H ; 京
4580 DB 0C6H,031H,00H,01H,036H,0C0H ; 人
4590 DB 00H,0F4H,044H,044H,044H,0F0H ; 日
4600 DB 03H,010H,033H,0F3H,030H,013H ; 本
4610 DB 0FH,044H,070H,0FCH,044H,0CFH ; 語
4620 DB 0CH,043H,010H,00H,013H,06CH ; 入
4630 DB 0CH,047H,010H,08H,088H,070H ; 力

4640TMP: DB 0
4650KCOUNT: DB 41
4660KNUM: DB 0
4670PATERN: DB 0, 0FH, 0F0H, 0FFH
4680COLUMN: DB 0
4690ROW: DB 0
4700DBUF: DEFS 12
4710BUFFER: DEFS 256
4720POSY: DB 0
4730POSX: DW 0
4740GREET: DB 13,10,'- Edit Kanji started -',13,10,0
4750BFR00: DB 'Before adjustment, posY = 0x'
4760BFR01: DB 0,0,13,10,0
4770AFTER0: DB 'After adjustment, posY = 0x'
4780AFTER1: DB 0,0,13,10,0

