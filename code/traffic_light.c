/*
Name: Hassan Sayed Hassan Mohammed
Date: 10/8/2024
Project: Traffic Light Controller
*/

#define red1 portd.b0
#define yellow1 portd.b1
#define green1 portd.b2
#define red2 portd.b3
#define yellow2 portd.b4
#define green2 portd.b5
//#define EN1 portd.b6
//#define EN2 portd.b7
#define flag portb.b0
#define man portb.b1




interrupt(){
     if(intf_bit){
          intf_bit=0;
          flag=~flag;
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
     //Initializing the interrupt RB0/INT
     gie_bit=1;
     inte_bit=1;



     
     while(1){
          // auto mode
          if(!flag){
              portd=0b11001100;

              // south street will stop   west: on
              if(red2){
                   for(counter=23; counter>=0 && !flag ; counter--){
                        green1=(counter>3 ? 1:0);
                        if(counter<=3){
                             yellow1=1;
                             red2=0;
                             yellow2=1;
                        }
                        portc=segment[counter];
                        if(counter==0) {yellow1=0;yellow2=0;red1=1;green2=1;}
                        delay_ms(1000);
                        
                   }

              }
              // west street will stop    south: on
              else{
                   for(counter=23;counter>=0 && !flag ; counter--){
                        green2=(counter>3 ? 1:0);
                        if(counter<=3){
                             yellow2=1;
                             red1=0;
                             yellow1=1;
                        }
                        portc=segment[counter];
                        if(counter==0) {yellow2=0;yellow1=0;green1=1;red2=1;}
                        delay_ms(1000);
                   }
              
              }

          }
//           manual mode
          else{
                 if(red2){
                          for(counter = 3; counter > 0 && flag; counter--) {
                                      yellow1 = 1;
                                      green1 = 0;
                                      portc = segment[counter];
                                      delay_ms(1000);
                          }
                          while(flag && man != 1) {
                          red1 = 1;
                          yellow1 = 0;
                          green1 = 0;
                          red2 = 0;
                          yellow2 = 0;
                          green2 = 1;
                          portc = segment[0];
                          delay_ms(50);
                          }
                 }

                 else {
                      for(counter = 3; counter > 0 && flag; counter--) {
                      yellow2 = 1;
                      green2 = 0;
                      portc = segment[counter];
                      delay_ms(1000);
                      }
                      while(flag && man != 1) {
                      red1 = 0;
                      yellow1 = 0;
                      green1 = 1;
                      red2 = 1;
                      yellow2 = 0;
                      green2 = 0;
                      portc = segment[0];
                      delay_ms(50);
                      }
                 }
          }

     }
}
     

     


     
     

     
     
     
