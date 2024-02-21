;Boros Kevin, assembly 8086 project
;Program that divides a number to the sum of its digits and shows the remainder
;file name: drafth.asm
.model small
.stack 200h
.data
       num dw 0   
	   mesajIntroduceti db 13,10,'Introduceti un numar intre [1;65535]:$'
	   mesajGresit db 13,10,'Caracterul nu este un numar! Introduceti numarul din nou:$'	
	   mesajFinal db 13, 10,'Restul impartirii numarului la suma cifrelor sale este:$'
	   mesajZero db 13, 10,'Impartirea la 0 este imposibila! Introduceti alt numar:$'
	   mesajMacro db 13, 10,'Calculul a luat sfarsit. Pentru a inchide programul apasati enter sau esc.$'
	   mesajMacrodoi db, 13, 10,'Alternativ apasati backspace pentru introduce un alt numar:$'
	   mesajOverflow db, 13, 10,'Numarul este prea mare! Incercati din nou:$'
.code

    afiseazaMesaj proc 
	 mov ah, 09h
	 int 21h
	 jmp initializare
	endp
	
    main:
	
	 mov ax, @data
	 mov ds, ax
	
	 mov dx, offset mesajIntroduceti
     call afiseazaMesaj
	
    initializare: ;initializare registrii, eticheta va fi reapelata
	 mov dx, 0
	 mov cx, 10
	 mov bx, 0
	
	citireCifra:
	 mov ah, 01h
	 int 21h
	 cmp al, 13
	 je poateZero
	 cmp al, 30h
	 jb gresit
	 cmp al,39h 
	 ja gresit
	 sub al, 48
	 mov bl, al
	 mov ax, dx
	 mul cx
	 jo overflow
	 add ax, bx
	 mov dx, ax
	 
	jmp citireCifra
	
	poateZero: ;verificam impartirea cu 0 inainte de toate
	 cmp dx, 0
	 jne gataNumarul
	 mov dx, offset mesajZero
	 call afiseazaMesaj
	
	gataNumarul:
	 mov num, dx
     mov ax, dx
	 mov bx, 10
	 mov cx, 0
	
	descompunePtAdunare:
	 mov dx, 0
	 div bx
	 push dx
	 inc cx
	 cmp ax, 0
	 je faozero
	 jmp descompunePtAdunare
	
	pragPentruSfarsit: ;relative jump out of range
	 jmp main
	
	faozero: ;avem nevoie ca bx sa fie 0, dar inainte de loop
	 mov bx, 0
	
	adunareCifre:
	 pop dx 
	 add bx, dx
	 
	 loop adunareCifre
	
	
	impartirea:
	 mov dx, 0
	 mov ax, num
	 div bx
	
	 mov bx, 10
	 mov cx, 0
	 mov ax, dx
	 
	descompuneRest:
	 mov dx, 0
	 div bx
	 push dx
	 inc cx
	 cmp ax, 0
	 je lolzmndea 
	 jmp descompuneRest
	
    lolzmndea:
	 mov dx, offset mesajFinal
	 mov ah, 09h
	 int 21h
	
	afiseazaRest:
	 pop dx
	 add dl, 48
	 mov ah, 02h
	 int 21h
	
	 loop afiseazaRest
	 jmp sfarsit
	
	gresit:
	 mov dx, offset mesajGresit
	 call afiseazaMesaj
	
	overflow:
	 mov dx, offset mesajOverflow
	 call afiseazaMesaj
	
	sfarsit:
	
	mesaj macro final
     mov dx, offset final 
	 mov ah, 09h
	 int 21h
	endm 	
    	
	mesaj mesajMacro
	mesaj mesajMacrodoi
	
	ciclu:
	 mov ah, 01h
	 int 21h
	 cmp al, 13
	 je incheiereProgram
	 cmp al, 27
	 je incheiereProgram
	 cmp al, 8
	 je pragPentruSfarsit
	 jmp ciclu
	
    incheiereProgram:	
	 mov ah, 4ch
     int 21h
	
end main




