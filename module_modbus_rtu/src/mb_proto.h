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
#define MBRTU_ADDRESS_BROADCAST   0     /*!< Modbus Broadcast Address. */
#define MBRTU_ADDRESS_MIN         1     /*!< Smallest Modbus Slave Address. */
#define MBRTU_ADDRESS_MAX         247   /*!< Largest Modbus Slave Address. */

#define MBRTU_PDU_SIZE_MIN        4     /*!< Minimum size of a Modbus RTU frame. */
#define MBRTU_PDU_SIZE_MAX        256   /*!< Maximum size of a Modbus RTU frame. */

#define MBRTU_SLAVE_ADDR_OFF      0                           /*!< Offset of slave address. */
#define MBRTU_FNCODE_OFF          (MBRTU_SLAVE_ADDR_OFF + 1)  /*!< Offset of Function Code. */
#define MBRTU_DATA_OFF            (MBRTU_SLAVE_ADDR_OFF + 2)  /*!< Offset of Read Data. */

#define MBRTU_READ_QTY_OFF        (MBRTU_SLAVE_ADDR_OFF + 4)  /*!< Offset of Read Quantity. */
#define MBRTU_READ_RESP_QTY_OFF   (MBRTU_SLAVE_ADDR_OFF + 2)
#define MBRTU_READ_RESP_DATA_OFF  (MBRTU_SLAVE_ADDR_OFF + 3)
#define MBRTU_READ_RESP_QTY_MIN   3

#define MBRTU_WRITE_VALUE_OFF     (MBRTU_SLAVE_ADDR_OFF + 4)

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
/**
 * \enum mb_exception_t
 * \brief Modbus Exception Codes
 */
typedef enum mb_exception_t_
{
  MB_EX_NONE = 0x00,
  MB_EX_ILLEGAL_FUNCTION = 0x01,
  MB_EX_ILLEGAL_DATA_ADDRESS = 0x02,
  MB_EX_ILLEGAL_DATA_VALUE = 0x03,
  MB_EX_SLAVE_DEVICE_FAILURE = 0x04
} mb_exception_t;

/**
 * \enum mb_exception_t
 * \brief Modbus Exception Codes
 */
typedef enum mb_diagnostic_sub_fn_code_t_
{
  MB_DIAG_QUERY_DATA = 0,
  MB_DIAG_FORCE_LISTEN_ONLY = 4,
  MB_DIAG_CLEAR = 10,
  MB_DIAG_BUS_MSG_COUNT = 11,
  MB_DIAG_BUS_COMM_ERROR_COUNT = 12,
  MB_DIAG_BUS_EXCEPTION_COUNT = 13,
  MB_DIAG_SERVER_MESSAGE_COUNT = 14,
  MB_DIAG_SERVER_NO_RESPONSE_COUNT = 15
}mb_diagnostic_sub_fn_code_t;

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
