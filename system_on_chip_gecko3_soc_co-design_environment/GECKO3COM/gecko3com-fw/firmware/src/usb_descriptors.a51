;;; -*- asm -*-

;;; GECKO3COM
;;;
;;; Copyright (C) 2008 by
;;;   ___    ____  _   _
;;;  (  _`\ (  __)( ) ( )   
;;;  | (_) )| (_  | |_| |   Berne University of Applied Sciences
;;;  |  _ <'|  _) |  _  |   School of Engineering and
;;;  | (_) )| |   | | | |   Information Technology
;;;  (____/'(_)   (_) (_)
;;;
;;;
;;; This program is free software: you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation, either version 3 of the License, or
;;; (at your option) any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details. 
;;; You should have received a copy of the GNU General Public License
;;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;;
;;;********************************************************************
;;; As vendor ID we use the ID from Anchor Chips (0x4705) which is now Cypress, so
;;; they don't need there old ID anymore.
;;;
;;; This device works with USB full and high speed hosts.
;;;
;;; Endpoint configuration is according to USB TMC specification 1.0
;;;


	.module usb_descriptors
	
	VID_FREE	 = 0x0547	; Anchor Chips (now Cypress) nobody using it anymore
	PID_GECKO	 = 0x0002	; GECKO3COM using USB TMC
	PID_DFU		 = 0x0003	; Different PID for DFU mode, some OS have problems when you use the same PID 

	;; We distinguish configured from unconfigured GECKO3main's using the Device ID.
	;; If the MSB of the DID is 0, the device is unconfigured.
	;; The LSB of the DID is reserved for hardware revs.
	
	DID_GECKO	 = 0x0100	; Device ID (bcd)

	
	DSCR_DEVICE	 =   1	; Descriptor type: Device
	DSCR_CONFIG	 =   2	; Descriptor type: Configuration
	DSCR_STRING	 =   3	; Descriptor type: String
	DSCR_INTRFC	 =   4	; Descriptor type: Interface
	DSCR_ENDPNT	 =   5	; Descriptor type: Endpoint
	DSCR_DEVQUAL	 =   6	; Descriptor type: Device Qualifier
	DSCR_DFUFUNC	 =   0x21 ;  Descriptor type: DFU Functional
	
	DSCR_DEVICE_LEN	 =  18
	DSCR_CONFIG_LEN  =   9
	DSCR_INTRFC_LEN  =   9
	DSCR_ENDPNT_LEN  =   7
	DSCR_DEVQUAL_LEN =  10
	DSCR_DFUFUNC_LEN =   9	
	
	ET_CONTROL	 =   0	; Endpoint type: Control
	ET_ISO		 =   1	; Endpoint type: Isochronous
	ET_BULK		 =   2	; Endpoint type: Bulk
	ET_INT		 =   3	; Endpoint type: Interrupt
	
	
	;; configuration attributes
	bmSELF_POWERED	=	1 << 6

;;; --------------------------------------------------------
;;;	external ram data
;;;--------------------------------------------------------
	
	.area USBDESCSEG    (XDATA)
	
;;; ----------------------------------------------------------------
;;; descriptors used when operating at high speed (480Mb/sec)
;;; ----------------------------------------------------------------
	
	.even	; descriptors must be 2-byte aligned for SUDPTR{H,L} to work

	;; The .even directive isn't really honored by the linker.  Bummer!
	;; (There's no way to specify an alignment requirement for a given area,
	;; hence when they're concatenated together, even doesn't work.)
	;; 
	;; We work around this by telling the linker to put USBDESCSEG
	;; at 0xE000 absolute.  This means that the maximimum length of this
	;; segment is 480 bytes, leaving room for the two hash slots 
	;; at 0xE1EO to 0xE1FF.  
	;; 
	;; As of March 9, 2009, this segment is 398 bytes long
	
_high_speed_device_descr::
	.db	DSCR_DEVICE_LEN
	.db	DSCR_DEVICE
	.db	<0x0200		; Specification version (LSB)
	.db	>0x0200		; Specification version (MSB)
	.db	0x00		; device class (see interface)
	.db	0x00		; device subclass (see interface)
	.db	0x00		; device protocol (see interface)
	.db	64		; bMaxPacketSize0 for endpoint 0
	.db	<VID_FREE	; idVendor
	.db	>VID_FREE	; idVendor	
	.db	<PID_GECKO	; idProduct
	.db	>PID_GECKO	; idProduct
_usb_desc_hw_rev_binary_patch_location_0::
	.db	<DID_GECKO	; bcdDevice
	.db	>DID_GECKO	; bcdDevice
	.db	SI_VENDOR	; iManufacturer (string index)
	.db	SI_PRODUCT	; iProduct (string index)
	.db	SI_SERIAL	; iSerial number (string index)
	.db	1		; bNumConfigurations
	
;;; describes the other speed (12Mb/sec)
	.even
_high_speed_devqual_descr::
	.db	DSCR_DEVQUAL_LEN
	.db	DSCR_DEVQUAL
	.db	<0x0200		; bcdUSB (LSB)
	.db	>0x0200		; bcdUSB (MSB)
	.db	0x00		; bDeviceClass
	.db	0x00		; bDeviceSubClass
	.db	0x00		; bDeviceProtocol
	.db	64		; bMaxPacketSize0
	.db	1		; bNumConfigurations (one config at 12Mb/sec)
	.db	0		; bReserved
	
	.even
_high_speed_config_descr::	
	.db	DSCR_CONFIG_LEN
	.db	DSCR_CONFIG
	.db	<(_high_speed_config_descr_end - _high_speed_config_descr) ; LSB
	.db	>(_high_speed_config_descr_end - _high_speed_config_descr) ; MSB
	.db	2		; bNumInterfaces
	.db	1		; bConfigurationValue
	.db	0		; iConfiguration
	.db	0x80 | bmSELF_POWERED ; bmAttributes
	.db	0		; bMaxPower

	;; interface descriptor 0 (USB TMC, ep2 OUT BULK, ep6 IN BULK)
	
	.db	DSCR_INTRFC_LEN
	.db	DSCR_INTRFC
	.db	0		; bInterfaceNumber (zero based)
	.db	0		; bAlternateSetting
	.db	2		; bNumEndpoints
	.db	0xfe		; bInterfaceClass (application class)
	.db	0x03		; bInterfaceSubClass (USB TMC)
	.db	0x01		; bInterfaceProtocol (USB TMC USB488 subclass device)
	.db	SI_USB_TMC	; iInterface (description)

	;; interface 0's OUT end point

	.db	DSCR_ENDPNT_LEN
	.db	DSCR_ENDPNT
	.db	0x02		; bEndpointAddress (ep 2 OUT)
	.db	ET_BULK		; bmAttributes
	.db	<512		; wMaxPacketSize (LSB)
	.db	>512		; wMaxPacketSize (MSB)
	.db	0		; bInterval (iso only)

	;; interface 0's IN end point

	.db	DSCR_ENDPNT_LEN
	.db	DSCR_ENDPNT
	.db	0x86		; bEndpointAddress (ep 6 IN)
	.db	ET_BULK		; bmAttributes
	.db	<512		; wMaxPacketSize (LSB)
	.db	>512		; wMaxPacketSize (MSB)
	.db	0		; bInterval (iso only)

	;; interface descriptor 1 (command & status, ep0 COMMAND)

;;	disabled since firmware version 0.4, use version 0.3 after production to set parameters
;;	.db	DSCR_INTRFC_LEN
;;	.db	DSCR_INTRFC
;;	.db	1		; bInterfaceNumber (zero based)
;;	.db	0		; bAlternateSetting
;;	.db	0		; bNumEndpoints
;;	.db	0xff		; bInterfaceClass (vendor specific)
;;	.db	0xff		; bInterfaceSubClass (vendor specific)
;;	.db	0xff		; bInterfaceProtocol (vendor specific)
;;	.db	SI_COMMAND_AND_STATUS	; iInterface (description)
	
	;; interface descriptor 2 (Run-Time DFU Interface descriptor)
	
	.db	DSCR_INTRFC_LEN
	.db	DSCR_INTRFC
	.db	1		; bInterfaceNumber (zero based)
	.db	0		; bAlternateSetting
	.db	0		; bNumEndpoints
	.db	0xfe		; bInterfaceClass (application specific)
	.db	0x01		; bInterfaceSubClass (device firmware upgrade)
	.db	0x01		; bInterfaceProtocol (runtime protocol)
	.db	SI_DFU		; iInterface (description)
	
	;; interface 2's functional descriptor

	.db	DSCR_DFUFUNC_LEN
	.db	DSCR_DFUFUNC
	.db	0x01		; bmAttributes:	no auto detach, no upload, yes download
	.db	<500		; wDetachTimeOut (LSB)
	.db	>500		; wDetachTimeOut (MSB)
	.db	<64		; wMaxPacketSize (LSB)
	.db	>64		; wMaxPacketSize (MSB)
	.db	<0x0001		; bcdDFUVersion (LSB)
	.db	>0x0001		; bcdDFUVersion (MSB)
_high_speed_config_descr_end:		

;;; ----------------------------------------------------------------
;;; descriptors used when operating at full speed (12Mb/sec)
;;; ----------------------------------------------------------------

	.even
_full_speed_device_descr::	
	.db	DSCR_DEVICE_LEN
	.db	DSCR_DEVICE
	.db	<0x0200		; Specification version (LSB)
	.db	>0x0200		; Specification version (MSB)
	.db	0x00		; device class (see interface)
	.db	0x00		; device subclass (see interface)
	.db	0x00		; device protocol (see interface)
	.db	64		; bMaxPacketSize0 for endpoint 0
	.db	<VID_FREE	; idVendor
	.db	>VID_FREE	; idVendor	
	.db	<PID_GECKO	; idProduct
	.db	>PID_GECKO	; idProduct
_usb_desc_hw_rev_binary_patch_location_1::
	.db	<DID_GECKO	; bcdDevice
	.db	>DID_GECKO	; bcdDevice
	.db	SI_VENDOR	; iManufacturer (string index)
	.db	SI_PRODUCT	; iProduct (string index)
	.db	SI_SERIAL	; iSerial number (None)
	.db	1		; bNumConfigurations
	
	
;;; describes the other speed (480Mb/sec)
	.even
_full_speed_devqual_descr::
	.db	DSCR_DEVQUAL_LEN
	.db	DSCR_DEVQUAL
	.db	<0x0200		; bcdUSB
	.db	>0x0200		; bcdUSB
	.db	0x00		; bDeviceClass
	.db	0x00		; bDeviceSubClass
	.db	0x00		; bDeviceProtocol
	.db	64		; bMaxPacketSize0
	.db	1		; bNumConfigurations (one config at 480Mb/sec)
	.db	0		; bReserved
	
	.even
_full_speed_config_descr::	
	.db	DSCR_CONFIG_LEN
	.db	DSCR_CONFIG
	.db	<(_full_speed_config_descr_end - _full_speed_config_descr) ; LSB
	.db	>(_full_speed_config_descr_end - _full_speed_config_descr) ; MSB
	.db	3		; bNumInterfaces
	.db	1		; bConfigurationValue
	.db	0		; iConfiguration
	.db	0x80 | bmSELF_POWERED ; bmAttributes
	.db	0		; bMaxPower

	;; interface descriptor 0 (USB TMC, ep2 OUT BULK, ep6 IN BULK)
	
	.db	DSCR_INTRFC_LEN
	.db	DSCR_INTRFC
	.db	0		; bInterfaceNumber (zero based)
	.db	0		; bAlternateSetting
	.db	2		; bNumEndpoints
	.db	0xfe		; bInterfaceClass (application class)
	.db	0x03		; bInterfaceSubClass (USB TMC)
	.db	0x01		; bInterfaceProtocol (USB TMC USB488 subclass device)
	.db	SI_USB_TMC	; iInterface (description)

	;; interface 0's OUT end point

	.db	DSCR_ENDPNT_LEN
	.db	DSCR_ENDPNT
	.db	0x02		; bEndpointAddress (ep 2 OUT)
	.db	ET_BULK		; bmAttributes
	.db	<64		; wMaxPacketSize (LSB)
	.db	>64		; wMaxPacketSize (MSB)
	.db	0		; bInterval (iso only)

	;; interface 1's IN end point

	.db	DSCR_ENDPNT_LEN
	.db	DSCR_ENDPNT
	.db	0x86		; bEndpointAddress (ep 6 IN)
	.db	ET_BULK		; bmAttributes
	.db	<64		; wMaxPacketSize (LSB)
	.db	>64		; wMaxPacketSize (MSB)
	.db	0		; bInterval (iso only)

	;; interface descriptor 1 (command & status, ep0 COMMAND)

;;	disabled since firmware version 0.4, use version 0.3 after production to set parameters	
;;	.db	DSCR_INTRFC_LEN
;;	.db	DSCR_INTRFC
;;	.db	1		; bInterfaceNumber (zero based)
;;	.db	0		; bAlternateSetting
;;	.db	0		; bNumEndpoints
;;	.db	0xff		; bInterfaceClass (vendor specific)
;;	.db	0xff		; bInterfaceSubClass (vendor specific)
;;	.db	0xff		; bInterfaceProtocol (vendor specific)
;;	.db	SI_COMMAND_AND_STATUS	; iInterface (description)

	;; interface descriptor 2 (Run-Time DFU Interface descriptor)
	
	.db	DSCR_INTRFC_LEN
	.db	DSCR_INTRFC
	.db	1		; bInterfaceNumber (zero based)
	.db	0		; bAlternateSetting
	.db	0		; bNumEndpoints
	.db	0xfe		; bInterfaceClass (application specific)
	.db	0x01		; bInterfaceSubClass (device firmware upgrade)
	.db	0x01		; bInterfaceProtocol (runtime protocol)
	.db	SI_DFU		; iInterface (description)

	;; interface 2's functional descriptor

	.db	DSCR_DFUFUNC_LEN
	.db	DSCR_DFUFUNC
	.db	0x01		; bmAttributes:	no auto detach, no upload, yes download
	.db	<500		; wDetachTimeOut (LSB)
	.db	>500		; wDetachTimeOut (MSB)
	.db	<64		; wMaxPacketSize (LSB)
	.db	>64		; wMaxPacketSize (MSB)
	.db	<0x0001		; bcdDFUVersion (LSB)
	.db	>0x0001		; bcdDFUVersion (MSB)
_full_speed_config_descr_end:	

;;; ----------------------------------------------------------------
;;; descriptors used when operating in DFU class mode
;;; ----------------------------------------------------------------

	.even
_dfu_mode_device_descr::	
	.db	DSCR_DEVICE_LEN
	.db	DSCR_DEVICE
	.db	<0x0100		; Specification version (LSB)
	.db	>0x0100		; Specification version (MSB)
	.db	0x00		; device class (see interface)
	.db	0x00		; device subclass (see interface)
	.db	0x00		; device protocol (see interface)
	.db	64		; bMaxPacketSize0 for endpoint 0
	.db	<VID_FREE	; idVendor
	.db	>VID_FREE	; idVendor	
	.db	<PID_DFU	; idProduct
	.db	>PID_DFU	; idProduct
_usb_desc_hw_rev_binary_patch_location_2::
	.db	<DID_GECKO	; bcdDevice
	.db	>DID_GECKO	; bcdDevice
	.db	SI_VENDOR	; iManufacturer (string index)
	.db	SI_PRODUCT	; iProduct (string index)
	.db	SI_SERIAL	; iSerial number (None)
	.db	1		; bNumConfigurations
	
	.even
_dfu_mode_config_descr::	
	.db	DSCR_CONFIG_LEN
	.db	DSCR_CONFIG
	.db	<(_dfu_mode_config_descr_end - _dfu_mode_config_descr) ; LSB
	.db	>(_dfu_mode_config_descr_end - _dfu_mode_config_descr) ; MSB
	.db	1		; bNumInterfaces
	.db	1		; bConfigurationValue
	.db	0		; iConfiguration
	.db	0x80 | bmSELF_POWERED ; bmAttributes
	.db	0		; bMaxPower

	;; interface descriptor 0 (command & status, ep0 COMMAND)
	
	.db	DSCR_INTRFC_LEN
	.db	DSCR_INTRFC
	.db	0		; bInterfaceNumber (zero based)
	.db	0		; bAlternateSetting
	.db	0		; bNumEndpoints
	.db	0xfe		; bInterfaceClass (vendor specific)
	.db	0x01		; bInterfaceSubClass (vendor specific)
	.db	0x02		; bInterfaceProtocol (vendor specific)
	.db	SI_DFU		; iInterface (description)
_dfu_mode_config_descr_end:

_dfu_mode_functional_descr::	
	.db	DSCR_DFUFUNC_LEN
	.db	DSCR_DFUFUNC
	.db	0x01		; bmAttributes:	no auto detach, no upload, yes download
	.db	<500		; wDetachTimeOut (LSB)
	.db	>500		; wDetachTimeOut (MSB)
	.db	<64		; wMaxPacketSize (LSB)
	.db	>64		; wMaxPacketSize (MSB)
	.db	<0x0001		; bcdDFUVersion (LSB)
	.db	>0x0001		; bcdDFUVersion (MSB)	

			
;;; ----------------------------------------------------------------
;;;			string descriptors
;;; ----------------------------------------------------------------

_nstring_descriptors::
	.db	(_string_descriptors_end - _string_descriptors) / 2

_string_descriptors::
	.db	<str0, >str0
	.db	<str1, >str1
	.db	<str2, >str2
	.db	<str3, >str3
	.db	<str4, >str4
	.db	<str5, >str5
	.db	<str6, >str6
_string_descriptors_end:

	SI_NONE = 0
	;; str0 contains the language ID's.
	.even
str0:	.db	str0_end - str0
	.db	DSCR_STRING
	.db	0
	.db	0
	.db	<0x0409		; magic code for US English (LSB)
	.db	>0x0409		; magic code for US English (MSB)
str0_end:

	SI_VENDOR = 1
	.even
str1:	.db	str1_end - str1
	.db	DSCR_STRING
	.db	'M, 0		; 16-bit unicode
	.db	'i, 0
	.db	'c, 0
	.db	'r, 0
	.db	'o, 0
	.db	'L, 0
	.db	'a, 0
	.db	'b, 0
	.db	' , 0
	.db	'B, 0
	.db	'F, 0
	.db	'H, 0
	.db	'-, 0
	.db	'T, 0
	.db	'I, 0
str1_end:

	SI_PRODUCT = 2
	.even
str2:	.db	str2_end - str2
	.db	DSCR_STRING
	.db	'G, 0
	.db	'E, 0
	.db	'C, 0
	.db	'K, 0
	.db	'O, 0
	.db	'3, 0
	.db	'C, 0
	.db	'O, 0
	.db	'M, 0
str2_end:

	SI_COMMAND_AND_STATUS = 3
	.even
str3:	.db	str3_end - str3
	.db	DSCR_STRING
	.db	'C, 0
	.db	'o, 0
	.db	'm, 0
	.db	'm, 0
	.db	'a, 0
	.db	'n, 0
	.db	'd, 0
	.db	' , 0
	.db	'&, 0
	.db	' , 0
	.db	'S, 0
	.db	't, 0
	.db	'a, 0
	.db	't, 0
	.db	'u, 0
	.db	's, 0
str3_end:

	SI_USB_TMC = 4
	.even
str4:	.db	str4_end - str4
	.db	DSCR_STRING
	.db	'U, 0
	.db	'S, 0
	.db	'B, 0
	.db	'T, 0
	.db	'M, 0
	.db	'C, 0
	.db	' , 0
	.db	'U, 0
	.db	'S, 0
	.db	'B, 0
	.db	'4, 0
	.db	'8, 0
	.db	'8, 0
str4_end:

	SI_DFU = 5
	.even
str5:	.db	str5_end - str5
	.db	DSCR_STRING
	.db	'G, 0
	.db	'E, 0
	.db	'C, 0
	.db	'K, 0
	.db	'O, 0
	.db	'3, 0
	.db	'C, 0
	.db	'O, 0
	.db	'M, 0
	.db	' , 0
	.db	'F, 0
	.db	'W, 0
	.db	' , 0
	.db	'U, 0
	.db	'P, 0
	.db	'D, 0
	.db	'A, 0
	.db	'T, 0
	.db	'E, 0
str5_end:	

	SI_SERIAL = 6
	.even
str6:	.db	str6_end - str6
	.db	DSCR_STRING
_usb_desc_serial_number_ascii::
	.db	'3, 0
	.db	'., 0
	.db	'1, 0
	.db	'4, 0
	.db	'1, 0
	.db	'5, 0
	.db	'9, 0
	.db	'3, 0
str6_end:

