10 ORG 100H
20 JP MAIN
30RPTCHR EQU 0BFEEH
40GPF EQU 0BFD0H
50AOUT EQU 0BD09H
60PUTSTR EQU 0BFF1H
70WAITK EQU 0BFCDH
80LDPSTR EQU 0BD00H
90REGOUT EQU 0BD03H

100MAIN: CALL CLS
110 LD HL,DPSET
120 CALL STRLN
130 LD DE,0
140 CALL PUTSTR
150 CALL GTVRAM
160 LD A,12
170 LD (POSY),A
180 LD A,133
190 LD (POSX),A
200 CALL PSET
210 LD A,120
220 LD (POSX),A
230 LD A,22
240 LD (POSY),A
250 CALL PSET
260 CALL DSPLAY
270 CALL WAIT

280 LD HL,DHLINE
290 CALL STRLN
300 LD DE,0
310 CALL PUTSTR
320 CALL GTVRAM
330 LD A,32
340 LD (POSY),A
350MAIN00: LD A,100
360 LD (POSX),A
370 LD A,133
380 LD (ENDX),A
390 CALL HLINE
400 LD A,(POSY)
410 INC A
420 INC A
430 LD (POSY),A
440 CP 42
450 JP NZ,MAIN00
460 CALL DSPLAY
470 CALL WAIT

480 LD HL,DVLINE
490 CALL STRLN
500 LD DE,0
510 CALL PUTSTR
520 CALL GTVRAM
530 LD A,80
540 LD (POSX),A
550 LD A,28
560 LD (ENDY),A
570MAIN01: LD A,10
580 LD (POSY),A
590 CALL VLINE
600 LD A,(POSX)
610 INC A
620 INC A
630 LD (POSX),A
640 CP 90
650 JP NZ,MAIN01
660 CALL DSPLAY
670 CALL WAIT

680 CALL CLS
690 CALL CLVRAM
700 LD HL,RNDPNT
710 CALL STRLN
720 LD DE,0
730 CALL PUTSTR
740 CALL GTVRAM
750 LD B,8 ; 8 TIMES
760FILL01: PUSH BC
770 LD B,0 ; 256 TIMES
780FILL00: PUSH BC
790 CALL PRNG
800 LD D,143
810 CALL DVDX ; A = A % 143
820 LD (POSX),A
830 CALL PRNG
840 LD D,45
850 CALL DVDX ; A = A % 45
860 LD (POSY),A
870 CALL PSET
880 POP BC
890 DJNZ FILL00
900 POP BC
910 DJNZ FILL01
920 CALL DSPLAY
930 CALL WAIT

1900 RET

1950WAIT: CALL WAITK
1960 OR A
1970 JP Z,WAIT
1980 RET

2000CLS: LD B,144
2010 LD DE,0
2020CLS0: LD A,32
2030 CALL RPTCHR
2040 RET
2050CLLN: LD B,24
2060 LD E,0
2070 JP CLS0

2100CLVRAM: LD HL,VRAM0
2110 AND A
2120 LD B,144
2130CVRAM0: LD (HL),A
2140 INC HL
2150 DJNZ CVRAM0
2160 LD DE,VRAM1
2170 LD BC,144
2180 LD HL,VRAM0
2190 LDIR
2200 LD BC,288
2210 LD HL,VRAM0
2220 LDIR
2230 LD BC,288
2240 LD HL,VRAM0
2250 LDIR
2260 RET

2270VRAM0: DS 144
2280VRAM1: DS 144
2290VRAM2: DS 144
2300VRAM3: DS 144
2310VRAM4: DS 144
2320VRAM5: DS 144

2330GTVRAM: LD HL,VRAM0
2340 LD DE,0000H
2350 LD B,144
2360 CALL LDPSTR
2370 LD HL,VRAM1
2380 LD DE,0100H
2390 LD B,144
2400 CALL LDPSTR
2410 LD HL,VRAM2
2420 LD DE,0200H
2430 LD B,144
2440 CALL LDPSTR
2450 LD HL,VRAM3
2460 LD DE,0300H
2470 LD B,144
2480 CALL LDPSTR
2490 LD HL,VRAM4
2500 LD DE,0400H
2510 LD B,144
2520 CALL LDPSTR
2530 LD HL,VRAM5
2540 LD DE,0500H
2550 LD B,144
2560 CALL LDPSTR
2570 RET

2580DSPLAY: LD HL,VRAM0
2590 LD DE,0000H
2600 LD B,144
2610 CALL GPF
2620 LD HL,VRAM1
2630 LD DE,0100H
2640 LD B,144
2650 CALL GPF
2660 LD HL,VRAM2
2670 LD DE,0200H
2680 LD B,144
2690 CALL GPF
2700 LD HL,VRAM3
2710 LD DE,0300H
2720 LD B,144
2730 CALL GPF
2740 LD HL,VRAM4
2750 LD DE,0400H
2760 LD B,144
2770 CALL GPF
2780 LD HL,VRAM5
2790 LD DE,0500H
2800 LD B,144
2810 CALL GPF
2820 RET

3000BYTE: PUSH AF
3010 AND 0F0H
3020 RRCA
3030 RRCA
3040 RRCA
3050 RRCA
3060 CALL NIBBLE
3070 INC HL
3080 POP AF
3090 AND 15
3100 CALL NIBBLE
3110 INC HL
3120 RET
3130NIBBLE: SUB 10
3140 JP M,ZERO9
3150 ADD A,7
3160ZERO9: ADD A,58
3170 LD (HL),A
3180 RET

4000CALCXY: LD HL,VRAM0
4010 LD A,(POSY)
4020 SRL A
4030 SRL A
4040 SRL A ; Y / 8
4050 OR A
4060 JP Z,CALC00
4070 LD B,A
4080 LD DE,144
4090CALC01: ADD HL,DE
4100 DJNZ CALC01
4110CALC00: ; HL = beginning of line Y
4120 LD A,(POSX) ; x
4130 LD C,A
4140 LD B,0
4150 ADD HL,BC ; HL = exactly at pos x,y
4160 LD A,(POSY) ; y
4170 CALL DVD8 ; A = bit offset
4180 LD (REMNY),A
4190 OR A
4200 JP NZ,CALC02
4210 LD A,1
4220 JP CALC03
4230CALC02: LD B,A
4240 LD A,1
4250CALC04: SLA A; A << 1
4260 DJNZ CALC04
4270CALC03: LD B,A ; bit offset in B
4280 LD A,(HL) ; 8 bits in A
4290 RET ; Now do what you want with A (current bit pattern) and B (bit offset)

4380PSET: CALL CALCXY
4390 OR B ; set to black
4400 LD (HL),A
4440 RET

4450PUNSET: CALL CALCXY
4460 XOR B ; set to white
4470 LD (HL),A
4510 RET

4520PGET: CALL CALCXY
4530 AND B ; is it black?
4540 RET

4550HLINE: CALL PSET
4560 LD A,(ENDX)
4570 LD D,A
4580 LD A,(POSX)
4590 INC A
4600 LD (POSX),A
4610 CP D
4620 JP NZ,HLINE
4630 RET

4640VLINE: CALL PSET
4650 LD A,(ENDY)
4660 LD D,A
4670 LD A,(POSY)
4680 INC A
4690 LD (POSY),A
4700 CP D
4710 JP NZ,VLINE
4720 RET

4730POSX: DB 0
4740POSY: DB 0
4750ENDX: DB 0
4760ENDY: DB 0
4770REMNX: DB 0
4780CHARX: DB 0
4790REMNY: DB 0
4800CHARY: DB 0
4810BUFFER: DB 0,0,0,0,0,0
4815TMP: DB 0

4820HX2DEC: PUSH HL
4830 LD B,'0'
4840 LD (HL),B
4850HDEC00: LD (TMP),A
4860 CP 100
4870 JP M,HDEC01
4880 INC (HL)
4890 SUB 100
4900 JP HDEC00
4910HDEC01: INC HL
4920 LD B,'0'
4930 LD (HL),B
4940 LD A,(TMP)
4950HDEC02: LD (TMP),A
4960 CP 10
4970 JP M,HDEC03
4980 INC (HL)
4990 SUB 10
5000 JP HDEC02
5010HDEC03: INC HL
5020 LD A,(TMP)
5030 ADD A,48
5040 LD (HL),A
5050 POP HL ; remove heading 0s
5060 LD A,(HL)
5070 CP '0'
5080 JP NZ,HDEC05
5090 LD A,' '
5100 LD (HL),A
5110HDEC04: INC HL
5120 LD A,(HL)
5130 CP '0'
5140 JP NZ,HDEC05
5150 LD A,' '
5160 LD (HL),A
5170HDEC05: RET

6000 ; A <-- INPUT
6010 ; A --> REMAINDER. B --> QUOTIENT
6020DVD6: LD B,0
6030DVD6A: CP 6
6040 RET M
6050 SUB 6
6060 INC B
6070 JP DVD6A

6080DVD8: LD B,0
6090DVD8A: CP 8
6100 RET M
6110 SUB 8
6120 INC B
6130 JP DVD8A

6140DVDX: LD B,0
6150DVDXA: CP D
6160 RET M
6170 SUB D
6180 INC B
6190 JP DVDXA

6200STRLN: LD B,0
6210 PUSH HL ;preserve HL
6220STRLN0: LD A,(HL)
6230 OR A
6240 JP Z,STRLN1
6250 INC HL
6260 INC B
6270 JP STRLN0
6280STRLN1: POP HL ;restore HL
6290 RET

6300DPSET:  DB 'PSET         ',0
6310DHLINE: DB 'HLINE        ',0
6320DVLINE: DB 'VLINE        ',0
6340RNDPNT: DB 'Random points',0

7000 ; change Seed value for LCM PRNG
7010PRNG: PUSH DE
7020 PUSH HL
7030 LD DE,(RVAL16)
7040 LD H,E
7050 LD L,1
7060 ADD HL,DE
7070 ADD HL,DE
7080 ADD HL,DE
7090 ADD HL,DE
7100 ADD HL,DE
7110 LD A,H
7120 LD (RVAL16),HL
7130 POP HL
7140 POP DE
7150 LD A,(RVAL88)
7170 RET ; 0-255

7200RVAL16: DB 30H
7210RVAL88: DB 81H

7300DX: DB 0
7310DY: DB 0
7320MYD: DB 0


