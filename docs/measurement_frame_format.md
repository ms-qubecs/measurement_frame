# Measurement Frame Format

## Overview

The Measurement Frame Format (MFF) is an Ethernet II frame used to transmit measurement data
from the Quantum-Classical interface frontend (FE) to the quantum error-correction backend (BE).

Key features are as follows:

- Uses a simple Ethernet II frame to minimize hardware/software implementation cost.
- Encodes measurement data as a position-dependent bit vector so that frames can be merged efficiently.

## Frame format

SFF is carried in an Ethernet II frame. All multi-byte fields use network byte order (big-endian).

```
 +--------+--------+--------+--------+--------+--------+--------+--------+
 | Destination MAC address                             | Source MAC...   |
 +--------+--------+--------+--------+--------+--------+--------+--------+
 | ...address                        | EtherType       | Version         |
 +--------+--------+--------+--------+--------+--------+--------+--------+
 | Step ID                                                               |
 +--------+--------+--------+--------+--------+--------+--------+--------+
 | Qubit ID                          | #. of Qubits                      |
 +--------+--------+--------+--------+--------+--------+--------+--------+
 | #. of Information bits            | Measurement data payload ...      |
 +--------+--------+--------+--------+--------+--------+--------+--------+
 | ...                                                                   |
 +--------+--------+--------+--------+--------+--------+--------+--------+
```

- Destination and Source MAC addresses are 6 octets each.
- `EtherType` is 2 octets and is set to `0x3434` for MFF.
- `Version` is 2 octets. The current version is `0x0002`.
- `Step ID` is 8 octets and identifies the QEC step (e.g., round index).
- `Logical Qubit ID` is 4 octets and identifies the target physical qubit.
- `#. of Qubits` is 4 octets and specifies the length of **each** measurement information bit vector in bits.
- `#. of Information bits` is 4 octets and specifies the length of information bit measured from each qubit.
  - At least, each qubit has 1 measuremented bit for the state.
  - In some case, controller get additional software information bit for each qubit.
- `Measurement data payload` is variable length determined by `Payload length`.
  Measurement data consists of bit vectors of information bits.
  The total payload size in bytes is `#. of Inforamtion bits * ceil(#. of Qubits / 8)`.

MFF may be transported over networks supporting jumbo frames.
The maximum usable the length of `Measurement data payload` is constrained by the link MTU.

## Payload Layout for Surface Code

### Bit Mapping

Within each bit vector:
- Bit positions correspond to Physical Qubit IDs
- Physical Qubit ID 0 corresponds to the most significant bit (MSB) of the first byte.
- Bits increase in ascending Physical Qubit ID order.
- Bits are ordered in big-endian bit order within each byte.

### Payload Layout

```
+---------------------------+---------------------------+---------------------------+
| Information bit[0]        | Information bit[1]        | Information bit[...]      | 
+---------------------------+---------------------------+---------------------------+
```

Let:

- `N` = the number of qubits
- `I` = the number of information bits.

The number of qubits and information bits are implementation-defined and must be consistent between FE and BE.

Then:

If `N` is not a multiple of 8, the unused least significant bits of the final byte shall be set to zero.

### Interpretation

Each bit represents the measured measurement value of the corresponding qubit:

- `0`
- `1`

When multiple frames with the same `Step ID` are merged, the payloads shall be combined by bitwise OR.
