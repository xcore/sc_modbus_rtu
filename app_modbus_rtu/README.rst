Modbus RTU Demo
===============

:scope: Example
:description: Demonstrates Modbus slave with GPIO slice card
:keywords: ModbusRTU
:boards: XA-SK-ISBUS, XA-SK-GPIO

Demo Overview
=============

This simple demonstration of xTIMEcomposer Studio functionality that uses the XA-SK-ISBUS and XA-SK-GPIO Slice Cards together with the xSOFTip ``module_modbus_rtu`` to demonstrate how the module is used to receive commands from a Modbus Master over RS485 and service them to:

- Turn GPIO Slice Card LEDS on and off
- Read the room temperature via the on-board ADC
- Display GPIO Slice Card button presses
- Read communication message counters

Software Requirements
=====================

A Modbus Master application running on the host. For example:

- SimplyModbus on a PC (http://www.simplymodbus.ca/TCPclient.htm)
- Free command line based Modbus Master simulator like FieldTalk modpoll (http://www.focus-sw.com/fieldtalk/modpoll.html)

Required Repositories
=====================

- sc_modbus_rtu git://github.com/xcore/sc_modbus_rtu.git
- sc_i2c git://github.com/xcore/sc_i2c.git

Support
=======

Issues may be submitted via the Issues tab in this github repo. Response to any issues submitted as at the discretion of the manitainer for this line.
