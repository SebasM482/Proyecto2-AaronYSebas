`timescale 1ns/1ps

module top(
    input logic clk,
    input logic [3:0] filas_raw, // Entradas directas desde las filas del teclado
    output logic [6:0] d,  // Segmentos
    output logic [4:0] a, // Control de los segmentos
    output logic [3:0] columnas, // Salida de la FSM de columnas 
    output logic [3:0] led  // Senal de debug
    );      

    logic [3:0] w;
    logic [3:0] sample; // Salidas debouneadas
    logic [15:0] cdu;
    reg n_reset = 1;


    // Instaciamiento de los modulos
    disp_dec decoder (.w(w), .d(d));
    disp_controller controller (.clk(clk), .a(a));
    mux mux (.a(a), .cdu(cdu), .w(w));
 
    sume suma (
    .clk(clk),              
    .sample(sample),       
    .cdu(cdu),
    .debug(led)              
    );

    lecture lect (
        .clk(clk),
        .n_reset(n_reset),
        .filas_raw(filas_raw),
        .columnas(columnas),
        .sample(sample)
    );

endmodule