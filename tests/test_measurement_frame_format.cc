#include <gtest/gtest.h>
#include <arpa/inet.h>
#include <string>
#include <vector>

extern "C" {
#include "measurement_frame_format.h"
#include "ethernet_util.h"

    // 被テスト関数（C実装）
    measurement_frame_t* new_measurement_frame(unsigned int qubit_num, unsigned info_num);
    unsigned int measurement_frame_length(measurement_frame_t* frame);
    void print_measurement_frame(measurement_frame_t* frame);
}

// ヘルパ：MACを埋める（ethernet_util.h 側の実装に依存しないように直接代入）
static void set_mac(uint8_t mac[6], uint64_t v) {
    for (int i = 0; i < 6; ++i) mac[5 - i] = (v >> (i * 8)) & 0xFF;
}

// ヘルパ：qubit_numとinfo_numから合計バイト数を算出
static size_t total_bytes(uint32_t qubit_num, uint32_t info_num) {
    const size_t bytes = ((qubit_num + 7u) / 8u) * 1u; // 8bitアライン
    return bytes * info_num;
}

TEST(MeasurementFrame, AllocAndHeaderInit) {
    for (uint32_t qubit_num : std::vector<uint16_t>{0, 1, 31, 32, 33, 64}) {
        for (uint32_t info_num : std::vector<uint16_t>{1, 2, 3}) {
            auto* f = new_measurement_frame(qubit_num, info_num);
            ASSERT_NE(f, nullptr) << "allocation failed at qubit_num=" << qubit_num << ", " << info_num;
            
            // ヘッダ値（ネットワークバイトオーダ）確認
            EXPECT_EQ(ntohs(*(uint16_t*)f->header_type), MEASUREMENT_FRAME_TYPE);
            EXPECT_EQ(ntohs(*(uint16_t*)f->version), MEASUREMENT_FRAME_VERSION);
            EXPECT_EQ(ntohl(*(uint32_t*)f->qubit_num), qubit_num);
            EXPECT_EQ(ntohl(*(uint32_t*)f->info_num), info_num);
            
            // 全体サイズが  sizeof(header) + ceil(qubit_num/8)*info_num になっているか
            const size_t expected_total = sizeof(measurement_frame_t) + total_bytes(qubit_num, info_num);
            EXPECT_EQ(expected_total, (size_t)measurement_frame_length(f));
            
            free(f);
        }
    }
}

