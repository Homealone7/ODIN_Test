`timescale 1ps/1ps
module tb_lif_neuron_state;
    parameter N = 256;
    parameter M = 8;
    reg [6:0] param_leak_str; // corresponds to leak_str in the golden model
    reg       param_leak_en;  // corresponds to leak_en in the golden model
    reg [7:0] param_thr;      // corresponds to thr in the golden model
    reg [7:0] state_core;
    reg       event_leak;
    reg       event_inh;
    reg       event_exc;
    reg [2:0] syn_weight;     // a 3-bit synaptic weight for simplicity
    wire [7:0] state_core_next;
    wire [6:0] event_out;

    integer file_descriptor;

neuron_core #(
        .N(N),
        .M(M)
    ) neuron_core_0 (
    
        // Global inputs ------------------------------------------
        .RSTN_syncn(RSTN_syncn),
        .CLK(CLK),
        
        // Inputs from SPI configuration registers ----------------
        .SPI_GATE_ACTIVITY_sync(SPI_GATE_ACTIVITY_sync),
        .SPI_PROPAGATE_UNMAPPED_SYN(SPI_PROPAGATE_UNMAPPED_SYN),
		
        // Synaptic inputs ----------------------------------------
        .SYNARRAY_RDATA(SYNARRAY_RDATA),
        .SYN_SIGN(SYN_SIGN),
        
        // Inputs from controller ---------------------------------
        .CTRL_NEUR_EVENT(CTRL_NEUR_EVENT),
        .CTRL_NEUR_TREF(CTRL_NEUR_TREF),
        .CTRL_NEUR_VIRTS(CTRL_NEUR_VIRTS),
        .CTRL_NEURMEM_WE(CTRL_NEURMEM_WE),
        .CTRL_NEURMEM_ADDR(CTRL_NEURMEM_ADDR),
        .CTRL_NEURMEM_CS(CTRL_NEURMEM_CS),
        .CTRL_PROG_DATA(CTRL_PROG_DATA),
        .CTRL_SPI_ADDR(CTRL_SPI_ADDR),
        
        // Inputs from scheduler ----------------------------------
        .CTRL_NEUR_BURST_END(CTRL_NEUR_BURST_END), 
        
        // Outputs ------------------------------------------------
        .NEUR_STATE(NEUR_STATE),
        .NEUR_EVENT_OUT(NEUR_EVENT_OUT),
        .NEUR_V_UP(NEUR_V_UP),
        .NEUR_V_DOWN(NEUR_V_DOWN),
        .NEUR_STATE_MONITOR(NEUR_STATE_MONITOR)
    );

    initial begin
        // Open the file for writing
        file_descriptor = $fopen("neuron_output.csv", "w");
        if (file_descriptor == 0) $fatal("Error opening file for writing.");

        // Write the CSV header
        $fwrite(file_descriptor, "Time,State Core\n");

        // Initialize parameters to match the golden model
        param_leak_str = 7'd5;    // leakage strength set to 5
        param_leak_en  = 1'b1;    // Enable leakage
        param_thr      = 8'd100;  // Firing threshold set to 100
        state_core     = 8'd0;    // Initial membrane potential

        // Start the test
        event_leak = 0;
        event_inh = 0;
        event_exc = 0;
        syn_weight = 3'd4;  // Set an arbitrary synaptic weight for testing
        $fwrite(file_descriptor, "%0d,%0d\n", $time, state_core_next);
        #10
        event_exc = 1;  // Trigger excitatory event
        $fwrite(file_descriptor, "%0d,%0d\n", $time, state_core_next);
        #10
        event_exc = 0;
        $fwrite(file_descriptor, "%0d,%0d\n", $time, state_core_next);

        #10
        event_exc = 1;  // Trigger inhibitory event
        $fwrite(file_descriptor, "%0d,%0d\n", $time, state_core_next);
        #10
        event_inh = 1;
        $fwrite(file_descriptor, "%0d,%0d\n", $time, state_core_next);

        #10
        event_leak = 1;  // Trigger leakage event
        $fwrite(file_descriptor, "%0d,%0d\n", $time, state_core_next);
        #10
        event_leak = 0;
        $fwrite(file_descriptor, "%0d,%0d\n", $time, state_core_next);

        #10
        $fwrite(file_descriptor, "%0d,%0d\n", $time, state_core_next);

        #10
        $fclose(file_descriptor);  // Close the file
        $stop;  // End the simulation
    end

endmodule