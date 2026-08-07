"""C3 PROBE — gate-level test of the structural adder.

Council ruling 1 fired a measured probe of structural gate-level input. This
test runs against the POST-LAYOUT netlist in the gl_test job, so a pass here is
evidence that a design written as sky130 cell instantiations still computes what
it was written to compute after the flow has placed and routed it.
"""
import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_structural_adder(dut):
    dut._log.info("C3 probe: 8-bit structural ripple adder, registered outputs")
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())
    dut.ena.value = 1
    dut.rst_n.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 2)

    rng = random.Random(20260807)
    cases = [(0, 0), (255, 1), (1, 255), (255, 255), (170, 85)]
    cases += [(rng.randrange(256), rng.randrange(256)) for _ in range(40)]

    for a, b in cases:
        dut.ui_in.value = a
        dut.uio_in.value = b
        await ClockCycles(dut.clk, 1)   # combinational settles, flops sample
        await ClockCycles(dut.clk, 1)   # registered value observable
        total = a + b
        assert int(dut.uo_out.value) == (total & 0xFF), (
            f"sum: {a}+{b} -> got {int(dut.uo_out.value)} want {total & 0xFF}")
        assert (int(dut.uio_out.value) & 1) == (total >> 8), (
            f"cout: {a}+{b} -> got {int(dut.uio_out.value) & 1} want {total >> 8}")

    dut._log.info(f"{len(cases)} vector(s) passed on the structural netlist")
