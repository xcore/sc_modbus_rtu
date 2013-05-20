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
- Write Single Coil
- Read Input Register
- Read Holding Registers
- Write Single Register
- Read Discrete Inputs

Description
===========

The Modbus RTU component internally uses RS485 component to receive Modbus master commands from a RS485 client. Based on the commands issued by the Modbus Master, the Modbus RTU component requests appropriate data from the user application. It then sends this data back to the Modbus Master and waits for next command.
