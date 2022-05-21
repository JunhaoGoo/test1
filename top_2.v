`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/30 23:18:57
// Design Name: 
// Module Name: top_2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 111111 test git
//////////////////////////////////////////////////////////////////////////////////
module top_2(
    input   [31:0]   a,
    input   [31:0]   b,
    input            ci,
    input            sub,
    input            sign,

    output  [31:0]   s,
    output           co,
    output           overflow
);

wire            cib = ci ^ sub;
wire    [31:0]  bb  = b ^ {32{sub}};
wire            g_out,p_out;
reg             sign_over;

cla_32 cla (a,bb,cib, g_out,p_out,s);
assign  co  =  g_out | p_out & cib;
assign  overflow = sign ? (sign_over) : (co ^ sub);

always @(*) begin
    if(sign == 1) begin
       if (!(a[31]|bb[31])&(s[31]==1)) sign_over = 1;
       else if ( (a[31]&bb[31]) & (s[31] == 0)) sign_over = 1;
       else sign_over = 0;
    end
    else    sign_over = 0;
end
endmodule


module gp(
    input   [1:0]   g,
    input   [1:0]   p,
    input           c_in,
    output          g_out,
    output          p_out,
    output          c_out
);

assign g_out = g[1] | p[1] & g[0];
assign p_out = p[1] & p[0];
assign c_out = g[0] | p[0] & c_in;

endmodule

module add(
    input a,
    input b,
    input c,
    output g,
    output p,
    output s
);

assign s = a ^ b ^ c;
assign g = a & b;
assign p = a | b;

endmodule

module cla_2(
    input   [1:0]   a,
    input   [1:0]   b,
    input           c_in,

    output          g_out,
    output          p_out,
    output  [1:0]   s
);

wire    [1:0]   g,p;
wire            c_out;

add add0 (a[0],b[0],c_in,   g[0],p[0],s[0]);
add add1 (a[1],b[1],c_out,  g[1],p[1],s[1]);
gp gp0 (g,p,c_in, g_out,p_out,c_out);

endmodule


module cla_4(
    input   [3:0]   a,
    input   [3:0]   b,
    input           c_in,

    output          g_out,
    output          p_out,
    output  [3:0]   s
);

wire    [1:0]   g,p;
wire            c_out;

cla_2 cla0 (a[1:0],b[1:0],c_in,     g[0],p[0],s[1:0]);
cla_2 cla1 (a[3:2],b[3:2],c_out,    g[1],p[1],s[3:2]);
gp   gp0 (g,p,c_in , g_out,p_out,c_out);

endmodule

module cla_8(
    input   [7:0]   a,
    input   [7:0]   b,
    input           c_in,

    output          g_out,
    output          p_out,
    output  [7:0]   s
);

wire    [1:0]   g,p;
wire            c_out;

cla_4 cal0 (a[3:0],b[3:0],c_in,     g[0],p[0],s[3:0]);
cla_4 cal1 (a[7:4],b[7:4],c_out,    g[1],p[1],s[7:4]);
gp   gp0 (g,p,c_in , g_out,p_out,c_out);

endmodule


module cla_16(
    input   [15:0]   a,
    input   [15:0]   b,
    input           c_in,

    output          g_out,
    output          p_out,
    output  [15:0]   s
);

wire    [1:0]   g,p;
wire            c_out;

cla_8 cal0 (a[7:0],b[7:0],c_in,     g[0],p[0],s[7:0]);
cla_8 cal1 (a[15:8],b[15:8],c_out,  g[1],p[1],s[15:8]);
gp   gp0 (g,p,c_in , g_out,p_out,c_out);

endmodule

module cla_32(
    input   [31:0]   a,
    input   [31:0]   b,
    input           c_in,

    output          g_out,
    output          p_out,
    output  [31:0]   s
);

wire    [1:0]   g,p;
wire            c_out;

cla_16 cal0 (a[15:0],b[15:0],c_in,     g[0],p[0],s[15:0]);
cla_16 cal1 (a[31:16],b[31:16],c_out,  g[1],p[1],s[31:16]);
gp   gp0 (g,p,c_in , g_out,p_out,c_out);

endmodule










