# Microcode for 350-20181-II ISA

#00 Memory Read and PC Adjust 1
#  IR,MDR <-- M[PC]
#  PC <-- PC + 2
00:	PC_MemAddress, MemRead, Mem_MDR, MDRWrite,
	PC_ALUA, Two_ALUB, Add, ALU_PC, PCWrite, IRWrite,
	Seq;

#01 Wait for decode
#	DispatchROM1
01: DispatchROM1;

#02 Load next word for long instruction
#	MDR <-- M[PC]
#	PC <-- PC + 2
02:	PC_MemAddress, MemRead, Mem_MDR, MDRWrite,
	PC_ALUA, Two_ALUB, Add, ALU_PC, PCWrite,
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
