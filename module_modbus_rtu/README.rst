Modbus RTU
==========

:scope: General Use
:description: Modbus RTU Server component
:keywords: ModbusRTU
:boards: XA-SK-ISBUS

Key Features
============

Implements following Modbus commands received over RS485:

- Read Coils
- Read Discrete Inputs
- Read Holding Registers
- Read Input Register
- Write Single Coil
- Write Single Register
- Read Exception Status
- Diagnostics
- Get Comm Event Counter
- Write Multiple Coils

Description
===========

The Modbus RTU component internally uses RS485 component to receive Modbus master commands over RS485 interface. Based on the commands issued by the Modbus Master, the Modbus RTU component requests appropriate data from the user application. It then sends this data back to the Modbus Master and waits for next command.
