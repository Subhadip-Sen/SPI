# SPI Master-Slave Memory Communication System

This project implements a custom **SPI protocol-based communication system** between a **Master**, **Slave**, and **Memory module** using **SystemVerilog**. It supports both read and write operations initiated by the SPI Master, with the Slave acting as an intermediary to access memory.


## ⚙️ Modules Overview

### SPI Master
- Initiates communication and controls the SPI clock (assumed).
- Sends 17-bit packet: `{data[7:0], address[7:0], op (wr/rd)}`
- FSM-based operation with states: `IDLE`, `LOAD`, `CHECK_OP`, `SEND_DATA`, `SEND_ADDR`, `READ_DATA`, `DONE`, `ERROR`

### SPI Slave
- Responds to master's commands and interacts with internal memory.
- Decodes read/write instructions and performs memory access.
- FSM with states: `IDLE`, `READ_DATA`, `GET_ADDR`, `SEND_DATA`.

### Memory
- 256-byte internal memory within the slave.
- Supports byte-addressable read and write.

### SPI Protocol Behavior

- **Write Operation**
  - Master sends 17-bit packet to Slave.
  - Slave writes to memory at specified address.
- **Read Operation**
  - Master sends 9-bit address command.
  - Slave responds with data from memory.

## 🧪 Simulation

You can simulate this design using tools like **ModelSim**, **Vivado**, or **Icarus Verilog**.
