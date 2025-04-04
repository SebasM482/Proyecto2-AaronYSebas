`timescale 1ps/1ps

module freq_div_tb;

    // Declaración de señales
    logic clk;           // Reloj de entrada
    logic clk_out;      // Reloj de salida del divisor de frecuencia

    // Instancia del módulo bajo prueba (DUT)
    freq_div uut (.clk(clk), .clk_out(clk_out));

    // Generador de reloj (frecuencia de 27 MHz)
    always begin
        #18.5 clk = ~clk;  // T = 1 / 27 MHz => periodo = 37ns, cada mitad del periodo 18.5ns
    end

    // Procedimiento de inicialización
    initial begin
        // Inicialización de señales
        clk = 0;

        // Monitorear el comportamiento de la salida
        $monitor("Time: %t, clk_out: %b", $time, clk_out);

        // Correr la simulación por 3 ms (aproximadamente)
        #3000000;
        $finish;
    end

    // Generación del archivo VCD
    initial begin
        $dumpfile("freq_div_tb.vcd");
        $dumpvars(0, freq_div_tb);
    end
endmodule
