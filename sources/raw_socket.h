#ifndef __RAW_ETHERNET_SOCKET_H__
#define __RAW_ETHERNET_SOCKET_H__

#define RAW_SOCKET_BUFSIZE (8192)

typedef struct {
    char *interface;
    int socket;
    unsigned char buf[RAW_SOCKET_BUFSIZE];
} raw_socket_t;

int open_raw_socket(raw_socket_t *sock);
void close_raw_socket(raw_socket_t* sock);
int bind_raw_socket(raw_socket_t* sock);
int recv_raw_socket(raw_socket_t* sock);

#endif /* __RAW_ETHERNET_SOCKET_H__ */
