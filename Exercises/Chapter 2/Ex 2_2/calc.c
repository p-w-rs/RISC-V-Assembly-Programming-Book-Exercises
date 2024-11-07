extern int read(int __fd, const void *__buf, int __n);
extern void write(int __fd, const void *__buf, int __n);

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
