#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <net/ethernet.h>
#include <net/if.h>
#include <netpacket/packet.h>
#include <sys/ioctl.h>

#include "raw_socket.h"
#include "ethernet_util.h"

void parse_mac_address(unsigned char *bytes, char *mac_address)
{
    char *ptr;
    ptr = strtok(mac_address, ":");
    bytes[0] = (unsigned char)strtol(ptr, NULL, 16);
    for(int i = 1; i < 6; i++){
        ptr = strtok(NULL, ":");
        bytes[i] = (unsigned char)strtol(ptr, NULL, 16);
    }
}

void get_mac_address(char *mac, char *interface_name)
{
    int fd;
    struct ifreq ifr;
    
    fd = socket(AF_INET, SOCK_DGRAM, 0);
    ifr.ifr_addr.sa_family = AF_INET;
    strncpy(ifr.ifr_name, interface_name, IFNAMSIZ - 1);
    ioctl(fd, SIOCGIFHWADDR, &ifr);
    close(fd);

    sprintf(mac,
            "%02x:%02x:%02x:%02x:%02x:%02x",
            (unsigned char)ifr.ifr_hwaddr.sa_data[0],
            (unsigned char)ifr.ifr_hwaddr.sa_data[1],
            (unsigned char)ifr.ifr_hwaddr.sa_data[2],
            (unsigned char)ifr.ifr_hwaddr.sa_data[3],
            (unsigned char)ifr.ifr_hwaddr.sa_data[4],
            (unsigned char)ifr.ifr_hwaddr.sa_data[5]
    );
}

void print_mac_address(unsigned char *bytes)
{
    char *sep = "";
    for(int i = 0; i < 6; i++){
        printf("%s%02x", sep, bytes[i]);
        sep = ":";
    }
}

int ethernet_send(char *interface, unsigned char* buf, int bytes)
{
    raw_socket_t sock;
    sock.interface = interface;
    if(open_raw_socket(&sock) < 0){
        perror("cannot open socket");
        return 0;
    }

    if(bind_raw_socket(&sock) < 0){
        perror("cannot bind socket");
        return 0;
    }

    int len = send(sock.socket, buf, bytes, 0);
    close_raw_socket(&sock);

    return len;
}

int ethernet_sendrecv(
    char *interface,
    unsigned char* sbuf,
    int sbytes,
    unsigned char *rbuf,
    int rcap,
    unsigned short ethernet_type)
{
    raw_socket_t sock;
    sock.interface = interface;
    if(open_raw_socket(&sock) < 0){
        perror("cannot open socket");
        return 0;
    }

    if(bind_raw_socket(&sock) < 0){
        perror("cannot bind socket");
        return 0;
    }

    int len = send(sock.socket, sbuf, sbytes, 0);

    printf("wait for respons packet\n");

    for(;;){
        len = recv(sock.socket, rbuf, rcap, 0);
        ethernet_frame_t *frame = (ethernet_frame_t*)(rbuf);
        if(len > 0){
            if(ntohs(*((unsigned short*)frame->ethernet_type)) != ethernet_type) continue;
            print_mac_address(frame->src);
            printf("->");
            print_mac_address(frame->dest);
            printf(" type:%04x", ntohs(*((unsigned short*)frame->ethernet_type)));
            printf(" length:%d", len);
            printf("\n");
            int mesg_len = len - sizeof(ethernet_frame_t);
            for(int i = 0; i < mesg_len; i++){
                printf(" %02x", frame->payload[i]);
                if(i%16 == 15) printf("\n");
            }
            if(mesg_len % 16 != 0) printf("\n");
            break;
        }
    }
    close_raw_socket(&sock);
    return len;
}
