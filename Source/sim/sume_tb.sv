module sume_tb;

    logic clk = 0;
    logic n_reset;
    logic [3:0] sample;
    logic [11:0] sum, w1, w2;

    // Instanciar el módulo
    sume uut (
        .clk(clk),
        .n_reset(n_reset),
        .sample(sample),
        .sum(sum),
        .w1(w1),
        .w2(w2)
    );

    // Generador de reloj (10ns periodo)
    always #5 clk = ~clk;

    initial begin
        $display("===  ===");
        $dumpfile("sume_tb.vcd");
        $dumpvars(0, sume_tb);

        // Reset activado
        n_reset = 0;
        sample = 4'd0;
        #10;

        // Reset desactivado
        n_reset = 1;

        // Paso por cada estado solo una vez
        sample = 4'd0; #10; // S0: w1[11:8]
        sample = 4'd7; #10; // S1: w1[7:4]
        sample = 4'd3; #10; // S2: w1[3:0]
        sample = 4'd2; #10; // S3: w2[11:8]
        sample = 4'd4; #10; // S4: w2[7:4]
        sample = 4'd7; #10; // S5: w2[3:0]
        sample = 4'd0; #10; // S6: calcular suma

        // Mostrar resultado
        $display("w1 = %0d (0x%03h)", w1, w1);
        $display("w2 = %0d (0x%03h)", w2, w2);
        $display("sum = %0d (0x%03h)", sum, sum);

        #10;
        $display("===  ===");
        $finish;
    end

endmodule