# Measurement Frame Reference

## Overview

This repository provides a reference implementation of the Measurement Frame Format (MFF).

See the following documents for details:
- [Measurement Frame Format specification](docs/measurement_frame_format.md)

## System Setup

The assumed system architecture is shown below.
- `BE` denotes the Quantum Error Correction backend.
- `FE` denotes the Quantum-Classical interface frontend.
- An `FE server` manages and coordinates multiple `FE`s.

Each `FE` sends measured error syndrome data directly to the `BE`
using the Measurement Frame Format (MFF) over Ethernet II (Layer 2).

Control communication between the `BE` and the `FE server`
is also performed over Ethernet II (Layer 2).

Communication between the `FE server` and individual `FE`s
is implementation-defined and is outside the scope of this specification.

```
 +----+                           +--------+    +-----+
 |    |                           |        |    |     |
 |    |<-(control communication)->| FE     |--->|     |
 | BE |                           | server |    | FEs |
 |    |                           |        |    |     |
 |    |                           +--------+    |     |
 |    |                                         |     |
 |    |<-------(measurement frame)--------------|     |
 |    |                                         |     |
 +----+                                         +-----+
```

## Build

```
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build . -j
ctest --output-on-failure
```

## Usage

### The example of send/recv error-syndrome

#### Receiver

```
sudo ./ethernet_receiver <interface name>
```

#### Sender

```
sudo ./measurement_frame_sender <interface name> <destination MAC address>
```

