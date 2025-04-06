`timescale 1ns/1ps

module freq_div(
    input logic clk,   // Señal de reloj de 27 MHz
    output logic a1,   // Salidas de control para el display de 7 segmentos
    output logic a2,
    output logic a3
);

    parameter int frequency = 27_000_000;               // Frecuencia de entrada en Hz
    parameter int freq_out = 500;                      // Frecuencia de salida deseada en Hz
    parameter int max_count = frequency / (2 * freq_out); // Cuenta máxima del contador

    logic [24:0] count;  // Contador con tamaño suficiente
    logic [2:0] segOn;   // Estado de encendido de los segmentos

    // Asignaciones de salida
    assign a1 = segOn[0];
    assign a2 = segOn[1];
    assign a3 = segOn[2];

    // Bloque secuencial
    always_ff @(posedge clk) begin
        if (count == max_count - 1) begin
            // Cambia el estado de los segmentos en secuencia cíclica
            case (segOn)
                3'b100: segOn <= 3'b010;
                3'b010: segOn <= 3'b001;
                3'b001: segOn <= 3'b100;
                default: segOn <= 3'b100;
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
        segOn = 3'b100; // Estado inicial del display
    end

endmodule
