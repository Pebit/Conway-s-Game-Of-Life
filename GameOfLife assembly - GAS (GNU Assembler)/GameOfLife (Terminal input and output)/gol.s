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
	
	formatRead: .asciz "%d"
	formatPrint: .asciz "%d "
	newLine: .asciz "\n"
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

// printarea matricei
	movl $1, lindex
for_lines:
	movl lindex, %ecx
	cmp m, %ecx
	je sfprint
	
	movl $1, cindex
	for_columns:
		movl cindex, %ecx
		cmp n, %ecx 
		je cont_for_lines
		
		// prelucrarea efectiva
		movl lindex, %eax
		mull n
		addl cindex, %eax
		
		movl (%esi, %eax, 4), %ebx
		// afisam elementul din %ebx
		pushl %ebx
		push $formatPrint
		call printf
		pop %ebx
		pop %ebx
		
		pushl $0
		call fflush
		pop %ebx
		
		addl $1, cindex
		jmp for_columns
		
cont_for_lines:
	mov $4, %eax
	mov $1, %ebx
	mov $newLine, %ecx
	mov $2, %edx
	int $0x80
		
	addl $1, lindex
	jmp for_lines
sfprint:
//sfarsit printare matrice
	pushl $0
	call fflush
	pop %ebx
		
etexit:
	mov $1, %eax
	mov $0, %ebx 
	int $0x80
