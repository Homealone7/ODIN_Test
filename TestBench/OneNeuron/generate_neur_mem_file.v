module generate_neur_mem_file();

  integer i;
  integer file;
  reg [127:0] random_value;
    integer random;
  initial begin
    // Open a file to write
    file = $fopen("Neur_Mem.txt", "w");

    // Seed the random number generator
    // `random` is a dummy variable to avoid the same sequence of random numbers
    // every time the simulation is run if the `$random` function is used.
    
    random = $random;

    // Generate random values and write to file
    for (i = 0; i < 256; i = i + 1) begin
      random_value = $random;
      $fdisplay(file, "%b", random_value);
    end

    // Close the file
    $fclose(file);
  end

endmodule
