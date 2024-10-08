/*
 * efone - Distributed internet phone system.
 *
 * (c) 1999,2000 Krzysztof Dabrowski
 * (c) 1999,2000 ElysiuM deeZine
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version
 * 2 of the License, or (at your option) any later version.
 *
 */

/* based on implementation by Finn Yannick Jacobs */

#include <stdio.h>
#include <stdlib.h>

#include <systemc.h>

/* crc_tab[] -- this crcTable is being build by chksum_crc32GenTab().
 *		so make sure, you call it before using the other
 *		functions!
 */
u_int32_t crc_tab[256];

/* chksum_crc() -- to a given block, this one calculates the
 *				crc32-checksum until the length is
 *				reached. the crc32-checksum will be
 *				the result.
 */
u_int32_t chksum_crc32 (sc_uint<8> *block, unsigned int length)
{
    register unsigned long crc;
    unsigned long i;

    crc = 0xFFFFFFFF;
    for (i = 0; i < length; i++)
        {
            crc = ((crc >> 8) & 0x00FFFFFF) ^ crc_tab[(crc ^ *block++) & 0xFF];
        }
    return (crc ^ 0xFFFFFFFF);
}

/* chksum_crc32gentab() --      to a global crc_tab[256], this one will
 *				calculate the crcTable for crc32-checksums.
 *				it is generated to the polynom [..]
 */

void chksum_crc32gentab ()
{
    unsigned long crc, poly;
    int i, j;

    poly = 0xEDB88320L;
    for (i = 0; i < 256; i++)
        {
            crc = i;
            for (j = 8; j > 0; j--)
                {
                    if (crc & 1)
                        {
                            crc = (crc >> 1) ^ poly;
                        }
                    else
                        {
                            crc >>= 1;
                        }
                }
            crc_tab[i] = crc;
        }
}
