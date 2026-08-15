import argparse
import socket
import struct


ETHERTYPE = 0x3535
VERSION = 0x0001

CMD_RESET_SYSTEM = 0x00000001
CMD_SET_BACKEND = 0x00000002
CMD_KICK_MEASUREMENT = 0x00000004


def parse_mac(mac: str) -> bytes:
    value = bytes.fromhex(mac.replace(":", ""))

    if len(value) != 6:
        raise ValueError(f"Invalid MAC address: {mac}")

    return value


def format_mac(mac: bytes) -> str:
    return ":".join(f"{value:02x}" for value in mac)

def make_reset_frame(
    destination_mac: bytes,
    source_mac: bytes,
) -> bytes:
    if len(destination_mac) != 6:
        raise ValueError("destination_mac must be 6 bytes")

    if len(source_mac) != 6:
        raise ValueError("source_mac must be 6 bytes")

    frame = struct.pack(
        "!6s6sHHI",
        destination_mac,
        source_mac,
        ETHERTYPE,
        VERSION,
        CMD_RESET_SYSTEM,
    )

    # EthernetフレームはFCSを除いて最低60バイト
    return frame.ljust(60, b"\x00")

def make_set_backend_frame(
    destination_mac: bytes,
    source_mac: bytes,
    backend_mac: bytes,
) -> bytes:
    if len(destination_mac) != 6:
        raise ValueError("destination_mac must be 6 bytes")

    if len(source_mac) != 6:
        raise ValueError("source_mac must be 6 bytes")

    if len(backend_mac) != 6:
        raise ValueError("backend_mac must be 6 bytes")

    frame = struct.pack(
        "!6s6sHHI6s",
        destination_mac,
        source_mac,
        ETHERTYPE,
        VERSION,
        CMD_SET_BACKEND,
        backend_mac,
    )

    # EthernetフレームはFCSを除いて最低60バイト
    return frame.ljust(60, b"\x00")

def make_kick_measurement_frame(
    destination_mac: bytes,
    source_mac: bytes,
    code_distance: int,
    num_of_rounds: int,
) -> bytes:
    if len(destination_mac) != 6:
        raise ValueError("destination_mac must be 6 bytes")

    if len(source_mac) != 6:
        raise ValueError("source_mac must be 6 bytes")

    frame = struct.pack(
        "!6s6sHHIII",
        destination_mac,
        source_mac,
        ETHERTYPE,
        VERSION,
        CMD_KICK_MEASUREMENT,
        code_distance,
        num_of_rounds,
    )

    # EthernetフレームはFCSを除いて最低60バイト
    return frame.ljust(60, b"\x00")


def main() -> None:
    parser = argparse.ArgumentParser()

    parser.add_argument("--interface", default="eth0")
    parser.add_argument("--dst-mac", required=True, help="destination MAC address")
    parser.add_argument("--src-mac", required=True, help="this MAC address")
    parser.add_argument("--backend-mac", required=True, help="configuration MAC address")
    
    args = parser.parse_args()

    destination_mac = parse_mac(args.dst_mac)
    source_mac = parse_mac(args.src_mac)
    backend_mac = parse_mac(args.backend_mac)

#    frame = make_set_backend_frame(
#        destination_mac=destination_mac,
#        source_mac=source_mac,
#        backend_mac=backend_mac,
#    )
#    frame = make_reset_frame(
#        destination_mac=destination_mac,
#        source_mac=source_mac,
#    )
    frame = make_kick_measurement_frame(
        destination_mac=destination_mac,
        source_mac=source_mac,
        code_distance = 3,
        num_of_rounds = 4,
    )

    print(f"Destination MAC : {format_mac(destination_mac)}")
    print(f"Source MAC      : {format_mac(source_mac)}")
    print(f"Backend MAC     : {format_mac(backend_mac)}")
    print("TX:", frame.hex(" "))

    with socket.socket(socket.AF_PACKET, socket.SOCK_RAW, socket.htons(ETHERTYPE)) as sock:
        sock.bind((args.interface, 0))
        sock.send(frame)


if __name__ == "__main__":
    main()
