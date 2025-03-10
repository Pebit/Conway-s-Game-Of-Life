// game of life
.data
	m: .space 4
	n: .space 4
	lindex: .space 4
	cindex: .space 4
	p: .space 4
	k: .space 4
	mat: .space 1600
	aux: .space 1600
	x: .space 4
	y: .space 4
	celulevi: .space 4
	kindex: .space 4
	
// variabile pt decriptare:
	operationDecider: .space 4
	mesaj:		.space 23
	vector:		.space 320
	caracterint:	.space 4
	vindex:		.space 4
	lenmesajcriptat:	.space 4
	
	newLine: .asciz "\n"
	hexprefix: .asciz "0x"
	hexa: .asciz "0123456789ABCDEF"
// format read si print
	formatRead: .asciz "%d"
	formatReadchar: .asciz "%s"
	formatPrint: .asciz "%d "
	formatPrintchar: .asciz "%c"

.text 

.global main

main:
//citim nr de linii si coloane	
	pushl $m
	push $formatRead
	call scanf
	pop %ebx
	pop %ebx

	pushl $n
	push $formatRead
	call scanf
	pop %ebx
	pop %ebx
	
// adaugam 1 pentru usurarea creeri metricei extinse
	addl $1, m
	addl $1, n

//initializam matricile cu 0
	lea mat, %edi
	lea aux, %esi
	movl $0, lindex
etfor0l:
	movl lindex, %ecx
	cmp m, %ecx
	jg iesirefor0
	
	movl $0, cindex
	etfor0c:
		movl cindex, %ecx
		cmp n, %ecx
		jg cont_etfor0l
		
		movl lindex, %eax
		mull n
		addl cindex, %eax
		movl $0, (%edi, %eax, 4)
		movl $0, (%esi, %eax, 4)
		
		addl $1, cindex
		jmp etfor0c

cont_etfor0l:	
	addl $1, lindex
	jmp etfor0l


iesirefor0:

// citim numarul de celule vi pe care le vom pregati
	pushl $p
	push $formatRead
	call scanf
	pop %ebx
	pop %ebx
	

	movl $0, lindex
etforp:
	movl lindex, %ecx
	cmp %ecx, p
	je iesireforp
	
	// citim coordonatele celulelor vi
	pushl $x
	push $formatRead
	call scanf
	pop %ebx
	pop %ebx
	
	pushl $y
	push $formatRead
	call scanf
	pop %ebx
	pop %ebx
	
	// le notam in matrice
	addl $1, x
	addl $1, y
	
	movl x, %eax
	mull n
	addl y, %eax
	movl $1, (%edi, %eax, 4)
	movl $1, (%esi, %eax, 4)
	
	
	addl $1, lindex
	jmp etforp
iesireforp:	

// citim numarul de loop-uri parcurse in joc
	pushl $k
	push $formatRead
	call scanf
	pop %ebx
	pop %ebx
	
// jocul efectiv
	movl $0, kindex
etfork:
	movl kindex, %ecx
	cmp k, %ecx
	je iesirefork
	// parcurgerea matricei neexpandate
		movl $1, lindex
	etforkl:
		movl lindex, %ecx
		cmp m, %ecx
		je cont_etfork
		
			movl $1, cindex
		etforkc:
			movl cindex, %ecx
			cmp n, %ecx
			je cont_etforkl
			
			//calculam numarul de celule vii din jurul celulei curente
			movl lindex, %ebx
			movl %ebx, x
			movl cindex, %ebx
			movl %ebx, y
			
			// celulevi =
			// mat[x-1][y]
			subl $1, x
			movl x, %eax
			mull n
			addl y, %eax
			movl (%edi, %eax, 4), %ebx
			movl %ebx, celulevi
			
			// + mat[x-1][y-1]
			subl $1, y
			movl x, %eax
			mull n
			addl y, %eax
			movl (%edi, %eax, 4), %ebx
			addl %ebx, celulevi
			
			// + mat[x-1][y+1]
			addl $2, y
			movl x, %eax
			mull n
			addl y, %eax
			movl (%edi, %eax, 4), %ebx
			addl %ebx, celulevi
			
			// + mat[x][y+1]
			addl $1, x
			movl x, %eax
			mull n
			addl y, %eax
			movl (%edi, %eax, 4), %ebx
			addl %ebx, celulevi
			
			// + mat[x][y-1]
			subl $2, y
			movl x, %eax
			mull n
			addl y, %eax
			movl (%edi, %eax, 4), %ebx
			addl %ebx, celulevi
			
			// + mat[x+1][y-1]
			addl $1, x
			movl x, %eax
			mull n
			addl y, %eax
			movl (%edi, %eax, 4), %ebx
			addl %ebx, celulevi
			
			// + mat[x+1][y]
			addl $1, y
			movl x, %eax
			mull n
			addl y, %eax
			movl (%edi, %eax, 4), %ebx
			addl %ebx, celulevi
			
			// + mat[x+1][y+1]
			addl $1, y
			movl x, %eax
			mull n
			addl y, %eax
			movl (%edi, %eax, 4), %ebx
			addl %ebx, celulevi
			
			// copiem valoarea celulei curente in matricea auxiliara
			movl lindex, %eax
			mull n
			addl cindex, %eax
			movl (%edi, %eax, 4), %ebx
			movl %ebx, (%esi, %eax, 4)
			
			// verificam daca celula este vie
			movl lindex, %eax
			mull n
			addl cindex, %eax
			movl (%edi, %eax, 4), %eax
			
			cmp $1, %eax
			jne et_verif_cel_moarta
			
			// verificam daca celula indeplineste conditiile de subpopulare
			movl celulevi, %ebx
			cmp $2, %ebx
			jge et_verif_suprapopulare
			
			movl lindex, %eax
			mull n
			addl cindex, %eax
			movl $0, (%esi, %eax, 4)
		
			// verificam daca celula indeplineste conditiile de suprapopulare
		et_verif_suprapopulare:
			movl celulevi, %ebx
			cmp $3, %ebx
			jle et_verif_cel_moarta
			
			movl lindex, %eax
			mull n
			addl cindex, %eax
			movl $0, (%esi, %eax, 4)
			
			// verificam daca celula este moarta
		et_verif_cel_moarta:
			movl lindex, %eax
			mull n
			addl cindex, %eax
			movl (%edi, %eax, 4), %eax
			
			cmp $0, %eax
			jne cont_etforkc
			
			// verificam daca celula indeplineste conditiile pentru creare
			movl celulevi, %ebx
			cmp $3, %ebx
			jne cont_etforkc
			
			movl lindex, %eax
			mull n
			addl cindex, %eax
			movl $1, (%esi, %eax, 4)
			
		cont_etforkc:
			addl $1, cindex
			jmp etforkc
	cont_etforkl:
		addl $1, lindex
		jmp etforkl
cont_etfork:

// copiem matricea din aux inapoi in mat pt a fi refolosita la urmatorul loop
	movl $1, lindex
etfor1l:
	movl lindex, %ecx
	cmp m, %ecx
	je iesirefor1l
	
	movl $1, cindex
	etfor1c:
		movl cindex, %ecx
		cmp n, %ecx 
		je cont_etfor1l
		
		movl lindex, %eax
		mull n
		addl cindex, %eax
		
		movl (%esi, %eax, 4), %ebx
		movl %ebx, (%edi, %eax, 4)
		
		addl $1, cindex
		jmp etfor1c
		
cont_etfor1l:
	addl $1, lindex
	jmp etfor1l
	
iesirefor1l:
	addl $1, kindex
	jmp etfork	

iesirefork:

// citim variabila care decide daca urmeaza o criptare sau o decriptare
	pushl $operationDecider 
	push $formatRead
	call scanf
	pop %ebx
	pop %ebx

// citim sirul care trebuie criptat sau decriptat
	push $mesaj
	push $formatReadchar
	call scanf
	pop %ebx
	pop %ebx
	
	movl operationDecider, %ecx
	cmp $0, %ecx
	jne iesirecriptare

//transformam fiecare caracter din string in binar si il adaugam in vector
	lea vector, %edi
	lea mesaj, %esi
	movl $0, x
	movl $0, y
whilemesaj:
	movl x, %ecx
	
	movl $0, %eax
	movb (%esi, %ecx, 1), %al
	cmp $0, %eax
	je iesiremesaj
	
	movl $0, %eax
	movb (%esi, %ecx, 1), %al
	movl %eax, caracterint
	//incarcam fiecare 8 biti cu codul ascii in binar al caracterului corespunzaator prin algoritmul cu impartirea la 2
	movl $7, vindex
	fortransbinar:
		movl vindex, %eax
		cmp $0, %eax
		jl contwhilemesaj
		
		//vector[y + vindex] = caracterint % 2
		movl y, %ebx
		addl vindex, %ebx
		movl caracterint, %eax
		movl $0, %edx
		movl $2, %ecx
		divl %ecx
		movl %edx, (%edi, %ebx, 4)
		
		//caracterint = caracterint / 2
		movl %eax, caracterint
		
		subl $1, vindex
		jmp fortransbinar
		
contwhilemesaj:
	addl $8, y
	addl $1, x
	jmp whilemesaj
	
iesiremesaj:
	
	movl y, %eax
	movl %eax, lenmesajcriptat
	
// xoram fiecare element din vectorul cu mesaj cu elementele din matricea extinsa game of life
	lea mat, %esi
	movl $0, x
	movl $0, y
	movl $0, vindex
parcurgereparalela:
	movl vindex, %eax
	cmp lenmesajcriptat, %eax
	jge iesireparcurgere
	
	// parcurgem in paralel vectorul si matricea
	// atunci cand indexul coloanelor matricei trece peste nr coloanelor se intoarce la prima coloana iar linia se incrementeaza
	movl y, %eax
	cmp n, %eax
	jle condrepetare
	
	movl $0, y
	addl $1, x
condrepetare:
	// atunci cand indexul liniilor depaseste nr liniilor matricei se intoarce la prima linie
	movl x, %eax
	cmp m, %eax
	jle contparcurgereparalela
	movl $0, x
contparcurgereparalela:
	// se xoreaza si rezultatul se pastreaza in vectorul "vector"
	movl vindex, %ebx
	movl x, %eax
	mull n
	addl y, %eax
	movl (%esi, %eax, 4), %ecx
	xor %ecx, (%edi, %ebx, 4)
	
	addl $1, y
	addl $1, vindex
	jmp parcurgereparalela
iesireparcurgere:
	// printam 0x pentru afisarea numarului in hex conform cerintei
	mov $4, %eax
	mov $1, %ebx
	mov $hexprefix, %ecx
	mov $2, %edx
	int $0x80
// parcurgem vectorul cu cifrul obtinut si il transformam in hexa
	lea hexa, %esi
	movl $0, x
parcurgerevector:
	movl x, %ecx
	cmp lenmesajcriptat, %ecx
	jge iesirecriptare
	
	movl $0, caracterint
	movl x, %eax
	movl (%edi, %eax, 4), %ebx
	cmp $1, %ebx
	jne poz1	
	addl $8, caracterint

poz1:
	incl x
	movl x, %eax
	movl (%edi, %eax, 4), %ebx
	cmp $1, %ebx
	jne poz2

	addl $4, caracterint
	
poz2:
	incl x
	movl x, %eax
	movl (%edi, %eax, 4), %ebx
	cmp $1, %ebx
	jne poz3
	
	addl $2, caracterint
poz3:
	incl x
	movl x, %eax
	movl (%edi, %eax, 4), %ebx
	cmp $1, %ebx
	jne afis
	
	addl $1, caracterint
afis:
	movl caracterint, %ecx
	movl $0, %eax
	movb (%esi, %ecx, 1), %al
	push %eax
	push $formatPrintchar
	call printf
	pop %ebx
	pop %ebx
	
	push $0
	call fflush
	pop %ebx
	
	incl x
	jmp parcurgerevector
	
iesirecriptare:

// pentru decriptare	
	movl operationDecider, %ecx
	cmp $1, %ecx
	jne iesiredecriptare
	
	lea mesaj, %esi
	
// x este 2 deoarece ignoram caracterele "0x"
	movl $2, x
	movl $0, y
	movl $0, caracterint
parcurgerehex:

	movl x, %ecx
	movb (%esi, %ecx, 1), %al
	
	cmp $0, %eax
	je sfarsitparcurgerehex
	
	// transformam in decimal

	cmp $57, %eax
	jg veriflitera
	subl $48, %eax
	jmp contparcurgerehex1

veriflitera:
cmp $65, %eax
	jl contparcurgerehex1
	subl $55, %eax

contparcurgerehex1:
	movl %eax, caracterint

	// transformam decimal in binar si punem binarul in vector
	movl y, %eax
	addl $3, %eax
	movl %eax, vindex
	lea vector, %edi
	
	whilebinar:
		movl vindex, %ecx
		cmp y, %ecx
		jl iesirewhilebinar
		
		movl $0, %edx
		movl caracterint, %eax
		movl $2, %ebx
		divl %ebx
		movl vindex, %ecx
		movl %edx, (%edi, %ecx, 4)
		movl %eax, caracterint
		
		subl $1, vindex
		jmp whilebinar
	iesirewhilebinar:
	addl $4, y
	addl $1, x
	jmp parcurgerehex
sfarsitparcurgerehex:
// xoram vectorul cu cheia (matricea game of life la al k-lea loop) pentru a descifram mesajul
	movl y, %eax
	movl %eax, lenmesajcriptat
	lea mat, %esi
	movl $0, x
	movl $0, y
	movl $0, vindex
parcurgereparalela2:
	movl vindex, %eax
	cmp lenmesajcriptat, %eax
	jge iesireparcurgere2
	
	// parcurgem in paralel vectorul si matricea
	// atunci cand indexul coloanelor matricei trece peste nr coloanelor se intoarce la prima coloana iar linia se incrementeaza
	movl y, %eax
	cmp n, %eax
	jle condrepetare2
	
	movl $0, y
	addl $1, x
condrepetare2:
	// atunci cand indexul liniilor depaseste nr liniilor matricei se intoarce la prima linie
	movl x, %eax
	cmp m, %eax
	jle contparcurgereparalela2
	movl $0, x
contparcurgereparalela2:
	// se xoreaza si rezultatul se pastreaza in vectorul "vector"
	movl vindex, %ebx
	movl x, %eax
	mull n
	addl y, %eax
	movl (%esi, %eax, 4), %ecx
	xor %ecx, (%edi, %ebx, 4)
	
	addl $1, y
	addl $1, vindex
	jmp parcurgereparalela2
iesireparcurgere2:
// luam cate 8 valori din vector si le transormam din binar in decimal si le afisam drept char
	movl $0, vindex
afisare:
	movl vindex, %ecx
	cmp lenmesajcriptat, %ecx
	je iesiredecriptare
	
	movl $0, caracterint
	addl $1, vindex
	movl vindex, %ecx
	movb (%edi, %ecx, 1), %al
	cmp $1, %eax
	jne pos2
	addl $64, caracterint
pos2:
	addl $1, vindex
	movl vindex, %ecx
	movl (%edi, %ecx, 4), %eax
	cmp $1, %eax
	jne pos3
	addl $32, caracterint
pos3:
	addl $1, vindex
	movl vindex, %ecx
	movl (%edi, %ecx, 4), %eax
	cmp $1, %eax
	jne pos4
	addl $16, caracterint
pos4:
	addl $1, vindex
	movl vindex, %ecx
	movl (%edi, %ecx, 4), %eax
	cmp $1, %eax
	jne pos5
	addl $8, caracterint
pos5:
	addl $1, vindex
	movl vindex, %ecx
	movl (%edi, %ecx, 4), %eax
	cmp $1, %eax
	jne pos6
	addl $4, caracterint
pos6:
	addl $1, vindex
	movl vindex, %ecx
	movl (%edi, %ecx, 4), %eax
	cmp $1, %eax
	jne pos7
	addl $2, caracterint
pos7:
	addl $1, vindex
	movl vindex, %ecx
	movl (%edi, %ecx, 4), %eax
	cmp $1, %eax
	jne afis2
	addl $1, caracterint
afis2:
	movl caracterint, %eax
	push %eax
	push $formatPrintchar
	call printf
	pop %ebx
	pop %ebx
	
	push $0
	call fflush
	pop %ebx
	
	addl $1, vindex
	jmp afisare
	
iesiredecriptare:
	mov $4, %eax
	mov $1, %ebx
	mov $newLine, %ecx
	mov $2, %edx
	int $0x80
	
	pushl $0
	call fflush
	pop %ebx
	
etexit:
	mov $1, %eax
	mov $0, %ebx 
	int $0x80
