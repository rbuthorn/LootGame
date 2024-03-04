################# Robert Buthorn #################
################# rbuthorn ################
################# 112628833 #################

################# DO NOT CHANGE THE DATA SECTION #################


.data
arg1_addr: .word 0
arg2_addr: .word 0
num_args: .word 0
invalid_arg_msg: .asciiz "One of the arguments is invalid\n"
args_err_msg: .asciiz "Program requires exactly two arguments\n"
zero: .asciiz "Zero\n"
nan: .asciiz "NaN\n"
inf_pos: .asciiz "+Inf\n"
inf_neg: .asciiz "-Inf\n"
mantissa: .asciiz ""

.text
.globl hw_main
hw_main:
    sw $a0, num_args
    sw $a1, arg1_addr
    addi $t0, $a1, 2
    sw $t0, arg2_addr
    j start_coding_here

start_coding_here:

li $t1, 2
beq $t1, $a0, checkArgLength
li $v0, 4
la $a0, args_err_msg
syscall

li $v0, 10
syscall

checkArgLength:
lw $s0, 0($a1)
li $t1, 0   ##counter
li $t2, 2   ##counter end
li $t4, 0
for: 
lbu $t3, 0($s0)
addi $t1, $t1, 1  ##increment counter
beq $t3, $t4, checkValidArg1
addi $s0, $s0, 1 ##get next char in first arg
beq $t1, $t2, invalidArg
j for


invalidArg:
la $a0, invalid_arg_msg
li $v0, 4
syscall

li $v0, 10
syscall

checkValidArg1:

lw $s0, 0($a1)

lbu $t1, 0($s0)
li $t2, 'D'
li $t3, 'X'
li $t4, 'F'
li $t5, 'L'

beq $t1, $t2, stringToDec
beq $t1, $t3, hexToDec
beq $t1, $t4, hexToFP
beq $t1, $t5, lootGame

j invalidArg

stringToDec:

lw $s1, 2($t0)

li $t1, '0'
li $t2, '9'
li $t3, 0
li $t4, 0  ##counter

for1:
lbu $s0, 0($s1)
beq $s0, $t3, validArg2
bgt $s0, $t2, invalidArg
blt $s0, $t1, invalidArg
addi $s1, $s1, 1
addi $t4, $t4, 1
j for1

validArg2:

lw $s1, 2($t0)

li $t2, 1        ## t2 = 1
li $t5, 10      ## t5 = 10
li $t6, 0      ## t6 = sum
li $t7, 0
li $s2, 48

for2:
sub $t4, $t4, $t2
move $t3, $t4   ## t3 = string length changing, t4 = string length constant
add $t6, $t6, $t7
beqz $t4, exit
lbu $t1, 0($s1)
sub $t1, $t1, $s2
addi $s1, $s1, 1
move $t7, $t1

for3:
mul $t7, $t7, $t5   ## t1 = individual sums
sub $t3, $t3, $t2
beqz $t3, for2
j for3

exit:
lbu $t1, 0($s1)
sub $t1, $t1, $s2
add $t6, $t6, $t1

li $v0, 1
add $a0, $t6, $0
syscall

li $v0, 10
syscall


hexToDec:

lw $s1, 2($t0)
lbu $s0, 0($s1)
li $t1, '0'
bne $s0, $t1, invalidArg
addi $s1, $s1, 1
lbu $s0, 0($s1)
li $t1, 'x'
bne $s0, $t1, invalidArg
addi $s1, $s1, 1

##checks if hex is between 3-10 characaters
li $t1, 0  ##counter
li $t2, 0  ## null char checker
li $t3, 8
li $t4, 1

for4:
bgt $t1, $t3, invalidArg
lbu $s0, 0($s1)
beq $s0, $t2, checkCounter
addi $t1, $t1, 1
addi $s1, $s1, 1
j for4

checkCounter:
blt $t1, $t4, invalidArg

lw $s1, 2($t0)
addi $s1, $s1, 2
move $s4, $t1
li $t1, '0'
li $t2, '9'

for5:
lbu $s0, 0($s1)
beq $s0, $0, validHex
blt $s0, $t1, invalidArg
bgt $s0, $t2, checkIfAF
addi $s1, $s1, 1
j for5


checkIfAF:
li $t3, 'A'
li $t4, 'F'
blt $s0, $t3, invalidArg
bgt $s0, $t4, invalidArg
addi $s1, $s1, 1
j for5

validHex:
lw $s1, 2($t0)
addi $s1, $s1, 2
li $t2, 'A'
li $t3, '9'
li $s3, 0  ## binary representation of hex number
li $s5, 0  ## counter, s4 is limit

for6:
beq $s5, $s4, hexToBinDone
lbu $s0, 0($s1)
addi $s1, $s1, 1
addi $s5, $s5, 1
bge $s0, $t2, ConverterAF
ble $s0, $t3, Converter09

backToLoop:
li $t4, 8
and $s2, $s0, $t4
sll $s3, $s3, 1
beq $s2, $t4, hasOne0  ## if $s2 has a 1 in it, branch
back0:
li $t4, 4
and $s2, $s0, $t4
sll $s3, $s3, 1
beq $s2, $t4, hasOne1
back1:
li $t4, 2
and $s2, $s0, $t4
sll $s3, $s3, 1
beq $s2, $t4, hasOne2
back2:
li $t4, 1
and $s2, $s0, $t4
sll $s3, $s3, 1
beq $s2, $t4, hasOne3
j for6


hasOne0: 
addi $s3, $s3, 1
j back0
hasOne1: 
addi $s3, $s3, 1
j back1
hasOne2: 
addi $s3, $s3, 1
j back2
hasOne3: 
addi $s3, $s3, 1
j for6

ConverterAF:
li $t6, 55
sub $s0, $s0, $t6
j backToLoop

Converter09:
li $t6, 48
sub $s0, $s0, $t6
j backToLoop


hexToBinDone:
li $t2, 2147483648
and $t1, $s3, $t2

li $v0, 1
move $a0, $s3
syscall

li $v0, 10
syscall

hexToFP:

## check if string is 8 chars

lw $s1, 2($t0)
li $t1, 0  ## counter

for7:
lbu $s0, 0($s1)
beq $s0, $0, checkCounter1
addi $t1, $t1, 1
addi $s1, $s1, 1
j for7

checkCounter1:
li $t2, 8
bne $t1, $t2, invalidArg

##checks if 0-9 or A-F
checkValidHex1:
lw $s1, 2($t0)
li $t2, '0'
li $t3, '9'

for9:
lbu $s0, 0($s1)
beq $s0, $0, convertToHex
blt $s0, $t2, invalidArg
bgt $s0, $t3, checkIfAF2
addi $s1, $s1, 1
j for9


checkIfAF2:
li $t4, 'A'
li $t5, 'F'
blt $s0, $t4, invalidArg
bgt $s0, $t5, invalidArg
addi $s1, $s1, 1
j for9


convertToHex:
lw $s1, 2($t0)
li $t2, 'A'
li $t3, '9'
li $s3, 0  ## binary representation of hex number
li $s4, 8
li $s5, 0  ## counter, s4 is limit

for10:
beq $s5, $s4, hexDone
lbu $s0, 0($s1)
addi $s1, $s1, 1
addi $s5, $s5, 1
bge $s0, $t2, ConverterAF1
ble $s0, $t3, Converter091

backToLoop1:
li $t4, 8
and $s2, $s0, $t4
sll $s3, $s3, 1
beq $s2, $t4, hasOne00 ## if $s2 has a 1 in it, branch
back00:
li $t4, 4
and $s2, $s0, $t4
sll $s3, $s3, 1
beq $s2, $t4, hasOne11
back11:
li $t4, 2
and $s2, $s0, $t4
sll $s3, $s3, 1
beq $s2, $t4, hasOne22
back22:
li $t4, 1
and $s2, $s0, $t4
sll $s3, $s3, 1
beq $s2, $t4, hasOne33
j for10


hasOne00: 
addi $s3, $s3, 1
j back00
hasOne11: 
addi $s3, $s3, 1
j back11
hasOne22: 
addi $s3, $s3, 1
j back22
hasOne33: 
addi $s3, $s3, 1
j for10

ConverterAF1:
li $t6, 55
sub $s0, $s0, $t6
j backToLoop1

Converter091:
li $t6, 48
sub $s0, $s0, $t6
j backToLoop1


hexDone:
lw $s1, 2($t0)
li $t1, 0x80000000
li $t2, 0x0
li $t3, 8  ##counter limit
li $t4, 0  ##counter
li $t5, 2

for11:


exit2:
bne $s2, $t2, checkZero2

li $v0, 4
la $a0, zero
syscall

li $v0, 10
syscall

checkZero2:
lw $s1, 2($t0)
li $t1, 0x80000000
li $t2, 0x80000000
li $t3, 8  ##counter limit
li $t4, 0  ##counter
li $t5, 2

for12:
beq $t3, $t4, exit2
lbu $s0, 0($s1)
and $s2, $s0, $t1
addi $t4, $t4, 1
addi $s1, $s1, 1
div $t1, $t5
mflo $t1
j for12

exit3:
bne $s2, $t2, checkNegInf

li $v0, 4
la $a0, zero
syscall

li $v0, 10
syscall

checkNegInf:
lw $s1, 2($t0)
li $t1, 0x80000000
li $t2, 0xFF800000
li $t3, 8  ##counter limit
li $t4, 0  ##counter
li $t5, 2

for13:
beq $t3, $t4, exit4
lbu $s0, 0($s1)
and $s2, $s0, $t1

addi $t4, $t4, 1
addi $s1, $s1, 1
div $t1, $t5
mflo $t1
j for13

exit4:
bne $s2, $t2, checkPosInf

li $v0, 4
la $a0, inf_neg
syscall

li $v0, 10
syscall

checkPosInf:
li $t1, 0x7F800000
bne $t1, $s0, checkNAN1
li $v0, 4
la $a0, inf_pos
syscall
li $v0, 10
syscall

checkNAN1:
li $t1, 0x7F800001
li $t2, 0x7FFFFFFF
blt $s0, $t1, checkNAN2
bgt $s0, $t2, checkNAN2
li $v0, 4
la $a0, nan
syscall
li $v0, 10
syscall

checkNAN2:
li $t1, 0xFF800001
li $t2, 0xFFFFFFFF
blt $s0, $t1, notSpecial
bgt $s0, $t2, notSpecial
li $v0, 4
la $a0, nan
syscall
li $v0, 10
syscall

notSpecial:





lootGame:

lw $s1, 2($t0)
li $t1, '0'
li $t2, '9'
li $t5, 0
li $t6, 6

for20:
beq $t5, $t6, checkLetters
lbu $s0, 0($s1)
blt $s0, $t1, invalidArg
bgt $s0, $t2, invalidArg
addi $s1, $s1, 2
addi $t5, $t5, 1
j for20

checkLetters:
lw $s1, 2($t0)
li $t5, 0
li $t6, 6
li $t1, 'P'
li $t2, 'M'

for21:
beq $t5, $t6, verifiedLoot
lbu $s0, 1($s1)
bne $s0, $t2, checkIfP
here1:
addi $s1, $s1, 2
addi $t5, $t5, 1
j for21

checkIfP:
bne $s0, $t1, invalidArg
j here1

verifiedLoot:

li $t3, 48
li $t4, 'M'
lw $s1, 2($t0)
li $t5, 0
li $t6, 6

for22:
beq $t5, $t6, endLoot
lbu $t1, 0($s1)
sub $t1, $t1, $t3
addi $s1, $s1, 1
lbu $t2, 0($s1)
addi $s1, $s1, 1
addi $t5, $t5, 1
beq $t2, $t4, Merchant
sub $s2, $s2, $t1
j for22


Merchant:
add $s2, $s2, $t1
j for22

endLoot:
li $v0, 1
move $a0, $s2
syscall

li $v0, 10
syscall







