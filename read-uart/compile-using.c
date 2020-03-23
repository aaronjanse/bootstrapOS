#include <stdio.h>
#include <stdlib.h>


#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>
#include <errno.h>

FILE * popen2(char* command, char type, int* pid)
{
    pid_t child_pid;
    int fd[2];
    pipe(fd);

    if((child_pid = fork()) == -1)
    {
        perror("fork");
        exit(1);
    }

    /* child process */
    if (child_pid == 0)
    {
        if (type == 'r')
        {
            close(fd[0]);    //Close the READ end of the pipe since the child's fd is write-only
            dup2(fd[1], 1); //Redirect stdout to pipe
        }
        else
        {
            close(fd[1]);    //Close the WRITE end of the pipe since the child's fd is read-only
            dup2(fd[0], 0);   //Redirect stdin to pipe
        }

        setpgid(child_pid, child_pid); //Needed so negative PIDs can kill children of /bin/sh
        // execl(command, command, (char*)NULL);
        execl("/bin/sh", "/bin/sh", "-c", command, NULL);
        exit(0);
    }
    else
    {
        // printf("child pid %d\n", child_pid);
        if (type == 'r')
        {
            close(fd[1]); //Close the WRITE end of the pipe since parent's fd is read-only
        }
        else
        {
            close(fd[0]); //Close the READ end of the pipe since parent's fd is write-only
        }
    }

    pid = child_pid;

    if (type == 'r')
    {
        return fdopen(fd[0], "r");
    }

    return fdopen(fd[1], "w");
}

int pclose2(FILE * fp, int* pid)
{
    int stat;

    fclose(fp);
    while (waitpid(pid, &stat, 0) == -1)
    {
        if (errno != EINTR)
        {
            stat = -1;
            break;
        }
    }

    return stat;
}
int main(int argc, char *argv[]) {
  FILE *f;
  int pid;


  // danger danger danger
  char cmd[256];
  strcpy(cmd, "qemu-system-aarch64 -M raspi4 -nographic -monitor none -kernel ");
  // strcpy(cmd, "sed 's/e/x/g'");
  strcat(cmd, argv[1]);
  printf("cmd: %s\n", cmd);



  f = popen2(cmd, 'r', pid);
  // f = popen2("echo 1234", 'r', pid);
  if (f == NULL) {
    printf("Failed to run qemu.\n");
    exit(1);
  }

  printf("READING\n");

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

  fflush(stdout);
  printf("WRITING!!\n");

  kill(-pid, 9);

  pclose2(f, pid);

  return 0;
}


// int main()
// {
//     int pid;
//     string command = "ping 8.8.8.8"; 
//     FILE * fp = popen2(command, "r", pid);
//     char command_out[100] = {0};
//     stringstream output;

//     //Using read() so that I have the option of using select() if I want non-blocking flow
//     while (read(fileno(fp), command_out, sizeof(command_out)-1) != 0)
//     {
//         output << string(command_out);
//         kill(-pid, 9);
//         memset(&command_out, 0, sizeof(command_out));
//     }

//     string token;
//     while (getline(output, token, '\n'))
//         printf("OUT: %s\n", token.c_str());

//     pclose2(fp, pid);

//     return 0;
// }
