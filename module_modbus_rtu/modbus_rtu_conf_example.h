// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*===========================================================================
 Info
 ----
 Modbus RTU Configuration
 ===========================================================================*/

#ifndef __modbus_rtu_conf_h__
#define __modbus_rtu_conf_h__

#define MODBUS_COIL_ADDRESS_START               0
#define MODBUS_COIL_ADDRESS_END                 2000
#define MODBUS_DISCRETE_INPUT_ADDRESS_START     0
#define MODBUS_DISCRETE_INPUT_ADDRESS_END       2000
#define MODBUS_INPUT_REGISTER_ADDRESS_START     0
#define MODBUS_INPUT_REGISTER_ADDRESS_END       125
#define MODBUS_HOLDING_REGISTER_ADDRESS_START   0
#define MODBUS_HOLDING_REGISTER_ADDRESS_END     125

#endif // __modbus_rtu_conf_h__
