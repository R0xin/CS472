#include <stdio.h>
#include <stdlib.h>

FILE* open_file(char* filename){
	FILE *fp = fopen(filename, "r");
	if (fp == NULL){
		printf("wzip: cannot open file\n");
		exit(1);
	}
	return fp;
}

int main(int argc, char** argv){

	int i;
	int c = 0;
	int last = -1;
	int count = 0;

	if(argc < 2){
		printf("wzip: file1 [file2 ...]\n");
		exit(1);
	}

	FILE* fp;

	for(i = 1; i < argc; i++){
		fp = open_file(argv[i]);
		while((c = fgetc(fp)) != EOF){
			if (last == -1){
				last = c;
				count++;
			}else if(c != last){
				fwrite(&count, sizeof(int), 1, stdout);
				fputc(last, stdout);
				count = 1;
			}else{
				count++;
			}
			last = c;
		}
		fclose(fp);
	}
	if(count > 0){
		fwrite(&count, sizeof(int), 1, stdout);
		fputc(last, stdout);
	}

	return 0;
}