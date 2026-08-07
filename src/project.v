/*
 * C3 PROBE — ARM A: STRUCTURAL GATE-LEVEL INPUT.
 *
 * Council ruling 1 (2026-08-07) fired a measured probe of option (A),
 * "structural gate-level emission, synthesis-as-passthrough". This file is the
 * flow-side test article: an 8-bit ripple adder written ONLY as sky130 standard
 * cell instantiations, with the per-slice carry boundaries NAMED so the census
 * can ask whether they survive to the fabricated netlist.
 *
 * It is a PROBE, not a submission. `main` carries the banyan fabric.
 *
 * Outputs are registered with structural dfxtp_1 so the design has a real clock
 * domain — otherwise a failure could mean "structural input rejected" when it
 * actually meant "no sequential elements", and the probe would answer the wrong
 * question.
 *
 * Pin map: a = ui_in[7:0], b = uio_in[7:0], sum = uo_out[7:0] (registered),
 * cout = uio_out[0] (registered), carry-in tied low.
 */

`default_nettype none

module tt_um_saltworks_banyan (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    wire [7:0] p;              // a ^ b, per slice
    wire [8:0] carry;          // THE SLICE BOUNDARIES — named on purpose
    wire [7:0] s;              // combinational sum, pre-register
    wire       cout_c;
    wire g0_w, h0_w;
    wire g1_w, h1_w;
    wire g2_w, h2_w;
    wire g3_w, h3_w;
    wire g4_w, h4_w;
    wire g5_w, h5_w;
    wire g6_w, h6_w;
    wire g7_w, h7_w;

    assign carry[0] = 1'b0;

    sky130_fd_sc_hd__xor2_1 px0 (.A(ui_in[0]), .B(uio_in[0]), .X(p[0]));
    sky130_fd_sc_hd__xor2_1 sm0 (.A(p[0]),     .B(carry[0]),  .X(s[0]));
    sky130_fd_sc_hd__and2_1 ab0 (.A(ui_in[0]), .B(uio_in[0]), .X(g0_w));
    sky130_fd_sc_hd__and2_1 pc0 (.A(p[0]),     .B(carry[0]),  .X(h0_w));
    sky130_fd_sc_hd__or2_1  cy0 (.A(g0_w),     .B(h0_w),      .X(carry[1]));
    sky130_fd_sc_hd__xor2_1 px1 (.A(ui_in[1]), .B(uio_in[1]), .X(p[1]));
    sky130_fd_sc_hd__xor2_1 sm1 (.A(p[1]),     .B(carry[1]),  .X(s[1]));
    sky130_fd_sc_hd__and2_1 ab1 (.A(ui_in[1]), .B(uio_in[1]), .X(g1_w));
    sky130_fd_sc_hd__and2_1 pc1 (.A(p[1]),     .B(carry[1]),  .X(h1_w));
    sky130_fd_sc_hd__or2_1  cy1 (.A(g1_w),     .B(h1_w),      .X(carry[2]));
    sky130_fd_sc_hd__xor2_1 px2 (.A(ui_in[2]), .B(uio_in[2]), .X(p[2]));
    sky130_fd_sc_hd__xor2_1 sm2 (.A(p[2]),     .B(carry[2]),  .X(s[2]));
    sky130_fd_sc_hd__and2_1 ab2 (.A(ui_in[2]), .B(uio_in[2]), .X(g2_w));
    sky130_fd_sc_hd__and2_1 pc2 (.A(p[2]),     .B(carry[2]),  .X(h2_w));
    sky130_fd_sc_hd__or2_1  cy2 (.A(g2_w),     .B(h2_w),      .X(carry[3]));
    sky130_fd_sc_hd__xor2_1 px3 (.A(ui_in[3]), .B(uio_in[3]), .X(p[3]));
    sky130_fd_sc_hd__xor2_1 sm3 (.A(p[3]),     .B(carry[3]),  .X(s[3]));
    sky130_fd_sc_hd__and2_1 ab3 (.A(ui_in[3]), .B(uio_in[3]), .X(g3_w));
    sky130_fd_sc_hd__and2_1 pc3 (.A(p[3]),     .B(carry[3]),  .X(h3_w));
    sky130_fd_sc_hd__or2_1  cy3 (.A(g3_w),     .B(h3_w),      .X(carry[4]));
    sky130_fd_sc_hd__xor2_1 px4 (.A(ui_in[4]), .B(uio_in[4]), .X(p[4]));
    sky130_fd_sc_hd__xor2_1 sm4 (.A(p[4]),     .B(carry[4]),  .X(s[4]));
    sky130_fd_sc_hd__and2_1 ab4 (.A(ui_in[4]), .B(uio_in[4]), .X(g4_w));
    sky130_fd_sc_hd__and2_1 pc4 (.A(p[4]),     .B(carry[4]),  .X(h4_w));
    sky130_fd_sc_hd__or2_1  cy4 (.A(g4_w),     .B(h4_w),      .X(carry[5]));
    sky130_fd_sc_hd__xor2_1 px5 (.A(ui_in[5]), .B(uio_in[5]), .X(p[5]));
    sky130_fd_sc_hd__xor2_1 sm5 (.A(p[5]),     .B(carry[5]),  .X(s[5]));
    sky130_fd_sc_hd__and2_1 ab5 (.A(ui_in[5]), .B(uio_in[5]), .X(g5_w));
    sky130_fd_sc_hd__and2_1 pc5 (.A(p[5]),     .B(carry[5]),  .X(h5_w));
    sky130_fd_sc_hd__or2_1  cy5 (.A(g5_w),     .B(h5_w),      .X(carry[6]));
    sky130_fd_sc_hd__xor2_1 px6 (.A(ui_in[6]), .B(uio_in[6]), .X(p[6]));
    sky130_fd_sc_hd__xor2_1 sm6 (.A(p[6]),     .B(carry[6]),  .X(s[6]));
    sky130_fd_sc_hd__and2_1 ab6 (.A(ui_in[6]), .B(uio_in[6]), .X(g6_w));
    sky130_fd_sc_hd__and2_1 pc6 (.A(p[6]),     .B(carry[6]),  .X(h6_w));
    sky130_fd_sc_hd__or2_1  cy6 (.A(g6_w),     .B(h6_w),      .X(carry[7]));
    sky130_fd_sc_hd__xor2_1 px7 (.A(ui_in[7]), .B(uio_in[7]), .X(p[7]));
    sky130_fd_sc_hd__xor2_1 sm7 (.A(p[7]),     .B(carry[7]),  .X(s[7]));
    sky130_fd_sc_hd__and2_1 ab7 (.A(ui_in[7]), .B(uio_in[7]), .X(g7_w));
    sky130_fd_sc_hd__and2_1 pc7 (.A(p[7]),     .B(carry[7]),  .X(h7_w));
    sky130_fd_sc_hd__or2_1  cy7 (.A(g7_w),     .B(h7_w),      .X(carry[8]));

    assign cout_c = carry[8];

    // Registered outputs — structural flops, so the clock domain is real.
    sky130_fd_sc_hd__dfxtp_1 rq0 (.CLK(clk), .D(s[0]), .Q(uo_out[0]));
    sky130_fd_sc_hd__dfxtp_1 rq1 (.CLK(clk), .D(s[1]), .Q(uo_out[1]));
    sky130_fd_sc_hd__dfxtp_1 rq2 (.CLK(clk), .D(s[2]), .Q(uo_out[2]));
    sky130_fd_sc_hd__dfxtp_1 rq3 (.CLK(clk), .D(s[3]), .Q(uo_out[3]));
    sky130_fd_sc_hd__dfxtp_1 rq4 (.CLK(clk), .D(s[4]), .Q(uo_out[4]));
    sky130_fd_sc_hd__dfxtp_1 rq5 (.CLK(clk), .D(s[5]), .Q(uo_out[5]));
    sky130_fd_sc_hd__dfxtp_1 rq6 (.CLK(clk), .D(s[6]), .Q(uo_out[6]));
    sky130_fd_sc_hd__dfxtp_1 rq7 (.CLK(clk), .D(s[7]), .Q(uo_out[7]));
    sky130_fd_sc_hd__dfxtp_1 rqc (.CLK(clk), .D(cout_c), .Q(uio_out[0]));

    assign uio_out[7:1] = 7'b0;
    assign uio_oe = 8'b0000_0001;   // drive only the cout bit

    wire _unused = &{ena, rst_n, 1'b0};

endmodule
