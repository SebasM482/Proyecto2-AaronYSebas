module ohsm_tb;

    // Variables de entrada
    reg clk;
    reg reset;
    reg start;

    // Variables de salida

    wire [3:0] SGlobal;

    // Instancia del módulo 'ohsm'
    ohsm uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .SGlobal(SGlobal)
    );

    // Generación del reloj (clk)
    always begin
        #5 clk = ~clk; // Reloj con un ciclo de 10 unidades de tiempo (5 para 'high' y 5 para 'low')
    end

    // Procedimiento de inicialización
    initial begin
        // Inicialización de señales
        clk = 0;
        reset = 0;
        start = 0;

        // Secuencia de pruebas
        $display("Iniciando simulacion...");
        
        // Reseteo del sistema
        reset = 1;
        #10; // Esperamos 10 unidades de tiempo para asegurarnos de que el reset se haya activado
        reset = 0;
        #10;

        // Activamos 'start' para ver la transición de estados
        start = 1;
        #10; // Esperamos 10 unidades de tiempo
        start = 0;
        #10;

        // Ciclo de prueba para ver cada uno de los estados
        #10;
        start = 1; // Inicia la transición al siguiente estado
        #10;
        start = 0;

        #10; // Estado S2
        start = 1;
        #10;
        start = 0;

        #10; // Estado S3
        start = 1;
        #10;
        start = 0;

        #10; // Estado S4
        start = 1;
        #10;
        start = 0;

        // Fin de la simulación
        $stop;
    end

    // Monitorización de valores
    initial begin
        $monitor("Tiempo: %t | SGlobal: %b", $time, SGlobal);
    end

endmodule