; useful constants

constant_columns_per_line = 40

; useful addresses

!addr   address_font_pointer = $D018
!addr   address_sid_music_init = $1000
!addr   address_sid_music_play = address_sid_music_init + 3
!addr   address_border_color = $D020
!addr   address_screen_color = $D021
!addr   address_horizontal_scroll_register = $D016
!addr   address_first_screen_char_color = $D800
!addr   address_raster_line_interrupt = $D012
!addr   address_lo_byte_interrupt = $0314
!addr   address_hi_byte_interrupt = $0315

!addr   address_kernal_irq_handler_full = $ea31     ; The complete (beginning of) KERNAL's standard interrupt service routine. Use once in each frame
!addr   address_kernal_irq_handler_end_part = $ea81 ; The final part of KERNAL's standard interrupt service routine. Use multiple times per frame