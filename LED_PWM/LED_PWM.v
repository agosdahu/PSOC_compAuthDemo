
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
// Generated on 07/10/2018 at 09:06
// Component: LED_PWM
module LED_PWM (
	output [7:0] cnt,
	output reg  drive,
	input   clock,
	input   enable,
	input   reset
);
	parameter duty = 7;
	parameter period = 16;

//`#start body` -- edit after this line, do not edit this line

// don't forget to make drive reg!!!!

wire clk;

cy_psoc3_udb_clock_enable_v1_0 #(.sync_mode(`TRUE)) MyCompClockSpec (
    .enable(enable),      /*EN from interconnect*/
    .clock_in(clock),    /*clk from interconnect*/
    .clock_out(clk)    /*clk to interconnect*/
);

/********************7-bit Counter******************************/
wire [6:0] myCnt;
wire load;
cy_psoc3_count7 #(.cy_period(period), .cy_route_ld(`FALSE), .cy_route_en(`FALSE))
Counter7 (
/* input */ .clock (clk), // Clock
/* input */ .reset(reset), // Reset
/* input */ .load(load), // Load signal used if cy_route_ld = TRUE
/* input */ .enable(enable), // Enable signal used if cy_route_en = TRUE
/* output [6:0] */ .count(myCnt), // Counter value output
/* output */ .tc(load) // Terminal Count output
);


/********************Control REG*******************************/
wire [7:0] myCREG;

cy_psoc3_control #(.cy_init_value (8'b00000000), .cy_force_order(`TRUE))
ControlReg(
/* output [07:00] */ .control(myCREG)
);

/********************Status REG********************************/
reg [7:0] mySREG;

always @ (posedge clk)
    if(reset)
        mySREG <= 8'd0;
    else
        mySREG <= {drive, myCnt};

cy_psoc3_status #(.cy_force_order(`TRUE), .cy_md_select(8'b00000000)) StatusReg (
/* input [07:00] */ .status(mySREG), // Status Bits
/* input */ .reset(reset), // Reset from interconnect
/* input */ .clock(clk) // Clock used for registering data
);

reg myDrive;

always @ (posedge clk)
if(myCnt <= duty)
    begin
        myDrive <= 'b0;
    end
else
    begin
        myDrive <= 'b1;
    end
    
    
assign drive = (|myCREG) ? 1'b0 : myDrive;
assign cnt[7:0] = {drive, myCnt};


//`#end` -- edit above this line, do not edit this line
endmodule
//`#start footer` -- edit after this line, do not edit this line
//`#end` -- edit above this line, do not edit this line
