#M2 matrix = M1 transpose.
.data
overallsize: .word 64 # M2 = M^2 * 4 
M: .word 4
N: .word 16 # N = M * 4
matrix1: .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16

.text #lets find transpose
main:
lw $a0, M #a0 contatin M
la $t1, matrix1
lw $t4, overallsize
lw $t5 , N
add $t6, $zero, $zero
add $t2 , $t1, $t4
lw $t7, overallsize

loop: 
beq $t7, $zero, end
sub $t7, $t7, $t5
loop1:
beq $t6, $t5, rabbi  #finish first step, reaprt M times 
add $t6, $t6, $a0
lw $t3, ($t1)
sw $t3, ($t2)
add $t1, $t1, $t5 # promote t1 address of 16 to the next row 
add $t2, $t2, $a0 # promote t2 address of save, to appropiate place 
beq $zero, $zero, loop1
rabbi:
sub $t1, $t1, $t4
add $t1, $t1, $a0
add $t6, $zero,$zero
beq $zero, $zero, loop

end: nop
nop
nop
beq $zero, $zero,  end

 
