module register #(
parameter XREG = 1,
parameter WIDTH = 18,
parameter RSTTYPE = "SYNC"
)(
input [WIDTH-1:0] X,
input clk,
input CEX,
input RSTX,
output [WIDTH-1:0] XOUT
);
reg [WIDTH-1:0] X_reg;
generate
    if(XREG && RSTTYPE == "SYNC")begin
     always @(posedge clk) begin
            if(RSTX)begin
              X_reg <= 0;
            end
            else if(CEX)begin
             X_reg <= X;
            end
        end
    end
    else if(XREG && RSTTYPE == "ASYNC") begin
     always @(posedge clk or posedge RSTX) begin
            if(RSTX)begin
             X_reg <= 0;
            end
            else if(CEX)begin
             X_reg <= X;
            end
        end
    end
endgenerate
assign XOUT = (XREG == 0) ? X : X_reg;
endmodule
