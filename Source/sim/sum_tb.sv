`timescale 1ns / 1ps

module sum_tb;

    logic clk;
    logic n_reset;
    logic [3:0] centenas;
    logic [3:0] decenas;
    logic [3:0] unidades;
    logic cargar;
    logic [9:0] numero_guardado;  // Salida del número almacenado

    sum dut (
        .clk(clk),
        .n_reset(n_reset),
        .centenas(centenas),
        .decenas(decenas),
        .unidades(unidades),
        .cargar(cargar),
        .numero_guardado(numero_guardado)
    );

    // Clock de 100 MHz
    always #5 clk = ~clk;

    task reset();
        begin
            n_reset = 0;
            cargar = 0;
            centenas = 0;
            decenas = 0;
            unidades = 0;
            #20;
            n_reset = 1;
        end
    endtask

    // Simula la entrada de un número de tres dígitos
    task ingresar_numero(input [3:0] c, input [3:0] d, input [3:0] u);
        begin
            // Entrada de centenas, decenas y unidades
            centenas = c; decenas = d; unidades = u;
            cargar = 1; #10;  // Activar la señal de carga
            cargar = 0; #10;  // Desactivar la señal de carga
        end
    endtask

    initial begin
        clk = 0;
        reset();

        // Definir Primer Numero
        ingresar_numero(4'd1, 4'd5, 4'd6);

        // Esperar un ciclo para asegurarnos de que el número se ha guardado
        #20;


        // Definir Segundo Numero
        ingresar_numero(4'd1, 4'd5, 4'd7);

        // Esperar un ciclo para asegurarnos de que el número se ha guardado
        #20;

        $display("Resultado de la suma: %d", numero_guardado);
        // Verificación: Debería ser N1 + N2
        if (numero_guardado == 10'd213) 
            $display("T-SumaCorrecta");
        else
            $display("F-SumaIncorrecta");
        $finish;
    end

endmodule