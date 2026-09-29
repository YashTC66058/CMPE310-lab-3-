.section .data

prompt1:
    .ascii "Enter first string: "
prompt1_len = . - prompt1

prompt2:
    .ascii "Enter second string: "
prompt2_len = . - prompt2

result:
    .ascii "Hamming distance: "
result_len = . - result

newline:
    .ascii "\n"


.section .bss

.lcomm string1, 256
.lcomm string2, 256
.lcomm len1, 8
.lcomm len2, 8
.lcomm distance, 8
.lcomm number, 4


.section .text
.global _start

_start:

    # Print first prompt
    mov $1, %rax
    mov $1, %rdi
    mov $prompt1, %rsi
    mov $prompt1_len, %rdx
    syscall

    # Read first string
    mov $0, %rax
    mov $0, %rdi
    mov $string1, %rsi
    mov $255, %rdx
    syscall

    dec %rax
    mov %rax, len1

    # Print second prompt
    mov $1, %rax
    mov $1, %rdi
    mov $prompt2, %rsi
    mov $prompt2_len, %rdx
    syscall

    # Read second string
    mov $0, %rax
    mov $0, %rdi
    mov $string2, %rsi
    mov $255, %rdx
    syscall

    dec %rax
    mov %rax, len2

    # Find shorter length
    mov len1, %rcx
    cmp len2, %rcx
    jle length_ready
    mov len2, %rcx

length_ready:

    mov $0, %r8
    mov $0, %r9

compare_loop:

    cmp $0, %rcx
    je finished

    movb string1(%r8), %al
    movb string2(%r8), %bl
    xor %bl, %al

    mov $8, %rdx

bit_loop:

    mov %al, %bl
    and $1, %bl
    add %bl, %r9b

    shr $1, %al

    dec %rdx
    jne bit_loop

    inc %r8
    dec %rcx
    jmp compare_loop

finished:

    mov %r9, distance

    # Print result message
    mov $1, %rax
    mov $1, %rdi
    mov $result, %rsi
    mov $result_len, %rdx
    syscall

    # Convert distance to decimal
    mov distance, %rax
    mov $10, %rbx
    mov $number+3, %rsi
    mov $0, %rcx

convert_loop:

    mov $0, %rdx
    div %rbx

    add $48, %dl
    movb %dl, (%rsi)

    dec %rsi
    inc %rcx

    cmp $0, %rax
    jne convert_loop

    inc %rsi

    # Print number
    mov %rcx, %rdx
    mov $1, %rax
    mov $1, %rdi
    syscall

    # Print newline
    mov $1, %rax
    mov $1, %rdi
    mov $newline, %rsi
    mov $1, %rdx
    syscall

    # Exit
    mov $60, %rax
    mov $0, %rdi
    syscall
