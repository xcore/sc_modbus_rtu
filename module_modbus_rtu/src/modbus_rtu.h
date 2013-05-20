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

/*---------------------------------------------------------------------------
 constants
 ---------------------------------------------------------------------------*/

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

/*==========================================================================*/
/**
 *  Modbus RTU Server
 *
 *  \param c_modbus       Modbus channel to top level application
 *  \param rs485_if       RS485 interface ports
 *  \param slave_address  Modbus slave address
 *  \param baud           Baud rate
 *  \param parity         Parity
 *  \return None
 **/
void modbus_rtu_server(chanend c_modbus,
                       rs485_interface_t &rs485_if,
                       unsigned char slave_address,
                       unsigned baud,
                       rs485_parity_t parity);

#endif // __modbus_rtu_h__
/*==========================================================================*/
