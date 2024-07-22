// Custom integer types
typedef signed int int32_t;
typedef unsigned int uint32_t;

// Function prototypes
int read(int __fd, const void *__buf, int __n);
void write(int __fd, const void *__buf, int __n);
void exit(int code) __attribute__((noreturn));
int32_t parse_input(char *str, int len);
void print_binary(int32_t num);
void print_decimal(int32_t num);
void print_hex(uint32_t num);
void print_unsigned_swapped(uint32_t num);

#define STDIN_FD 0
#define STDOUT_FD 1

int main() {
  char input[20];
  int len = read(STDIN_FD, input, 20);

  // Remove newline character
  if (len > 0 && input[len - 1] == '\n') {
    input[len - 1] = '\0';
    len--;
  }

  int32_t num = parse_input(input, len);

  print_binary(num);
  print_decimal(num);
  print_hex((uint32_t)num);
  print_unsigned_swapped((uint32_t)num);
  return 0;
}

int32_t parse_input(char *str, int len) {
  int32_t result = 0;
  int is_negative = 0;
  int i = 0;

  if (str[0] == '-') {
    is_negative = 1;
    i++;
  }

  if (len > 2 && str[0] == '0' && (str[1] == 'x' || str[1] == 'X')) {
    // Hexadecimal input
    for (i = 2; i < len; i++) {
      result = result * 16;
      if (str[i] >= '0' && str[i] <= '9')
        result += str[i] - '0';
      else if (str[i] >= 'a' && str[i] <= 'f')
        result += str[i] - 'a' + 10;
      else if (str[i] >= 'A' && str[i] <= 'F')
        result += str[i] - 'A' + 10;
    }
  } else {
    // Decimal input
    for (; i < len; i++) {
      result = result * 10 + (str[i] - '0');
    }
    if (is_negative)
      result = -result;
  }

  return result;
}

void print_binary(int32_t num) {
  char buffer[35];
  buffer[0] = '0';
  buffer[1] = 'b';
  int i;
  for (i = 2; i < 34; i++) {
    buffer[i] = '0';
  }
  for (i = 0; i < 32; i++) {
    if ((num & (1 << (31 - i))) != 0) {
      buffer[i + 2] = '1';
    }
  }
  buffer[34] = '\n';
  write(STDOUT_FD, buffer, 35);
}

void print_decimal(int32_t num) {
  char buffer[12];
  int i = 0;

  // Handle the special case of minimum 32-bit integer
  if (num == -2147483648) {
    char *min_int = "-2147483648\n";
    write(STDOUT_FD, min_int, 12);
    return;
  }

  int is_negative = 0;
  if (num < 0) {
    is_negative = 1;
    num = -num;
  }

  do {
    buffer[i++] = (num % 10) + '0';
    num /= 10;
  } while (num > 0);

  if (is_negative) {
    buffer[i++] = '-';
  }

  // Reverse the string
  for (int j = 0; j < i / 2; j++) {
    char temp = buffer[j];
    buffer[j] = buffer[i - j - 1];
    buffer[i - j - 1] = temp;
  }

  buffer[i++] = '\n';
  write(STDOUT_FD, buffer, i);
}

void print_hex(uint32_t num) {
  char buffer[11] = "0x00000000\n";
  int i;
  for (i = 0; i < 8; i++) {
    int digit = (num >> (28 - i * 4)) & 0xF;
    buffer[2 + i] = digit < 10 ? digit + '0' : digit - 10 + 'a';
  }
  write(STDOUT_FD, buffer, 11);
}

void print_unsigned_swapped(uint32_t num) {
  // Swap endianness
  num = ((num & 0xFF000000) >> 24) | ((num & 0x00FF0000) >> 8) |
        ((num & 0x0000FF00) << 8) | ((num & 0x000000FF) << 24);

  char buffer[12];
  int i = 0;

  do {
    buffer[i++] = (num % 10) + '0';
    num /= 10;
  } while (num > 0);

  // Reverse the string
  for (int j = 0; j < i / 2; j++) {
    char temp = buffer[j];
    buffer[j] = buffer[i - j - 1];
    buffer[i - j - 1] = temp;
  }

  buffer[i++] = '\n';
  write(STDOUT_FD, buffer, i);
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
