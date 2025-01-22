# Низкоуровневое программирование

## Инструменты

### Подготовка и установка

```sh
apt install nasm gcc-multilib gdb
```

### Библиотечный файл library.asm

Процедура print_number выводит число, которое находится в регистре EAX.

Некоторые метки в этом файле добавлены только для удобства чтения кода.

```nasm
_print_char:
    push eax
    mov  eax, 4
    mov  ebx, 1
    mov  ecx, esp
    mov  edx, 1
    int  80h
    pop  eax
    ret

_print_digits:
    xor  edx, edx        ; edx = 0
    mov  ecx, 10
    div  ecx             ; eax = eax/10, edx = eax%10
    push edx             ; добавляем текущую цифру в стек
    cmp  eax, 0          ; проверяем, можно ли делить дальше
    je   .output
    call _print_digits   ; рекурсивно вызываем эту же процедуру
  .output:
    pop  eax
    add  eax, '0'
    call _print_char
    ret

print_number:
    push edx
    push ecx
    push ebx
    push eax

    cmp  eax, 0
    jge  .positive

  .negative:
    push eax
    mov  eax, '-'
    call _print_char
    pop  eax
    neg  eax

  .positive:
    call _print_digits

    mov  eax, 0x0A       ; символ конца строки
    call _print_char

    pop  eax
    pop  ebx
    pop  ecx
    pop  edx
    ret

exit:
    mov  eax, 1
    xor  ebx, ebx
    int  0x80
```

### Математический Hello, world

```nasm
%include 'library.asm'

section .text
    global _start

_start:
    mov  eax, 100       ; eax = 100
    add  eax, 156       ; eax = eax + 156

    call print_number
    call exit
```

### Ассемблирование, компоновка и запуск

```sh
nasm -f elf -g -F dwarf program.asm
```

```sh
ld -m elf_i386 -o program program.o
```

```sh
./program
```

### Просмотр таблицы символов

```sh
nm -nf sysv program.o
```

```sh
nm -nf sysv program
```

## Отладка

### Запуск отладчика

```sh
gdb program
```

### Основные команды

```
layout regs         ; Переключаемся на просмотр регистров
break _start        ; Устанавливаем точку останова в начале
run                 ; Запускаем программу

next                ; Выполняем следующую строку кода
next                ; (повторяем нужное кол-во раз)

quit                ; Завершаем работу
```

### Просмотр значений

```
p/d   $eax          ; Регистр EAX, десятичный формат
p/t   $eax          ; Регистр EAX, двоичный формат
p/x   $eax          ; Регистр EAX, шестнадцатеричный формат

x/d   0x83040       ; Адрес указан явно
x/d   $ebx          ; Адрес лежит в регистре EBX
x/5d  0x83040       ; 5 ячеек по 32 бита с этого адреса
x/5bd 0x83040       ; 5 ячеек по  8 бит  с этого адреса

x/wd  &height       ; Переменная height, 32 бита
x/bu  &price        ; Переменная price,   8 бит без знака
x/hd  &arr+2        ; Элемент arr[1],    16 бит
```

### Изменение значений

```
set $eax = 100              ; Регистр EAX, значение 100
set $eax += 50              ; Регистр EAX, прибавляем 50
set $ebx = &distance        ; Регистр EBX, адрес distance
set $ebx = (int) &distance  ; Регистр EBX, значение distance

set {int} &height = 20      ; Переменная height, значение 20
set {int} 0x83040 = 30      ; Адрес задан явно,  значение 30
```

## Основы NASM

### Математические инструкции: сложение

```nasm
%include 'library.asm'

section .text
    global _start

_start:
    mov  eax, 10        ; eax = 10
    mov  ebx, 20        ; ebx = 20
    add  eax, ebx       ; eax = eax+ebx
    add  eax, 5         ; eax = eax+5

    call print_number
    call exit
```

```sh
nasm -f elf -g -F dwarf program.asm && ld -m elf_i386 -o program program.o
```

```sh
gdb program
```

### Математические инструкции: умножение

```nasm
%include 'library.asm'

section .text
    global _start

_start:

    mov  eax, 0x100000   ; 2^20
    mov  ebx, 0x100000   ; 2^20
    imul ebx             ; 2^40
                         ; edx:eax = eax*ebx

    call print_number
    call exit
```

```sh
nasm -f elf -g -F dwarf program.asm && ld -m elf_i386 -o program program.o
```

```sh
gdb program
```

### Математические инструкции: деление

```nasm
%include 'library.asm'

section .text
    global _start

_start:

    xor  edx, edx        ; edx = 0
    mov  eax, 158        ; eax = 158
    mov  ebx, 10         ; ebx = 10
    idiv ebx             ; eax = 158/10,
                         ; edx = 158%10

    call print_number
    call exit
```

```sh
nasm -f elf -g -F dwarf program.asm && ld -m elf_i386 -o program program.o
```

```sh
gdb program
```

**Домашнее задание:** Попробуйте самостоятельно разобраться, почему при делении -158/10 получается неправильный результат.

### Упражнение: цена товара в копейках

```nasm
%include 'library.asm'

section .text
    global _start

_start:

    mov  eax, 14         ; eax = 14
    mov  ebx, 25         ; ebx = 25
    ; Ваш код

    call print_number
    call exit
```

### Логические инструкции

**Домашнее задание:** Попробуйте определить, что выведет эта программа, не запуская её.

```nasm
%include 'library.asm'

section .text
    global _start

_start:

    mov  eax, 0b0000_0000_1111_0000
    mov  ebx, 0b0000_0000_0011_1100
    and  eax, ebx
    or   eax, 0b0000_0000_0000_1111
    inc  eax

    call print_number
    call exit
```

### Условные переходы: сравнение

Некоторые метки в этом файле добавлены только для удобства чтения кода.

```nasm
%include 'library.asm'

section .text
    global _start

_start:
    mov  eax, 25_000    ; eax = 25_000
    mov  ebx, 365       ; ebx = 365
    imul ebx            ; eax = eax*ebx

calculate_diff:
    cmp  eax, 8_000_000 ; cmp a, b
    jl   reduced_taxes  ; переход, если a < b

regular_taxes:
    mov  eax, 10_000    ; обычные налоги
    jmp  output         ; безусловный переход

reduced_taxes:
    mov  eax, 1_250     ; сниженные налоги

output:
    call print_number
    call exit
```

### Условные переходы: флаги

**Домашнее задание:** Посмотрите в отладчике (пошагово), как меняются флаги после каждой инструкции в программе.

```nasm
%include 'library.asm'
section .text
    global _start

_start:
    mov  eax, 3
    dec  eax
    dec  eax
    dec  eax
    dec  eax

    mov  eax, 0x100000     ; 2^20
    mov  ebx, 0x100000     ; 2^20
    mul  ebx               ; 2^40

    call exit
```

### Циклы: for

```nasm
%include 'library.asm'

section .text
    global _start

_start:
    xor  eax, eax     ; eax = 0
    mov  ecx, 5       ; counter
loop_start:
    add  eax, 10
    dec  ecx
    jnz  loop_start

    call print_number
    call exit
```

### Циклы: for (с использованием loop)

Это более лаконичная запись цикла for.

```nasm
%include 'library.asm'

section .text
    global _start

_start:
    xor  eax, eax     ; eax = 0
    mov  ecx, 5       ; counter
    
loop_start:
    add  eax, 10
    loop loop_start

    call print_number
    call exit
```

### Циклы: while

Эта программа возводит двойку в степень 1, 2, 3... до тех пор, пока полученное число не превысит 1000.

Решение на языке C:

```c
#include <stdio.h>

int main(void)
{
    int a = 1;
    while (a < 1000)
    {
        a = a * 2;
    }
    printf("%d\n", a);
}
```

В языке ассемблера нет инструкции while, поэтому мы:

- заменяем while на if
- меняем условие **на противоположное** (законы де Моргана)

```nasm
%include 'library.asm'

section .text
    global _start

_start:
    mov  eax, 1

loop_start:
    cmp  eax, 1000      ; if (eax >= 1000) {
    jge  output         ;     goto output
                        ; } else {
    imul eax, 2         ;     eax = eax * 2
    jmp  loop_start     ;     goto loop_start
                        ; }
output:
    call print_number
    call exit
```

### Упражнение: 2 в степени N

```nasm
%include 'library.asm'

section .text
    global _start

_start:
    mov  eax, 1          ; eax = 1
    mov  ecx, 3          ; ecx = 3

loop_start:
    ; Ваш код
    jnz loop_start       ; if (ecx != 0) goto loop_start

    call print_number
    call exit
```

## Работа с памятью

### Указатели

Подумайте, что выведет эта программа?

```nasm
%include 'library.asm'

section .data
    height     db 100
    price      dw 20_000
    distance   dd 1_000_000_000
    population dd 2_000_000_000

section .text
    global _start

_start:
    mov  eax, height
    mov  eax, price
    mov  eax, distance
    mov  eax, population

    call print_number
    call exit
```

### Указатели и значения

```nasm
%include 'library.asm'

section .data
    height     db 100
    price      dw 20_000
    distance   dd 1_000_000_000   ; int *distance_ptr
    population dd 2_000_000_000

section .text
    global _start

_start:
    mov  eax, distance            ; eax = distance_ptr
    mov  eax, [distance]          ; eax = *distance_ptr

    add  eax, 10                  ; eax = eax + 10
    mov  [distance], eax          ; *distance_ptr = eax

    call exit
```

### Адресная арифметика

```nasm
%include 'library.asm'

section .data
    height     db 100               ; char  *height_ptr
    price      dw 20_000            ; short *price_ptr
    distance   dd 1_000_000_000     ; int   *distance_ptr
    population dd 2_000_000_000     ; int   *population_ptr

section .text
    global _start

_start:
    mov  eax, [height+3]            ; eax = 1_000_000_000
    mov  eax, [price+2]             ; eax = 1_000_000_000
    mov  eax, [distance+4]          ; eax = 2_000_000_000

    call exit
```

### Проверка знаний

Найдите и исправьте ошибки в этой программе.

```nasm
%include 'library.asm'

section .data
    height     db           100    ;  8 бит
    price      dw        20_000    ; 16 бит

section .text
    global _start

_start:
    mov  ebx,     [height]
    mov  eax,     [ebx+1]
    add  eax,     50_000
    mov  [price], eax

    call print_number              ; выведет 70000
    call exit
```

### Работа со стеком

Как вы думаете, какое значение окажется в регистре EAX после выполнения строки со знаками вопроса?

```nasm
%include 'library.asm'

section .text
    global _start

_start:

    push 10                  ; 32 бита
    push 20                  ; 32 бита
    push 30                  ; 32 бита

    mov  eax, [esp+0]        ; eax = 30
    mov  eax, [esp+4]        ; eax = 20
    mov  eax, [esp+8]        ; eax = 10
    pop  eax                 ; eax = ???

    call exit
```

## Массивы

### Доступ к элементу по индексу

```nasm
%include 'library.asm'

section .data
    arr dd  10, 20, 30, 40, 50
    n   dd  5

section .text
    global _start

_start:
    mov  ebx, arr         ; ebx = arr_ptr
    mov  eax, [ebx + 4*0] ; eax = arr[0]
    mov  eax, [ebx + 4*1] ; eax = arr[1]
    mov  eax, [ebx + 4*2] ; eax = arr[2]

    call exit
```

### Перебор элементов

```nasm
%include 'library.asm'

section .data
    arr dd  10, 20, 30, 40, 50
    n   dd  5                    ; в реальности обычно используется equ

section .text
    global _start

_start:
    xor  eax, eax                ; eax = 0
    mov  ecx, [n]                ; ecx = *n_ptr
    mov  ebx, arr                ; ebx = arr_ptr

next_element:
    add  eax, [ebx]              ; eax = eax + *arr_ptr
    add  ebx, 4                  ; ebx = ebx + 4
    loop next_element

    call print_number
    call exit
```



### Пример задачи: максимальный элемент массива

Подсказка: временные переменные обычно создаются на стеке.

```nasm
section .data
    arr dd  48, 16, 256, 0, 3
    n   dd  5

section .text
global _start

_start:
    mov  ebx, arr
    mov  eax, [ebx]
    mov  ecx, [n]
    push eax

next_element:
    add  ebx, 4
    mov  eax, [ebx]
    cmp  eax, [esp]
    jle  skip_element
    mov  [esp], eax

skip_element:
    loop next_element

    pop  eax
    call print_number
    call exit
```

## Домашнее задание

При решении задач попробуйте использовать разные тестовые данные (придумайте их сами, включая граничные случаи).

### Задача 1: самая длинная последовательность

Дан массив, который состоит из нулей и единиц. Выведите размер самой длинной непрерывной последовательности единиц в массиве.

Пример: `[0, 0, 1, 0, 1, 1, 1, 0]`

Ответ:  `3`

Пример: `[0, 0, 0]`

Ответ:  0

**Ограничения:**

- `0 < n < 50`, где `n` — длина массива
- массив состоит только из чисел `0` и `1`

**Шаблон кода:**

```nasm
%include 'library.asm'

section .data
    arr dd  0, 0, 1, 0, 1, 1, 1, 0
    n   dd  8

section .text
    global _start
    
_start:

    ; Ваш код

    call print_number
    call exit
```

### Задача 2: беготня по этажам

Вася бегает по этажам офисного здания с блокнотом в руках:

- когда он поднимается на 1 этаж, он записывает букву `u`
- когда он опускается  на 1 этаж, он записывает букву `d`

Определите по записям в блокноте (есть минимум 1 запись), смог ли Вася вернуться на исходный этаж в конце рабочего дня:

- выведите `1`, если Вася закончил работать там же, где начал
- выведите `0`, если Вася застрял на другом этаже

Пример: `['u', 'd', 'd', 'u', 'u', 'd', 'd', 'u']`

Ответ:  `1`

Пример: `['u', 'u', 'u']`

Ответ:  `0` (Вася закончил на 3 этажа выше)

**Ограничения:**

- `0 < n < 50`, где `n` — длина массива
- массив состоит только из символов `u` и `d`

**Шаблон кода:**

```nasm
%include 'library.asm'

section .data
    arr dd  'u', 'd', 'd', 'u', 'u', 'd', 'd', 'u'
    n   dd  8

section .text
    global _start
    
_start:

    ; Ваш код

    call print_number
    call exit
```

### Задача 3 (со звёздочкой): ближайший тёплый день

Детям в школе задали на лето записывать каждый день:

- какая в этот день была температура
- если до этого были дни с более высокой температурой — записать температуру **ближайшего** такого дня (или -1, если таких дней не было)

Помогите Маше найти ближайшие предыдущие дни с более высокой температурой. 

ВАЖНО: решение должно выполняться за время O(n).

Пример: `[17, 21, 13, 17, 14, 12]`

Ответ:  `[-1, -1, 21, 21, 17, 14]`

Разбор примера: 

- день 1: 17 градусов (наблюдений до этого не было, поэтому ставим -1)
- день 2: 21 градус (все предыдущие дни были холоднее, поэтому ставим -1)
- день 3: 13 градусов (до этого **ближайший** более тёплый день был день 2, ставим 21 градус)
- день 4: 17 градусов (до этого **ближайший** более тёплый день был день 2, ставим 21 градус)
- день 5: 14 градусов (до этого **ближайший** более тёплый день был день 4, ставим 17 градусов)
- день 6: 12 градусов (до этого **ближайший** более тёплый день был день 5, ставим 14 градусов)

**Ограничения:**

- `0 < n < 50`, где `n` — длина массива
- `0 < arr[i] < 50` для любого индекса `i` в массиве

**Шаблон кода:**

```nasm
%include 'library.asm'

section .data
    arr dd  17, 21, 13, 17, 14, 12
    n   dd  6

section .text
    global _start
    
_start:

    ; Ваш код
    ; Вам нужно будет вызвать print_number n раз

    call exit
```

## Ссылка на опрос

```
https://otus.ru/polls/113301/
```