// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*===========================================================================
 Info
 ----
 Modbus Function codes and device return values
 ===========================================================================*/

#ifndef __mb_codes_h__
#define __mb_codes_h__

/*---------------------------------------------------------------------------
 nested include files
 ---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
 constants
 ---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
 typedefs
 ---------------------------------------------------------------------------*/
/** \enum   modbus_rtu_cmd_t
 *  \brief  Modbus commands supported.
 *
 *  This Modbus RTU slave implmentation can service the following Modbus master
 *  commands (Function Codes). Any other command by the Modbus master will
 *  result in an exception response (illegal function).
 */
typedef enum modbus_rtu_cmd_t_
{
  MODBUS_READ_COIL              = 0x01, /**<Modbus Read Coils */
  MODBUS_READ_DISCRETE_INPUT    = 0x02, /**<Modbus Read Discrete Inputs */
  MODBUS_READ_HOLDING_REGISTER  = 0x03, /**<Modbus Read Holding Registers */
  MODBUS_READ_INPUT_REGISTER    = 0x04, /**<Modbus Read Input Registers */
  MODBUS_WRITE_SINGLE_COIL      = 0x05, /**<Modbus Write Single Coil */
  MODBUS_WRITE_SINGLE_REGISTER  = 0x06, /**<Modbus Write Single Register */
  MODBUS_READ_EXCEPTION_STATUS  = 0x07, /**<Modbus Read Exception Status */
  MODBUS_DIAGNOSTIC             = 0x08, /**<Modbus Diagnostic */
  MODBUS_COMM_EVENT_COUNTER     = 0x0B, /**<Modbus Get Comm Event Counter */
  MODBUS_WRITE_MULTIPLE_COILS   = 0x0F, /**<Modbus Write Multiple Coils */
}modbus_rtu_cmd_t;

/** \enum   modbus_rtu_device_status_t
 *  \brief  Device access status.
 *
 *  The user application may respond with following status when a Modbus command
 *  is used to access the devices connected to it.
 */
typedef enum modbus_rtu_device_status_t_
{
  MODBUS_READ_1BIT_ERROR  = 2,  /**<Application fails to read coil (or) discrete
                                input */
  MODBUS_READ_16BIT_ERROR = 0,  /**<Application fails to read registers */
  MODBUS_WRITE_OK         = 1,  /**<Application writes successfully */
  MODBUS_WRITE_ERROR      = 0,  /**<Application fails to write */
}modbus_rtu_device_status_t;

/** \enum   modbus_rtu_exception_t
 *  \brief  Modbus exception codes
 *
 *  These codes are returned by the Modbus slave to requesting master when an
 *  exception occurs.
 */
typedef enum modbus_rtu_exception_t_
{
  MB_EX_NONE = 0x00,                  /**< No exception. All ok. */
  MB_EX_ILLEGAL_FUNCTION = 0x01,      /**< Function code not supported. */
  MB_EX_ILLEGAL_DATA_ADDRESS = 0x02,  /**< Out of range address. */
  MB_EX_ILLEGAL_DATA_VALUE = 0x03,    /**< Out of range data value. */
  MB_EX_SLAVE_DEVICE_FAILURE = 0x04   /**< Failure at the device side. */
} modbus_rtu_exception_t;

/** \enum   modbus_rtu_diag_subfn_t
 *  \brief  Sub function codes supported on a diagnostic command.
 *
 *  The following sub function codes are supported. These codes must accompany
 *  a MODBUS_DIAGNOSTIC (0x08) command from the Modbus master. For more
 *  information see:
 *  Modbus Application Protocol Specification V1.1b3
 *  Section: Function code description -> 08 Diagnostics
 */
typedef enum modbus_rtu_diag_subfn_t_
{
  MB_DIAG_QUERY_DATA = 0,               /**< Return query data */
  MB_DIAG_FORCE_LISTEN_ONLY = 4,        /**< Force listen only mode */
  MB_DIAG_CLEAR = 10,                   /**< Clear disgnostic counters */
  MB_DIAG_BUS_MSG_COUNT = 11,           /**< Return bus message count */
  MB_DIAG_BUS_COMM_ERROR_COUNT = 12,    /**< Return communication error count */
  MB_DIAG_BUS_EXCEPTION_COUNT = 13,     /**< Return exception response count */
  MB_DIAG_SERVER_MESSAGE_COUNT = 14,    /**< Return server message count */
  MB_DIAG_SERVER_NO_RESPONSE_COUNT = 15 /**< Return no response count */
}modbus_rtu_diag_subfn_t;

/*---------------------------------------------------------------------------
 global variables
 ---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
 extern variables
 ---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
 prototypes
 ---------------------------------------------------------------------------*/

#endif // __mb_codes_h__
/*==========================================================================*/
