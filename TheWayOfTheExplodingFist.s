.data
.include ".\Imagens\Fundos\abertura.s"
.include ".\Imagens\Fundos\fundo1.s"
.include ".\Imagens\Fundos\fundo2.s"
.include ".\Imagens\Fundos\fundo3.s"
.include ".\Imagens\Sprites\Saudacao\ola1.s"
.include ".\Imagens\Sprites\Saudacao\ola2.s"
.include ".\Imagens\Sprites\Saudacao\ola3.s"
.include ".\Imagens\Sprites\Saudacao\ola4.s"
#.include "Sonica.s"
Notas1: .word 60,2856,67,357,69,357,71,1428,71,357,71,357,62,2856,71,714,69,178,67,178,65,178,67,178,69,1785,62,2856,65,357,67,357,69,357,71,714,69,357,67,357,60,2856,65,535,64,357,65,178,67,1963,60,2856,64,357,67,178,65,178,67,178,69,178,67,178,71,357,74,535,75,357,74,178,62,2856,72,357,67,357,69,357,71,357,67,892,71,357,69,178,62,2856,67,357,71,535,65,535,69,535,63,357,65,178,67,178,60,2856,65,178,0,-1
Notas: .word 60,107,60,107,60,107,60,107,60,214,60,214,60,107,60,107,60,107,60,321,60,107,60,107,64,107,64,107,64,107,64,107,64,214,65,107,65,107,65,107,65,107,65,214,64,107,64,107,62,107,62,107,64,107,64,107,64,107,64,107,64,214,62,107,62,107,62,107,62,107,62,214,62,107,62,107,64,107,64,107,67,107,67,107,67,107,67,107,67,214,65,107,65,107,65,107,65,107,65,214,64,107,64,107,62,107,62,107,64,107,64,107,64,107,64,107,64,214,65,107,65,107,65,107,65,107,6,214,64,107,64,107,65,107,65,107,67,107,67,107,67,107,67,107,67,214,65,107,65,107,65,107,65,107,65,214,64,107,64,107,62,107,62,107,60,107,60,107,60,107,60,107,60,214,59,107,59,107,59,107,59,107,59,214,55,107,55,107,59,214,57,107,57,107,57,107,57,107,57,214,57,107,57,107,55,107,55,107,55,107,55,107,55,107,55,107,55,107,55,107,0,-1
Aperte: .string "Aperte 1 para iniciar"
#X0, Y0, P0, Img0, Frame, Anim, Size
Player: .word 52, 180, 0xff00E134, 0, 0, 0, 4
Enemy: .word 104, 180, 0xff00E168, 0, 0, 0, 4
AnimacoesPlayer: .word 0x10000000, 4
AnimacoesEnemy: .word 0x10000000, 4
Fundos: .word 0x10002000
Fundo: .word 0
Fase: .word 0
PontuacaoPlayer: .word 0
PontuacaoEnemy: .word 0
Score: .word 0
Tempo: .word 0
TempoMusica: .word 0
NotaAtual: .word 0
Input: .word 64, 0


.text	
.include "MACROSv21.s"
.include "Macros.s"	
		
Menu:	TelaInicial()
	Inicializacao() #Setagem de todos os arrays e valores salvos na mem�ria
	
FaseLoop:
	DesenharFundo()

	#ZerarPontua��o()
	la t0, PontuacaoPlayer #Endere�o da pontuaacao 0x10000022
	sw zero, (t0)

VidaLoop:

	#Reposicionar Jogadores()
	#anima��o de sauda��o
	#Medir tempo inicial
	
GameLoop:
	#IA() #Calcula pr�xima a��o da IA
	#a0=current time

InputLoop:
	Input() #Get input #####
	la t0, Notas
	PlayMusic(t0)
	#Pequeno delay
	li a7, 32
	li a0, 30
	ecall 
	
	li a7, 30
	ecall	#a0=tempo atual
	la t1, Tempo
	lw t0,0(t1) #t0 = tempo limite
	
	blt a0, t0, InputLoop #Checa se passaram x ms
	####Atualizar tempo futuro
	addi t0, a0, 300 #t0=currentTime+xms
	la t1, Tempo
	sw t0, 0(t1)
	
	Processamento() #Chamar a fun��o Processamento (Interpretar o input e o resultado da IA. escolher frames. checar hits)
	la t0, Player
	la t1, AnimacoesPlayer
	DesenharFrame(t0, t1)
	la t0, Enemy
	la t1, AnimacoesEnemy
	DesenharFrame(t0, t1)
	# Refresh Screen
	li a0 0xFF200604
	li a1 0
	sw a1 0(a0)
	li a1 1
	sw a1 0(a0)

	j GameLoop
ForaGameLoop:

	#Checar vitoria ou derrota
	la t1, PontuacaoPlayer
	lw t2, (t1) #(fundo,fase, pontua��o player, pontua��o enemy)
	li t0, 4
	bge t2, t0, Vitoria
	j VidaLoop
Vitoria:

	#Mudar Fundo
	#FaseAtual+=1
	#Dificuldade+=1
	j FaseLoop
Derrota:
	TelaFinal()
	
	li a7,10# exit
	ecall
.include "SYSTEMv21.s"