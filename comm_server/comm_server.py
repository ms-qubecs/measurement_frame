import sys
import os
import socket
import struct
from dataclasses import dataclass

import expr_ctrl

sys.path.insert(0, os.getcwd())

import read_record

TARGET_HOST = '10.3.0.240'

INTERFACE = "enp5s0"

ETHERTYPE = 0x3535
SUPPORTED_VERSION = 0x0001

CMD_RESET_SYSTEM = 0x00000001
CMD_SET_BACKEND = 0x00000002
CMD_KICK_MEASUREMENT = 0x00000004

shots = 0

@dataclass
class EthernetCommand:
    destination_mac: bytes
    source_mac: bytes
    ethertype: int
    version: int
    command: int
    arguments: bytes


def format_mac(mac: bytes) -> str:
    return ":".join(f"{value:02x}" for value in mac)


def parse_frame(frame: bytes) -> EthernetCommand:
    # Ethernet header 14 bytes + Version 2 bytes + Command 4 bytes
    if len(frame) < 20:
        raise ValueError(
            f"Frame is too short: {len(frame)} bytes"
        )

    destination_mac, source_mac, ethertype = struct.unpack(
        "!6s6sH",
        frame[:14],
    )

    version, command = struct.unpack(
        "!HI",
        frame[14:20],
    )

    arguments = frame[20:]

    return EthernetCommand(
        destination_mac=destination_mac,
        source_mac=source_mac,
        ethertype=ethertype,
        version=version,
        command=command,
        arguments=arguments,
    )

def handle_command(packet: EthernetCommand) -> None:
    print()
    print(f"Destination MAC : {format_mac(packet.destination_mac)}")
    print(f"Source MAC      : {format_mac(packet.source_mac)}")
    print(f"Header          : 0x{packet.ethertype:04x}")
    print(f"Version         : 0x{packet.version:04x}")
    print(f"Command         : 0x{packet.command:08x}")

    if packet.version != SUPPORTED_VERSION:
        print("Unsupported version")
        return

    if packet.command == CMD_RESET_SYSTEM:
        print("Command name    : reset system")

        expr = expr_ctrl.ExprCtrl(TARGET_HOST)
        expr.set_reset()

        SHOTS = 0

    elif packet.command == CMD_SET_BACKEND:
        if len(packet.arguments) < 6:
            print("Invalid SET_BACKEND arguments")
            return

        backend_mac = packet.arguments[:6]

        print("Command name    : set backend")
        print(f"Backend MAC     : {format_mac(backend_mac)}")

        expr = expr_ctrl.ExprCtrl(TARGET_HOST)
        expr.set_mac_address_prim(backend_mac)

    elif packet.command == CMD_KICK_MEASUREMENT:
        global shots

        if len(packet.arguments) < 8:
            print("Invalid KICK_MEASUREMENT arguments")
            return

        code_distance, number_of_rounds = struct.unpack(
            "!II",
            packet.arguments[:8],
        )

        print("Command name    : kick measurement")
        print(f"Code distance   : {code_distance}")
        print(f"Number of rounds: {number_of_rounds}")
        print(f"Shots: {shots}")

        expr = expr_ctrl.ExprCtrl(TARGET_HOST)

        if code_distance == 0:
            code_distance = 3
        if number_of_rounds == 0:
            number_of_rounds = 2
            
        result = read_record.load_record(code_distance, number_of_rounds, 0, shots, shots+1, True, True)
        shots += 1 
        
        i = 0
        for qubits_bytevector_rounds in result:
            for qubits_bytevector in qubits_bytevector_rounds:
                hexstr = ''.join(f'{x:02x}' for x in qubits_bytevector)
                v = int(hexstr, 16) << 64
                expr.write_memory(i, v)
                i += 1

        for i in range(number_of_rounds):
            v = expr.read_memory(i)
            print('{:02x}:'.format(i), v.hex(" "))


        expr.set_config_data(frontend_id = 0,   # device_id
                             frontend_num = 64, # num_qubits
                             round_num = number_of_rounds,     # round_num
                             qubit_id = 0,      # not used
                             field_len = 1,     # num_info
                             round_unit = 0     # not used
                             )
        
        print("kick")
        expr.set_kick()

    else:
        print("Command name    : unknown")
        print(f"Arguments       : {packet.arguments.hex(' ')}")


def main() -> None:
    # 0x3535のEthernetフレームだけを受信
    with socket.socket(socket.AF_PACKET, socket.SOCK_RAW, socket.htons(ETHERTYPE)) as sock:
        sock.bind((INTERFACE, 0))

        print(f"Listening on {INTERFACE}")
        print(f"EtherType: 0x{ETHERTYPE:04x}")

        while True:
            frame, address = sock.recvfrom(65535)

            try:
                packet = parse_frame(frame)
            except ValueError as error:
                print(f"Invalid frame: {error}")
                continue

            # check header
            if packet.ethertype != ETHERTYPE:
                continue

            handle_command(packet)


if __name__ == "__main__":
    main()
