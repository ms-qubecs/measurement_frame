#include <stdio.h>
#include <stdlib.h>
#include <linux/if_ether.h>

#include "raw_socket.h"
#include "ethernet_util.h"

void recv_ethernet_message(char *interface_name, unsigned short ethernet_type)
{
    raw_socket_t sock;
    sock.interface = interface_name;
    
    if(open_raw_socket(&sock) < 0){
        perror("cannot open socket");
        return;
    }

    if(bind_raw_socket(&sock) < 0){
        perror("cannot bind socket");
        return;
    }
    
    for(;;){
        
        int len = recv_raw_socket(&sock);

        if(len < 0){
            return;
        }
        
        ethernet_frame_t *frame = (ethernet_frame_t*)(sock.buf);
        
        fflush(stdout);

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
        }
    }
}

int main(int argc, char **argv)
{
    if(argc != 2){
        printf("usage: %s interface_name\n", argv[0]);
        return 0;
    }
    
    recv_ethernet_message(argv[1], 0x3434);
    return 0;
}
