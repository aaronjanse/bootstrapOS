#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
	FILE *f = fopen(argv[1], "rb");


	unsigned long bytes = 0;
	bytes = bytes << 8; bytes += fgetc(f);
	bytes = bytes << 8; bytes += fgetc(f);
	bytes = bytes << 8; bytes += fgetc(f);
	bytes = bytes << 8; bytes += fgetc(f);

	unsigned char *data = (unsigned char*) malloc(bytes * sizeof(unsigned char));
	fread(data, bytes, 1, f);

	printf("%s", data);

	fclose(f);

	return 0;
}
