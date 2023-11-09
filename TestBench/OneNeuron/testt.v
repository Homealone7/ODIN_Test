module testt;
reg [2:0] syn_sign_dummy;
reg SYN_SIGN;
reg [3:0] SPI_SYN_SIGN;
  initial 
    begin
        syn_sign_dummy = 0;
        SYN_SIGN = 0;
        SPI_SYN_SIGN = 4'b 1010;
      {syn_sign_dummy,SYN_SIGN} = SPI_SYN_SIGN >> 4'd3;
      $display("syn_sign_dummy = %b, SYN_SIGN = %b", syn_sign_dummy, SPI_SYN_SIGN);
      $stop ;
    end
endmodule