// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*===========================================================================
 Info
 ----

 ===========================================================================*/

#ifndef __mb_proto_h__
#define __mb_proto_h__

/*---------------------------------------------------------------------------
 nested include files
 ---------------------------------------------------------------------------*/
#ifdef __modbus_rtu_conf_h_exists__
#include "modbus_rtu_conf.h"
#endif

/*---------------------------------------------------------------------------
 constants
 ---------------------------------------------------------------------------*/
#define MBRTU_ADDRESS_BROADCAST   0   /**< Modbus broadcast address */
#define MBRTU_ADDRESS_MIN         1   /**< Smallest Modbus RTU slave address */
#define MBRTU_ADDRESS_MAX         247 /**< Largest Modbus RTU slave address */
#define MBRTU_PDU_SIZE_MIN        4   /**< Minimum size of Modbus RTU frame */
#define MBRTU_PDU_SIZE_MAX        256 /**< Maximum size of Modbus RTU frame */
#define MBRTU_READ_RESP_QTY_MIN   3   /**< Minimum response length */

#define MBRTU_SLAVE_ADDR_OFF      0   /**< Slave address offset */
#define MBRTU_FNCODE_OFF          1   /**< Function code offset */
#define MBRTU_DATA_OFF            2   /**< Data offset */
#define MBRTU_READ_QTY_OFF        4   /**< Read quantity offset */
#define MBRTU_READ_RESP_QTY_OFF   2   /**< Response quantity offset */
#define MBRTU_READ_RESP_DATA_OFF  3   /**< Response data offset */
#define MBRTU_WRITE_VALUE_OFF     4   /**< Write value offset */

/**
 * Default Modbus device addresses. May be defined in modbus_rtu_conf.h by user.
 */
#ifndef MODBUS_COIL_ADDRESS_START
#define MODBUS_COIL_ADDRESS_START               0
#endif
#ifndef MODBUS_COIL_ADDRESS_END
#define MODBUS_COIL_ADDRESS_END                 2000
#endif
#ifndef MODBUS_DISCRETE_INPUT_ADDRESS_START
#define MODBUS_DISCRETE_INPUT_ADDRESS_START     0
#endif
#ifndef MODBUS_DISCRETE_INPUT_ADDRESS_END
#define MODBUS_DISCRETE_INPUT_ADDRESS_END       2000
#endif
#ifndef MODBUS_INPUT_REGISTER_ADDRESS_START
#define MODBUS_INPUT_REGISTER_ADDRESS_START     0
#endif
#ifndef MODBUS_INPUT_REGISTER_ADDRESS_END
#define MODBUS_INPUT_REGISTER_ADDRESS_END       125
#endif
#ifndef MODBUS_HOLDING_REGISTER_ADDRESS_START
#define MODBUS_HOLDING_REGISTER_ADDRESS_START   0
#endif
#ifndef MODBUS_HOLDING_REGISTER_ADDRESS_END
#define MODBUS_HOLDING_REGISTER_ADDRESS_END     125
#endif

/*---------------------------------------------------------------------------
 typedefs
 ---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
 global variables
 ---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
 extern variables
 ---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
 prototypes
 ---------------------------------------------------------------------------*/

#endif // __mbrtu_proto_h__
/*==========================================================================*/
