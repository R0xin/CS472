#include <stdio.h>
#include <stdlib.h>

FILE* open_file(char* filename){
	FILE *fp = fopen(filename, "r");
	//if null, print out the required line
	if (fp == NULL){
		printf("wunzip: file1 [file2 ...]\n");
		exit(1);
	}
	return fp;
}

int main(int argc, char *argv[]){

	int c;
	int count;
	size_t buffer;

	FILE* fp;
	
	if(argc < 2){
		printf("wunzip: file1 [file2 ...]\n");
		exit(1);
	}
	for(int i = 1; i < argc; i++){
		fp = open_file(argv[i]);
		while((buffer = fread(&count, sizeof(int), 1, fp)) == 1){
			c = fgetc(fp);
			for(int j = 0; j < count; j++){
				printf("%c",c);
			}
		}
		fclose(fp);
	}
	return 0;
}