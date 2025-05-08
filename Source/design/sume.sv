module sume (
    input  logic clk,
    input  logic n_reset,
    input  logic [3:0] sample,  // Este es el valor del teclado
    output logic [11:0] cdu           // Resultado de la suma
);

    typedef enum logic [2:0] {S0, S1, S2, S3, S4, S5, S6} statetype;
    statetype state, nextstate;

    // Variables internas
    logic [11:0] w1, w2;
    logic [3:0] sample_prev;
    logic sample_changed;

    // Detectar cambio en sample
    assign sample_changed = (sample != sample_prev) && (sample != 4'b1111);

    // Lógica secuencial
    always_ff @(posedge clk or negedge n_reset) begin
        if (!n_reset) begin
            // Inicialización en caso de reset
            cdu   <= 12'd0;
            w1    <= 12'd0;
            w2    <= 12'd0;
            state <= S0;
            sample_prev <= 4'b1111;
        end else begin
            // Actualizamos sample_prev con el valor de sample
            sample_prev <= sample;
            if (sample_changed) begin
                case (state)
                    S0: w1[11:8] <= sample;  // Centena del primer número
                    S1: w1[7:4]  <= sample;  // Decena
                    S2: w1[3:0]  <= sample;  // Unidad
                    S3: w2[11:8] <= sample;  // Centena del segundo número
                    S4: w2[7:4]  <= sample;  // Decena
                    S5: w2[3:0]  <= sample;  // Unidad
                    S6: cdu      <= w1 + w2; // Suma
                endcase
                state <= nextstate;
            end
        end
    end

    // Lógica del siguiente estado
    always_ff @(posedge clk or negedge n_reset) begin
        if (!n_reset) begin
            nextstate <= S0;  // Inicialización del siguiente estado
        end else begin
            case (state)
                S0: nextstate = S1;
                S1: nextstate = S2;
                S2: nextstate = S3;
                S3: nextstate = S4;
                S4: nextstate = S5;
                S5: nextstate = S6;
                S6: nextstate = S0;
                default: nextstate = S0;
            endcase
        end
    end

endmodule
