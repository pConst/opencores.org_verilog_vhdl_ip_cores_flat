/* BFD support for the SCARTS_32 architecture.
   Copyright 2008, 2009 Free Software Foundation, Inc.
   Contributed by Martin Walter <mwalter@opencores.org>

   This file is part of BFD, the Binary File Descriptor library.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street - Fifth Floor, Boston,
   MA 02110-1301, USA.  */

#include "sysdep.h"
#include "bfd.h"
#include "libbfd.h"

static const bfd_arch_info_type *
scarts_32_compatible(const bfd_arch_info_type *a, const bfd_arch_info_type *b)
{
  BFD_ASSERT(a->arch == bfd_arch_scarts_32);
  switch (b->arch)
  {
    case bfd_arch_scarts_32:
      return bfd_default_compatible(a, b);
      break;
    default:
      return NULL;
  }
  /*NOTREACHED*/
}

const bfd_arch_info_type bfd_scarts_32_arch =
{
  32,                   /* 32 bits per word */
  32,                   /* 32 bits per address */
  8,                    /* 8 bits per byte */
  bfd_arch_scarts_32,   /* architecture */
  bfd_mach_scarts_32,   /* machine */
  "scarts_32",          /* architecture name */
  "scarts_32",          /* printable name */
  2,                    /* section align power */
  TRUE,                 /* the default machine for the architecture? */
  scarts_32_compatible, /* SCARTS_32 is only compatible with itself, see above */
  bfd_default_scan,
  0
};

