#include <spawn.h>
// Colors
// Normal   "\x1B[0m"
// Red      "\x1B[31m"
// Green    "\x1B[32m"
// Yellow   "\x1B[33m"
// Blue     "\x1B[34m"
// CYAN     "\x1B[36m"
// White    "\x1B[37m"

#define LOG_DBG(s, ...) \
        NSLog(@"\x1B[32m[Debug] %s:%d \x1B[0m %@",__func__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]);
#define LOG_ERR(s, ...) \
        NSLog(@"\x1B[31m[Error] %s:%d \x1B[0m %@",__func__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]);
#define LOG_INFO(s, ...) \
        NSLog(@"\x1B[36m[INFO] %s:%d \x1B[0m %@",__func__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__]);


extern char**environ;

void run_cmd(const char*cmd)
{
    pid_t pid;
    const char*argv[] = {"sh","-c", cmd,NULL};
    int status;
    status = posix_spawn(&pid,"/bin/sh",NULL,NULL, (char*const*)argv, environ);
    if(status ==0) {
        if(waitpid(pid, &status,0) == -1) {
            perror("waitpid");
        }
    }
}

int main(int argc,char* argv[],char* envp[])
{
    if(argc <2)
    {
        fprintf(stderr,"usage: %s program args...\n", argv[0]);
        return EXIT_FAILURE;
    }
    int ret, status;
    pid_t pid;
    LOG_DBG(@"00000");
    posix_spawnattr_t attr;
    posix_spawnattr_init(&attr);
    posix_spawnattr_setflags(&attr, POSIX_SPAWN_START_SUSPENDED);
    ret = posix_spawnp(&pid, argv[1],NULL, &attr, &argv[1], envp);
    posix_spawnattr_destroy(&attr);
    LOG_DBG(@"111111");
    if(ret !=0)
    {
        printf("posix_spawnp failed with %d: %s\n", ret, strerror(ret));
        return ret;
    }
    char buf[200];
    LOG_DBG(@"22222");
    snprintf(buf,sizeof(buf), "/electra/jailbreakd_client %d 1", pid);
    LOG_DBG(@"333: %s", buf);
    run_cmd(buf);
    kill(pid, SIGCONT);
    waitpid(pid, &status,0);return 0;
}