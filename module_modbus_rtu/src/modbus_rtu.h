// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*===========================================================================
 Info
 ----

 ===========================================================================*/

#ifndef __modbus_rtu_h__
#define __modbus_rtu_h__

/*---------------------------------------------------------------------------
 nested include files
 ---------------------------------------------------------------------------*/
#include "rs485.h"
#include "mb_codes.h"

/*==========================================================================*/
/** Modbus RTU Server. This Modbus Slave task must be called from the main
 *  user application. It internally instantiates RS485 component to
 *  receive Modbus RTU commands (from a Modbus Master) over RS485 interface.
 *
 *  It processes Modbus commands and requests user application for data. These
 *  requests to user are made over ``c_modbus``. The data in c_modbus is of
 *  the following format:
 *
 *  It sends:
 *
 *  unsigned char: Modbus command
 *  unsigned short: Address to read/write
 *  unsigned short: Value to write (sent always. on read command, this is 0)
 *
 *  And expects:
 *
 *  unsigned short: value (for Read) or status (for write)
 *
 *  After receiving request data from user application, it sends the response
 *  back to Modbus master over RS485 interface.
 *
 *  \param c_modbus       Modbus channel to top level application
 *  \param rs485_if       RS485 interface ports
 *  \param slave_address  Modbus slave address
 *  \param baud           Baud rate
 *  \param parity         Parity
 *  \return None
 */
void modbus_rtu_server(chanend c_modbus,
                       rs485_interface_t &rs485_if,
                       unsigned char slave_address,
                       unsigned baud,
                       rs485_parity_t parity);

#endif // __modbus_rtu_h__
/*==========================================================================*/
