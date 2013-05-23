// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*===========================================================================
 Info
 ----

 ===========================================================================*/

#ifndef __crc16_h__
#define __crc16_h__

/*---------------------------------------------------------------------------
 nested include files
 ---------------------------------------------------------------------------*/
#include <xccompat.h>

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
/** Calculate 16-bit CRC
 *  \param msg    Pointer to an unsigned char array of data
 *  \param len    Length of data (used size of msg array)
 *  \return       unsigned short CRC
 */
unsigned short crc16(REFERENCE_PARAM(unsigned char, msg), unsigned short len);

#endif // __crc16_h__
/*==========================================================================*/