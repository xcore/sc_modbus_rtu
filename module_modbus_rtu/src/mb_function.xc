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
#include "mb_function.h"
#include "mb_proto.h"

/*---------------------------------------------------------------------------
 constants
 ---------------------------------------------------------------------------*/
/** \def     MODBUS_ADDRESS_START
 *  \brief   Serviceable starting address of any device connected.
 */
#define MODBUS_ADDRESS_START        0x0000
/** \def     MODBUS_ADDRESS_END
 *  \brief   Serviceable end address of any device connected.
 */
#define MODBUS_ADDRESS_END          0xFFFF
/** \def     MODBUS_QUANTITY_START
 *  \brief   Minimum number of devices to access at a time.
 */
#define MODBUS_QUANTITY_START       0x0001
/** \def     MODBUS_QUANTITY_1BIT_END
 *  \brief   Maximum number of 1 bit devices connected.
 */
#define MODBUS_QUANTITY_1BIT_END    0x07D0
/** \def     MODBUS_QUANTITY_16BIT_END
 *  \brief   Maximum number of 16 bit devices connected.
 */
#define MODBUS_QUANTITY_16BIT_END   0x007D

/*---------------------------------------------------------------------------
 ports and clocks
 ---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
 typedefs
 ---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
 global variables
 ---------------------------------------------------------------------------*/
extern unsigned short comm_event_counter;
extern modbus_rtu_diag_counters_t diag_count;
extern unsigned char listen_only_mode;

/*---------------------------------------------------------------------------
 static variables
 ---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
 static prototypes
 ---------------------------------------------------------------------------*/

/*==========================================================================*/
/** Check whether a value falls within a given range (inclusive).
 *  \param value      value to check
 *  \param limit_lo   bottom limit
 *  \param limit_hi   top limit
 *  \return char      0 is ok; 1 is outside range
 */
static unsigned char check_range(int value,
                                 unsigned short limit_lo,
                                 unsigned short limit_hi)
{
  return (((value < limit_lo) || (value > limit_hi)));
}

/*==========================================================================*/
/** Get number of 8-bit bytes required to fit a certain number of bits.
 *  \param qty      quantity
 *  \return char    number of bytes required
 */
static unsigned char get_byte_count(unsigned short qty)
{
  return (unsigned char) ((qty + 7u) / 8u);
}

/*==========================================================================*/
/** Send commands to the top level application to read/write device values.
 *  This function will send:
 *  unsigned char: Modbus command
 *  unsigned short: Address to read/write
 *  unsigned short: Value to write (sent always. on read command, this is 0)
 *
 *  And expects:
 *  unsigned short: value (for Read) or status (for write)
 *
 *  \param c_modbus   Channel connecting to top-level application
 *  \param fn_code    Modbus Function code
 *  \param address    Device address
 *  \param value      Value
 *  \return           Value/Status
 */
static unsigned short access_external_device(chanend c_modbus,
                                             unsigned char fn_code,
                                             unsigned short address,
                                             unsigned short value)
{
  unsigned short rtnval;
  c_modbus <: fn_code;
  c_modbus <: address;
  c_modbus <: value;
  c_modbus :> rtnval;
  return rtnval;
}

/*---------------------------------------------------------------------------
 mb_read_1bit_device
 ---------------------------------------------------------------------------*/
modbus_rtu_exception_t mb_read_1bit_device(chanend c_modbus,
                                           unsigned char msg[],
                                           int &len,
                                           unsigned char fn_code)
{
  unsigned short address, end_address, quantity;
  unsigned char byte_count;

  address = (unsigned short)(msg[MBRTU_DATA_OFF] << 8u);
  address |= (unsigned short)(msg[MBRTU_DATA_OFF + 1]);

  quantity = (unsigned short)(msg[MBRTU_READ_QTY_OFF] << 8u);
  quantity |= (unsigned short)(msg[MBRTU_READ_QTY_OFF + 1]);

  end_address = address + quantity - 1;

  if(check_range(quantity, MODBUS_QUANTITY_START, MODBUS_QUANTITY_1BIT_END))
  {
    return MB_EX_ILLEGAL_DATA_VALUE;
  }

  switch(fn_code)
  {
    case MODBUS_READ_COIL:
    {
      if((address < MODBUS_COIL_ADDRESS_START) ||
          (end_address > MODBUS_COIL_ADDRESS_END))
      {
        return MB_EX_ILLEGAL_DATA_ADDRESS;
      }
      break;
    }
    case MODBUS_READ_DISCRETE_INPUT:
    {
      if((address < MODBUS_DISCRETE_INPUT_ADDRESS_START) ||
          (end_address > MODBUS_DISCRETE_INPUT_ADDRESS_END))
      {
        return MB_EX_ILLEGAL_DATA_ADDRESS;
      }
      break;
    }
    default: break;
  }

  byte_count = get_byte_count(quantity);
  msg[MBRTU_READ_RESP_QTY_OFF] = byte_count;
  len = MBRTU_READ_RESP_QTY_MIN + byte_count;

  for(int i = 0; i < quantity; i++)
  {
    unsigned short result, index_bit, index_byte;

    index_byte = i / 8u;
    index_bit = i % 8u;

    result = access_external_device(c_modbus,
                                    fn_code,
                                    (i + address),
                                    0);

    if (result == 1u)
    {
      msg[MBRTU_READ_RESP_DATA_OFF + index_byte] |= (1u << index_bit);
    }
    else if (result == 0u)
    {
      msg[MBRTU_READ_RESP_DATA_OFF + index_byte] &= ~(1u << index_bit);
    }
    else
    {
      return MB_EX_SLAVE_DEVICE_FAILURE;
    }
  } // for(int i = 0; i < quantity; i++)
  return MB_EX_NONE;
}

/*---------------------------------------------------------------------------
 mb_read_16bit_device
 ---------------------------------------------------------------------------*/
modbus_rtu_exception_t mb_read_16bit_device(chanend c_modbus,
                                            unsigned char msg[],
                                            int &len,
                                            unsigned char fn_code)
{
  unsigned short address, end_address, quantity;
  unsigned char byte_count;

  address = (unsigned short)(msg[MBRTU_DATA_OFF] << 8u);
  address |= (unsigned short)(msg[MBRTU_DATA_OFF + 1]);

  quantity = (unsigned short)(msg[MBRTU_READ_QTY_OFF] << 8u);
  quantity |= (unsigned short)(msg[MBRTU_READ_QTY_OFF + 1]);

  end_address = address + quantity - 1;

  if(check_range(quantity, MODBUS_QUANTITY_START, MODBUS_QUANTITY_16BIT_END))
  {
    return MB_EX_ILLEGAL_DATA_VALUE;
  }

  switch(fn_code)
  {
    case MODBUS_READ_HOLDING_REGISTER:
    {
      if((address < MODBUS_HOLDING_REGISTER_ADDRESS_START) ||
          (end_address > MODBUS_HOLDING_REGISTER_ADDRESS_END))
      {
        return MB_EX_ILLEGAL_DATA_ADDRESS;
      }
      break;
    }
    case MODBUS_READ_INPUT_REGISTER:
    {
      if((address < MODBUS_INPUT_REGISTER_ADDRESS_START) ||
          (end_address > MODBUS_INPUT_REGISTER_ADDRESS_END))
      {
        return MB_EX_ILLEGAL_DATA_ADDRESS;
      }
      break;
    }
    default: break;
  }

  byte_count = quantity * 2u;
  msg[MBRTU_READ_RESP_QTY_OFF] = byte_count;
  len = MBRTU_READ_RESP_QTY_MIN + byte_count;

  for(int i = 0; i < quantity; i++)
  {
    unsigned short result;

    result = access_external_device(c_modbus,
                                    fn_code,
                                    (i + address),
                                    0);

    if (result)
    {
      msg[MBRTU_READ_RESP_DATA_OFF + (i * 2)]  = (unsigned char)(result >> 8u);
      msg[MBRTU_READ_RESP_DATA_OFF + (i * 2) + 1u] = (unsigned char)(result & 0xFF);
    }
    else
    {
      return MB_EX_SLAVE_DEVICE_FAILURE;
    }
  } // for(int i = 0; i < quantity; i++)
  return MB_EX_NONE;
}

/*---------------------------------------------------------------------------
 mb_write_coil
 ---------------------------------------------------------------------------*/
modbus_rtu_exception_t mb_write_coil(chanend c_modbus, unsigned char msg[])
{
  unsigned short address, value, result;

  address = (unsigned short)(msg[MBRTU_DATA_OFF] << 8u);
  address |= (unsigned short)(msg[MBRTU_DATA_OFF + 1]);

  value = (unsigned short)(msg[MBRTU_WRITE_VALUE_OFF] << 8u);
  value |= (unsigned short)(msg[MBRTU_WRITE_VALUE_OFF + 1]);

  if(value != 0x0000 && value != 0xFF00)
  {
    return MB_EX_ILLEGAL_DATA_VALUE;
  }

  if((address < MODBUS_ADDRESS_START) ||
      (address > MODBUS_ADDRESS_END))
  {
    return MB_EX_ILLEGAL_DATA_ADDRESS;
  }

  result = access_external_device(c_modbus,
                                  MODBUS_WRITE_SINGLE_COIL,
                                  address,
                                  value);

  if(result == 0)
  {
    return MB_EX_SLAVE_DEVICE_FAILURE;
  }

  return MB_EX_NONE;
}

/*---------------------------------------------------------------------------
 mb_write_multiple_coils
 ---------------------------------------------------------------------------*/
modbus_rtu_exception_t mb_write_multiple_coils(chanend c_modbus,
                                               unsigned char msg[],
                                               int &len)
{
  unsigned short address, end_address, quantity;

  address = (unsigned short)(msg[MBRTU_DATA_OFF] << 8u);
  address |= (unsigned short)(msg[MBRTU_DATA_OFF + 1]);

  quantity = (unsigned short)(msg[MBRTU_READ_QTY_OFF] << 8u);
  quantity |= (unsigned short)(msg[MBRTU_READ_QTY_OFF + 1]);

  end_address = address + quantity - 1;

  if((check_range(quantity, MODBUS_QUANTITY_START, MODBUS_QUANTITY_1BIT_END)) ||
      (msg[MBRTU_READ_QTY_OFF + 2] != get_byte_count(quantity)))
  {
    return MB_EX_ILLEGAL_DATA_VALUE;
  }

  if(check_range(address, MODBUS_ADDRESS_START, MODBUS_ADDRESS_END))
  {
    return MB_EX_ILLEGAL_DATA_ADDRESS;
  }

  len = MBRTU_READ_RESP_QTY_MIN + 3;

  for(int i = 0; i < quantity; i++)
  {
    unsigned short result, index_bit, index_byte, value;

    index_byte = i / 8u;
    index_bit = i % 8u;
    value = (msg[index_byte + MBRTU_READ_QTY_OFF + 3] & (0x01 << index_bit)) ? 1 : 0;

    result = access_external_device(c_modbus,
                                    MODBUS_WRITE_SINGLE_COIL,
                                    (i + address),
                                    value);

    if (result == 1u)
    {
      msg[MBRTU_READ_RESP_DATA_OFF + index_byte] |= (1u << index_bit);
    }
    else if (result == 0u)
    {
      msg[MBRTU_READ_RESP_DATA_OFF + index_byte] &= ~(1u << index_bit);
    }
    else
    {
      return MB_EX_SLAVE_DEVICE_FAILURE;
    }
  } // for(int i = 0; i < quantity; i++)
  return MB_EX_NONE;

}

/*---------------------------------------------------------------------------
 mb_write_register
 ---------------------------------------------------------------------------*/
modbus_rtu_exception_t mb_write_register(chanend c_modbus, unsigned char msg[])
{
  unsigned short address, value, result;

  address = (unsigned short)(msg[MBRTU_DATA_OFF] << 8u);
  address |= (unsigned short)(msg[MBRTU_DATA_OFF + 1]);

  value = (unsigned short)(msg[MBRTU_WRITE_VALUE_OFF] << 8u);
  value |= (unsigned short)(msg[MBRTU_WRITE_VALUE_OFF + 1]);

  if(check_range(value, 0x0000, 0xFFFF))
  {
    return MB_EX_ILLEGAL_DATA_VALUE;
  }

  if(check_range(address, MODBUS_ADDRESS_START, MODBUS_ADDRESS_END))
  {
    return MB_EX_ILLEGAL_DATA_ADDRESS;
  }

  result = access_external_device(c_modbus,
                                  MODBUS_WRITE_SINGLE_REGISTER,
                                  address,
                                  value);

  if(result == 0)
  {
    return MB_EX_SLAVE_DEVICE_FAILURE;
  }

  return MB_EX_NONE;
}

/*---------------------------------------------------------------------------
 mb_read_exception_status
 ---------------------------------------------------------------------------*/
modbus_rtu_exception_t mb_read_exception_status(chanend c_modbus,
                                                unsigned char msg[],
                                                int &len)
{
  unsigned short result;

  result = access_external_device(c_modbus,
                                  MODBUS_READ_EXCEPTION_STATUS,
                                  0,
                                  0);

  msg[MBRTU_DATA_OFF] = (unsigned char)(result & 0xFF);
  len = MBRTU_READ_RESP_QTY_MIN;
  return MB_EX_NONE;
}

/*---------------------------------------------------------------------------
 mb_diagnostic
 ---------------------------------------------------------------------------*/
modbus_rtu_exception_t mb_diagnostic(unsigned char msg[], int &len)
{
  unsigned short sub_fn_code;

  sub_fn_code = (unsigned short)(msg[MBRTU_DATA_OFF] << 8u);
  sub_fn_code |= (unsigned short)(msg[MBRTU_DATA_OFF + 1]);

  switch(sub_fn_code)
  {

    case MB_DIAG_QUERY_DATA:
    {
      len -= 2;
      break;
    }
    case MB_DIAG_FORCE_LISTEN_ONLY:
    {
      listen_only_mode = 1;
      len = 0;
      break;
    }
    case MB_DIAG_CLEAR:
    {
      len -= 2;
      mb_reset_diagnostic_counters();
      break;
    }
    case MB_DIAG_BUS_MSG_COUNT:
    {
      len -= 2;
      msg[MBRTU_READ_RESP_DATA_OFF + 2u] = (unsigned char)(diag_count.bus_msg >> 8u);
      msg[MBRTU_READ_RESP_DATA_OFF + 3u] = (unsigned char)(diag_count.bus_msg & 0xFF);
      break;
    }
    case MB_DIAG_BUS_COMM_ERROR_COUNT:
    {
      len -= 2;
      msg[MBRTU_READ_RESP_DATA_OFF + 2u] = (unsigned char)(diag_count.bus_comm_error >> 8u);
      msg[MBRTU_READ_RESP_DATA_OFF + 3u] = (unsigned char)(diag_count.bus_comm_error & 0xFF);
      break;
    }
    case MB_DIAG_BUS_EXCEPTION_COUNT:
    {
      len -= 2;
      msg[MBRTU_READ_RESP_DATA_OFF + 2u] = (unsigned char)(diag_count.bus_exception >> 8u);
      msg[MBRTU_READ_RESP_DATA_OFF + 3u] = (unsigned char)(diag_count.bus_exception & 0xFF);
      break;
    }
    case MB_DIAG_SERVER_MESSAGE_COUNT:
    {
      len -= 2;
      msg[MBRTU_READ_RESP_DATA_OFF + 2u] = (unsigned char)(diag_count.server_msg >> 8u);
      msg[MBRTU_READ_RESP_DATA_OFF + 3u] = (unsigned char)(diag_count.server_msg & 0xFF);
      break;
    }
    case MB_DIAG_SERVER_NO_RESPONSE_COUNT:
    {
      len -= 2;
      msg[MBRTU_READ_RESP_DATA_OFF + 2u] = (unsigned char)(diag_count.no_response >> 8u);
      msg[MBRTU_READ_RESP_DATA_OFF + 3u] = (unsigned char)(diag_count.no_response & 0xFF);
      break;
    }
    default:
    {
      return MB_EX_ILLEGAL_FUNCTION; break;
    }
  }
  return MB_EX_NONE;
}

/*---------------------------------------------------------------------------
 mb_comm_event_counter
 ---------------------------------------------------------------------------*/
modbus_rtu_exception_t mb_comm_event_counter(unsigned char msg[], int &len)
{
  msg[MBRTU_DATA_OFF] = 0x00;
  msg[MBRTU_DATA_OFF + 1] = 0x00;
  msg[MBRTU_DATA_OFF] = (unsigned char)(comm_event_counter >> 8u);
  msg[MBRTU_DATA_OFF + 1] = (unsigned char)(comm_event_counter & 0xFF);
  len = MBRTU_READ_RESP_QTY_MIN + 4 - 1;
  comm_event_counter--;
  return MB_EX_NONE;
}

/*---------------------------------------------------------------------------
 mb_reset_diagnostic_counters
 ---------------------------------------------------------------------------*/
void mb_reset_diagnostic_counters()
{
  diag_count.bus_msg = 0;
  diag_count.bus_comm_error = 0;
  diag_count.bus_exception = 0;
  diag_count.server_msg = 0;
  diag_count.no_response = 0;
}

/*==========================================================================*/
