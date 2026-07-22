#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <net/ethernet.h>
#include <net/if.h>
#include <netpacket/packet.h>

#include "raw_socket.h"

int open_raw_socket(raw_socket_t *sock)
{
    
    if((sock->socket = socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL))) < 0){
        return -1;
    };
    
    return 0;
}

void close_raw_socket(raw_socket_t* sock)
{
    
    close(sock->socket);
    
    return;
}

int bind_raw_socket(raw_socket_t* sock)
{
    
    struct sockaddr_ll sockaddr;
    
    memset(&sockaddr, 0x0, sizeof(sockaddr));
    
    sockaddr.sll_family = AF_PACKET;
    sockaddr.sll_protocol = htons(ETH_P_ALL);
    
    // get interface index with tha name
    sockaddr.sll_ifindex = if_nametoindex(sock->interface);
    
    if(bind(sock->socket, (struct sockaddr*)&sockaddr, sizeof(sockaddr)) < 0){
        return -1;
    }
    
    return 0;
}


int recv_raw_socket(raw_socket_t* sock)
{
    int len;
    
    memset(sock->buf, 0x0, sizeof(sock->buf));
    
    len = recv(sock->socket, sock->buf, sizeof(sock->buf), 0);

    return len;
};
