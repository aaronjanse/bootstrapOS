#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
	FILE *f = fopen(stdin, "rb");

	unsigned long bytes = 0;
	bytes = bytes << 8; bytes += fgetc(f);
	bytes = bytes << 8; bytes += fgetc(f);
	bytes = bytes << 8; bytes += fgetc(f);
	bytes = bytes << 8; bytes += fgetc(f);

	unsigned char *data = (unsigned char*) malloc(bytes * sizeof(unsigned char));
	fread(data, bytes, 1, f);

  // print manually so null bytes don't confuse us
	for(int i = 0; i < bytes; i++) {
		printf("%c", data[i]);
	}

	fclose(f);

	return 0;
}
