# AXI4-Lite Slave Interface

## 📘 Description

This SystemVerilog module implements an **AXI4-Lite Slave** compliant with the AMBA AXI4-Lite protocol. It supports:

- ✅ 32-bit data width
- ✅ 4 memory-mapped registers
- ✅ Byte-wise writes via `WSTRB`
- ✅ Full-duplex, handshake-based read/write transactions

This design is ideal for simple control/status register maps in SoC and FPGA designs.

---

## 📡 Interface Signals

| Channel        | Signal         | Dir     | Width         | Description                              |
|----------------|----------------|---------|---------------|------------------------------------------|
| **Global**     | `ACLK`         | Input   | 1             | Clock signal                             |
|                | `ARESETn`      | Input   | 1 (active low) | Asynchronous reset                       |
| **Write Addr** | `AWADDR`       | Input   | `ADDR_WIDTH`  | Write address                            |
|                | `AWVALID`      | Input   | 1             | Write address valid                      |
|                | `AWREADY`      | Output  | 1             | Write address ready                      |
| **Write Data** | `WDATA`        | Input   | `DATA_WIDTH`  | Write data                               |
|                | `WSTRB`        | Input   | `DATA_WIDTH/8`| Write strobe (byte-enable)               |
|                | `WVALID`       | Input   | 1             | Write data valid                         |
|                | `WREADY`       | Output  | 1             | Write data ready                         |
| **Write Resp** | `BVALID`       | Output  | 1             | Write response valid                     |
|                | `BREADY`       | Input   | 1             | Write response ready                     |
| **Read Addr**  | `ARADDR`       | Input   | `ADDR_WIDTH`  | Read address                             |
|                | `ARVALID`      | Input   | 1             | Read address valid                       |
|                | `ARREADY`      | Output  | 1             | Read address ready                       |
| **Read Data**  | `RDATA`        | Output  | `DATA_WIDTH`  | Read data                                |
|                | `RVALID`       | Output  | 1             | Read data valid                          |
|                | `RREADY`       | Input   | 1             | Read data ready                          |

---

## 🧠 Key Features

- Word-aligned address decoding via `addr[3:2]`
- Internal register file: 4 x 32-bit registers
- Partial writes handled using `WSTRB`
- All channels follow AXI handshaking:
  - `VALID` asserted by sender
  - `READY` asserted by receiver

---


