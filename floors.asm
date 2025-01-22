%include 'library.asm'
section .data
	arr dd 'u', 'u', 'd', 'd', 'u', 'd', 'd', 'u'
	n		dd 8
	counter dd 0
		
section .text
global _start

_start:
	mov ecx, [n]
	mov ebx, arr
	
my_loop:
	mov eax, [ebx]
	cmp eax, 'u'
	je add_one
	jne extract_one
	
loop_step:	
	add ebx, 4
	dec ecx
	jnz my_loop
	jmp take_result
	
add_one:
	mov eax, [counter]
	inc eax
	mov [counter], eax	 
	jmp loop_step

extract_one:
	mov eax, [counter]
	dec eax
	mov [counter], eax	 
	jmp loop_step

take_result:
	mov eax, [counter]
	cmp eax, 0
	je print_one
	jne print_zero

print_one:
	mov eax, 1
	call print_number
	call exit

print_zero:
	mov eax, 0
	call print_number
	call exit