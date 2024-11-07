#define STDIN_FD 0
#define STDOUT_FD 1

typedef unsigned int uint32_t;
typedef signed int int32_t;

int read(int __fd, const void *__buf, int __n);
void write(int __fd, const void *__buf, int __n);
void hex_code(int val);
void exit(int code) __attribute__((noreturn));

void pack(int input, int start_bit, int end_bit, int *val) {
  int mask = (1 << (end_bit - start_bit + 1)) - 1;
  int shifted_input = (input & mask) << start_bit;
  *val |= shifted_input;
}

int parse_number(const char *str) {
  int num = 0;
  int sign = 1;
  if (*str == '-') {
    sign = -1;
    str++;
  } else if (*str == '+') {
    str++;
  }
  while (*str >= '0' && *str <= '9') {
    num = num * 10 + (*str - '0');
    str++;
  }
  return sign * num;
}

int main() {
  char input[30];
  read(STDIN_FD, input, 30);

  int numbers[5];
  char *ptr = input;
  for (int i = 0; i < 5; i++) {
    numbers[i] = parse_number(ptr);
    ptr += 6; // Move to the next number (5 digits + space)
  }

  int result = 0;
  pack(numbers[0], 0, 2, &result);   // 3 LSB
  pack(numbers[1], 3, 10, &result);  // 8 LSB
  pack(numbers[2], 11, 15, &result); // 5 LSB
  pack(numbers[3], 16, 20, &result); // 5 LSB
  pack(numbers[4], 21, 31, &result); // 11 LSB

  hex_code(result);
  return 0;
}

int read(int __fd, const void *__buf, int __n) {
  int ret_val;
  __asm__ __volatile__("mv a0, %1           # file descriptor\n"
                       "mv a1, %2           # buffer \n"
                       "mv a2, %3           # size \n"
                       "li a7, 63           # syscall write code (63) \n"
                       "ecall               # invoke syscall \n"
                       "mv %0, a0           # move return value to ret_val\n"
                       : "=r"(ret_val)                   // Output list
                       : "r"(__fd), "r"(__buf), "r"(__n) // Input list
                       : "a0", "a1", "a2", "a7");
  return ret_val;
}

void write(int __fd, const void *__buf, int __n) {
  __asm__ __volatile__("mv a0, %0           # file descriptor\n"
                       "mv a1, %1           # buffer \n"
                       "mv a2, %2           # size \n"
                       "li a7, 64           # syscall write (64) \n"
                       "ecall"
                       :                                 // Output list
                       : "r"(__fd), "r"(__buf), "r"(__n) // Input list
                       : "a0", "a1", "a2", "a7");
}

void hex_code(int val) {
  char hex[11];
  unsigned int uval = (unsigned int)val, aux;

  hex[0] = '0';
  hex[1] = 'x';
  hex[10] = '\n';

  for (int i = 9; i > 1; i--) {
    aux = uval % 16;
    if (aux >= 10)
      hex[i] = aux - 10 + 'A';
    else
      hex[i] = aux + '0';
    uval = uval / 16;
  }
  write(1, hex, 11);
}

void exit(int code) {
  __asm__ __volatile__("mv a0, %0           # return code\n"
                       "li a7, 93           # syscall exit (64) \n"
                       "ecall"
                       :           // Output list
                       : "r"(code) // Input list
                       : "a0", "a7");
}

void _start() {
  int ret_code = main();
  exit(ret_code);
}
