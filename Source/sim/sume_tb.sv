module sume_tb;

    // Inputs
    logic clk;
    logic n_reset;
    logic [3:0] sample;

    // Outputs
    logic [11:0] cdu;

    // Instantiate the Unit Under Test (UUT)
    sume uut (
        .clk(clk),
        .n_reset(n_reset),
        .sample(sample),
        .cdu(cdu)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // Toggle clock every 5 time units
    end

    // Stimulus block
    initial begin
        // Initialize signals
        clk = 0;
        n_reset = 0;     // Reset the design initially
        sample = 4'b1111; // No sample initially

        // Apply reset
        #10 n_reset = 1; // Release reset after 10 time units

        // Start sending values to `sample`
        #10 sample = 4'b0101; // First input for w1[11:8]
        #10 sample = 4'b0011; // First input for w1[7:4]
        #10 sample = 4'b0100; // First input for w1[3:0]
        #10 sample = 4'b1001; // Second input for w2[11:8]
        #10 sample = 4'b0110; // Second input for w2[7:4]
        #10 sample = 4'b0001; // Second input for w2[3:0]
        
        // Finish the simulation after a few more cycles
        #10 $finish;
    end

    // Monitor output for debugging
    initial begin
        $monitor("At time %t, sample = %b, cdu = %b", $time, sample, cdu);
    end

endmodule
