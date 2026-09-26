# A terminal calculator
#
# Reads a line of input, interprets it as a simple arithmetic expression,
# and prints the result. The input format is
# <long_integer> <operation> <long_integer>

# Make `main` accessible outside of this module
.global main

# Start of the code section
.text

main:
  # Function prologue
  enter $0, $0

  # Use scanf to retrieve and process a line of input
  # This block implements the following line of C code: 
  #   scanf("%ld %c %ld", &a, &op, &b);
  # Take a look at the man page for scanf and ask questions. You can also look 
  # at scanf_example.c
  movq $scanf_fmt, %rdi
  movq $a, %rsi
  movq $op, %rdx
  movq $b, %rcx
  xorb %al, %al
  call scanf

  movb op, %r8b
  movq a, %r9

  # TODO: Analyze operation and execute
  cmpb $'+', %r8b
  je add_numbers

  cmpb $'-', %r8b
  je subtract_numbers

  cmpb $'*', %r8b
  je multiply_numbers

  cmpb $'/', %r8b
  je divide_numbers

  # For any other case
  jmp unknown_operation

  add_numbers:
    addq b, %r9
    jmp print_result

  subtract_numbers:
    subq b, %r9
    jmp print_result

  multiply_numbers:
    imulq b, %r9
    jmp print_result

  divide_numbers:
    cmpq $0, b
    je division_error

    movq %r9, %rax
    cqto
    idivq b

    movq %rax, %r9
    jmp print_result

  # TODO: Print result
  print_result:
    movq $output_fmt, %rdi
    movq %r9, %rsi
    xorb %al, %al
    call printf

    movl $0, %eax
    jmp done
  # TODO: Print error if operation cannot be (safely) performed
  unknown_operation:
    movq $unknown_fmt, %rdi
    xorb %al, %al
    call printf

    movl $1, %eax
    jmp done

  division_error:
    movq $division_fmt, %rdi
    xorb %al, %al
    call printf

    movl $1, %eax

  # if (op_char == '+') {
  #   ...
  # }
  # else if (op_char == '-') {
  #  ...
  # }
  # ...
  # else {
  #   // print error
  #   // return 1 from main
  # }

  # Function epilogue
done:
  leave
  ret

# Start of the data section
.data

output_fmt: 
  .asciz "%ld\n"
unknown_fmt:
  .asciz "Unknown operation\n"
division_fmt:
  .asciz "Division by zero\n"
scanf_fmt: 
  .asciz "%ld %c %ld"  # TODO: modify as needed

# "Slots" for scanf
a:  .quad 0
b:  .quad 0
op: .byte 0

