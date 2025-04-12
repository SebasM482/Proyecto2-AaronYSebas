module ohsm (
    input wire clk,
    input wire reset,
    input wire start,
    output reg [3:0] SGlobal //Output del one hot
);

    
    typedef enum reg [3:0] { //One-hot y su estado respectivo
        S1 = 4'b1000,
        S2 = 4'b0100,
        S3 = 4'b0010, 
        S4 = 4'b0001
    } state_t;

    state_t state, next_state;

    
    always @(posedge clk or posedge reset) begin //Estado 1 
        if (reset)
            state <= S1;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        // Default to current state
        next_state = state;

        case (state)
            S1: begin //Iniciar en 1
                if (start)
                next_state = S2;

            end
            S2: begin //Iniciar 2
                next_state = S3;

            end
            S3: begin //Iniciar 3
                next_state = S4;

            end
            S4: begin //Inicar 4
                next_state = S1;

            end
            default: next_state = S1; //Inicializar en S1
        endcase
    end


    always @(*) begin //Output
        SGlobal = state; //SGlobal adquiere el valor del state
    end

endmodule