/**
 * F_CPU é uma diretiva necessária para utilizar _delay_ms.  
 * Em F_CPU é atribuido o valor da frequência do oscilador.
 */
#define F_CPU 16000000UL //int -> 16bits -> UL -> 32bits

/**
 * Inclui as definições dos registrados do ATMEGA328p ou ATMEGA2560;
 */
#include <avr/io.h>

/**
 * Biblioteca que inclui a macro _delay_ms;
 */
#include <util/delay.h>

/**
 * Diretivas 
 */
#define TRUE  1

/**
 * Função principal e de entrada do programa;
 */
int main( void )
{
	printf("senai");
	/**
	 * Para usar qualquer GPIO antes é necessário configurar o sentido (entrada ou saída);
	 * Configura todos os pinos do PORTB como saída; 
	 */
    DDRB |= (1<<5); //Seta em nível 1 o pino ddr _bit5 
 
	/**
	 * Isso é um pisca led, correto? Portanto, loop infinito!
	 */
    while ( TRUE ) 
    {
		PORTB |= (1<<5);  // Seta em nível 1 o pino RB5 (led building on)
		_delay_ms(1000);  // Delay de 1000 milisegundos; //Nop()
		/*
           for(int i = 0; i < F_CPU; i++) Nop();
		*/
		
		PORTB &= ~(1<<5); // Seta em nível 0 o pino RB5 (led building off)
		_delay_ms(1000);
    }

    return 0; //OK
}










