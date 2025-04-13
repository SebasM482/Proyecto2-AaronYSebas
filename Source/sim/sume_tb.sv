`timescale 1ns/1ps

module fsm_tb;

    // Testbench signals
    logic clk;
    logic reset;
    logic [3:0] sample;
    logic [3:0] w;

    // Instantiate the DUT (Device Under Test)
    fsm dut (
        .clk(clk),
        .reset(reset),
        .sample(sample),
        .w(w)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    // Task to change sample and wait
    task change_sample(input [3:0] new_val);
        begin
            sample = new_val;
            #10;  // wait one clock cycle
        end
    endtask

    // Test sequence
    initial begin
        // Initialize
        clk = 0;
        reset = 1;
        sample = 4'b0000;
        #12;  // wait for reset to take effect

        reset = 0;

        // Stimulate with sample changes
        change_sample(4'b0001);  // change sample to 1
        change_sample(4'b0010);  // change sample to 2
        change_sample(4'b0011);  // change sample to 3
        change_sample(4'b0100);  // change sample to 4
        change_sample(4'b0101);  // change sample to 5
        change_sample(4'b0110);  // change sample to 6
        change_sample(4'b0111);  // change sample to 7
        change_sample(4'b1000);  // change sample to 8
        change_sample(4'b1001);  // change sample to 9
        change_sample(4'b1010);  // change sample to 10

        // Wait for a few clock cycles after the last change
        #20;

        // End the simulation
        $finish;
    end

    // Monitor signals (Display changes on console)
    initial begin
        $display("Time\tclk\treset\tsample\tw");
        $monitor("%0t\t%b\t%b\t%04b\t%04b", $time, clk, reset, sample, w);
    end

endmodule