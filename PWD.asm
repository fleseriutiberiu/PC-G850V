10 ORG 100H
20 JP MAIN
30PUTSTR EQU 0BFF1H
40WAITK EQU 0BFCDH
50RPTCHR EQU 0BFEEH
60MAIN: CALL CLS
70 LD DE, BUFFER
80 LD HL, 079C0H
90 LD BC, 8
100 LDIR
110 LD HL, BUFFER
120 LD B, 8
130 LD DE, 0000FH
140 CALL PUTSTR
150 LD HL, PWD
160 LD B, 4
170 LD DE, 0000AH
180 CALL PUTSTR
190MAIN0: CALL WAITK
200 CP 0
210 JP Z, MAIN0
220 RET

2000CLS: LD B, 144
2010 LD DE, 0
2020CLS0: LD A, 32
2030 CALL RPTCHR
2040 RET

3000BUFFER: DB 0,0,0,0,0,0,0,0
3010PWD: DB 'pwd:'

