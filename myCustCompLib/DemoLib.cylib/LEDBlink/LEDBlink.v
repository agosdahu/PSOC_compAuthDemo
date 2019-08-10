
//`#start header` -- edit after this line, do not edit this line
// ========================================
//
// Copyright YOUR COMPANY, THE YEAR
// All Rights Reserved
// UNPUBLISHED, LICENSED SOFTWARE.
//
// CONFIDENTIAL AND PROPRIETARY INFORMATION
// WHICH IS THE PROPERTY OF your company.
//
// ========================================
`include "cypress.v"
//`#end` -- edit above this line, do not edit this line
// Generated on 08/10/2019 at 10:28
// Component: LEDBlink
module LEDBlink (
	output [7:0] Cnt,
	output  reg DriveOut,
	input   Clock,
	input   Enable,
	input   Reset
);
	parameter cmp = 49;
	parameter period = 99;

//`#start body` -- edit after this line, do not edit this line
/******************************************************************************************************************/

/************************************** UDB Clock Sync ************************************************************/
wire clk;

cy_psoc3_udb_clock_enable_v1_0 #(.sync_mode(`TRUE)) MyCompClockSpec (
    .enable(Enable),        /*EN from interconnect*/
    .clock_in(Clock),       /*clk from interconnect*/
    .clock_out(clk)         /*clk to interconnect*/
);

/************************************** 7-bit counter *************************************************************/
wire [6:0] myCnt;
wire load;

cy_psoc3_count7 #(.cy_period(period), .cy_route_ld(`FALSE), .cy_route_en(`FALSE))
Counter7 (
/* input */         .clock (clk),       // Clock
/* input */         .reset(Reset),      // Reset
/* input */         .load(load),        // Load signal used if cy_route_ld = TRUE
/* input */         .enable(Enable),    // Enable signal used if cy_route_en = TRUE
/* output [6:0] */  .count(myCnt),      // Counter value output
/* output */        .tc(load)           // Terminal Count output
);

/************************************** Control REG ***************************************************************/
/* [LR][COMP 6:0] */
wire [7:0] myCREG;

cy_psoc3_control #(.cy_init_value (8'b00000000), .cy_force_order(`TRUE))
ControlReg(
/* output [07:00] */ .control(myCREG)
);

/************************************** Control logic *************************************************************/
localparam LR_ALIGN = 8'b1000_0000;     // 0 = Left aligned, 1 = Right aligned

wire [6:0] compare;
assign compare = ( !(|myCREG[6:0]) ) ? cmp : (myCREG[6:0] >= period) ? (period - 4) : myCREG[6:0];

/************************************** Status logic **************************************************************/
reg [7:0] tcCount;

always @ (posedge clk)
    if(Reset)
        tcCount <= 8'b0;
    else
        begin
            if(load)
                tcCount <= tcCount + 1;
            else
                tcCount <= tcCount;
        end

/************************************** Status REG ****************************************************************/
/* [tcCount 7:0] */
reg [7:0] mySREG;

always @ (posedge clk)
    if(Reset)
        mySREG <= 8'b0;
    else
        mySREG <= tcCount;

cy_psoc3_status #(.cy_force_order(`TRUE), .cy_md_select(8'b00000000)) StatusReg (
/* input [07:00] */ .status(mySREG),    // Status Bits
/* input */         .reset(Reset),      // Reset from interconnect
/* input */         .clock(clk)         // Clock used for registering data
);

/************************************** Blink logic ***************************************************************/
reg myDrive;

always @ (posedge clk)
if(myCnt <= compare)
    begin
        myDrive <= 'b1;
    end
else
    begin
        myDrive <= 'b0;
    end
    
/************************************** Output logic **************************************************************/  
always @ (posedge clk)
if(Reset)
    DriveOut <= 'b0;
else
    begin
        if(myCREG & LR_ALIGN)
            DriveOut <= myDrive;
        else
            DriveOut <= ~myDrive;
    end

assign Cnt      = {0, myCnt};

//`#end` -- edit above this line, do not edit this line
endmodule
//`#start footer` -- edit after this line, do not edit this line
//`#end` -- edit above this line, do not edit this line
