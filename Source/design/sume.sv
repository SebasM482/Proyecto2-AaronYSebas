module fsm (
    input  logic clk, 
    input  logic reset,
    input  logic [3:0] sample,
    output logic [3:0] w1
);

    typedef enum logic [2:0] {S0, S1, S2, S3, S4, S5, S6, S7} statetype;
    statetype state, nextstate;

    logic [3:0] prev_sample;  // Stores the previous sample
    logic       sample_changed;
    logic [7:0] sum;

    // Detect when sample changes
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            prev_sample <= sample;
            sample_changed <= 0;
            sum <= 8'd0;
        end else begin
            sample_changed <= (sample != prev_sample);
            prev_sample <= sample;
        end
    end

    // State transition logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else if (sample_changed) begin
            // Cycle through states in order
            case (state)
                S0: begin
                    state <= S1;
                    sum <= sum + 1;
                end
                S1: begin
                    state <= S2;
                end
                S2: begin
                    state <= S3;
                end
                S3: begin
                    state <= S4;
                end
                S4: begin
                    state <= S5;
                end
                S5: begin
                    state <= S6;
                end 
                S6: begin
                    state <= S7;
                end
                S7: begin
                    state <= S0;
                end
                default: state <= S0;
            endcase
        end
    end


endmodule