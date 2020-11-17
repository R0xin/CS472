#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>



#define error(msg) \
           do { perror(msg); exit(EXIT_FAILURE); } while (0)

//made a function for checking if there is a file to open
/*FILE* open_file(char* filename){
	FILE *fp = fopen(filename, "r");
	//if null, print out the required line
	if (fp == NULL){
		printf("wzip: cannot open file\n");
		exit(1);
	}
	return fp;
}*/
#pragma pack(1)
typedef struct results{
    int count;
    char character;
}Result;

void createResult(int count, char character, Result *buffer, int index){
	Result result;	
	result.count = count;
	result.character = character;
	buffer[index] = result;
}

int main(int argc, char** argv){
	//no files
	if(argc < 2){
		printf("pzip: file1 [file2 ...]\n");
		exit(1);
	}

	char character = '\0';
	int count = 0;
	int size = 10;
	int index = 0;

	Result *buffer = malloc(size * sizeof(Result));

	int maxFile = argc - 1;
	for(int current = 1; current <= maxFile; current++){
		int fd;
		struct stat sb;
		fd = open(argv[current], O_RDONLY);
		if(fd == -1){
			close(fd);
			error("open");
		}
		if(fstat(fd, &sb) == -1){
			close(fd);
			error("fstat");
		}
		int length = sb.st_size;
		if(length == 0){
			close(fd);
			continue;
		}
		char *addr = mmap(NULL, length, PROT_READ, MAP_PRIVATE, fd, 0);
		close(fd);
		if(addr == MAP_FAILED){
			close(fd);
			error("mmap");
		}
		if(character == '\0'){
			character = addr[0];
		}
		for(int i = 0; i < length; i++){
			char temp = addr[i];

			if(temp == character){
				count++;
			}else{
				//checks to see if needs to realloc
				if(i > size){
					size *= 2;
					buffer = realloc(buffer, (size * sizeof(Result)));
				}

				createResult(count, character, buffer, index);
				
				character = temp;
				count = 1;
				index++;

			}

		}
		munmap(addr, length);
	}
	//printf("Character: %c count: %d\n", character, count);
	createResult(count, character, buffer, index);
	index++;
	if(write(STDOUT_FILENO, buffer, index*sizeof(Result)) !=-1);
	free(buffer);
	return 0;
}