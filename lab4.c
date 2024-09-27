#include <msp430.h> 
#define CPU_F ((double)1000000)
#define delay_ms(x) __delay_cycles((long)(CPU_F*(double)x/1000.0))

int main(void)
{
    WDTCTL = WDTPW | WDTHOLD; 

    P8DIR|=BIT1;
    P3DIR|=BIT7;
    P7DIR|=BIT4;
    P6DIR|=BIT3;
    P6DIR|=BIT4;
    P3DIR|=BIT5; //These lines of code are used to set the IO port to output mode


    P8OUT&=~BIT1;
    P3OUT&=~BIT7;
    P7OUT&=~BIT4;
    P6OUT&=~BIT3;
    P6OUT&=~BIT4;
    P3OUT&=~BIT5; //Initialize the six lights of the MSP430 to turn it off


    while(1)//Cycle to turn on/off 6 leds
    {

            P8OUT^=BIT1;//turn on led
            delay_ms(800);//used to delay
            P8OUT^=BIT1;//turn off led

            P3OUT^=BIT7;
            delay_ms(800);
            P3OUT^=BIT7;

            P7OUT^=BIT4;
            delay_ms(800);
            P7OUT^=BIT4;

            P6OUT^=BIT3;
            delay_ms(800);
            P6OUT^=BIT3;

            P6OUT^=BIT4;
            delay_ms(800);
            P6OUT^=BIT4;

            P3OUT^=BIT5;
            delay_ms(800);
            P3OUT^=BIT5;

    }

    return 0;
}
