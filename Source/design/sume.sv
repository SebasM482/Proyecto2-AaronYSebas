module sume (
    input  logic clk, //Para encender
    input  logic n_reset, //Reseteo
    input  logic [3:0] sample, //Numero recibido
    output logic [11:0] sum //Suma de los numeros
);

    typedef enum logic [2:0] {S0, S1, S2, S3, S4, S5, S6} statetype;
    statetype state, nextstate;

    logic [11:0] w1;
    logic [11:0] w2;
    logic reset = !n_reset;
    // Detect when sample changes
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        sum <= 12'd0;
        w1 <= 12'd0;
        w2 <= 12'd0;
    end 
    else begin
        case (state)
            S0: sum <= w1 + w2;
            S1: w1[11:8] <= sample;
            S2: w1[7:4]  <= sample;
            S3: w1[3:0]  <= sample;
            S4: w2[11:8] <= sample;
            S5: w2[7:4]  <= sample;
            S6: w2[3:0]  <= sample;
            default: ;
        endcase
    end
end

    // State transition logic
always_comb begin
        case (state)
            S0: begin
                state = S1;
                sum = w1 + w2;
            end
            S1: begin
                state = S2;
                w1[11:8] = sample;
            end
            S2: begin
                state = S3;
                w1[7:4] = sample;                    
            end
            S3: begin
                state = S4;
                w1[3:0] = sample;
            end
            S4: begin
                state = S5;
                w2[11:8] = sample;
            end
            S5: begin
                state = S6;
                w2[7:4] = sample;
            end 
            S6: begin
                state = S0;
                w2[3:0] = sample;
            end
            default: state = S0;
        endcase
end
endmodule