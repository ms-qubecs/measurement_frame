#include <stdlib.h>
#include <arpa/inet.h>

#include "measurement_frame_format.h"
#include "ethernet_util.h"

/**
 * 8bit alignment
 */
static unsigned int align_to_8bit(unsigned int len)
{
    return (len + 7) / 8; // 8bit alignment
}

/**
 * allocate measurement frame info. to send the given #. of X,Z ancilas
 * @param len #. of ancilas to send
 * @return the pointer to allocated memory or NULL if some error occurs.
 */
measurement_frame_t * new_measurement_frame(unsigned int qubit_num, unsigned int info_num)
{
    unsigned int byte_size = align_to_8bit(qubit_num);
    int bufsize = sizeof(measurement_frame_t) + byte_size * info_num;
    
    measurement_frame_t *frame = (measurement_frame_t*)malloc(bufsize);
    if(frame == NULL){
        return 0;
    }
    
    *((unsigned short*)frame->header_type) = htons(MEASUREMENT_FRAME_TYPE);
    *((unsigned short*)frame->version) = htons(MEASUREMENT_FRAME_VERSION);
    *((unsigned int*)frame->qubit_num) = htonl(qubit_num);
    *((unsigned int*)frame->info_num) = htonl(info_num);

    return frame;
}

unsigned int measurement_frame_length(measurement_frame_t *frame)
{
    unsigned int byte_size = align_to_8bit(ntohl(*(unsigned int*)frame->qubit_num));
    unsigned int info_num = ntohl(*(unsigned int*)frame->info_num);
    return sizeof(measurement_frame_t) + byte_size * info_num;
}

void print_measurement_frame(measurement_frame_t *frame)
{
    print_mac_address(frame->dest);
    printf(" -> ");
    print_mac_address(frame->src);
    printf("\n");
    printf("TYPE: 0x%04x\n", ntohs(*(unsigned short*)frame->header_type));
    printf("VERSION: 0x%02x\n", ntohs(*(unsigned short*)frame->version));
    printf("STEP: 0x%016lx\n", be64toh(*(unsigned long long*)frame->step_id));
    printf("Device:0x%08x\n", ntohl(*(unsigned int*)frame->device_id));
    unsigned int qubit_num = ntohl(*(unsigned int*)frame->qubit_num);
    unsigned int info_num = ntohl(*(unsigned int*)frame->info_num);
    printf("#. of Qubits: %d\n", qubit_num);
    printf("#. of Info: %d\n", info_num);

    unsigned int bytes = align_to_8bit(qubit_num);
    for(int i = 0; i < info_num; i++){
        printf("Info.:%d", i);
        for(int j = 0; j < bytes; j++){
            printf(" %02x", frame->measurement[bytes*i + j]);
        }
        printf("\n");
    }
}
