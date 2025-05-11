`timescale 1ns / 1ns

module sume_tb;

    logic clk;
    logic [3:0] sample;
    logic [11:0] cdu;

    // Instancia del DUT (Device Under Test)
    sume uut (
        .clk(clk),
        .sample(sample),
        .cdu(cdu)
    );

    // Reloj: periodo de 10 unidades de tiempo
    always #18.5 clk = ~clk;

    initial begin
        // Inicializar señales
        clk = 0;
        sample = 4'b1111; // Sin tecla presionada inicialmente
        #1000;

        // Simular presiones de teclas
        sample = 4'b0001; // w1[11:8] = 5
        #1000;
        sample = 4'b1111; // w1[11:8] 
        #1000;

        sample = 4'b0001; // w1[7:4] = 3
        #1000;
        sample = 4'b1111; // w1[11:8] 
        #1000;

        sample = 4'b0001; // w1[3:0] = 4
        #1000;
        sample = 4'b1111; // w1[11:8] 
        #1000;

        sample = 4'b0001; // w2[11:8] = 9
        #1000;
        sample = 4'b1111; // w1[11:8] 
        #1000;

        sample = 4'b0001; // w2[7:4] = 6
        #1000;
        sample = 4'b1111; // w1[11:8] 
        #1000;

        sample = 4'b0001; // w2[3:0] = 1
        #1000;
        sample = 4'b1111; // w1[11:8] 
        #1000;


        sample = 4'b0000; // Sin tecla presionada (para evitar cambios en el estado)
        #5000;

        // Simular presiones de teclas
        sample = 4'b0010; // w1[11:8] = 5
        #1000;
        sample = 4'b1111; // w1[11:8] 
        #1000;
        sample = 4'b0010; // w1[7:4] = 3
        #1000;
        sample = 4'b1111; // w1[11:8] 
        #1000;
        sample = 4'b0010; // w1[3:0] = 4
        #1000;
        sample = 4'b1111; // w1[11:8] 
        #1000;
        sample = 4'b0010; // w2[11:8] = 9
        #1000;
        sample = 4'b1111; // w1[11:8] 
        #1000;
        sample = 4'b0010; // w2[7:4] = 6
        #1000;
        sample = 4'b1111; // w1[11:8] 
        #1000;
        sample = 4'b0010; // w2[3:0] = 1
        #1000;
        sample = 4'b1111; // w1[11:8] 

        sample = 4'b0000; // Sin tecla presionada (para evitar cambios en el estado)
        #5000;


        $display("Resultado de la suma: %0b", cdu); // Esperado: 534 + 961 = 1495
        $finish;
    end

    initial begin
        $dumpfile("sume_tb.vcd");
        $dumpvars(0, sume_tb);
    end

endmodule
