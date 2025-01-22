%include 'library.asm'
section .data
	arr dd 1, 0, 1, 0, 0, 0, 1, 1
	n		dd 8
	g_max  dd 0
	l_max  dd 0	
		
section .text
global _start

_start:
	mov ecx, [n]
	mov ebx, arr
	
my_loop:
	mov eax, [ebx]
	add [l_max], eax
	mov eax, [ebx]
	cmp eax, 0
	je cmp_max
	
loop_step:	
	add ebx, 4
	dec ecx
	jnz my_loop
	jmp cmp_max
	
cmp_max:
	mov eax, [l_max]
	cmp eax, [g_max]
	jg renew_max
	xor eax, eax
	mov [l_max], eax
	cmp ecx, 0
	jne loop_step
	jmp print_result

renew_max:
	mov [g_max], eax
	xor eax, eax
	mov [l_max], eax
	cmp ecx, 0
	jne loop_step
	jmp print_result

print_result:
	mov eax, [g_max]
	call print_number
	call exit