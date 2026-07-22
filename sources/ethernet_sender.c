#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ethernet_util.h"

/**
 * send ethernet message
 * @param interface ethernet adapter name (ex. enp0s3)
 * @param dest_mac destination MAC address (ex. XX:XX:XX:XX:XX:XX)
 * @param src_mac source MAC address (ex. YY:YY:YY:YY:YY:YY)
 * @param type ethrnet type
 * @param mesg data
 */
void send_ethernet_message(char *interface, char *dest_mac, char* src_mac, unsigned short type, char *mesg)
{
    int bytes = sizeof(ethernet_frame_t)+sizeof(char)*strlen(mesg);
    ethernet_frame_t* frame = (ethernet_frame_t*)malloc(bytes);
    
    parse_mac_address(frame->dest, dest_mac);
    parse_mac_address(frame->src, src_mac);
    *((unsigned short*)frame->ethernet_type) = htons(type);
    memcpy(frame->payload, mesg, sizeof(char)*strlen(mesg));

    int len = ethernet_send(interface, (unsigned char*)frame, bytes);
    
    printf("%d bytes sent\n", len);
}

int main(int argc, char **argv)
{
    if(argc != 4){
        printf("usage: %s interface_name destination_mac_address message\n", argv[0]);
        return 0;
    }

    char *interface_name = argv[1];
        
    char src_mac[18]; // "XX:XX:XX:XX:XX:XX\0"
    get_mac_address(src_mac, interface_name);

    send_ethernet_message(interface_name, argv[2], src_mac, 0x0344, argv[3]);

    return 0;
}
