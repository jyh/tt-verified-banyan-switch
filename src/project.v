/*
 * BB-1 / B3 — THE COMPOSED TILE (revision branch; `main` carries the proven
 * banyan alone and is the Captain's floor).
 *
 * Batcher sorter (24 bitonic compare-exchange elements, emitted STRUCTURALLY
 * by compiler's `emitSMux` from `bnCore`) feeding the landed banyan fabric.
 *
 * ⚠️ THIS RUN ASKS KB4 ONLY: does ~2.6x logic HARDEN? The Batcher core takes
 * act/data as SEPARATE vectors while the banyan takes the INTERLEAVED frame;
 * matching those protocols is B4. `gl_test` is EXPECTED TO FAIL here and that
 * is not a hardening result. Stated before the run, not after it.
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

    // ---- Batcher state: 48 flops, one pair per element ----------------
    reg  [47:0] bst;
    wire [63:0] bo;          // o0..o7 data, o8..o15 act, o16..o63 next-state

    // ---- the emitted structural sorter core ---------------------------
    batcher_struct u_sort (.i0(~rst_n), .i1(uio_in[0]), .i2(uio_in[1]), .i3(uio_in[2]), .i4(uio_in[3]), .i5(uio_in[4]), .i6(uio_in[5]), .i7(uio_in[6]), .i8(uio_in[7]), .i9(ui_in[0]), .i10(ui_in[1]), .i11(ui_in[2]), .i12(ui_in[3]), .i13(ui_in[4]), .i14(ui_in[5]), .i15(ui_in[6]), .i16(ui_in[7]), .i17(bst[0]), .i18(bst[1]), .i19(bst[2]), .i20(bst[3]), .i21(bst[4]), .i22(bst[5]), .i23(bst[6]), .i24(bst[7]), .i25(bst[8]), .i26(bst[9]), .i27(bst[10]), .i28(bst[11]), .i29(bst[12]), .i30(bst[13]), .i31(bst[14]), .i32(bst[15]), .i33(bst[16]), .i34(bst[17]), .i35(bst[18]), .i36(bst[19]), .i37(bst[20]), .i38(bst[21]), .i39(bst[22]), .i40(bst[23]), .i41(bst[24]), .i42(bst[25]), .i43(bst[26]), .i44(bst[27]), .i45(bst[28]), .i46(bst[29]), .i47(bst[30]), .i48(bst[31]), .i49(bst[32]), .i50(bst[33]), .i51(bst[34]), .i52(bst[35]), .i53(bst[36]), .i54(bst[37]), .i55(bst[38]), .i56(bst[39]), .i57(bst[40]), .i58(bst[41]), .i59(bst[42]), .i60(bst[43]), .i61(bst[44]), .i62(bst[45]), .i63(bst[46]), .i64(bst[47]), .o0(bo[0]), .o1(bo[1]), .o2(bo[2]), .o3(bo[3]), .o4(bo[4]), .o5(bo[5]), .o6(bo[6]), .o7(bo[7]), .o8(bo[8]), .o9(bo[9]), .o10(bo[10]), .o11(bo[11]), .o12(bo[12]), .o13(bo[13]), .o14(bo[14]), .o15(bo[15]), .o16(bo[16]), .o17(bo[17]), .o18(bo[18]), .o19(bo[19]), .o20(bo[20]), .o21(bo[21]), .o22(bo[22]), .o23(bo[23]), .o24(bo[24]), .o25(bo[25]), .o26(bo[26]), .o27(bo[27]), .o28(bo[28]), .o29(bo[29]), .o30(bo[30]), .o31(bo[31]), .o32(bo[32]), .o33(bo[33]), .o34(bo[34]), .o35(bo[35]), .o36(bo[36]), .o37(bo[37]), .o38(bo[38]), .o39(bo[39]), .o40(bo[40]), .o41(bo[41]), .o42(bo[42]), .o43(bo[43]), .o44(bo[44]), .o45(bo[45]), .o46(bo[46]), .o47(bo[47]), .o48(bo[48]), .o49(bo[49]), .o50(bo[50]), .o51(bo[51]), .o52(bo[52]), .o53(bo[53]), .o54(bo[54]), .o55(bo[55]), .o56(bo[56]), .o57(bo[57]), .o58(bo[58]), .o59(bo[59]), .o60(bo[60]), .o61(bo[61]), .o62(bo[62]), .o63(bo[63]));

    always @(posedge clk) if (!rst_n) bst <= 48'b0; else bst <= bo[63:16];

    // ---- the landed banyan, fed by the sorter's data output ----------
    wire [2:0] cnt_o; wire valid;
    banyan_fabric u_fab (.clk(clk), .rst_n(rst_n), .sof(uio_in[0]),
                         .din(bo[7:0]), .dout(uo_out), .cnt_o(cnt_o), .valid(valid));

    assign uio_out = {3'b000, valid, cnt_o, 1'b0};   // main's map: cnt at [3:1], valid [4], bit0 = sof IN
    assign uio_oe  = 8'b0001_1110;                   // drive [4:1] only; uio[0] is the sof INPUT
    wire _unused = &{ena, bo[15:8], 1'b0};

endmodule
