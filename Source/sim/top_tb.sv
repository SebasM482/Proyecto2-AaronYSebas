`timescale 1ns/1ps


module top_tb;

    // Declaracion de entradas
    logic [3:0] i;   // Numero binario
    logic [6:0] e;   // Numero binario codificado con hamming
    logic clk,       // Reloj 27 MHz

    // Declaracion de salidas
    logic [6:0] d; // Segmentos del display
    logic [3:0] c;  // Palabra corregida
    logic x;
    logic y;  

    ////////////////////////////


    // Instaciamiento de los modulos
    top uut(.clk(clk), .i(i), .e(e), .d(d), .c(c), .x(x), .y(y));
    ////////////////////////////

    always begin
        #18.5 clk = ~clk;  // T = 1 / 27 MHz => periodo = 37ns, cada mitad del periodo 18.5ns
    end

    initial begin
        clk=0;
        i = 4'b0101; // Numero binario
        e = 7'b1100110; // Numero binario codificado error en bit 5
        $monitor("Reloj: %t, Segmentos: %b, Correccion: %b", $time, d, c);

        
        #3000000; // Simular por 3 ms
        $finish;
    end


    // Generación del archivo VCD
    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);
    end


endmodule