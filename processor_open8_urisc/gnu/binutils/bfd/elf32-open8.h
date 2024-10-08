/* Open8-specific support for 32-bit ELF.
   Copyright 2006, 2007, 2010, 2011 Free Software Foundation, Inc.

   Contributed by Kirk Hays <khays@hayshaus.com>

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
   Foundation, Inc., 51 Franklin Street - Fifth Floor,
   Boston, MA 02110-1301, USA.  */


/* These four functions will be called from the ld back-end.  */

extern void
elf32_open8_setup_params (struct bfd_link_info *, bfd *, asection *,
			  bfd_boolean, bfd_boolean, bfd_boolean,
			  bfd_vma, bfd_boolean);

extern int
elf32_open8_setup_section_lists (bfd *, struct bfd_link_info *);

extern bfd_boolean
elf32_open8_size_stubs (bfd *, struct bfd_link_info *, bfd_boolean);

extern bfd_boolean
elf32_open8_build_stubs (struct bfd_link_info *);
