#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]){

	size_t buffer = 1000;
	char *line = malloc(sizeof(char)*buffer);

	if(argc < 2){
		printf("wgrep: searchterm [file ...]\n");
		free(line);
		exit(1);
	}
	int i;
	for (i=2; i<argc; i++){
		FILE *fp = fopen(argv[i], "r");
		/*Check to see if file(s) exist*/
		if(fp == NULL){	
			printf("wgrep: cannot open file\n");
			free(line);
			exit(1);	
		}	
		while(getline(&line, &buffer, fp) != -1){
			if(strstr(line, argv[1])!= NULL){
				printf("%s", line);
			}else{
				continue;
			}
		}
		fclose(fp);
	} 
	if(argc == 2){
		while(getline(&line, &buffer, stdin) != -1){
			if(strstr(line, argv[1])!= NULL){
				printf("%s", line);
			}else{
				continue;
			}
		}
	}
	free(line);
	return 0;
}