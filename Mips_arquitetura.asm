.data
	menu: .asciiz "		ESCOLHA UMA DAS OP��ES ABAIXO\n1- REGISTRAR DESPESAS PESSOAIS\n2- LISTAR DESPESAS\n3- EXCLUIR DESPESAS\n4- EXIBIR GASTOS MENSAIS\n5- EXUIBIR GASTOS POR CATEGORIA\n6- EXIBIR RANKING DE DESPESAS"
	digitar: .asciiz "\n\nDigite a op��o: "
	vetor: .space 400
	contador: .word -4
	ler: .space 16
	table: .asciiz "\t"
	new_line: .asciiz "\n"
	opcaodedia: .asciiz "Dia/mes/ano:  "
	barra: .asciiz "/"
	opcaodecategoria: .asciiz "\nDigite a categoria:  "
	opcaodevalor: .asciiz "\nDigite o valor da despesa:"
	opcaodeid: .asciiz "\nDigite um numero para o id:  "
	continuardigitando: .asciiz "\nDeseja continuar cadastrando?  (1) SIM  (2)N�O"
	opcaodeidexclusao: .asciiz "\nDigite um numero para o id exclus�o:  "
#aosdijaoisdjajdo
.text
Inicio:
	#PRINTAR O MENU
	addi $v0, $zero, 4
	la $a0, menu
	syscall

	#ESCOLHA DA OP��O
	addi $v0, $zero, 4
	la $a0, digitar
	syscall
	addi $v0, $zero, 5
	syscall
	addi $t0, $v0, 0

	beq $t0, 1, L1
	beq $t0, 2, L2
	beq $t0, 3, L3
################################################################   1 PARTE #########################################################
L1:
	#pegar o valor do ultimo na pilha
	lw $s0, contador($0)

	#chamar a string de ID
	addi $v0, $zero, 4
	la $a0, opcaodeid
	syscall
	#chamar a leitura da data
	addi $v0, $zero, 5
	syscall
	#salva a leitura em um registrador temporario S1
	addi $s1, $v0, 0

	#salvar no meu vetor
	addi $s0, $s0, 4
	sw $s1, vetor($s0) #salva na posi��o 0
#-----------------------------------------------------------------------------------------------
	#chamar a string de categoria
	addi $v0, $zero, 4
	la $a0, opcaodecategoria
	syscall
	#chamar a leitura da categoria
	#la $a0, ler
	addi $s0,$s0,4 #salva a partir da posi 4
	li $v0, 8
  	li $a1, 16
  	la $a0,vetor($s0)
  	syscall
	
	la $t8, vetor($s0)
	li $v0, 4
	la $a0, ($t8)
	syscall
	
#--------------------------------------------------------------------------------------------
	#chamar a string de valor
	addi $v0, $zero, 4
	la $a0, opcaodevalor
	syscall
	#chamar a leitura do valor
	addi $v0, $zero, 5
	syscall
	#salva a leitura em um registrador temporario S1
	addi $s1, $v0, 0
	#salvar no meu vetor
	addi $s0, $s0, 16 #20
	sw $s1, vetor($s0)
#--------------------------------------------------------------------------------------------
	#chamar a string de data
	addi $v0, $zero, 4
	la $a0, opcaodedia
	syscall
	#chamar a leitura do dia
	addi $v0, $zero, 5
	syscall
	#salva a leitura em um registrador temporario S1
	addi $s1, $v0, 0
	#salvar no meu vetor
	addi $s0, $s0, 4 #24
	sw $s1, vetor($s0)
	
	addi $v0, $zero, 4
	la $a0, barra
	syscall
	#chamar a leitura do mes
	addi $v0, $zero, 5
	syscall
	addi $s1, $v0, 0
	addi $s0,$s0,4   #28
	sw $s1, vetor($s0)
	
	addi $v0, $zero, 4
	la $a0, barra
	syscall
	
	#chamar a leitura do ano
	addi $v0, $zero, 5
	syscall
	addi $s1, $v0, 0
	addi $s0,$s0,4  #32
	sw $s1, vetor($s0)
	
	#------------------------------------------------------------
	#Jogar o ultimo valor variavel
	sw $s0, contador($0)
	#adicionei para testes printar o contador
	lw $a0, contador($0)
	addi $v0, $zero, 1
	addi $a0, $a0, 0
	syscall
	
	#Fazer a escolha se deseja cadastrar mais
Escolha_errada:
	addi $v0, $zero, 4
	la $a0, continuardigitando
	syscall
	#leitura para escolha 
	addi $v0, $zero, 5
	syscall
	
	addi $s0, $v0, 0
	beq $s0, 1, L1
	beq $s0, 2, Inicio
	j Escolha_errada

#################################################################  2 PARTE  ########################################################
	#printaaaaa vetor
	
L2: #printar o vetor
	lw $t0, contador($0)
	li $t1,-4
	beq $t0, $t1, print_fim
	
	addi $s0, $zero, -4
l2_1:
  #printa o ID
  	addi $s0, $s0, 4
	lw $t1, vetor($s0)
	#printtt
	addi $v0, $zero, 1
	addi $a0, $t1, 0
	syscall
	addi $v0, $zero, 4
	la $a0, table
	syscall
  #printa a categoria (STRING)
	addi $s0, $s0, 4
	add $s4, $zero, $s0
  	la $t0,vetor    # aqui
 	add $s0,$t0,$s0
	la $t0, 0($s0)

	li $v0, 4
	la $a0, ($t0)
	syscall

	li $v0, 4
	la $a0, table
	syscall

   #printar o valor da despeza
	addi $s4, $s4, 16
  	addi $s0, $s4, 0
	la $t0, vetor
  	add $s0,$t0,$s0
  	lw $t0, 0($s0)

	li $v0, 1
	la $a0, ($t0)
	syscall

	addi $v0, $zero, 4
	la $a0, table
	syscall
  #printar a dia
 	addi $s4, $s4, 4
  	addi $s0,$s4,0
	lw $t1, vetor($s0)
	addi $v0, $zero, 1
	addi $a0, $t1, 0
	syscall
	
	addi $v0, $zero, 4
	la $a0, barra
	syscall

#printar mes

	addi $s4, $s4, 4
  	addi $s0,$s4,0
	lw $t1, vetor($s0)
	addi $v0, $zero, 1
	addi $a0, $t1, 0
	syscall
	
	addi $v0, $zero, 4
	la $a0, barra
	syscall

#printar ano

	addi $s4, $s4, 4
  	addi $s0,$s4,0
	lw $t1, vetor($s0)
	addi $v0, $zero, 1
	addi $a0, $t1, 0
	syscall
	
	addi $v0, $zero, 4
	la $a0, new_line
	syscall
  	addi $s0,$s4,0

print_fim:
#condi��o para continuar if maior que
	lw $t4, contador($0)
	blt $s4, $t4, l2_1
	j Inicio

#--\-\\-\-\-\--\\\\--\---\-\-\-\-\-\-\-\-\-\-\-\-\--\-\-\-\-
#------------------exclus�o----------------------------

L3:
	addi $v0, $zero, 4
	la $a0, opcaodeid
	syscall
	
	addi $v0,$zero,5
	syscall
	add $a0,$v0,$zero
	
	addi $s0,$zero,0
	l3_loop:
	
	lw $t0,vetor($s0)
	beq $a0,$t0,excluir
	
	addi $s0,$s0,36
	j l3_loop

excluir:
	
	lw $t2,contador($0)
	addi $t2,$t2,-32
	addi $t6,$t2,-4
	sw $t6,contador($0)
	addi $t3,$zero,36
	
excluir_loop:
	
	lb $t4,vetor($t2)
	sb $t4,vetor($s0)
	
	addi $t3,$t3,-1
	addi $t2,$t2,1
	addi $s0,$s0,1
	bgt $t3,0,excluir_loop
	#qq coisa usar flag
	
excluir_fim:
j Inicio
	
	
	
	
	
	
	
	
	
	
	
	
	
	