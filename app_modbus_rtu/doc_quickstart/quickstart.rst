Modbus RTU Demo Quickstart Guide
================================

This simple demonstration of xTIMEcomposer Studio functionality that uses the ``XA-SK-ISBUS`` and ``XA-SK-GPIO`` Slice Cards together with the xSOFTip ``module_modbus_rtu`` to demonstrate how the module is used to receive commands from a Modbus Master over RS485 bus and service them to:

- Turn GPIO Slice Card LEDS on and off
- Read the room temperature via the on-board ADC
- Display GPIO Slice Card button presses
- Read communication messages counters

Host Computer Setup
+++++++++++++++++++

Free Modbus master simulator utility like FieldTalk modpoll (http://www.focus-sw.com/fieldtalk/modpoll.html) is available. Download and install the utility on your system.

Hardware Setup
++++++++++++++

The Modbus RTU Demo Application requires the following items:

- XP-SKC-L2 Slicekit Core board marked with edge connectors: ``SQUARE``, ``CIRCLE``, ``TRIANGLE`` and ``STAR``.
- XA-SK-ISBUS Ethernet Slice Card
- XA-SK-GPIO GPIO Slice Card
- XTAG2 and XTAG Adapter
- Ethernet Cable and
- 12V DC power supply

To setup the system:
