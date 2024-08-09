#line 1 "E:/Final_Project/Final_Project_Embedded/code/traffic_light.c"
#line 21 "E:/Final_Project/Final_Project_Embedded/code/traffic_light.c"
interrupt(){
 if(intf_bit){
 intf_bit=0;
  portb.b0 =~ portb.b0 ;
 }
}
int counter=0;
int segment[]={0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x10,
0x11,0x12,0x13,20,21,22,23,24,25,32,33,34,35};
void main() {

 adcon1=0x07;
 trisa=0; trisa.b4=1;
 trisc=0; portc=segment[23];
 trisd=0; portd=0b11001100;
 trisb=0b00000011;

 gie_bit=1;
 inte_bit=1;




 while(1){

 if(! portb.b0 ){
 portd=0b11001100;


 if( portd.b3 ){
 for(counter=23; counter>=0 && ! portb.b0  ; counter--){
  portd.b2 =(counter>3 ? 1:0);
 if(counter<=3){
  portd.b1 =1;
  portd.b3 =0;
  portd.b4 =1;
 }
 portc=segment[counter];
 if(counter==0) { portd.b1 =0; portd.b4 =0; portd.b0 =1; portd.b5 =1;}
 delay_ms(1000);

 }

 }

 else{
 for(counter=23;counter>=0 && ! portb.b0  ; counter--){
  portd.b5 =(counter>3 ? 1:0);
 if(counter<=3){
  portd.b4 =1;
  portd.b0 =0;
  portd.b1 =1;
 }
 portc=segment[counter];
 if(counter==0) { portd.b4 =0; portd.b1 =0; portd.b2 =1; portd.b3 =1;}
 delay_ms(1000);
 }

 }

 }

 else{
 if( portd.b3 ){
 for(counter = 3; counter > 0 &&  portb.b0 ; counter--) {
  portd.b1  = 1;
  portd.b2  = 0;
 portc = segment[counter];
 delay_ms(1000);
 }
 while( portb.b0  &&  portb.b1  != 1) {
  portd.b0  = 1;
  portd.b1  = 0;
  portd.b2  = 0;
  portd.b3  = 0;
  portd.b4  = 0;
  portd.b5  = 1;
 portc = segment[0];
 delay_ms(50);
 }
 }

 else {
 for(counter = 3; counter > 0 &&  portb.b0 ; counter--) {
  portd.b4  = 1;
  portd.b5  = 0;
 portc = segment[counter];
 delay_ms(1000);
 }
 while( portb.b0  &&  portb.b1  != 1) {
  portd.b0  = 0;
  portd.b1  = 0;
  portd.b2  = 1;
  portd.b3  = 1;
  portd.b4  = 0;
  portd.b5  = 0;
 portc = segment[0];
 delay_ms(50);
 }
 }
 }

 }
}
