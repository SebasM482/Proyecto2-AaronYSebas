module sum (
    input  logic clk,
    input  logic n_reset,
    input  logic [3:0] centenas,
    input  logic [3:0] decenas,
    input  logic [3:0] unidades,
    input  logic cargar,                // Señal para guardar el número
    output logic [9:0] numero_guardado  // Número almacenado
);

    always_ff @(posedge clk or negedge n_reset) begin
        if (!n_reset) begin
            numero_guardado <= 10'd0;
        end else if (cargar) begin
            numero_guardado <= numero_guardado + (centenas * 100) + (decenas * 10) + unidades;
        end
    end

endmodule