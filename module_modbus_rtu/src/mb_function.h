// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*===========================================================================
 Info
 ----

 ===========================================================================*/

#ifndef __mb_function_h__
#define __mb_function_h__

/*---------------------------------------------------------------------------
 nested include files
 ---------------------------------------------------------------------------*/
#include <xccompat.h>
#include "mb_proto.h"

/*---------------------------------------------------------------------------
 constants
 ---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
 typedefs
 ---------------------------------------------------------------------------*/
typedef struct mb_diag_counters_t_
{
  unsigned short bus_msg;
  unsigned short bus_comm_error;
  unsigned short bus_exception;
  unsigned short server_msg;
  unsigned short no_response;
}mb_diag_counters_t;

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
 *  Read single bit device
 *
 *  \param c_modbus   Modbus Channel to top level application
 *  \param msg        Incoming RS485 message
 *  \param len        Length of incoming message
 *  \param fn_code    Modbus Function code
 *  \return           Modbus exception status
 **/
mb_exception_t mb_read_1bit_device(chanend c_modbus,
                                   unsigned char msg[],
                                   int &len,
                                   unsigned char fn_code);

/*==========================================================================*/
/**
 *  Read 16 bit device
 *
 *  \param c_modbus   Modbus Channel to top level application
 *  \param msg        Incoming RS485 message
 *  \param len        Length of incoming message
 *  \param fn_code    Modbus Function code
 *  \return           Modbus exception status
 **/
mb_exception_t mb_read_16bit_device(chanend c_modbus,
                                    unsigned char msg[],
                                    int &len,
                                    unsigned char fn_code);

/*==========================================================================*/
/**
 *  Write single coil
 *
 *  \param c_modbus   Modbus Channel to top level application
 *  \param msg        Incoming RS485 message
 *  \return           Modbus exception status
 **/
mb_exception_t mb_write_coil(chanend c_modbus, unsigned char msg[]);

/*==========================================================================*/
/**
 *  Write multiple coils
 *
 *  \param c_modbus   Modbus Channel to top level application
 *  \param msg        Incoming RS485 message
 *  \param len        Length of incoming message
 *  \return           Modbus exception status
 **/
mb_exception_t mb_write_multiple_coils(chanend c_modbus,
                                       unsigned char msg[],
                                       int &len);

/*==========================================================================*/
/**
 *  Write single register
 *
 *  \param c_modbus   Modbus Channel to top level application
 *  \param msg        Incoming RS485 message
 *  \return           Modbus exception status
 **/
mb_exception_t mb_write_register(chanend c_modbus, unsigned char msg[]);

/*==========================================================================*/
/**
 *  Read Exception status
 *
 *  \param c_modbus   Modbus Channel to top level application
 *  \param msg        Incoming RS485 message
 *  \param len        Length of incoming message
 *  \return           Modbus exception status
 **/
mb_exception_t mb_read_exception_status(chanend c_modbus,
                                        unsigned char msg[],
                                        int &len);

/*==========================================================================*/
/**
 *  Modbus Diagnostics
 *
 *  \param msg        Incoming RS485 message
 *  \param len        Length of incoming message
 *  \return           Modbus exception status
 **/
mb_exception_t mb_diagnostic(unsigned char msg[], int &len);

/*==========================================================================*/
/**
 *  Get Comm event counter
 *
 *  \param msg        Incoming RS485 message
 *  \param len        Length of incoming message
 *  \return           Modbus exception status
 **/
mb_exception_t mb_comm_event_counter(unsigned char msg[], int &len);

/*==========================================================================*/
/**
 *  Reset Modbus diagnostics counters
 *
 *  \return None
 **/
void mb_reset_diagnostic_counters();

#endif // __mb_function_h__
/*==========================================================================*/
