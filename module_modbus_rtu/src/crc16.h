#ifndef __crc16_h__
#define __crc16_h__

#include <xccompat.h>

/*==========================================================================*/
/** Calculate 16-bit CRC
 *  \param msg    Pointer to an unsigned char array of data
 *  \param len    Length of data (used size of msg array)
 *  \return       unsigned short CRC
 */
unsigned short crc16(REFERENCE_PARAM(unsigned char, msg), unsigned short len);

#endif // __crc16_h__
