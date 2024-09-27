#include <msp430.h>

#define LED_PIN BIT7
#define SWITCH_PIN BIT3

#define CPU_F ((double)1000000)
#define delay_ms(x) __delay_cycles((long)(CPU_F*(double)x/1000.0))

int main(void) {
    WDTCTL = WDTPW | WDTHOLD;   // Stop watchdog timer

    P3DIR |= LED_PIN;           // Set P3.7 as output for the LED
    P1DIR &= ~SWITCH_PIN;       // Set P1.3 as input for the switch
    P1REN |= SWITCH_PIN;        // Enable pull-up resistor for P1.3
    P1OUT |= SWITCH_PIN;        // Set pull-up resistor as active for P1.3

    while(1)
    {
        if ((P1IN & SWITCH_PIN) == 0) // Switch is pressed
        {
            delay_ms(20); // Debounce delay
            if ((P1IN & SWITCH_PIN) == 0) // Switch is still pressed after debounce, toggle LED state
            {
                P3OUT ^= LED_PIN; // Toggle the LED state
                while ((P1IN & SWITCH_PIN) == 0); // Wait for the switch to be released
            }
        }
    }
    return 0;
}

