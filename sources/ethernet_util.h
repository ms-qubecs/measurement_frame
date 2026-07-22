#ifndef __EHTERNET_UTIL_H__
#define __EHTERNET_UTIL_H__

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
#include <sys/ioctl.h>

typedef struct{
    unsigned char dest[6]; /* destination MAC address */
    unsigned char src[6];  /* source MAC address */
    unsigned char ethernet_type[2]; /* ethernet type */
    unsigned char payload[];
} ethernet_frame_t;

void parse_mac_address(unsigned char *bytes, char *mac_address);
void get_mac_address(char *mac, char *interface_name);
void print_mac_address(unsigned char *bytes);
int ethernet_send(char *interface, unsigned char* buf, int bytes);
int ethernet_sendrecv(char *interface,
    unsigned char* sbuf,
    int sbytes,
    unsigned char *rbuf,
    int rcap,
    unsigned short ethernet_type);

#endif /* __EHTERNET_UTIL_H__ */
