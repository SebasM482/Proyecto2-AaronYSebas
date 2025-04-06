`timescale 1ns/1ps
// Este modulo recibe una señal de una frecuencia que se elije, un numero binario que se lee 
// del dipswitch de 4 pines y recibe el sindrome.
// Dependiendo del estado de la señal de reloj, el mux selecciona el numero binario o el sindrome.


module mux(
    input logic clk_out,    // Señal de reloj de 1 kHz (selector)
    input logic [3:0] i,    // Entrada 0 (4 bits)
    input logic [3:0] p,    // Entrada 1 (4 bits)
    output logic [3:0] w    // Salida (4 bits)
);

    always_comb begin
        w = (clk_out) ? p : i; // Si clk_1kHz = 1 -> p, sino -> i
    end

endmodule