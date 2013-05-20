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
/**
 * \enum modbus_cmd
 * \brief Modbus Commands currently supported by the modbus_rtu_server
 */
typedef enum modbus_cmd_t_
{
  MODBUS_READ_COIL              = 0x01, /**<Modbus Read Coil */
  MODBUS_READ_DISCRETE_INPUT    = 0x02, /**<Modbus Read Discrete Input */
  MODBUS_READ_HOLDING_REGISTER  = 0x03, /**<Modbus Read Holding Register */
  MODBUS_READ_INPUT_REGISTER    = 0x04, /**<Modbus Read Input Register */
  MODBUS_WRITE_SINGLE_COIL      = 0x05, /**<Modbus Write Single Coil */
  MODBUS_WRITE_SINGLE_REGISTER  = 0x06, /**<Modbus Write Single Register */
  MODBUS_READ_EXCEPTION_STATUS  = 0x07, /**<Modbus Read Exception Status */
  MODBUS_DIAGNOSTIC             = 0x08, /**<Modbus Diagnostic */
  MODBUS_COMM_EVENT_COUNTER     = 0x0B, /**<Modbus Get Comm Event Counter */
  MODBUS_WRITE_MULTIPLE_COILS   = 0x0F, /**<Modbus Write Multiple Coils */
}modbus_cmd_t;

/**
 * \enum modbus_error
 * \brief Modbus Error Status due to Read / Write operation performed by the
 *        application.
 */
typedef enum modbus_device_status_t_
{
  MODBUS_READ_1BIT_ERROR  = 2,  /**<Application fails to read coil (or) discrete
                                input*/
  MODBUS_READ_16BIT_ERROR = 0,  /**<Application fails to read registers */
  MODBUS_WRITE_OK         = 1,  /**<Application Writes successfully */
  MODBUS_WRITE_ERROR      = 0,  /**<Application fails to write */
}modbus_device_status_t;

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
