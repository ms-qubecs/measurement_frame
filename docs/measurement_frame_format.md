# Measurement Frame Format

## Overview

The Measurement Frame Format (MFF) is an Ethernet II frame used to transmit measurement data
from the Quantum-Classical interface frontend (FE) to the quantum error-correction backend (BE).

Key features are as follows:

- Uses a simple Ethernet II frame to minimize hardware/software implementation cost.
- Encodes measurement data as fixed-length, position-dependent bit vectors for efficient frame merging.

## Frame format

MFF is carried in an Ethernet II frame. All multi-byte fields use network byte order (big-endian).

```
 +--------+--------+--------+--------+--------+--------+--------+--------+
 | Destination MAC address                             | Source MAC...   |
 +--------+--------+--------+--------+--------+--------+--------+--------+
 | ...address                        | EtherType       | Version         |
 +--------+--------+--------+--------+--------+--------+--------+--------+
 | Step ID                                                               |
 +--------+--------+--------+--------+--------+--------+--------+--------+
 | Device ID                         | #. of Qubits                      |
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
- `Device ID` is 4 octets and identifies the control device unit.
- `#. of Qubits` is 4 octets and specifies the total number of physical qubits in the target quantum processor. This value determines the length of each measurement information bit vector.
- `#. of Information bits` is 4 octets and specifies the number of measurement information bits for each qubit.
  - Each qubit has at least one measured bit representing its state.
  - The frontend may optionally include additional soft information bits for each qubit.
- The Measurement data payload has a variable length determined by `#. of Qubits` and `#. of Information bits`.
  It consists of one bit vector for each information bit. Each bit vector contains one bit per qubit.
  The total payload size in bytes is `#. of Information bits` x `ceil(#. of Qubits / 8)`.

MFF may be transported over networks supporting jumbo frames.
The maximum size of the Measurement Data payload is limited by the link MTU.

## Bit Mapping

Within each measurement information bit vector:
- Bit positions correspond to physical qubit IDs
- Physical qubit ID 0 corresponds to the most significant bit (MSB) of the first byte.
- Bits increase in ascending physical qubit ID order.
- Bits are ordered in big-endian bit order within each byte.

### Payload Layout

```
+---------------------------+---------------------------+---------------------------+
| Information bit[0]        | Information bit[1]        | Information bit[...]      | 
+---------------------------+---------------------------+---------------------------+
```

Each information bit field is encoded as a bit vector of `N` bits and occupies `ceil(N / 8)` bytes.

Let:

- `N` = the number of qubits
- `I` = the number of information bits.

The values of `#. of Qubits` and `#. of Information bits` are implementation-defined and shall be consistent between the FE and BE.
If N is not a multiple of 8, the unused least significant bits of the final byte shall be set to zero.

### Interpretation

Each bit represents the measurement result of the corresponding physical qubit.
When multiple MFF frames with the same `Step ID` are merged,
the corresponding measurement data payloads shall be combined using a bitwise OR operation.
This allows independently generated measurement frames to be merged without regard to their transmission order.

## Example

The following example shows a frame carrying one measurement result bit and two soft information bits for each qubit.

Given:

- `#. of Qubits = 25`
- `#. of Information bits = 3`

Each information bit field is encoded as a 25-bit vector and occupies `ceil(25 / 8) = 4` bytes.
The payload therefore occupies `3 × 4 = 12` bytes.

```
+--------------------+--------------------+--------------------+
| Measurement result | Soft information 0 | Soft information 1 |
|      4 bytes       |      4 bytes       |      4 bytes       |
+--------------------+--------------------+--------------------+
```

The bit layout of each information bit field is:

```
Byte 0        Byte 1        Byte 2        Byte 3
+--------+    +--------+    +--------+    +--------+
|0......7|    |8.....15|    |16....23|    |24|PAD..|
+--------+    +--------+    +--------+    +--------+
 MSB                                                  LSB
```

where

- Bit 0 corresponds to physical qubit ID 0.
- Bit 24 corresponds to physical qubit ID 24.
- The remaining seven least significant bits of the final byte are padding bits and shall be set to zero.

For example, if

```
Qubit 0  = 1
Qubit 1  = 0
...
Qubit 24 = 1
```

the last byte is encoded as

```
+---+-------+
|24 | PAD   |
+---+-------+
  1 0000000
```

where the padding bits are all zero.
