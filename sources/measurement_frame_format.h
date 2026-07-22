#ifndef __MEASUREMENT_FRAME_FORMAT_H__
#define __MEASUREMENT_FRAME_FORMAT_H__

static const unsigned short MEASUREMENT_FRAME_TYPE = 0x0344;
static const unsigned short MEASUREMENT_FRAME_VERSION = 0x0002;

typedef struct {
    unsigned char dest[6]; // destination MAC address
    unsigned char src[6];  // source MAC address
    unsigned char header_type[2]; // Type
    unsigned char version[2];
    unsigned char step_id[8];
    unsigned char qubit_id[4];
    unsigned char qubit_num[4];
    unsigned char info_num[4];
    unsigned char measurement[];
} measurement_frame_t;

measurement_frame_t * new_measurement_frame(unsigned int qubit_num, unsigned int info_num);
unsigned int measurement_frame_length(measurement_frame_t *frame);
void print_measurement_frame(measurement_frame_t *frame);

#endif /* __MEASUREMENT_FRAME_FORMAT_H__ */
