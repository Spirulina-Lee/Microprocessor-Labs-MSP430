#include <msp430.h> 

#define CPU_F ((double)1000000)
#define delay_ms(x) __delay_cycles((long)(CPU_F*(double)x/1000.0))

int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;  // Stop watchdog timer

    P8DIR |= BIT1;             // Set P8.1 as output for LED
    P8OUT &= ~BIT1;            // Initially turn off the LED
    P1REN |= BIT2;             // Enable pull-up resistor for P1.2 (Switch)
    P1OUT |= BIT2;             // Set pull-up resistor as active for P1.2
    P1IES = BIT2;              // Set interrupt edge select to trigger on falling edge
    P1IFG &= ~BIT2;            // Clear P1.2 interrupt flag

    while(1)
    {
        if(P1IN & BIT2)
        {
            delay_ms(20);        // Debounce delay
            if(P1IN & BIT2)
            {
                P1IE |= BIT2;     // Enable interrupt on P1.2
                __bis_SR_register(LPM4_bits + GIE);  // Enter Low Power Mode 4 with interrupts enabled
            }
        }
    }
}

#pragma vector = PORT1_VECTOR
__interrupt void PORT1_ISR (void)
{
    P1IFG &= 0x00;            // Clear P1.2 interrupt flag
    P8OUT ^= BIT1;            // Toggle the LED state
    P1IES ^= BIT2;            // Toggle interrupt edge select for the next rising/falling edge
}
