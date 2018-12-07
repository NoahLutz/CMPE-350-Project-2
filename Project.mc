# Microcode for 350-20181-II ISA

#00 Memory Read and PC Adjust 1
#  IR <-- M[PC]
#  PC <-- PC + 2
00:	PC_MemAddress, MemRead,
	PC_ALUA, Two_ALUB, Add, ALU_PC, PCWrite, IRWrite,
	Seq;

#01 Wait for decode
#	DispatchROM1
01: DispatchROM1;

#02 Load next word for long instruction
#	MDR <-- M[PC]
#	MAR <-- M[PC]
#	PC <-- PC + 2
02:	PC_MemAddress, MemRead, Mem_MDR, MDRWrite,
	PC_ALUA, Two_ALUB, Add, ALU_PC, PCWrite,
	Mem_MAR, MARWrite,
	DispatchROM2;

#03 Clear AC (op 0)
#	AC <-- 0
03:	Zero_AC, ACWrite,
	Fetch;
	
#04	Inc
#	AC <-- AC+1 (op 34)
04:	AC_ALUA, One_ALUB, Add, ALU_AC, ACWrite,
	Fetch;

#05 Dec
#	AC <-- AC-1 (op 33)
05:	AC_ALUA, One_ALUB, Subt, ALU_AC, ACWrite,
	Fetch;

#06 StoreDS (op 13)
#	DS <-- AC
06:	DSWrite,
	Fetch;

#07 LoadDS (op 25)
#	AC <-- DS
07:	DS_AC, ACWrite,
	Fetch;

#08 StoreCS (op 14)
#	CS <-- AC
08:	CSWrite,
	Fetch;

#09	LoadCS (op 27)
#	AC <-- CS
09:	CS_AC, ACWrite,
	Fetch;

#10	StoreSS (op 11)
#	SS <-- AC
10:	SSWrite,
	Fetch;

#11	LoadSS (op 19)
#	AC <-- SS
11:	SS_AC, ACWrite,
	Fetch;

#12 AddI (op 28)
#	AC <-- AC + SignExt(imm10)
12:	AC_ALUA, Imm10_ALUB, Add, ALU_AC, ACWrite,
	Fetch;

#13	AddIL (op 26)
#	AC <-- AC + Imm16
13:	AC_ALUA, MDR_ALUB, Add, ALU_AC, ACWrite,
	Fetch;
	
#14: LoadIL (op 21)
#	AC <-- Imm16
14: Mem_AC, ACWrite,
	Fetch;

#15: Jump (5)
#	PC <-- CS + Address10
15:	CS_ALUA, Imm10_ALUB, Add, ALU_PC, PCWrite,
	Fetch;
	
#16: load/store/jumpN/AddN/AddNDec/AddNInce address computation (op 35 15 4 20 17 18)
# 	MAR <- DS + Address10
16: DS_ALUA, Address10_ALUB, Add, ALU_MAR, MARWrite,
	DispatchROM2;
	
#17: Load (35)
#	AC <- M[MAR]
17:	MAR_MemAddress, MemRead, Mem_AC, ACWrite,
	Fetch;
	
#18 Store (15)
#	M[MAR] <- AC
18:	MAR_MemAddress, MemWrite, AC_Mem,
	Fetch;
	
#19 Add/subt load (32/31)
#	MDR <- M[MAR]
19: MAR_MemAddress, Mem_MDR, MemRead, MDRWrite,
	Seq;
	
#20 Add/subt (32/31)
#	AC <- AC +- MDR
20:	AC_ALUA, MDR_ALUB, Opcode0, ALU_AC, ACWrite,
	Fetch;

#21 Load next word for long instruction
#	MAR <-- M[PC]
#	PC <-- PC + 2
21:	PC_MemAddress, MemRead, Mem_MAR, MARWrite,
	PC_ALUA, Two_ALUB, Add, ALU_PC, PCWrite,
	DispatchROM2;

#22 AddL_Load (22)
#	MDR <- M[MAR]
22:	MAR_MemAddress, Mem_MDR, MemRead, MDRWrite,
	Seq;
	
#23 AddL (22)
#	AC <- AC + MDR
23:	AC_ALUA, MDR_ALUB, Add, ALU_AC, ACWrite,
	Fetch;
	
#24 JumpN (4)
#	PC <- M[MAR]
24:	MAR_MemAddress, MemRead, Mem_PC, PCWrite,
	Fetch;
	
#25 AddDec/Inc 1 (23/24)
#	MDR <- M[MAR]
25:	MAR_MemAddress, MemRead, Mem_MDR, MDRWrite,
	Seq;
	
#26	AddDec/Inc 2 (23/24)
#	AC <- AC + MDR
26:	AC_ALUA, MDR_ALUB, Add, ALU_AC, ACWrite,
	Seq;

#27 AddDec/Inc 3 (23/24)
#	MDR <- MDR +- 2
27:	MDR_ALUA, One_ALUB, Opcode0, ALU_MDR, MDRWrite,
	Seq;
	
#28 AddDec/Inc 4 (23/24)
#	M[MAR] <- MDR
28:	MDR_Mem, MAR_MemAddress, MemWrite,
	Fetch;

#29	AddDisp 1 (16)
#	MDR <- M[MAR]
29:	MAR_MemAddress, Mem_MDR, MDRWrite, MemRead,
	Seq;
	
#30	AddDisp 2 (16)
#	MAR <- MDR + SignExt(imm10)
30:	MDR_ALUA, Imm10_ALUB, Add, ALU_MAR, MARWrite,
	Seq;
	
#31 AddDisp 3 (16)
#	MDR <- M[MAR]
31:	MAR_MemAddress, Mem_MDR, MDRWrite, MemRead,
	Seq;
	
#32 AddDis 4 (16)
#	AC <- AC + MDR
32:	AC_ALUA, MDR_ALUB, Add, ALU_AC, ACWrite,
	Fetch;

#33 AddN 1 (20)
#	MAR <- M[MAR]
33:	MAR_MemAddress, Mem_MAR, MARWrite, MemRead,
	Seq;
	
#34	AddN 2 (20)
#	MDR <- M[MAR]
34:	MAR_MemAddress, Mem_MDR, MDRWrite, MemRead,
	Seq;

#35	AddN 3 (20)
#	AC <- AC + MDR
35: MDR_ALUB, AC_ALUA, Add, ALU_AC, ACWrite,
	Fetch;

#36 AddNDec/Inc 1 (17/18)
#	MAR <- M[MAR]
36:	MAR_MemAddress, Mem_MAR, MARWrite, MemRead,
	Seq;

#37 AddNDec/Inc 2 (17/18)
#	MDR <- M[MAR]
37:	MAR_MemAddress, Mem_MDR, MDRWrite, MemRead,
	Seq;
	
#38 AddNDec/AddNInc 3 (17/18)
#	AC <- AC + MDR
38: MDR_ALUB, AC_ALUA, Add, ALU_AC, ACWrite,
	Seq;

#39 AddNDec/AddNInc 4 (17/18)
#	MDR <- MAR +- 2
39:	MAR_ALUA, Two_ALUB, Opcode0, ALU_MDR, MDRWrite,
	Seq;
	
#40	AddNDec/AddNInc 5 (17/18)
#	MAR <- DS + Address10
40:	DS_ALUA, Address10_ALUB, Add, ALU_MAR, MARWrite,
	Seq;

#41 AddNDec/AddNInc 6 (17/18)
#	M[MAR] <- MDR
41:	MAR_MemAddress, MDR_Mem, MemWrite,
	Fetch;

#42	BrNeg (8)
#	PC <- PC + signExt(offset10)x2 (if AC < 0)
42:	PCWriteCondN, PC_ALUA, Offset10_ALUB, Add,
	Fetch;

#43	BrPos (6)
#	PC < PC + signExt(offset)x2 (if AC > 0)
43:	PCWriteCondP, PC_ALUA, Offset10_ALUB, Add,
	Fetch;

#44	BrZ (7)
#	PC <- PC + signExt(offset)x2 (if AC == 0)
44:	PCWriteCondZ, PC_ALUA, Offset10_ALUB, Add,
	Fetch;

