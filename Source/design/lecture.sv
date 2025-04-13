`timescale 1 ns / 1 ns

module lecture (
    input logic clk,
    input logic n_reset,
    input logic [3:0] filas_raw,        // Entradas directas desde las filas del teclado
    output logic [3:0] columnas,
    output logic [3:0] sample           // Salidas debouneadas
);

    // Salidas del debouncer 
    logic [3:0] filas_db; // Muestreo de filas sin rebote
    logic [3:0] columna_presionada0; //4 columna_presionada para un trucazo mistico
    logic [3:0] columna_presionada1;
    logic [3:0] columna_presionada2;
    logic [3:0] columna_presionada3;
    logic [3:0] columna_presionada_total;
    logic [3:0] key_pressed; // Salida del teclado (4 bits)


    columnas_fsm fsm (
        .clk(clk),
        .columnas(columnas)
    );


    DeBounce db0 (
        .clk(clk),
        .n_reset(n_reset),
        .button_in(filas_raw[0]),
        .columnas(columnas),
        .DB_out(filas_db[0]),
        .columna_presionada(columna_presionada0)
    );

    DeBounce db1 (
        .clk(clk),
        .n_reset(n_reset),
        .button_in(filas_raw[1]),
        .columnas(columnas),
        .DB_out(filas_db[1]),
        .columna_presionada(columna_presionada1)
    );

    DeBounce db3 (
        .clk(clk),
        .n_reset(n_reset),
        .button_in(filas_raw[2]),
        .columnas(columnas),
        .DB_out(filas_db[2]),
        .columna_presionada(columna_presionada2)
    );

    DeBounce db (
        .clk(clk),
        .n_reset(n_reset),
        .button_in(filas_raw[3]),
        .columnas(columnas),
        .DB_out(filas_db[3]),
        .columna_presionada(columna_presionada3)
    );
















 
    assign columna_presionada_total = columna_presionada0 | columna_presionada1 | columna_presionada2 | columna_presionada3;

    always @(filas_db) begin
        case({columna_presionada_total, filas_db})
            8'b1000_1000 : key_pressed = 4'b0001; // columna 0, fila 0 = 1
            8'b0100_1000 : key_pressed = 4'b0010; // columna 1, fila 0 = 2
            8'b0010_1000 : key_pressed = 4'b0011; // columna 2, fila 0 = 3
            8'b0001_1000 : key_pressed = 4'b1010; // columna 3, fila 0 = 10 A

            8'b1000_0100 : key_pressed = 4'b0100; // columna 0, fila 1 = 4
            8'b0100_0100 : key_pressed = 4'b0101; // columna 1, fila 1 = 5
            8'b0010_0100 : key_pressed = 4'b0110; // columna 2, fila 1 = 6
            8'b0001_0100 : key_pressed = 4'b1011; // columna 3, fila 1 = 11 B

            8'b1000_0010 : key_pressed = 4'b0111; // columna 0, fila 2 = 7
            8'b0100_0010 : key_pressed = 4'b1000; // columna 1, fila 2 = 8
            8'b0010_0010 : key_pressed = 4'b1001; // columna 2, fila 2 = 9
            8'b0001_0010 : key_pressed = 4'b1100; // columna 3, fila 2 = 12 C

            8'b1000_0001 : key_pressed = 4'b1101; // columna 0, fila 3 = 13 * D
            8'b0100_0001 : key_pressed = 4'b0000; // columna 1, fila 3 = 0
            8'b0010_0001 : key_pressed = 4'b1110; // columna 2, fila 3 = # 14 E
            //8'b0001_0001 : key_pressed = 4'b1111; // columna 3, fila 3 = 15 F (Tecla D)
            default: key_pressed = 4'b1111; // Si no hay coincidencia, salida por defecto

        endcase
    end


    always @(key_pressed) begin
        if (key_pressed !== 4'b1111) begin
            sample <= key_pressed; // Asignar el valor de key_pressed a sample
        end
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