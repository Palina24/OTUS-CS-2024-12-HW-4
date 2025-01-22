%include 'library.asm'
section .data
	arr dd 17, 21, 13, 17, 14, 13, 12, 20
	n		dd 8
	counter dd 0
			
section .text
global _start

_start:
	mov ecx, [n]
	dec ecx
	mov ebx, arr + 4
	push -1
	mov eax, [esp]
	call print_number
	
my_loop:
	mov eax, [ebx - 4] ;eax = вчера
	cmp eax, [ebx]		 ;[ebx] = сегодня
	jg today_colder    ; сегодня холоднее-> запис. вчера на экран и в стек 
	jmp today_warmer   ; сегодня теплее, чем вчера -> ищем в стеке ближ. тепл.
	
loop_step:	
	add ebx, 4
	dec ecx
	jnz my_loop
	call exit

today_colder:
	call print_number	
	push eax
	jmp loop_step

today_warmer:
	mov eax, [esp] ;eax = число из стека = искомая t или -1, если стек пустой
	cmp eax, -1
	je print_now

	cmp eax, [ebx] ;если в стеке теплее, печатаем число из стека
	jg print_now
	pop eax        ;если в стеке холоднее - выбрасываем число и см. следующее
	jmp today_warmer 
	

print_now:
	call print_number
	jmp loop_step