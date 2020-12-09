
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h> 
#include <pthread.h>
#include <sys/stat.h> 
#include <sys/sysinfo.h>
#include <unistd.h>

#define queueCapacity 10 

typedef struct output {
	char* data;
	int* count;
	int size;
}output;

typedef struct buffer{
    char* address;  
    int fd; 
    int index;
    int chunk;
}buffer;

typedef struct fd{
	char* addr;
	int size;
}fileDescriptor;

int numberOfArgs; 
int isComplete = 0;
int totalNumberOfJobs;
int queueHead = 0;
int queueTail = 0; 
int *fileChunk;
int queueSize=0;

output * outputDataStruct;
buffer threadBuffer[queueCapacity];
fileDescriptor *files;

pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER, filelock=PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t empty = PTHREAD_COND_INITIALIZER, fill = PTHREAD_COND_INITIALIZER;

void enqueue(buffer tempBuffer){
	threadBuffer[queueHead] = tempBuffer; 
  	queueHead = (queueHead + 1) % queueCapacity;
  	queueSize++;
  	
}

//returns type struct buffer
buffer dequeue(){
  	buffer temp = threadBuffer[queueTail];
	queueTail = (queueTail + 1) % queueCapacity;
  	queueSize--;
  	return temp;
}

void* producer(void *arg){
	char** filenames = (char **)arg;
	struct stat sb;
	char* addr; 
	int file;
	int bufferSize = 512;
	
	for(int i=0;i < numberOfArgs;i++){

		file = open(filenames[i], O_RDONLY);
		int fd = 0; 
		int chunk = 0; 
		
		
		if(fstat(file,&sb) == -1){ 
			close(file);
			exit(1);
		}

    	if(sb.st_size == 0){
           		continue;
    	}
		fd=(sb.st_size / bufferSize);
		if(((double) sb.st_size / bufferSize) > fd){ 
			fd++;
			chunk = sb.st_size % bufferSize;
		}
		else{
			chunk = bufferSize;
		}
		totalNumberOfJobs += fd;
		fileChunk[i] = fd;
		addr = mmap(NULL, sb.st_size, PROT_READ, MAP_SHARED, file, 0);											  
		if (addr == MAP_FAILED) { 
			close(file);
			printf("Error mmapping the file\n");
			exit(1);
    	}	
    	
		for(int j = 0; j < fd; j++){
			pthread_mutex_lock(&lock);
			while(queueSize == queueCapacity){
			    pthread_cond_broadcast(&fill);
				pthread_cond_wait(&empty, &lock); 
			}
			pthread_mutex_unlock(&lock);
			buffer temp;
			if(j == fd-1){ 
				temp.chunk = chunk;
			}
			else{
				temp.chunk = bufferSize;
			}

			temp.address = addr;
			temp.index = j;
			temp.fd = i;
			addr += bufferSize;
			pthread_mutex_lock(&lock);
			enqueue(temp);
			pthread_mutex_unlock(&lock);
			pthread_cond_signal(&fill);
		}
		close(file);
	}
	isComplete = 1;
	pthread_cond_broadcast(&fill); 
	return 0;
}

void *consumer(){
	do{
		pthread_mutex_lock(&lock);
		while(queueSize == 0 && isComplete == 0){
		    pthread_cond_signal(&empty);
			pthread_cond_wait(&fill, &lock); 
		}
		if(isComplete == 1 && queueSize == 0){ 
			pthread_mutex_unlock(&lock);
			return NULL;
		}
		buffer temp = dequeue();
		if(isComplete == 0){
		    pthread_cond_signal(&empty);
		}	
		pthread_mutex_unlock(&lock);
		//Output position calculation
		int position = 0;
	
		for(int i = 0; i < temp.fd; i++){
			position += fileChunk[i];
		}
		
		position += temp.index;

		struct output compressed;

		compressed.count = malloc(temp.chunk * sizeof(int));
		char* tempString = malloc(temp.chunk);
		int countIndex = 0;
		for(int i = 0;i < temp.chunk; i++){
			tempString[countIndex] = temp.address[i];
			compressed.count[countIndex] = 1;
			while((i + 1) < temp.chunk && temp.address[i] == temp.address[i+1]){
				compressed.count[countIndex]++;
				i++;
			}
			countIndex++;
		}
		compressed.size = countIndex;
		compressed.data = realloc(tempString,countIndex);

		outputDataStruct[position] = compressed;
	}while(!(isComplete == 1 && queueSize == 0));
	return NULL;
}

int main(int argc, char* argv[]){
	
	//int threads;

	if(argc<2){
		printf("pzip: file1 [file2 ...]\n");
		exit(1);
	}

	
	numberOfArgs = argc-1; 
	int threads = get_nprocs(); 
	fileChunk = malloc(sizeof(int) * numberOfArgs); 
	
	
    outputDataStruct = malloc(sizeof(struct output)* 512000*2); 
	
	pthread_t pid;
	pthread_t cid[threads];

	pthread_create(&pid, NULL, producer, argv+1); 

	for (int i = 0; i < threads; i++) {
        pthread_create(&cid[i], NULL, consumer, NULL);
    }

    for (int i = 0; i < threads; i++) {
        pthread_join(cid[i], NULL);
    }

    pthread_join(pid,NULL);
	
	int bufferSize = 512;

	char* finalOutput = malloc(totalNumberOfJobs * bufferSize * (sizeof(int) + sizeof(char)));
    char* init = finalOutput; 
	for(int i = 0; i < totalNumberOfJobs; i++){
		if(i < totalNumberOfJobs - 1){
			if(outputDataStruct[i].data[outputDataStruct[i].size-1] == outputDataStruct[i+1].data[0]){ 
				outputDataStruct[i+1].count[0] += outputDataStruct[i].count[outputDataStruct[i].size-1];
				outputDataStruct[i].size--;
			}
		}
		
		for(int j = 0; j < outputDataStruct[i].size; j++){
			int num = outputDataStruct[i].count[j];
			char character = outputDataStruct[i].data[j];
			*((int*)finalOutput) = num;
			finalOutput += sizeof(int);
			*((char*)finalOutput) = character;
            finalOutput += sizeof(char);
		}
	}
	fwrite(init, finalOutput - init, 1, stdout);
	free(init);

	free(fileChunk);
	for(int i=0;i < totalNumberOfJobs;i++){
		free(outputDataStruct[i].data);
		free(outputDataStruct[i].count);
	}
	free(outputDataStruct);
	return 0;
}

