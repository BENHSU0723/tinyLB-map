#include <bpf/libbpf.h>

#define IP_ADDRESS(x) (unsigned int)(192 + (17 << 8) + (0 << 16) + (x << 24))



int main(int argc, char **argv)
{
  
  //   union bpf_attr attr = {
  //       .map_type = BPF_MAP_TYPE_ARRAY;  /* mandatory */
  //       .key_size = sizeof(char[8]);       /* mandatory */
  //       .value_size = sizeof(unsigned int);     /* mandatory */
  //       .max_entries = 256;              /* mandatory */
  //       .map_name = "my_map";
  // };
  // __u32 flag=0x00;
    // int fd = bpf(BPF_MAP_CREATE, &attr, sizeof(attr));
  int map_fd =bpf_create_map(BPF_MAP_CREATE, sizeof(char[20]), sizeof(unsigned int),256);
	if (map_fd<0){
    printf("Error: Create map fail from user space: %d\n",map_fd);
    return -1;
  }
  char client[8]="client";
  unsigned int client_IP=IP_ADDRESS(4);
  int result=bpf_map_update_elem(map_fd,client,client_IP,NULL);
  if (result<0){
    printf("Error: Update map fail from user space: %d\n",result);
    return -1;
  }

  // int *obj;
	// int map_fd, prog_fd;
	// // ...
  // obj=bpf_object__open(argv[0]);
  // if (obj==-1){
  //   printf("obj get from filename [%s] is [%d]",argv[0],obj);
  //   printf("ERROR: opening BPF object file failed\n");
  //   return -1;
  // }

	// map_fd = bpf_object__find_map_fd_by_name(obj, "my_map"); // == 本次关注 ==




	return 0;
}