`timescale 1ns/1ps

module bin_bcdtb;

    // Entradas
    reg [9:0] bin;

    // Salida
    wire [11:0] bcd;

    // Instancia del módulo
    bin_bcd uut (
        .bin(bin),
        .bcd(bcd)
    );

    initial begin
        // Mostrar encabezado
        $display("Time\tBinario\t\tBCD");
        $monitor("%0dns\t%b\t%h", $time, bin, bcd);

        // Pruebas
        bin = 0;       #10;
        bin = 1;       #10;
        bin = 9;       #10;
        bin = 10;      #10;
        bin = 59;      #10;
        bin = 123;     #10;
        bin = 999;     #10;
        bin = 1001;    #10;


        // Finaliza la simulación
        #10 $finish;
    end
endmodule