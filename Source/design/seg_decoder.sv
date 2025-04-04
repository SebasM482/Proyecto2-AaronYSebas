`timescale 1ns/1ps
// Este modulo recibe un numero binario de 4 bits retorna 7 bits, uno para cada segmentos del display

module seg_decoder(input logic [3:0] w, output logic [6:0] d);
    assign d[6] =  w[1] | w[3] | (~w[2] & ~w[0]) | (w[2] & w[0]);   // a
    assign d[5] = ~w[2] | w[1] | ~w[0];                            // b
    assign d[4] = ~w[1] | w[2] | w[0];                             // c
    assign d[3] = (~w[2] & ~w[0]) | (~w[2] & w[1]) + (w[1] & ~w[0]) | (w[2] & ~w[1] & w[0]) ;  // d
    assign d[2] = (~w[2] & ~w[0]) | (w[1] & ~w[0]);                // e
    assign d[1] = w[3] | (~w[1] & ~w[0]) | (w[2] & ~w[1]);         // f
    assign d[0] = w[3] | (~w[2] & w[1]) | (w[2] & ~w[0]) | (w[2] & ~w[1]);  // g
endmodule
