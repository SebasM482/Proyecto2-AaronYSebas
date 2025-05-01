`timescale 1ns/1ps

module sume_tb;

    // Señales
    logic clk;
    logic n_reset;
    logic [3:0] sample;
    logic [11:0] cdu, w1, w2;

    // Instancia del DUT (Device Under Test)
    sume dut (
        .clk(clk),
        .n_reset(n_reset),
        .sample(sample),
        .cdu(cdu),
        .w1(w1),
        .w2(w2)
    );

    // Generador de reloj con periodo de 37ns
    initial clk = 0;
    always #18.5 clk = ~clk;

    // Secuencia de prueba
    initial begin
        // Inicialización
        n_reset = 0;
        sample = 4'd0;

        // Esperar un poco y soltar el reset
        #20;
        n_reset = 1;

        // Esperar un poco más para asegurar transición
        #10;

        // En cada ciclo le damos un sample diferente
        sample = 4'd1; // S0
        #37;

        sample = 4'd2; // S1
        #37;

        sample = 4'd3; // S2
        #37;

        sample = 4'd4; // S3
        #37;

        sample = 4'd5; // S4
        #37;

        sample = 4'd6; // S5
        #37;

        sample = 4'd0; // S6 (trigger suma)
        #37;

        // Mostrar resultado final
        $display("W1 = %0d (0x%0h)", w1, w1);
        $display("W2 = %0d (0x%0h)", w2, w2);
        $display("SUM = %0d (0x%0h)", cdu, cdu);

        #20;
        $finish;
    end

endmodule