module tap_wrapper
(
  tdi,
  tms,
  tck,
  trst,
  tdo_pad_o,
  tdo_paden_o,
  sout,
  sin,
  shift,
  test
);

  input tdi;
  input tms;
  input tck;
  input trst;
  input sout;
  output tdo_pad_o;
  output tdo_paden_o;
  output shift;
  output test;
  output sin;
  wire chain_tdi_i;
  wire __trst_high__;
  wire tdo_padoe_o;
  wire shift_dr_o;
  wire pause_dr_o;
  wire run_test_idle_o;
  wire test_logic_reset_o;
  wire exit1_dr_o;
  reg sout_sampled;

  always @(negedge tck) begin
    sout_sampled <= sout;
  end

  assign chain_tdi_i = sout_sampled;
  assign __trst_high__ = ~trst;
  assign shift = (pause_dr_o | (shift_dr_o | exit1_dr_o)) & preload_chain_o;
  assign test = ~(run_test_idle_o | test_logic_reset_o);
  assign sin = tdo_o;
  assign tdo_paden_o = ~tdo_padoe_o;

  tap_top
  __tap_top__
  (
    .tms_pad_i(tms),
    .tck_pad_i(tck),
    .trst_pad_i(__trst_high__),
    .tdi_pad_i(tdi),
    .tdo_pad_o(tdo_pad_o),
    .tdo_padoe_o(tdo_padoe_o),
    .shift_dr_o(shift_dr_o),
    .pause_dr_o(pause_dr_o),
    .run_test_idle_o(run_test_idle_o),
    .test_logic_reset_o(test_logic_reset_o),
    .exit1_dr_o(exit1_dr_o),
    .preload_chain_o(preload_chain_o),
    .tdo_o(tdo_o),
    .chain_tdi_i(chain_tdi_i)
  );


endmodule
