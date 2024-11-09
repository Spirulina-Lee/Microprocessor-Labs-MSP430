#include <msp430.h> 
#define CPU_F ((double)1000000) // Define CPU frequency for delay calculation
#define delay_ms(x) __delay_cycles((long)(CPU_F * (double)x / 1000.0)) // Delay function in milliseconds

int main(void) {
    WDTCTL = WDTPW | WDTHOLD; // Stop the watchdog timer

    P8DIR |= BIT1; // Set P8.1 as output (LED)

    P1REN |= BIT2; // Enable pull-up resistor on P1.2 (Switch)
    P1OUT |= BIT2; // Set pull-up resistor as active for P1.2

    while (1)
    {
        if (P1IN & BIT2)// If the switch is not pressed, wait for debounce and turn off the LED
        {

            delay_ms(20);
            if (P1IN & BIT2)
                P8OUT &= ~BIT1;
        }
        else// If the switch is pressed, wait for debounce and turn on the LED
        {

            delay_ms(20);
            if ((P1IN & BIT2) == 0)
                P8OUT |= BIT1;
        }
    }

    return 0;
}
