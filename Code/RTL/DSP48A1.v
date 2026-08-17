module DSP48A1 #(
parameter A0REG = 0,
parameter A1REG = 1,
parameter B0REG = 0,
parameter B1REG = 1,
parameter CREG = 1,
parameter DREG = 1,
parameter MREG = 1,
parameter PREG = 1,
parameter CARRYINREG = 1,
parameter CARRYOUTREG = 1,
parameter OPMODEREG = 1,
parameter CARRYINSEL = "OPMODE5",
parameter B_INPUT = "DIRECT",
parameter RSTTYPE = "SYNC"
)(
input [17:0] A,
input [17:0] B,
input [47:0] C,
input [17:0] D,
input CARRYIN,
input CLK,
input [7:0]OPMODE,
input CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP,
input RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP,
input [47:0] PCIN,
input [17:0] BCIN,
output [17:0] BCOUT,
output [47:0] PCOUT,
output [35:0] M,
output [47:0] P,
output CARRYOUT,
output CARRYOUTF
);
//internal signals
wire [17:0] A0_reg;
wire [17:0] A1_reg;
wire [17:0] B0_reg;
wire [17:0] B1_reg;
wire [47:0] C_reg;
wire [17:0] D_reg;
wire [35:0] M_reg;
wire CYI_reg;
wire CYI;
wire CIN;
wire [7:0] OPMODE_reg;
wire [17:0] B0_pre;
wire [17:0] B1_pre;
wire [17:0] pre_out;
wire [35:0] M_pre;
reg [47:0] X_out;
reg [47:0] Z_out;
wire [47:0] P_pre;
wire [48:0] P_alu;
//pre_adder/subtracter
register #(.XREG(OPMODEREG),.WIDTH(8),.RSTTYPE(RSTTYPE)) OPMODE_reg_inst(.X(OPMODE),.clk(CLK),.CEX(CEOPMODE),.RSTX(RSTOPMODE),.XOUT(OPMODE_reg));
generate 
    if(B_INPUT == "DIRECT")begin
        assign B0_pre = B ;
    end
    else if(B_INPUT == "CASCADE")begin
        assign B0_pre = BCIN ;
    end
    else begin
        assign B0_pre = 18'b0 ;
    end
endgenerate
register #(.XREG(B0REG),.WIDTH(18),.RSTTYPE(RSTTYPE)) B0_reg_inst(.X(B0_pre),.clk(CLK),.CEX(CEB),.RSTX(RSTB),.XOUT(B0_reg));
register #(.XREG(DREG),.WIDTH(18),.RSTTYPE(RSTTYPE)) D_reg_inst(.X(D),.clk(CLK),.CEX(CED),.RSTX(RSTD),.XOUT(D_reg));
assign pre_out = (OPMODE_reg[6]) ? D_reg - B0_reg : B0_reg + D_reg ;
assign B1_pre = (OPMODE_reg[4]) ? pre_out : B0_reg;
//multiplier
register #(.XREG(B1REG),.WIDTH(18),.RSTTYPE(RSTTYPE)) B1_reg_inst(.X(B1_pre),.clk(CLK),.CEX(CEB),.RSTX(RSTB),.XOUT(B1_reg));
assign BCOUT = B1_reg;
register #(.XREG(A0REG),.WIDTH(18),.RSTTYPE(RSTTYPE)) A0_reg_inst(.X(A),.clk(CLK),.CEX(CEA),.RSTX(RSTA),.XOUT(A0_reg));
register #(.XREG(A1REG),.WIDTH(18),.RSTTYPE(RSTTYPE)) A1_reg_inst(.X(A0_reg),.clk(CLK),.CEX(CEA),.RSTX(RSTA),.XOUT(A1_reg));
assign M_pre = A1_reg * B1_reg;
register #(.XREG(CREG),.WIDTH(48),.RSTTYPE(RSTTYPE)) C_reg_inst(.X(C),.clk(CLK),.CEX(CEC),.RSTX(RSTC),.XOUT(C_reg));

register #(.XREG(MREG),.WIDTH(36),.RSTTYPE(RSTTYPE)) M_reg_inst(.X(M_pre),.clk(CLK),.CEX(CEM),.RSTX(RSTM),.XOUT(M_reg));
assign M = M_reg;
always@(*)begin
    case(OPMODE_reg[1:0])
    2'b00: X_out = 48'b0 ;
    2'b01: X_out = M_reg ;
    2'b10: X_out = PCOUT ;
    2'b11: X_out = {D_reg[11:0],A1_reg[17:0],B1_reg[17:0]} ;
    endcase
end
generate 
    if(CARRYINSEL == "OPMODE5")begin
        assign CYI =  OPMODE_reg[5] ; 
    end
    else if(CARRYINSEL == "CARRYIN")begin
        assign CYI =  CARRYIN ;
    end
    else begin
        assign CYI =  1'b0 ;
    end
endgenerate
register #(.XREG(CARRYINREG),.WIDTH(1),.RSTTYPE(RSTTYPE)) CARRYIN_reg_inst(.X(CYI),.clk(CLK),.CEX(CECARRYIN),.RSTX(RSTCARRYIN),.XOUT(CYI_reg));
assign CIN =CYI_reg ;
register #(.XREG(CARRYOUTREG),.WIDTH(1),.RSTTYPE(RSTTYPE)) CARRYOUT_reg_inst(.X(P_alu[48]),.clk(CLK),.CEX(CECARRYIN),.RSTX(RSTCARRYIN),.XOUT(CARRYOUT));
assign CARRYOUTF = CARRYOUT;
always@(*)begin
    case(OPMODE_reg[3:2])
    2'b00: Z_out = 48'b0 ;
    2'b01: Z_out = PCIN ;
    2'b10: Z_out = PCOUT ;
    2'b11: Z_out = C_reg ;
    endcase
end
//post_adder/subtracter
assign P_alu = (OPMODE_reg[7]) ? (Z_out - (X_out + CIN)) : (X_out + Z_out + CIN)  ;
assign P_pre = P_alu[47:0];
register #(.XREG(PREG),.WIDTH(48),.RSTTYPE(RSTTYPE)) P_reg_inst(.X(P_pre),.clk(CLK),.CEX(CEP),.RSTX(RSTP),.XOUT(P));
assign PCOUT = P;
endmodule