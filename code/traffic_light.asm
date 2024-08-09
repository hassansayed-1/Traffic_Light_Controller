
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;traffic_light.c,21 :: 		interrupt(){
;traffic_light.c,22 :: 		if(intf_bit){
	BTFSS      INTF_bit+0, BitPos(INTF_bit+0)
	GOTO       L_interrupt0
;traffic_light.c,23 :: 		intf_bit=0;
	BCF        INTF_bit+0, BitPos(INTF_bit+0)
;traffic_light.c,24 :: 		flag=~flag;
	MOVLW      1
	XORWF      PORTB+0, 1
;traffic_light.c,25 :: 		}
L_interrupt0:
;traffic_light.c,26 :: 		}
L_end_interrupt:
L__interrupt58:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;traffic_light.c,30 :: 		void main() {
;traffic_light.c,32 :: 		adcon1=0x07;
	MOVLW      7
	MOVWF      ADCON1+0
;traffic_light.c,33 :: 		trisa=0; trisa.b4=1;
	CLRF       TRISA+0
	BSF        TRISA+0, 4
;traffic_light.c,34 :: 		trisc=0; portc=segment[23];
	CLRF       TRISC+0
	MOVF       _segment+46, 0
	MOVWF      PORTC+0
;traffic_light.c,35 :: 		trisd=0; portd=0b11001100;
	CLRF       TRISD+0
	MOVLW      204
	MOVWF      PORTD+0
;traffic_light.c,36 :: 		trisb=0b00000011;
	MOVLW      3
	MOVWF      TRISB+0
;traffic_light.c,38 :: 		gie_bit=1;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;traffic_light.c,39 :: 		inte_bit=1;
	BSF        INTE_bit+0, BitPos(INTE_bit+0)
;traffic_light.c,44 :: 		while(1){
L_main1:
;traffic_light.c,46 :: 		if(!flag){
	BTFSC      PORTB+0, 0
	GOTO       L_main3
;traffic_light.c,47 :: 		portd=0b11001100;
	MOVLW      204
	MOVWF      PORTD+0
;traffic_light.c,50 :: 		if(red2){
	BTFSS      PORTD+0, 3
	GOTO       L_main4
;traffic_light.c,51 :: 		for(counter=23; counter>=0 && !flag ; counter--){
	MOVLW      23
	MOVWF      _counter+0
	MOVLW      0
	MOVWF      _counter+1
L_main5:
	MOVLW      128
	XORWF      _counter+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main60
	MOVLW      0
	SUBWF      _counter+0, 0
L__main60:
	BTFSS      STATUS+0, 0
	GOTO       L_main6
	BTFSC      PORTB+0, 0
	GOTO       L_main6
L__main56:
;traffic_light.c,52 :: 		green1=(counter>3 ? 1:0);
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _counter+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main61
	MOVF       _counter+0, 0
	SUBLW      3
L__main61:
	BTFSC      STATUS+0, 0
	GOTO       L_main10
	MOVLW      1
	MOVWF      R3+0
	GOTO       L_main11
L_main10:
	CLRF       R3+0
L_main11:
	BTFSC      R3+0, 0
	GOTO       L__main62
	BCF        PORTD+0, 2
	GOTO       L__main63
L__main62:
	BSF        PORTD+0, 2
L__main63:
;traffic_light.c,53 :: 		if(counter<=3){
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _counter+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main64
	MOVF       _counter+0, 0
	SUBLW      3
L__main64:
	BTFSS      STATUS+0, 0
	GOTO       L_main12
;traffic_light.c,54 :: 		yellow1=1;
	BSF        PORTD+0, 1
;traffic_light.c,55 :: 		red2=0;
	BCF        PORTD+0, 3
;traffic_light.c,56 :: 		yellow2=1;
	BSF        PORTD+0, 4
;traffic_light.c,57 :: 		}
L_main12:
;traffic_light.c,58 :: 		portc=segment[counter];
	MOVF       _counter+0, 0
	MOVWF      R0+0
	MOVF       _counter+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _segment+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTC+0
;traffic_light.c,59 :: 		if(counter==0) {yellow1=0;yellow2=0;red1=1;green2=1;}
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main65
	MOVLW      0
	XORWF      _counter+0, 0
L__main65:
	BTFSS      STATUS+0, 2
	GOTO       L_main13
	BCF        PORTD+0, 1
	BCF        PORTD+0, 4
	BSF        PORTD+0, 0
	BSF        PORTD+0, 5
L_main13:
;traffic_light.c,60 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main14:
	DECFSZ     R13+0, 1
	GOTO       L_main14
	DECFSZ     R12+0, 1
	GOTO       L_main14
	DECFSZ     R11+0, 1
	GOTO       L_main14
	NOP
	NOP
;traffic_light.c,51 :: 		for(counter=23; counter>=0 && !flag ; counter--){
	MOVLW      1
	SUBWF      _counter+0, 1
	BTFSS      STATUS+0, 0
	DECF       _counter+1, 1
;traffic_light.c,62 :: 		}
	GOTO       L_main5
L_main6:
;traffic_light.c,64 :: 		}
	GOTO       L_main15
L_main4:
;traffic_light.c,67 :: 		for(counter=23;counter>=0 && !flag ; counter--){
	MOVLW      23
	MOVWF      _counter+0
	MOVLW      0
	MOVWF      _counter+1
L_main16:
	MOVLW      128
	XORWF      _counter+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main66
	MOVLW      0
	SUBWF      _counter+0, 0
L__main66:
	BTFSS      STATUS+0, 0
	GOTO       L_main17
	BTFSC      PORTB+0, 0
	GOTO       L_main17
L__main55:
;traffic_light.c,68 :: 		green2=(counter>3 ? 1:0);
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _counter+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main67
	MOVF       _counter+0, 0
	SUBLW      3
L__main67:
	BTFSC      STATUS+0, 0
	GOTO       L_main21
	MOVLW      1
	MOVWF      R4+0
	GOTO       L_main22
L_main21:
	CLRF       R4+0
L_main22:
	BTFSC      R4+0, 0
	GOTO       L__main68
	BCF        PORTD+0, 5
	GOTO       L__main69
L__main68:
	BSF        PORTD+0, 5
L__main69:
;traffic_light.c,69 :: 		if(counter<=3){
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _counter+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main70
	MOVF       _counter+0, 0
	SUBLW      3
L__main70:
	BTFSS      STATUS+0, 0
	GOTO       L_main23
;traffic_light.c,70 :: 		yellow2=1;
	BSF        PORTD+0, 4
;traffic_light.c,71 :: 		red1=0;
	BCF        PORTD+0, 0
;traffic_light.c,72 :: 		yellow1=1;
	BSF        PORTD+0, 1
;traffic_light.c,73 :: 		}
L_main23:
;traffic_light.c,74 :: 		portc=segment[counter];
	MOVF       _counter+0, 0
	MOVWF      R0+0
	MOVF       _counter+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _segment+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTC+0
;traffic_light.c,75 :: 		if(counter==0) {yellow2=0;yellow1=0;green1=1;red2=1;}
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main71
	MOVLW      0
	XORWF      _counter+0, 0
L__main71:
	BTFSS      STATUS+0, 2
	GOTO       L_main24
	BCF        PORTD+0, 4
	BCF        PORTD+0, 1
	BSF        PORTD+0, 2
	BSF        PORTD+0, 3
L_main24:
;traffic_light.c,76 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main25:
	DECFSZ     R13+0, 1
	GOTO       L_main25
	DECFSZ     R12+0, 1
	GOTO       L_main25
	DECFSZ     R11+0, 1
	GOTO       L_main25
	NOP
	NOP
;traffic_light.c,67 :: 		for(counter=23;counter>=0 && !flag ; counter--){
	MOVLW      1
	SUBWF      _counter+0, 1
	BTFSS      STATUS+0, 0
	DECF       _counter+1, 1
;traffic_light.c,77 :: 		}
	GOTO       L_main16
L_main17:
;traffic_light.c,79 :: 		}
L_main15:
;traffic_light.c,81 :: 		}
	GOTO       L_main26
L_main3:
;traffic_light.c,84 :: 		if(red2){
	BTFSS      PORTD+0, 3
	GOTO       L_main27
;traffic_light.c,85 :: 		for(counter = 3; counter > 0 && flag; counter--) {
	MOVLW      3
	MOVWF      _counter+0
	MOVLW      0
	MOVWF      _counter+1
L_main28:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _counter+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main72
	MOVF       _counter+0, 0
	SUBLW      0
L__main72:
	BTFSC      STATUS+0, 0
	GOTO       L_main29
	BTFSS      PORTB+0, 0
	GOTO       L_main29
L__main54:
;traffic_light.c,86 :: 		yellow1 = 1;
	BSF        PORTD+0, 1
;traffic_light.c,87 :: 		green1 = 0;
	BCF        PORTD+0, 2
;traffic_light.c,88 :: 		portc = segment[counter];
	MOVF       _counter+0, 0
	MOVWF      R0+0
	MOVF       _counter+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _segment+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTC+0
;traffic_light.c,89 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main33:
	DECFSZ     R13+0, 1
	GOTO       L_main33
	DECFSZ     R12+0, 1
	GOTO       L_main33
	DECFSZ     R11+0, 1
	GOTO       L_main33
	NOP
	NOP
;traffic_light.c,85 :: 		for(counter = 3; counter > 0 && flag; counter--) {
	MOVLW      1
	SUBWF      _counter+0, 1
	BTFSS      STATUS+0, 0
	DECF       _counter+1, 1
;traffic_light.c,90 :: 		}
	GOTO       L_main28
L_main29:
;traffic_light.c,91 :: 		while(flag && man != 1) {
L_main34:
	BTFSS      PORTB+0, 0
	GOTO       L_main35
	BTFSC      PORTB+0, 1
	GOTO       L_main35
L__main53:
;traffic_light.c,92 :: 		red1 = 1;
	BSF        PORTD+0, 0
;traffic_light.c,93 :: 		yellow1 = 0;
	BCF        PORTD+0, 1
;traffic_light.c,94 :: 		green1 = 0;
	BCF        PORTD+0, 2
;traffic_light.c,95 :: 		red2 = 0;
	BCF        PORTD+0, 3
;traffic_light.c,96 :: 		yellow2 = 0;
	BCF        PORTD+0, 4
;traffic_light.c,97 :: 		green2 = 1;
	BSF        PORTD+0, 5
;traffic_light.c,98 :: 		portc = segment[0];
	MOVF       _segment+0, 0
	MOVWF      PORTC+0
;traffic_light.c,99 :: 		delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main38:
	DECFSZ     R13+0, 1
	GOTO       L_main38
	DECFSZ     R12+0, 1
	GOTO       L_main38
	NOP
	NOP
;traffic_light.c,100 :: 		}
	GOTO       L_main34
L_main35:
;traffic_light.c,101 :: 		}
	GOTO       L_main39
L_main27:
;traffic_light.c,104 :: 		for(counter = 3; counter > 0 && flag; counter--) {
	MOVLW      3
	MOVWF      _counter+0
	MOVLW      0
	MOVWF      _counter+1
L_main40:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _counter+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main73
	MOVF       _counter+0, 0
	SUBLW      0
L__main73:
	BTFSC      STATUS+0, 0
	GOTO       L_main41
	BTFSS      PORTB+0, 0
	GOTO       L_main41
L__main52:
;traffic_light.c,105 :: 		yellow2 = 1;
	BSF        PORTD+0, 4
;traffic_light.c,106 :: 		green2 = 0;
	BCF        PORTD+0, 5
;traffic_light.c,107 :: 		portc = segment[counter];
	MOVF       _counter+0, 0
	MOVWF      R0+0
	MOVF       _counter+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _segment+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTC+0
;traffic_light.c,108 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main45:
	DECFSZ     R13+0, 1
	GOTO       L_main45
	DECFSZ     R12+0, 1
	GOTO       L_main45
	DECFSZ     R11+0, 1
	GOTO       L_main45
	NOP
	NOP
;traffic_light.c,104 :: 		for(counter = 3; counter > 0 && flag; counter--) {
	MOVLW      1
	SUBWF      _counter+0, 1
	BTFSS      STATUS+0, 0
	DECF       _counter+1, 1
;traffic_light.c,109 :: 		}
	GOTO       L_main40
L_main41:
;traffic_light.c,110 :: 		while(flag && man != 1) {
L_main46:
	BTFSS      PORTB+0, 0
	GOTO       L_main47
	BTFSC      PORTB+0, 1
	GOTO       L_main47
L__main51:
;traffic_light.c,111 :: 		red1 = 0;
	BCF        PORTD+0, 0
;traffic_light.c,112 :: 		yellow1 = 0;
	BCF        PORTD+0, 1
;traffic_light.c,113 :: 		green1 = 1;
	BSF        PORTD+0, 2
;traffic_light.c,114 :: 		red2 = 1;
	BSF        PORTD+0, 3
;traffic_light.c,115 :: 		yellow2 = 0;
	BCF        PORTD+0, 4
;traffic_light.c,116 :: 		green2 = 0;
	BCF        PORTD+0, 5
;traffic_light.c,117 :: 		portc = segment[0];
	MOVF       _segment+0, 0
	MOVWF      PORTC+0
;traffic_light.c,118 :: 		delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main50:
	DECFSZ     R13+0, 1
	GOTO       L_main50
	DECFSZ     R12+0, 1
	GOTO       L_main50
	NOP
	NOP
;traffic_light.c,119 :: 		}
	GOTO       L_main46
L_main47:
;traffic_light.c,120 :: 		}
L_main39:
;traffic_light.c,121 :: 		}
L_main26:
;traffic_light.c,123 :: 		}
	GOTO       L_main1
;traffic_light.c,124 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
