Modbus RTU Repository
.....................

:Latest release: 1.0.1beta5
:Maintainer: vinithmundhra
:Description: Modbus RTU component


Firmware Overview
=================

This is a Modbus RTU Server component (A Modbus Slave). 
Modbus protocol specification and messaging implementation guide can be found here: Modbusorg_

The Modbus RTU Server component accepts data over RS485 interface and processes them for Modbus commands. If the received RTU data is a Modbus command, the component requests data from/to the user application. The request (Modbus Command) is usually to read/write values from/to registers, coils, etc... After this, the component forms the required Modbus response, sends it back to Modbus Master and waits for next Modbus command.

.. _Modbusorg: http://www.modbus.org/specs.php

Known Issues
============

none

Support
=======

Issues may be submitted via the Issues tab in this github repository. 
Response to any issues submitted as at the discretion of the maintainer for this line.

Required software (dependencies)
================================

  * sc_i2c (https://github.com/xcore/sc_i2c.git)
  * sc_uart (https://github.com/xcore/sc_uart.git)

