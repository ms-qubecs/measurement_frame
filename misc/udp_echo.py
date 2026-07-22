from socket import *

class udprecv():
    def __init__(self):
        self.addr = ("0.0.0.0", 16384)
        self.sock = socket(AF_INET, SOCK_DGRAM)
        self.sock.bind(self.addr)

    def recv(self):
        while True:
            data, addr = self.sock.recvfrom(2048)
            print(data.hex(), addr)
            self.sock.sendto(data, addr)

if __name__ == '__main__':
    udp = udprecv()
    udp.recv()
