`timescale 1 ns / 1 ns

module lecture (
    input logic clk,
    input logic n_reset,
    input logic [3:0] filas_raw,        // Entradas directas desde las filas del teclado
    output logic [3:0] sample   // Salidas debouneadas
);

    // Salidas del debouncer 
    logic [3:0] filas_db; // Muestreo de filas sin rebote
    logic [3:0] columnas; // Salida de la FSM de columnas

    
    initial begin
        filas_db = 4'b0000;
        sample   = 4'b0000;
    end

    // Instancias del módulo DeBounce para cada fila
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            DeBounce db (
                .clk(clk),
                .n_reset(n_reset),
                .button_in(filas_raw[i]),
                .DB_out(filas_db[i])
            );
        end
    endgenerate


    columnas_fsm fsm (
        .clk(clk),
        .columnas(columnas)
    );

    always @(filas_db) begin
        case({columnas, filas_db})
            8'b1000_1000 : sample = 4'b0001; // columna 0, fila 0 = 1
            8'b0100_1000 : sample = 4'b0010; // columna 1, fila 0 = 2
            8'b0010_1000 : sample = 4'b0100; // columna 2, fila 0 = 3

            8'b1000_0100 : sample = 4'b1000; // columna 0, fila 1 = 4
            8'b0100_0100 : sample = 4'b0001; // columna 1, fila 1 = 5
            8'b0010_0100 : sample = 4'b0010; // columna 2, fila 1 = 6

            8'b1000_0010 : sample = 4'b0100; // columna 0, fila 2 = 7
            8'b0100_0010 : sample = 4'b1000; // columna 1, fila 2 = 8
            8'b0010_0010 : sample = 4'b0001; // columna 2, fila 2 = 9
        endcase
    end
endmodule



module columnas_fsm(
    input logic clk,
    output logic [3:0] columnas
);
    parameter int frequency = 27_000_000;               // Frecuencia de entrada en Hz
    parameter int max_count = frequency * 1/1000000; // Cuenta máxima del contador 

    logic [24:0] count;  // Contador con tamaño suficiente

    // Bloque secuencial
    always_ff @(posedge clk) begin
        if (count == max_count - 1) begin
            // Cambia el estado de los segmentos en secuencia cíclica
            case (columnas)
                4'b1000: columnas <= 4'b0100;
                4'b0100: columnas <= 4'b0010;
                4'b0010: columnas <= 4'b0001;
                4'b0001: columnas <= 4'b1000;
                default: columnas <= 4'b1000;
            endcase
            count <= 0;
        end 
        else begin
            count <= count + 1;
        end
    end

    // Inicialización adecuada en reset
    initial begin
        count = 0;
        columnas = 4'b1000; // Estado inicial del contador
    end


endmodule
