module DSP_tb #(
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
);
reg [17:0] A;
reg [17:0] B;
reg [47:0] C;
reg [17:0] D;
reg CARRYIN;
reg CLK;
reg [7:0] OPMODE;
reg CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP;
reg RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP;
reg [47:0] PCIN;
reg [17:0] BCIN;
wire [17:0] BCOUT;
wire [47:0] PCOUT;
wire [35:0] M;
wire [47:0] P;
wire CARRYOUT;
wire CARRYOUTF;
//expected outputs
reg [17:0] BCOUT_expected;
reg [47:0] PCOUT_expected;
reg [35:0] M_expected;
reg [47:0] P_expected;
reg CARRYOUT_expected;
reg CARRYOUTF_expected;
//module_instance
DSP48A1 #(.A0REG(A0REG),.A1REG(A1REG),.B0REG(B0REG),.B1REG(B1REG),.CREG(CREG),.DREG(DREG),.MREG(MREG),.PREG(PREG),.CARRYINREG(CARRYINREG),
          .CARRYOUTREG(CARRYOUTREG),.OPMODEREG(OPMODEREG),.CARRYINSEL(CARRYINSEL),.B_INPUT(B_INPUT),.RSTTYPE(RSTTYPE))
         dut (.A(A),.B(B),.C(C),.D(D),.CARRYIN(CARRYIN),.CLK(CLK),.OPMODE(OPMODE),.CEA(CEA),.CEB(CEB),.CEC(CEC),.CECARRYIN(CECARRYIN),
              .CED(CED),.CEM(CEM),.CEOPMODE(CEOPMODE),.CEP(CEP),.RSTA(RSTA),.RSTB(RSTB),.RSTC(RSTC),.RSTCARRYIN(RSTCARRYIN),.RSTD(RSTD),.RSTM(RSTM),
              .RSTOPMODE(RSTOPMODE),.RSTP(RSTP),.PCIN(PCIN),.BCIN(BCIN),.BCOUT(BCOUT),.PCOUT(PCOUT),.M(M),.P(P),.CARRYOUT(CARRYOUT),.CARRYOUTF(CARRYOUTF));
initial begin
    CLK = 0;
    forever #5 CLK = ~CLK;
end
integer i;
initial begin
    BCOUT_expected = 0; PCOUT_expected = 0; M_expected = 0; P_expected = 0; CARRYOUT_expected = 0; CARRYOUTF_expected = 0;
    RSTA=1; RSTB=1; RSTC=1; RSTCARRYIN=1; RSTD=1; RSTM=1; RSTOPMODE=1; RSTP=1;
    for(i=0;i<10;i=i+1)begin
        A=$random; B=$random; C=$random; D=$random; CARRYIN=$random; OPMODE=$random;
        CEA=$random; CEB=$random; CEC=$random; CECARRYIN=$random; CED=$random; CEM=$random; CEOPMODE=$random; CEP=$random;
        BCIN=$random; PCIN=$random;
        @(negedge CLK);
        if(M !== 0 || P !== 0 || BCOUT !== 0 || PCOUT !== 0 || CARRYOUT !== 0 || CARRYOUTF !== 0) begin
            $display("Error: Outputs are not zero at reset");
            $finish;
        end
    end
    RSTA=0; RSTB=0; RSTC=0; RSTCARRYIN=0; RSTD=0; RSTM=0; RSTOPMODE=0; RSTP=0;
    //path1
    CEA=1; CEB=1; CEC=1; CECARRYIN=1; CED=1; CEM=1; CEOPMODE=1; CEP=1;
    A=20; B=10; C=350; D=25; OPMODE=8'b1101_1101;
    for(i=0;i<10;i=i+1)begin
      BCIN=$random; PCIN=$random; CARRYIN=$random;
      repeat(4)@(negedge CLK);
      BCOUT_expected = 'hf;
      M_expected = 'h12c;
      P_expected = 'h32;
      PCOUT_expected = 'h32;
      CARRYOUT_expected = 0;
      CARRYOUTF_expected = 0;
      if(BCOUT !== BCOUT_expected || M !== M_expected || P !== P_expected || PCOUT !== PCOUT_expected || CARRYOUT !== CARRYOUT_expected || CARRYOUTF !== CARRYOUTF_expected) begin
          $display("Error: Outputs do not match expected values");
          $finish;
      end
    end
    //path2
    A=20; B=10; C=350; D=25; OPMODE=8'b0001_0000;
    for(i=0;i<10;i=i+1)begin
      BCIN=$random; PCIN=$random; CARRYIN=$random;
      repeat(3)@(negedge CLK);
      BCOUT_expected = 'h23;
      M_expected = 'h2bc;
      P_expected = 'h0;
      PCOUT_expected = 'h0;
      CARRYOUT_expected = 0;
      CARRYOUTF_expected = 0;
      if(BCOUT !== BCOUT_expected || M !== M_expected || P !== P_expected || PCOUT !== PCOUT_expected || CARRYOUT !== CARRYOUT_expected || CARRYOUTF !== CARRYOUTF_expected) begin
          $display("Error: Outputs do not match expected values");
          $finish;
      end
    end
    //path3
    A=20; B=10; C=350; D=25;OPMODE=8'b0000_1010;
    for(i=0;i<10;i=i+1)begin
      BCIN=$random; PCIN=$random; CARRYIN=$random;
      repeat(3)@(negedge CLK);
      BCOUT_expected = 'ha;
      M_expected = 'hc8;
      P_expected = 'h0;
      PCOUT_expected = 'h0;
      CARRYOUT_expected = 0;
      CARRYOUTF_expected = 0;
      if(BCOUT !== BCOUT_expected || M !== M_expected || P !== P_expected || PCOUT !== PCOUT_expected || CARRYOUT !== CARRYOUT_expected || CARRYOUTF !== CARRYOUTF_expected) begin
          $display("Error: Outputs do not match expected values");
          $finish;
      end
    end
    //path4
    A=5; B=6; C=350; D=25; PCIN=3000; OPMODE=8'b1010_0111;
    for(i=0;i<10;i=i+1)begin
      BCIN=$random; CARRYIN=$random;
      repeat(3)@(negedge CLK);
      BCOUT_expected = 'h6;
      M_expected = 'h1e;
      P_expected = 'hfe6fffec0bb1;
      PCOUT_expected = 'hfe6fffec0bb1;
      CARRYOUT_expected = 1;
      CARRYOUTF_expected = 1;
      if(BCOUT !== BCOUT_expected || M !== M_expected || P !== P_expected || PCOUT !== PCOUT_expected || CARRYOUT !== CARRYOUT_expected || CARRYOUTF !== CARRYOUTF_expected) begin
          $display("Error: Outputs do not match expected values");
          $finish;
      end
    end
    $stop;
end
endmodule
