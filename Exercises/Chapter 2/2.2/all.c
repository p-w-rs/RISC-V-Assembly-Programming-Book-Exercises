/* read
 * Parameters:
 *  __fd:  file descriptor of the file to be read.
 *  __buf: buffer to store the data read.
 *  __n:   maximum amount of bytes to be read.
 * Return:
 *  Number of bytes read.
 */
int read(int __fd, const void *__buf, int __n) {
  int ret_val;
  __asm__ __volatile__("mv a0, %1           # file descriptor\n"
                       "mv a1, %2           # buffer \n"
                       "mv a2, %3           # size \n"
                       "li a7, 63           # syscall read code (63) \n"
                       "ecall               # invoke syscall \n"
                       "mv %0, a0           # move return value to ret_val\n"
                       : "=r"(ret_val)                   // Output list
                       : "r"(__fd), "r"(__buf), "r"(__n) // Input list
                       : "a0", "a1", "a2", "a7");
  return ret_val;
}

/* write
 * Parameters:
 *  __fd:  files descriptor where that will be written.
 *  __buf: buffer with data to be written.
 *  __n:   amount of bytes to be written.
 * Return:
 *  Number of bytes effectively written.
 */
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

char input_buffer[255];
char output_buffer[2];

int char_to_int(char c) { return c - '0'; }

char int_to_char(int n) { return n + '0'; }

int main() {
  int n = read(0, (void *)input_buffer, 255);
  if (n > 0) {
    int s1 = char_to_int(input_buffer[0]);
    int s2 = char_to_int(input_buffer[4]);
    char op = input_buffer[2];
    int result;

    switch (op) {
    case '+':
      result = s1 + s2;
      break;
    case '-':
      result = s1 - s2;
      break;
    case '*':
      result = s1 * s2;
      break;
    default:
      write(1, "Invalid operation\n", 18);
      return 1;
    }

    output_buffer[0] = int_to_char(result);
    output_buffer[1] = '\n';
    write(1, output_buffer, 2);
  } else {
    write(1, "Error reading input\n", 20);
  }
  return 0;
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
