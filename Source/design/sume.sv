module sume (
    input  logic clk,
    input  logic [3:0] sample,  // Valor del teclado
    output logic [11:0] cdu,         // Resultado de la suma
    output logic [3:0] debug
);

    typedef enum logic [2:0] {S0, S1, S2, S3, S4, S5, S6} statetype;
    statetype state=S0;  // Iniciar directamente en S0

    // Variables internas
    logic [11:0] w1, w2;
    logic [3:0] sample_A, sample_B;
    logic flag;
    assign debug =~state;

    // Registro de sample y detección de cambio
    always_ff @(posedge clk) begin
        sample_A <= sample; // 1 ciclo de retardo
        sample_B <= sample_A; // 2 ciclos de retardo
    end

    assign flag = (sample_A != sample); // Con 2 ciclos no funciona el testbench

    // Máquina de estados
    always_ff @(posedge clk) begin
        if (flag) begin
            case (state)
                S0: w1[11:8] <= sample;
                S1: w1[7:4]  <= sample;
                S2: w1[3:0]  <= sample;
                S3: w2[11:8] <= sample;
                S4: w2[7:4]  <= sample;
                S5: w2[3:0] <= sample;  // Asignar el valor de sample a w2[3:0]
                S6: cdu <= w1 + w2;  // Sumar w1 y w2 y asignar a cdu
            endcase

            // Avanzar al siguiente estado
            case (state)
                S0: state <= S1;
                S1: state <= S2;
                S2: state <= S3;
                S3: state <= S4;
                S4: state <= S5;
                S5: state <= S6;
                S6: state <= S0; 
                default: state <= S0;  // ← Aquí cambiamos a S6 como estado por defecto
            endcase
        end
    end


endmodule
