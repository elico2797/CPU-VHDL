#-------------------- MEMORY Mapped I/O -----------------------
#define PORT_LEDG[7-0] 0x800 - LSB byte (Output Mode)
#define PORT_LEDR[7-0] 0x804 - LSB byte (Output Mode)
#define PORT_HEX0[7-0] 0x808 - LSB byte (Output Mode)
#define PORT_HEX1[7-0] 0x80C - LSB byte (Output Mode)
#define PORT_HEX2[7-0] 0x810 - LSB byte (Output Mode)
#define PORT_HEX3[7-0] 0x814 - LSB byte (Output Mode)
#define PORT_SW[7-0]   0x818 - LSB byte (Input Mode)
#define PORT_KEY[3-1]  0x81C - LSB nibble (3 push-buttons - Input Mode)
#--------------------------------------------------------------
#define UCTL           0x820 - Byte 
#define RXBF           0x821 - Byte 
#define TXBF           0x822 - Byte 
#--------------------------------------------------------------
#define BTCTL          0x824 - LSB byte 
#define BTCNT          0x828 - Word 
#--------------------------------------------------------------
#define IE             0x82C - LSB byte 
#define IFG            0x82D - LSB byte
#define TYPE           0x82E - LSB byte
#---------------------- Register Mapping ----------------------
# $a0 - Byte To Sent
# $a1 - First Byte Address (argument for send data func)
# $a1 - Last Byte Address  (argument for send data func)
# $t0 - BT CTL update
# $t1 - IFG update
# $t2 - 0.5sec Timer flag
# $t3 - Sys Output
# $t4 - Address Of Send Data
# $t6 - Length Of String
# $t7 - UART Status (Check If Busy)
# $s0 - State (Operation Mode)  - update by interrupt
# $s1 - Current State 		- update by code
#---------------------- Data Segment --------------------------
.data 
	IV: 	.word main            # Start of Interrupt Vector Table
		.word UartRX_ISR
		.word UartRX_ISR
		.word UartTX_ISR
	        .word BT_ISR
		.word KEY1_ISR

	msg:	.word 0x0A 0x0D 0X47 0X72 0X65 0X61 0X74 0X20 0X53 0X75 0X63 0X63 0X65 0X73 0X73
	# msg = I love my Negev
	menu:	.word 0x0A 0x0D 0X54 0X68 0X65 0X20 0X4D 0X65 0X6E 0X75 0x0A 0x0D 0X31 0X2E 0X20 0X43 0X6F 0X75 0X6E 0X74 0X20 0X75 0X70 0X20 0X66 0X72 0X6F 0X6D 0X20 0X30 0X78 0X30 0X30 0X20 0X6F 0X6E 0X74 0X6F 0X20 0X4C 0X45 0X44 0X47 0X20 0X77 0X69 0X74 0X68 0X20 0X64 0X65 0X6C 0X61 0X79 0X20 0X30 0X2E 0X35 0X73 0X65 0X63 0x0A 0x0D 0X32 0X2E 0X20 0X43 0X6F 0X75 0X6E 0X74 0X20 0X64 0X6F 0X77 0X6E 0X20 0X66 0X72 0X6F 0X6D 0X20 0X30 0X78 0X46 0X46 0X20 0X6F 0X6E 0X74 0X6F 0X20 0X4C 0X45 0X44 0X52 0X20 0X77 0X69 0X74 0X68 0X20 0X64 0X65 0X6C 0X61 0X79 0X20 0X7E 0X30 0X2E 0X35 0X73 0X65 0X63 0x0A 0x0D 0X33 0X2E 0X20 0X43 0X6C 0X65 0X61 0X72 0X20 0X61 0X6C 0X6C 0X20 0X4C 0X45 0X44 0X73 0x0A 0x0D 0X34 0X2E 0X20 0X4F 0X6E 0X20 0X65 0X61 0X63 0X68 0X20 0X4B 0X45 0X59 0X31 0X20 0X70 0X72 0X65 0X73 0X73 0X65 0X64 0X2C 0X20 0X73 0X65 0X6E 0X64 0X20 0X74 0X68 0X65 0X20 0X6D 0X61 0X73 0X73 0X61 0X67 0X65 0X20 0X201C 0X49 0X20 0X6C 0X6F 0X76 0X65 0X20 0X6D 0X79 0X20 0X4E 0X65 0X67 0X65 0X76 0X201D 0x0A 0x0D 0X35 0X2E 0X20 0X53 0X68 0X6F 0X77 0X20 0X4D 0X65 0X6E 0X75 0x0A 0x0D
	# menu = Menu
	end:	.word 0x00
	
#---------------------- Code Segment --------------------------	
.text
main:	addi $sp,$zero,0x800 # $sp=0x800
	move $s0,$zero       # $s0=0
	move $s1,$zero       # $s1=0
	move $t4,$zero       # $t2=0
	move $t6,$zero       # $t2=0
	addi $t0,$zero,0x3F  
	sw   $t0,0x824       # BTIP=7, BTSSEL=3, BTHOLD=1
	sw   $0,0x828        # BTCNT=0
	sw   $0,0x82C        # IE=0
	sw   $0,0x82D        # IFG=0
	addi $t0,$zero,0x06  
	sw   $t0,0x824       # BTIP=6, BTSSEL=0, BTHOLD=0
	addi $t0,$zero,0x09
	sw   $t0,0x820       # UTCL=0x09 (SWRST=1,115200 BR)
	addi $t0,$zero,0x01  # BTIE and key 1-3 and tx is disabled
	sw   $t0,0x82C       # IE=0x3B
	ori  $k0,$k0,0x01    # EINT, $k0[0]=1 uses as GIE
	
	
#---------------------- FSM --------------------------
	
State0: addi $s1,$zero,0    # Check if State1
	bne  $s1,$s0,State1
	sw   $0,0x828        # BTCNT=0
	add $t3,$zero,$zero       # $t3=0
	sw   $t3,0x800 	     # write to PORT_LEDG[7-0]
	sw   $t3,0x804 	     # write to PORT_LEDR[7-0]
		
Sleep:	bne  $s1,$s0,State1
	addi $t8,$zero,0x01
	sw   $t8,0x82C       # IE=0x01 enable Rx
	j    Sleep		
			
State1: addi $s1,$zero,1	     # Check if State1
	bne  $s1,$s0,State2
	addi $t8,$zero,0x05
	sw   $t8,0x82C       # IE=0x03 enable Timer
	jal  UpCnt

State2: addi $s1,$zero,2	     # Check if State2
	bne  $s1,$s0,State3
	addi $t8,$zero,0x05
	sw   $t8,0x82C       # IE=0x03 enable Timer
	jal  DownCnt
	
State3: addi $s1,$zero,3	     # Check if State3
	bne  $s1,$s0,State4
	beq  $t4,$t6,State4
	addi $t8,$zero,0x03	
	sw   $t8,0x82C       # IE=0x03 enable k TX
	
State4: addi $s1, $zero,4
	bne $s1, $s0, State0
	bne $t4,$t6,print
	addi $t8,$zero,0x09
	sw   $t8,0x82C       # IE=0x0B enable key 1 
	j State4			
print:	addi $t8,$zero,0x0B
	sw   $t8,0x82C       # IE=0x0B enable key 1 
	j State4			
	
#---------------------- ISR --------------------------
		
KEY1_ISR:la   $a1, msg		# first byte address - prep for SendData
	move $t4,$a1	      # first byte address
	la   $a2,menu		# last byte address - prep for SendData
	move $t6,$a2          # last byte address 
	#addi $t8,$zero,0x0B
	#sw   $t8,0x82C       # IE=0x0B enable key  1 and TX 
	jr   $k1                # reti
				
BT_ISR:	addi $t2,$zero,1        # set timet 0.5 sec flag
        jr   $k1                # reti
 
               
UartRX_ISR:	lw   $t1,0x821          # read RXBUF
	sw   $t1,0x808
act1:	bne  $t1,0x31,act2	# value for action 1 - count up
	addi $s0,$zero,1 	# s0 = 1 if keyboard = 1
	jr   $k1                # reti
	
act2:	bne  $t1,0x32,act3      # value for action 2 - count down
	addi $s0,$zero,2	# s0 = 2 if keyboard =2
        jr   $k1                # reti
        
act3:   bne $t1, 0x34, act4 
	addi $s0, $zero, 4  	# s0 = 4 if keyboard =4
	jr   $k1        
	
act4:	bne  $t1,0x35,act0      # value for action 3 - SendData
	addi $s0,$zero,3	# s0 = 3 if keyboard =5
	la   $a1, menu		# first byte address - prep for SendData
	move $t4,$a1	      # first byte address
	la   $a2, end		# last byte address - prep for SendData
	move $t6,$a2          # last byte address 
        jr   $k1                # reti
        
act0:	addi $s0,$zero,0		# defult is action 0 - clr leds & sleep, $t1 = 0x33
        jr   $k1                # reti         
        
UartTX_ISR: beq $t4,$t6,Exit3    # check if there is more byte to send
	lw   $a0,0($t4)       # load byte of data to $a0
	sw   $a0,0x822          # write to TXBUF
	addi $t4,$t4,4	      # update address to next byte
 	jr   $k1               # reti
Exit3: addi $t8,$zero,0x01
	sw   $t8,0x82C       # IE=0x01 disable k TX         
	jr   $k1


         
#---------------------- Func --------------------------

UpCnt:  lw   $t0,0x824  
	andi $t0,$t0,0xFFDF   # BIT clr
	sw   $t0,0x824        # BTHOLD=0
	addi $t3,$zero,0
	sw   $t3,0x800
Loop1:	bne  $s1,$s0,Exit1
	beq  $t2,$zero,Loop1 # Wait for 0.5 Sec
	addi $t3,$t3,1
	sw   $t3,0x800
	move $t2,$zero
	beq  $s1,$s0,Loop1    # Check if State1
Exit1:	ori  $t0,$t0,0x0020   # BIT set
	sw   $t0,0x824        # BTHOLD=1
	jr   $ra 


DownCnt:lw   $t0,0x824        
	andi $t0,$t0,0xFFDF   # BIT clr
	sw   $t0,0x824        # BTHOLD=0
	addi $t3,$zero,0xFFFF
	sw   $t3,0x804
Loop2:	bne  $s1,$s0,Exit2
	beq  $t2,$zero,Loop2 # Wait for 0.5 Sec
	addi $t3,$t3,-1
	sw   $t3,0x804
	move $t2,$zero
	beq  $s1,$s0,Loop2    # Check if State1
Exit2:	ori  $t0,$t0,0x0020   # BIT set
	sw   $t0,0x824        # BTHOLD=1
	jr   $ra  


#---------------------- THE END --------------------------