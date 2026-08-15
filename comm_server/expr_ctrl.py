import socket
import struct

import argparse

class ExprCtrl:

    def __init__(self, host):
        self.host = host
        self.port = 16384
    
    def send_recv(self, message):
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.settimeout(3.0)
        #print("TX:", message.hex(" "))
        try:
            sock.sendto(message, (self.host, self.port))
            data, addr = sock.recvfrom(4096)
            #print(f"Received from {addr}")
            #print("RX:", data.hex(" "))
        except socket.timeout:
            print("Timeout")
        finally:
            sock.close()
        
        return data

    def set_kick(self):
        word0 = (0xE10004 << 104).to_bytes(16, "big")
        word1 = bytes(16)      # dummy
        message = word0 + word1
        self.send_recv(message)

    def set_reset(self):
        word0 = (0xE10000 << 104).to_bytes(16, "big")
        word1 = bytes(16)      # dummy
        message = word0 + word1
        self.send_recv(message)

    def set_mac_address(self, target_mac):
        mac_bytes = bytes.fromhex(target_mac.replace(":", ""))
        self.set_mac_address_prim(mac_bytes)

    def set_mac_address_prim(self, mac_bytes):
        command_word = bytes.fromhex("E10003") + bytes(13)
        data_word = mac_bytes + bytes(10)
        message = command_word + data_word
        self.send_recv(message)

    def write_memory(self, addr, data):
        word0 = 0
        word0 |= 0xE10001 << 104      # command
        word0 |= addr << 64           # memory_addr
        word0 |= 1 << 32              # write flag
        message = (word0.to_bytes(16, "big") + data.to_bytes(16, "big"))
        self.send_recv(message)

    def read_memory(self, addr):
        word0 = 0
        word0 |= 0xE10001 << 104      # command
        word0 |= addr << 64           # memory_addr
        # bit32 = 0 → Read
        word1 = 0                     # ダミー
        message = (
            word0.to_bytes(16, "big") +
            word1.to_bytes(16, "big")
        )
        data = self.send_recv(message)
        return data[16:32]
    
    def set_config_data(self,
                        frontend_id,
                        frontend_num,
                        round_num,
                        qubit_id,
                        field_len,
                        round_unit):
        word0 = (0xE10002 << 104).to_bytes(16, "big")
        word1 = struct.pack(
            ">6H4x",      # 6個のuint16 + 4バイトパディング
            frontend_id,  # frontend_id
            frontend_num, # frontend_num
            round_num,    # round_num
            qubit_id,     # qubit_id
            field_len,    # field_len
            round_unit    # round_unit
        )
        message = word0 + word1
        self.send_recv(message)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--ipaddr', default='10.3.0.240')
    parser.add_argument('--macaddr', default='7c:83:34:b9:b1:f2')
    
    args = parser.parse_args()
    
    expr = ExprCtrl(args.ipaddr)
    
    expr.set_mac_address(args.macaddr)
    expr.set_config_data(frontend_id = 0,   # device_id
                         frontend_num = 64, # num_qubits
                         round_num = 4,     # round_num
                         qubit_id = 0,      # not used
                         field_len = 1,     # num_info
                         round_unit = 0     # not used
                         )
    expr.write_memory(0, int("deadbeef89ABCDEFFEDCBA9876543210", 16))
    ret = expr.read_memory(0)
    print(ret.hex(" "))
    expr.set_kick()
    expr.set_kick()
    expr.set_reset()
