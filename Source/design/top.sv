`timescale 1ns/1ps

module top(
    //input logic module_inputs //Recibe los valores de los Pins
    input logic clk,
    input logic [3:0] filas_raw, // Entradas directas desde las filas del teclado
    output logic [6:0] d,  // Segmentos
    output logic [2:0] a, // Control de los segmentos
    output logic [3:0] columnas, // Salida de la FSM de columnas 
    output logic [3:0] columna_presionada_total   
    );      

    logic [3:0] leds;
    assign columna_presionada_total = ~leds;
    ////////////////////////////
    // Entradas
    reg n_reset;
    initial begin
        n_reset <= 1'b1;
    end



    // Instaciamiento de los modulos
    disp_dec decoder (.w(sample), .d(d));
    disp_controller controller (.clk(clk), .a(a));
    lecture lect (
        .clk(clk),
        .n_reset(n_reset),
        .filas_raw(filas_raw),
        .columnas(columnas),
        .sample(sample),
        .key_pressed(leds) // Esta señal es para de bugear
    );
    ////////////////////////////

endmodule