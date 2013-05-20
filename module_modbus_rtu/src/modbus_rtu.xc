// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*===========================================================================
 Info
 ----

 ===========================================================================*/

/*---------------------------------------------------------------------------
 include files
 ---------------------------------------------------------------------------*/
#include "modbus_rtu.h"
#include "rs485_conf.h"
#include "mb_proto.h"
#include "mb_function.h"
#include "crc16.h"

/*---------------------------------------------------------------------------
 constants
 ---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
 ports and clocks
 ---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
 typedefs
 ---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
 global variables
 ---------------------------------------------------------------------------*/
unsigned short comm_event_counter = 0;
unsigned char listen_only_mode = 0;
mb_diag_counters_t diag_count;

/*---------------------------------------------------------------------------
 static variables
 ---------------------------------------------------------------------------*/
static unsigned char mbrtu_slave_address;

/*---------------------------------------------------------------------------
 static prototypes
 ---------------------------------------------------------------------------*/

/*==========================================================================*/
/**
 *  Handle data from RS485 and process for Modbus commands
 *
 *  \param c_modbus       Modbus channel to top level application
 *  \param c_rs485_ctrl   RS485 control channel
 *  \param c_rs485_data   RS485 data channel
 *  \return None
 **/
static void mbrtu_event_handler(chanend c_modbus,
                                chanend c_rs485_ctrl,
                                chanend c_rs485_data)
{
  unsigned char mb_data[RS485_BUF_SIZE], fn_code;
  unsigned short crclohi;
  int length;
  mb_exception_t exception;

  mb_reset_diagnostic_counters();

  while(1)
  {
    select
    {
      case c_rs485_data :> length:
      {
        // Some data received from the RS485 component
        // Receive all data into the `rs485_data` array
        for(int i = 0; i < length; i++)
        {
          c_rs485_data :> mb_data[i];
        }

        if(listen_only_mode == 1)
        {
          break;
        }

        if( (length < MBRTU_PDU_SIZE_MIN || length > MBRTU_PDU_SIZE_MAX) ||
            (crc16(mb_data[0], length) != 0))
        {
          diag_count.bus_comm_error++;
          break;
        }

        diag_count.bus_msg++;

        // data received, check and process for modbus commands
        if(mb_data[MBRTU_SLAVE_ADDR_OFF] != mbrtu_slave_address &&
            mb_data[MBRTU_SLAVE_ADDR_OFF] != MBRTU_ADDRESS_BROADCAST)

        {
          break;
        }

        diag_count.server_msg++;

        if(mb_data[MBRTU_SLAVE_ADDR_OFF] == MBRTU_ADDRESS_BROADCAST)
        {
          diag_count.no_response++;
        }

        fn_code = mb_data[MBRTU_FNCODE_OFF];

        switch(fn_code)
        {
          case MODBUS_READ_COIL:
          {
            exception = mb_read_1bit_device(c_modbus, mb_data, length, MODBUS_READ_COIL);
            break;
          }
          case MODBUS_READ_DISCRETE_INPUT:
          {
            exception = mb_read_1bit_device(c_modbus, mb_data, length, MODBUS_READ_DISCRETE_INPUT);
            break;
          }
          case MODBUS_READ_HOLDING_REGISTER:
          {
            exception = mb_read_16bit_device(c_modbus, mb_data, length, MODBUS_READ_HOLDING_REGISTER);
            break;
          }
          case MODBUS_READ_INPUT_REGISTER:
          {
            exception = mb_read_16bit_device(c_modbus, mb_data, length, MODBUS_READ_INPUT_REGISTER);
            break;
          }
          case MODBUS_WRITE_SINGLE_COIL:
          {
            exception = mb_write_coil(c_modbus, mb_data);
            break;
          }
          case MODBUS_WRITE_SINGLE_REGISTER:
          {
            exception = mb_write_register(c_modbus, mb_data);
            break;
          }
          case MODBUS_READ_EXCEPTION_STATUS:
          {
            exception = mb_read_exception_status(c_modbus, mb_data, length);
            break;
          }
          case MODBUS_DIAGNOSTIC:
          {
            exception = mb_diagnostic(mb_data, length);
            break;
          }
          case MODBUS_COMM_EVENT_COUNTER:
          {
            exception = mb_comm_event_counter(mb_data, length);
            break;
          }
          case MODBUS_WRITE_MULTIPLE_COILS:
          {
            exception = mb_write_multiple_coils(c_modbus, mb_data, length);
            break;
          }
          default:
          {
            exception = MB_EX_ILLEGAL_FUNCTION;
            break;
          }
        } // switch(fn_code)

        // Check for Exception response
        if(exception != MB_EX_NONE)
        {
          // Form an exception response
          mb_data[MBRTU_FNCODE_OFF] = fn_code + 0x80;
          mb_data[MBRTU_FNCODE_OFF + 1] = exception;
          length = 3;
          diag_count.bus_exception++;
        }
        else
        {
          // Communication was alright, increment comm event counter
          comm_event_counter++;
        }

        if(listen_only_mode == 1)
        {
          break;
        }

        // Update CRC
        crclohi = crc16(mb_data[0], length);
        mb_data[length++] = (unsigned char)(crclohi & 0xFF);
        mb_data[length++] = (unsigned char)(crclohi >> 8);

        // Send response via RS485
        rs485_send_packet(c_rs485_ctrl, mb_data, length);

        break;

      } // case c_rs485_data :> length:


      // Frame silence check

    } // select
  } // while(1)
}

/*---------------------------------------------------------------------------
 implementation1
 ---------------------------------------------------------------------------*/
void modbus_rtu_server(chanend c_modbus,
                       rs485_interface_t &rs485_if,
                       unsigned char slave_address,
                       unsigned baud,
                       rs485_parity_t parity)
{
  chan c_rs485_ctrl, c_rs485_data;
  rs485_config_t rs485_config;

  mbrtu_slave_address = slave_address;
  rs485_config.dir_bit = 0;
  rs485_config.baud_rate = baud;
  rs485_config.data_bits = 8;
  rs485_config.stop_bits = (parity == RS485_PARITY_NONE) ? 2 : 1;
  rs485_config.parity = parity;
  rs485_config.data_timeout = 10;

  par
  {
    rs485_run(c_rs485_ctrl, c_rs485_data, rs485_if, rs485_config);
    mbrtu_event_handler(c_modbus, c_rs485_ctrl, c_rs485_data);
  }
}

/*==========================================================================*/
