# Microcode for 350-20181-II ISA

#00 Memory Read and PC Adjust 1
#  MDR <-- M[PC]
#  PC <-- PC + 2
00:  PC_MemAddress, MemRead, Mem_MDR, MDRWrite,
     PC_ALUA, Two_ALUB, Add, ALU_PC, PCWrite, IRWrite,
     Seq;

#01 Wait for decode
#	DispatchROM1
01: DispatchROM1;

#02 Clear AC
#	AC <-- 0
02:	Zero_AC, ACWrite,
	Fetch;
	
#03	Inc
#	AC <-- AC+1
03:	AC_ALUA, One_ALUB, Add, ALU_AC, ACWrite,
	Fetch;
