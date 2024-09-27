#include <msp430.h>

#define SWITCH_PIN1

#define CPU_F ((double)1000000)
#define delay_ms(x) __delay_cycles((long)(CPU_F*(double)x/1000.0))

int main(void) {
    WDTCTL = WDTPW | WDTHOLD;   // Stop watchdog timer

    P3DIR |= BIT7;           // Set P3.7 as output for the LED
    P1DIR &= ~(BIT2+BIT3);       // Set P1.3 as input for the switch
    P1REN |= BIT2+BIT3;        // Enable pull-up resistor for P1.3
    P1OUT |= BIT2+BIT3;        // Set pull-up resistor as active for P1.3

    while(1)
    {
        if (((P1IN & BIT2) == 0)||((P1IN & BIT3) == 0)) // Switch is pressed
        {
            delay_ms(20); // Debounce delay
            if (((P1IN & BIT2) == 0)||((P1IN & BIT3) == 0))// Switch is still pressed after debounce, toggle LED state
            {
                P3OUT |= BIT7; // Toggle the LED state
                while (((P1IN & BIT2) == 0)||((P1IN & BIT3) == 0)); // Wait for the switch to be released
            }
        }
        else
            P3OUT &= ~BIT7;
    }
    return 0;
}
