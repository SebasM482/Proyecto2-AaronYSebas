`timescale 1ns/1ps
// Este modulo es un divisor de frecuencia, el cual implenta un contador para determinar los momentos en los 
// en los que se debe conmutar la señal para que dicha señal sea de la frecuencia que se desea



module freq_div(
    input logic clk,       // Signal de reloj interno 27 MHz
    output logic clk_out,  // Signal de frecuencia deseada
    output logic x,        // Signal de control de bjt x
    output logic y);       // Signal de control de bjt y

    parameter frequency = 27_000_000;                   // Frecuencia de entrada (27 MHz)
    parameter freq_out = 500;                         // Frecuencia de salida ajustable
    parameter max_count = frequency / (2 * freq_out);   // La cuenta maxima del contador

    logic [24:0] count;  // Tamaño suficiente para almacenar max_count

    // Inicialización de los valores iniciales
    initial begin
        count = 0;
        clk_out = 0;
        x=0;
        y=1;
    end

    // Lógica para contar y generar clk_out
    always @(posedge clk) begin    // posedge clk -> flancos de subida de clk
        if (count == max_count - 1) begin
            // Se conmutan las señales de salida
            clk_out <= ~clk_out;
            x <= ~x;             
            y <= ~y;
            count <= 0;
        end 
        else begin
            count <= count + 1;
        end
    end
endmodule
