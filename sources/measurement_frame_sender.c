#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ethernet_util.h"
#include "measurement_frame_format.h"

/**
 * generate measurement info
 * @param step_id step ID
 * @param q_id logical qubit ID
 * @param qubit_num #. of qubits
 * @param info_num #. of information bits
 * @param data bit-vector of measurement data
 * @param dest_mac destination MAC address (ex. XX:XX:XX:XX:XX:XX)
 * @param src_mac source MAC address (ex. YY:YY:YY:YY:YY:YY)
 */
measurement_frame_t * gen_measurement(unsigned long long step_id, unsigned int qubit_id, unsigned int qubit_num, unsigned int info_num, unsigned char *data, char *dest_mac, char *src_mac)
{
    measurement_frame_t * frame = new_measurement_frame(qubit_num, info_num);
    if(frame == NULL) return NULL;

    parse_mac_address(frame->dest, dest_mac);
    parse_mac_address(frame->src, src_mac);

    *(unsigned long long*)frame->step_id = htobe64(step_id);
    *(unsigned int*)frame->qubit_id = htonl(qubit_id);
    
    int bytes = ((qubit_num + 7) / 8) * info_num;
    memcpy(frame->measurement, data, bytes);

    return frame;
}

/**
 * send measurement info
 * @param interface ethernet adapter name (ex. enp0s3)
 */
void send_measurement(char *interface, measurement_frame_t *frame)
{
    int bytes = measurement_frame_length(frame);
    int len = ethernet_send(interface, (unsigned char*)frame, bytes);
    printf("%d bytes sent\n", len);
}

int main(int argc, char **argv)
{
    if(argc != 3){
        printf("usage: %s interface_name destination_mac_address\n", argv[0]);
        return 0;
    }

    char *interface_name = argv[1];
        
    char src_mac[18]; // "XX:XX:XX:XX:XX:XX\0"
    get_mac_address(src_mac, interface_name);
    char *dest_mac = argv[2];
    
    unsigned long long step_id = 100L;
    unsigned int qubit_id = 0xDEADBEEF;
    unsigned int qubit_num = 25;
    unsigned int info_num = 3;
    // data is ceil(25/8) * 2 = 4 * 2 = 8
    unsigned char data[8] = {0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef};

    measurement_frame_t *frame = gen_measurement(step_id, qubit_id, qubit_num, info_num, data, dest_mac, src_mac);
    print_measurement_frame(frame);
    send_measurement(interface_name, frame);

    free(frame);
    
    return 0;
}
