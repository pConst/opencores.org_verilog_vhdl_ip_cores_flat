#ifndef __USB_HW_H__
#define __USB_HW_H__

//-----------------------------------------------------------------
// Defines
//-----------------------------------------------------------------
#define ENDPOINT_CONTROL        0

#define EP0_MAX_PACKET_SIZE     8
#define EP1_MAX_PACKET_SIZE     64
#define EP2_MAX_PACKET_SIZE     64
#define EP3_MAX_PACKET_SIZE     64

//-----------------------------------------------------------------
// Types
//-----------------------------------------------------------------
typedef void (*FUNC_PTR)(void);

//-----------------------------------------------------------------
// Prototypes
//-----------------------------------------------------------------
void usbhw_init(FUNC_PTR bus_reset, FUNC_PTR on_setup, FUNC_PTR on_out);
void usbhw_service(void);
void usbhw_attach(int state);
int  usbhw_is_attached(void);
int  usbhw_is_configured(void);
void usbhw_set_configured(int configured);
void usbhw_set_address(unsigned char addr);
int  usbhw_is_endpoint_stalled(unsigned char endpoint);
void usbhw_clear_endpoint_stall(unsigned char endpoint);
void usbhw_set_endpoint_stall(unsigned char endpoint);
int  usbhw_is_rx_ready(unsigned char endpoint);
int  usbhw_get_rx_count(unsigned char endpoint);
int  usbhw_get_rx_data(unsigned char endpoint, unsigned char *data, int max_len);
unsigned char usbhw_get_rx_byte(unsigned char endpoint);
void usbhw_clear_rx_ready(unsigned char endpoint);
int  usbhw_has_tx_space(unsigned char endpoint);
int  usbhw_load_tx_buffer(unsigned char endpoint, unsigned char *data, int count);
void usbhw_write_tx_byte(unsigned char endpoint, unsigned char data);
void usbhw_start_tx(unsigned char endpoint);
void usbhw_control_endpoint_stall(void);
void usbhw_control_endpoint_ack(void);
unsigned short usbhw_get_frame_number(void);

#endif
