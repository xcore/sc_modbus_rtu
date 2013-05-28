Modbus RTU Demo
===============

:scope: Example
:description: Demonstrates Modbus slave with GPIO sliceCARD
:keywords: ModbusRTU
:boards: XA-SK-ISBUS, XA-SK-GPIO

Demo Overview
=============

This simple demonstration of xTIMEcomposer Studio functionality that uses the XA-SK-ISBUS and XA-SK-GPIO sliceCARD together with the xSOFTip ``module_modbus_rtu`` and ``module_i2c_master`` to demonstrate how to receive commands from a Modbus Master over RS485 and service them to:

- Turn GPIO sliceCARD LEDS on and off
- Read the room temperature via the on-board ADC
- Display GPIO sliceCARD button presses

Software Requirements
=====================

A Modbus Master application running on the host. For example:

- SimplyModbus on a PC (http://www.simplymodbus.ca/TCPclient.htm)

Required Repositories
=====================

- sc_modbus_rtu git://github.com/xcore/sc_modbus_rtu.git
- sc_i2c git://github.com/xcore/sc_i2c.git

Support
=======

Issues may be submitted via the Issues tab in this github repo. Response to any issues submitted as at the discretion of the manitainer for this line.
