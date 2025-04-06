module bin_bcd (
    input logic [9:0] bin,         // Entrada binaria de 10 bits (máximo 1023)
    output logic [11:0] bcd    // Salida BCD (4 dígitos decimales, por si acaso)
);
    integer i;

    always @(bin) begin
        bcd = 0;  // Inicializa BCD a 0

        for (i = 0; i < 10; i = i + 1) begin
            // Verifica si algún dígito BCD necesita corrección
            if (bcd[3:0] >= 5)     bcd[3:0]   = bcd[3:0] + 3;
            if (bcd[7:4] >= 5)     bcd[7:4]   = bcd[7:4] + 3;
            if (bcd[11:8] >= 5)    bcd[11:8]  = bcd[11:8] + 3;

            // Shift e inserta el siguiente bit del binario
            bcd = {bcd[11:0], bin[9 - i]};
        end
    end
endmodule