
//
// module: lut4_rv32_tb
//
//  Testbench for the 32-bit lut4 instruction.
//
module lut4_rv32_tb ();

reg clk     ;
reg resetn  ;

integer ticks;

//
// DUT interface variables.
reg  [31:0] rs1;
reg  [31:0] rs2;
reg         hi ;
wire [31:0] rd_dut;

// Golden reference
wire [31:0] rd_ref;


//
// Clock / reset wavedumping
initial begin
    clk     = 1'b0;
    resetn  = 1'b0;
    ticks   = 0;
    
    $dumpfile(``WAVEFILE);
    $dumpvars(0,lut4_rv32_tb);
end

initial #50 resetn = 1'b1;

always @(clk) #10 clk <= !clk;


//
// Check expected result.
always @(posedge clk) if(resetn) begin

    if(rd_ref !== rd_dut) begin
        $display("RS1=%h, RS2=%h, HI=%d, expect %h, got %h",rs1,rs2,hi,rd_ref,rd_dut);
        $display("ERROR");
        $finish(1);
    end

end

//
// New input stimulus / simulation finish.
always @(posedge clk) begin
    
    rs1 <= $random();
    rs2 <= $random();
    hi  <= $random() & 32'b1;

    ticks = ticks + 1;
    if(ticks >= 100) begin
        $display("PASS");
        $finish(0);
    end
end


lut4_rv32 i_lut_rv32 (
.rs1(rs1    ),
.rs2(rs2    ),
.hi (hi     ),
.rd (rd_dut ) 
);

lut4_rv32_checker i_lut_rv32_checker (
.rs1(rs1    ),
.rs2(rs2    ),
.hi (hi     ),
.rd (rd_ref ) 
);

endmodule
