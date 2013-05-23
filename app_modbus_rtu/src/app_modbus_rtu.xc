// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*===========================================================================
 Info
 ----
 This simple demonstration uses XA-SK-ISBUS and XA-SK-GPIO Slice Cards that
 plugs into the Slicekit Core board (XP-SKC-L2). It uses xSOFTip(s)
 ``module_modbus_rtu`` and ``module_i2c_master`` to receive commands from a
 Modbus Master over RS485 and service them to:

 - Turn GPIO Slice Card LEDS on and off
 - Read the room temperature via the on-board ADC
 - Display GPIO Slice Card button presses

 Here is the flow of communication:
 Modbus Master (PC application. Eg. SimplyModbus RTU) <->
 USB to RS485 converter                               <->
 RS485 transceiver on the XA-SK-ISBUS slice card      <->
 Module RS485 (part of Module Modbus RTU)             <->
 Module Modbus RTU                                    <->
 User (this) application which further gets data from XA-SK-GPIO based on
 commands from Module Modbus RTU.

 ===========================================================================*/

/*---------------------------------------------------------------------------
 include files
 ---------------------------------------------------------------------------*/
#include <platform.h>
#include "modbus_rtu.h"
#include "i2c.h"

/*---------------------------------------------------------------------------
 constants
 ---------------------------------------------------------------------------*/
#define DEBOUNCE_INTERVAL     XS1_TIMER_HZ/50 /**< Button scan interval. */
#define BUTTON_1_PRESS_VALUE  0x2             /**< Button 1 press value. */

#define BAUD    9600              /**< Baud rate for RS485. */
#define PARITY  RS485_PARITY_EVEN /**< Parity for RS485. Options:
                                       RS485_PARITY_EVEN,
                                       RS485_PARITY_ODD or
                                       RS485_PARITY_NONE. See RS485
                                       documentation for further info.*/
/*---------------------------------------------------------------------------
 ports and clocks
 ---------------------------------------------------------------------------*/

/** \var     rs485_if
 *  \brief   RS485 ports. One for 'Data' and another for 'Direction'.
 *           See RS485 documentation for further info.
 */
on tile[0]: rs485_interface_t rs485_if =
{
 XS1_PORT_1J,
 XS1_PORT_4E
};

/** \var     p_i2c
 *  \brief   I2C ports to communicate with the ADC present on the XA-SK-GPIO
 *           slice card.
 */
on tile[1]: r_i2c p_i2c = {XS1_PORT_1F, XS1_PORT_1B, 1000};
/** \var     p_led
 *  \brief   LED ports for XA-SK-GPIO slice card.
 */
on tile[1]: port p_led = XS1_PORT_4A;
/** \var     p_button
 *  \brief   Button ports for XA-SK-GPIO slice card.
 */
on tile[1]: port p_button = XS1_PORT_4C;

/*---------------------------------------------------------------------------
 typedefs
 ---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
 global variables
 ---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
 static variables
 ---------------------------------------------------------------------------*/
/** \var     button_status
 *  Button status. Two buttons present on the XA-SK-GPIO slice card. Status of
 *  'SW1' is on Bit0, status of 'SW2' is on Bit1.
 */
static unsigned short button_status = 0;

/** \var     TEMPERATURE_LUT
 *  Look-up table for converting ADC values to integer temperature.
 */
static int TEMPERATURE_LUT[][2] = { {-10, 850}, {-5, 800}, {0, 750},
                                    {5, 700},   {10, 650}, {15, 600},
                                    {20, 550},  {25, 500}, {30, 450},
                                    {35, 400},  {40, 350}, {45, 300},
                                    {50, 250},  {55, 230}, {60, 210}
};

/*---------------------------------------------------------------------------
 static prototypes
 ---------------------------------------------------------------------------*/

/*==========================================================================*/
/** Read temperature value from the sensor using I2C
 *  \param p_i2c  I2C ports that connects to the temperature sensor
 *  \return       Current recorded temperature on the sensor
 */
static int read_temperature(r_i2c &p_i2c)
{
  int adc_value;
  int i = 0, x1, y1, x2, y2, temperature;
  unsigned char i2c_data[2];

  i2c_master_rx(0x28, i2c_data, sizeof(i2c_data), p_i2c);
  i2c_data[0] = i2c_data[0] & 0x0F;
  adc_value = (i2c_data[0] << 6) | (i2c_data[1] >> 2);

  while(adc_value < TEMPERATURE_LUT[i][1])  { i++; }

  //Calculate Linear interpolation using: y = y1+(x-x1)*(y2-y1)/(x2-x1)
  x1 = TEMPERATURE_LUT[i - 1][1];
  y1 = TEMPERATURE_LUT[i - 1][0];
  x2 = TEMPERATURE_LUT[i][1];
  y2 = TEMPERATURE_LUT[i][0];
  temperature = y1 + (((adc_value - x1) * (y2 - y1)) / (x2 - x1));

  return temperature;
}

/*==========================================================================*/
/** Read coil values. LEDs on the GPIO slice are imitated as coils. In the
 *  Simply Modbus PC application: First Coil 1, Number of Coils 4
 *  Output status byte is of format:
 *  +----+----+----+----+------+------+------+------+
 *  | XX | XX | XX | XX | LED3 | LED2 | LED1 | LED0 |
 *  +----+----+----+----+------+------+------+------+
 *
 *  Where,
 *  Bit0 is LED0 status (1 is OFF and 0 is ON)
 *  Bit1 is LED1 status (1 is OFF and 0 is ON)
 *  Bit2 is LED2 status (1 is OFF and 0 is ON)
 *  Bit3 is LED3 status (1 is OFF and 0 is ON)
 *  XX is Don't care.
 *  Other coil addresses return as device failures (no LEDs at such addresses)
 *  Device failure return value for coil = MODBUS_READ_1BIT_ERROR
 *  (present in mb_codes.h)
 *
 *  \param address    address of coil to read
 *  \return           coil value
 */
static unsigned short read_coil(unsigned short address)
{
  unsigned char led_status = 0;
  unsigned char tmp;

  if(address > 3) { return MODBUS_READ_1BIT_ERROR; }

  p_led :> led_status;
  p_led <: led_status;

  if(led_status & (0x01 << address))
  {
    return 1;
  }
  else
  {
    return 0;
  }
}

/*==========================================================================*/
/** Read Discrete Input values. Buttons on the GPIO slice are imitated as
 *  discrete inputs. In the Simply Modbus PC application: First Coil 1,
 *  Number of Coils 2. Output status byte is of format:
 *  +----+----+----+----+----+----+-----+-----+
 *  | XX | XX | XX | XX | XX | XX | SW2 | SW1 |
 *  +----+----+----+----+----+----+-----+-----+
 *
 *  Where,
 *  Bit0 is SW1 status (1 is Button Pressed)
 *  Bit1 is SW2 status (1 is Button Pressed)
 *  XX is Don't care.
 *  Other addresses return as device failures (no Buttons at such addresses)
 *  Device failure return value for discrete input = MODBUS_READ_1BIT_ERROR
 *  (present in mb_codes.h)
 *
 *  \param address    address of discrete input to read
 *  \return           discrete input value
 */
static unsigned short read_discrete_input(unsigned short address)
{
  unsigned short rtnval = button_status;

  if(address > 1)
  {
    return MODBUS_READ_1BIT_ERROR;
  }

  button_status &= ~(1 << address);
  if(rtnval & (1 << address))
  {
    return 1;
  }
  return 0;
}

/*==========================================================================*/
/** Read Holding Register values. Not implemented in this app.
 *  All addresses return as device failures (no Holding Register at such
 *  addresses)
 *  Device failure return value for Holding register = MODBUS_READ_16BIT_ERROR
 *  (present in mb_codes.h)
 *
 *  \param address    address of Holding Register to read
 *  \return           Holding Register value
 */
static unsigned short read_holding_register(unsigned short address)
{
  return MODBUS_READ_16BIT_ERROR;
}

/*==========================================================================*/
/** Read Input Register values. The temperature sensor present on the GPIO slice
 *  is imitated as an Input register. Temperature from this sensor is read using
 *  I2C. This sensor is connected to Input Register address 0 of the Modbus.
 *  All other addresses return as device failures (no Input Register at such
 *  addresses)
 *  Device failure return value for Input Register = MODBUS_READ_16BIT_ERROR
 *  (present in mb_codes.h)
 *
 *  \param address    address of Input Register to read
 *  \return           Input Register value
 */
static unsigned short read_input_register(unsigned short address)
{
  if(address == 0)
  {
    return (unsigned short)(read_temperature(p_i2c));
  }
  else
  {
    return MODBUS_READ_16BIT_ERROR;
  }
}

/*==========================================================================*/
/** Write to coils. LEDs on the GPIO slice are imitated as coils which would
 *  just toggle its state (ON/OFF) on this command. In the Simply Modbus Write
 *  window:
 *  Modbus First Register 1 = LED0
 *  Modbus First Register 2 = LED1
 *  Modbus First Register 3 = LED2
 *  Modbus First Register 4 = LED3
 *  Other coil addresses return as device failures (no LEDs at such addresses)
 *  Device failure return value for write coil = MODBUS_WRITE_ERROR
 *  (present in mb_codes.h)
 *
 *  \param address    address of coil to toggle
 *  \return           write status
 */
static unsigned short write_single_coil(unsigned short address,
                                        unsigned short value)
{
  int led_status;

  if(address > 3)
  {
    return MODBUS_WRITE_ERROR;
  }

  p_led :> led_status;

  if(led_status & (1 << address))
  {
    led_status &= ~(1 << address);
  }
  else
  {
    led_status |= (1 << address);
  }

  p_led <: led_status;
  return MODBUS_WRITE_OK;
}

/*==========================================================================*/
/** Write to Register. Not implemented in this app.
 *  All addresses return as device failures (no Register at such addresses)
 *  Device failure return value for Write register = MODBUS_WRITE_ERROR
 *  (present in mb_codes.h)
 *
 *  \param address    address of Register to write to
 *  \return           write status
 */
static unsigned short write_single_register(unsigned short address,
                                            unsigned short value)
{
  return MODBUS_WRITE_ERROR;
}

/*==========================================================================*/
/** Device Application. This task maps Modbus commands to external devices such
 *  as coils / registers. In this Demo application:
 *  Coils are mapped to LEDs on the GPIO Slice.
 *  Discrete Input are mapped to Buttons on the GPIO Slice.
 *  Holding Registers are mapped to Temperature sensor on the GPIO Slice.
 *  Input Registers are not mapped.
 *
 *  \param c_modbus   channel to receive Modbus commands from the
 *                    modbus_rtu_server
 *  \return           None
 */
static void device_application(chanend c_modbus)
{
  int scan_button_flag = 1;
  unsigned button_state_1 = 0;
  unsigned button_state_2 = 0;
  timer t_scan_button_flag;
  unsigned time;

  unsigned char i2c_register[1] = {0x13};
  i2c_master_write_reg(0x28, 0x00, i2c_register, 1, p_i2c);

  set_port_drive_low(p_button);
  t_scan_button_flag :> time;
  p_button :> button_state_1;

  while(1)
  {
    select
    {
      // Listen to Modbus RTU events
      case c_modbus :> unsigned char cmd:
      {
        unsigned short address, value, rtnval;

        c_modbus :> address;
        c_modbus :> value;

        switch(cmd)
        {
          case MODBUS_READ_COIL:
          {
            // Get LED status
            rtnval = read_coil(address);
            c_modbus <: rtnval;
            break;
          }

          case MODBUS_READ_DISCRETE_INPUT:
          {
            // Get Button status
            rtnval = read_discrete_input(address);
            c_modbus <: rtnval;
            break;
          }

          case MODBUS_READ_HOLDING_REGISTER:
          {
            // Not implmented in this demo
            rtnval = read_holding_register(address);
            c_modbus <: rtnval;
            break;
          }

          case MODBUS_READ_INPUT_REGISTER:
          {
            // Get temperature
            rtnval = read_input_register(address);
            c_modbus <: rtnval;
            break;
          }

          case MODBUS_WRITE_SINGLE_COIL:
          {
            // Toggle LED states
            rtnval = write_single_coil(address, value);
            c_modbus <: rtnval;
            break;
          }

          case MODBUS_WRITE_SINGLE_REGISTER:
          {
            // Not implmented in this demo
            rtnval = write_single_register(address, value);
            c_modbus <: rtnval;
            break;
          }

          default: break;
        } // switch(cmd)

        break;

      } // case c_modbus

      case scan_button_flag=> p_button when pinsneq(button_state_1) :> button_state_1 :
      {
        t_scan_button_flag :> time;
        scan_button_flag = 0;
        break;
      }

      case !scan_button_flag => t_scan_button_flag when timerafter(time + DEBOUNCE_INTERVAL) :> void:
      {
        p_button :> button_state_2;
        if(button_state_1 == button_state_2)
        {
          if(button_state_1 == BUTTON_1_PRESS_VALUE)
          {
            button_status |= 0x01;
          }
          if(button_state_2 == BUTTON_1_PRESS_VALUE-1)
          {
            button_status |= 0x02;
          }
        }
        scan_button_flag = 1;
        break;
      }
    }
  }
}

/*==========================================================================*/
/** Main Entry Point. Instantiates two tasks viz.:
 *  modbus_rtu_server: The Modbus RTU server to talk to XA-SK-ISBUS slice card
 *  device_application: The Host application to read values from XA-SK-GPIO
 *  Slice Card.
 */
int main(void)
{
  chan c_modbus;

  par
  {
    // The Modbus server
    on tile[0]: modbus_rtu_server(c_modbus, rs485_if, 10, BAUD, PARITY);
    // The device application
    on tile[1]: device_application(c_modbus);
  } // par

  return 0;
}

/*==========================================================================*/
