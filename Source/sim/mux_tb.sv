`timescale 1ns / 1ps

module mux_tb;

    // Señales del testbench
    logic clk_out;          // Señal de reloj de prueba
    logic [3:0] i;          // Entrada 0
    logic [3:0] p;          // Entrada 1
    logic [3:0] w;          // Salida

    // Instanciar el módulo mux
    mux uut (
        .clk_out(clk_out),
        .i(i),
        .p(p),
        .w(w)
    );

    // Generación de reloj
    always #100 clk_out = ~clk_out; // Cambia cada 5 ns (frecuencia de 100 MHz aprox.)

    initial begin
        // Inicialización
        clk_out = 0;
        i = 4'b0001;
        p = 4'b1000;

        // Prueba 1: clk_out = 0, se espera w = i
        #100;
        $display("Tiempo: %t | clk_out = %b | i = %b | e = %b | w = %b", 
                 $time, clk_out, i, p, w);
        
        // Prueba 2: clk_out = 1, se espera w = e
        #100;
        $display("Tiempo: %t | clk_out = %b | i = %b | e = %b | w = %b", 
                 $time, clk_out, i, p, w);
        
        #100;
        $display("Tiempo: %t | clk_out = %b | i = %b | e = %b | w = %b", 
                 $time, clk_out, i, p, w);

        // Prueba 4: Cambiar clk_out de nuevo
        #100;
        $display("Tiempo: %t | clk_out = %b | i = %b | e = %b | w = %b", 
                 $time, clk_out, i, p, w);

        // Terminar simulación
        #100;
        $finish;
    end

        // Generación del archivo VCD
    initial begin
        $dumpfile("mux_tb.vcd");
        $dumpvars(0, mux_tb);
    end
endmodule
