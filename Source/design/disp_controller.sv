<<<<<<< HEAD
`timescale 1ns/1ps

module disp_controller(
    input logic clk,
    output logic [2:0] a
);

    parameter int frequency = 27_000_000;               // Frecuencia de entrada en Hz
    parameter int max_count = frequency * 8/1000; // Cuenta máxima del contador

    logic [24:0] count;  // Contador con tamaño suficiente
   

    // Bloque secuencial
    always_ff @(posedge clk) begin
        if (count == max_count - 1) begin
            // Cambia el estado de los segmentos en secuencia cíclica
            case (a)
                3'b001: a <= 3'b010;
                3'b010: a <= 3'b100;
                3'b100: a <= 3'b001;
                default: a <= 3'b100;
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
        a = 3'b001; // Estado inicial del contador
    end

endmodule
=======
`timescale 1ns/1ps

module disp_controller(
    input logic clk,
    output logic [2:0] a
);

    parameter int frequency = 27_000_000;               // Frecuencia de entrada en Hz
    parameter int max_count = frequency * 8/1000; // Cuenta máxima del contador

    logic [24:0] count;  // Contador con tamaño suficiente
   

    // Bloque secuencial
    always_ff @(posedge clk) begin
        if (count == max_count - 1) begin
            // Cambia el estado de los segmentos en secuencia cíclica
            case (a)
                3'b001: a <= 3'b010;
                3'b010: a <= 3'b100;
                3'b100: a <= 3'b001;
                default: a <= 3'b100;
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
        a = 3'b001; // Estado inicial del contador
    end

endmodule
>>>>>>> bdfb6c7c62bfd17886a7345be005be423d40c3bf
