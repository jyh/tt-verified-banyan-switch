# Verified 8×8 bit-serial banyan switch — TinyTapeout TTSKY26c

A self-routing 8×8 packet switch fabric whose **gate netlist is proved
equivalent to its specification inside the Lean kernel**. It recreates the
banyan half of **US Patent 4,910,730** (1988) — an ATM packet switch built as
two chips, a Batcher sorter and a banyan router. That two-chip partition is also
the proof's partition: the sorter is the *hypothesis*, the banyan is the
*theorem*. **This chip is the proved half.**

Read the datasheet first: [`docs/info.md`](docs/info.md).

## The 1990 silicon

This is not a new architecture. In 1990 Bellcore built it, and measured it.

W. S. Marcus and J. J. Hickey, "A CMOS Batcher and banyan chip set for B-ISDN,"
*1990 IEEE International Solid-State Circuits Conference, Digest of Technical
Papers*, pp. 32–33 (session WPM 2.4), DOI
[`10.1109/ISSCC.1990.110116`](https://doi.org/10.1109/ISSCC.1990.110116) — with
the journal version as "A CMOS Batcher and Banyan chip set for B-ISDN packet
switching," *IEEE Journal of Solid-State Circuits* **25**(6):1426–1432, December
1990, DOI [`10.1109/4.62170`](https://doi.org/10.1109/4.62170).

That chip set was **measured at 170 Mb/s per bit-serial link**, against a
155.52 Mb/s SONET STS-3c requirement, for **5.44 Gb/s aggregate across 32
channels**. It was **1.2 µm CMOS**, a single 5 V supply, about **1.5 W**, in an
**84-pin LCC**.

The switching elements are US Patent **5,130,976**, "Batcher and Banyan Switching
Elements" (J. J. Hickey and W. S. Marcus, filed 1991-02-12, granted 1992-07-14).
The network architecture is US Patent **4,910,730**, "Batcher-banyan network"
(C. M. Day Jr. and J. N. Giacopelli, filed 1988-03-14, granted 1990-03-20) — cite
it for the architecture only; it carries no process node and no 155 Mb/s figure.

The ISSCC paper's **Figure 6 is a micrograph of the Batcher die**, and it is
worth looking up: the architecture is legible directly off the silicon — an input
column, then the switch-element fabric as countable vertical cell-column stripes
separated by wiring channels, then a latch column, a mux, and an output column,
inside a pad ring. We reproduce no part of it here; go and read the paper.

## What is actually proved, and what is not

The synthesized gate netlist of the switch element — real sky130 standard cells,
flip-flops included — computes the same outputs and next state as the Lean
specification **for every state and every input**, checked by kernel reduction
and lifted across cycles by induction. No SAT solver is trusted and no
`native_decide` is used.

**A banyan routes correctly only when the destinations presented to it are
sorted.** Of all 40,320 full-load permutations, exactly **4,096 (10.16 %)** route
without internal collision. The Batcher sorter that would guarantee sortedness is
on neither this chip nor in Lean. So this is a correct router *given a correct
input order*, and the ordering must come from off-chip — as it did in 1988.

## Layout of this directory

| path | what |
|---|---|
| `info.yaml` | the manifest — schema authority is `tt-support-tools/project_info.py` |
| `src/project.v` | the TT wrapper (`tt_um_saltworks_banyan`) |
| `src/config.json` | the two hardening knobs; rationale in [`docs/hardening-choices.md`](docs/hardening-choices.md) |
| `docs/info.md` | the datasheet body spliced into the shuttle datasheet |
| `docs/submission-checklist.md` | prepared / owed / the human's clicks |
| `src/banyan_fabric.v` | the 8×8 fabric: twelve switch elements in three stages |
| `src/bitserial_switch.v` | the 2×2 element — the thing the Lean proof is about |
| `test/` | the cocotb bench — [`test/README.md`](test/README.md) |

`banyan_fabric.v` and `bitserial_switch.v` are **generated into this repo**, not
authored here: they live once upstream, because the same bytes are what the
equivalence proof and the synthesis script read, and a second hand-maintained
copy would drift. What you see in `src/` is that copy, made by a script.

## Checking it

```sh
cd test && make            # the 255-scenario bench at RTL
GATES=yes make             # the same bench against the post-layout netlist
./gl_local.sh <netlist.v>  # ...or against a locally synthesized sky130 netlist
```

The GitHub Actions in this repo run the same bench, plus the hardening flow, the
TinyTapeout precheck, and a gate-level test against the **powered** post-layout
netlist.

`.github/workflows/`, `.devcontainer/`, `.vscode/`, `LICENSE` and `tb.gtkw` are
**TinyTapeout's template repo verbatim** — this repository was created *from*
that template, and those files are deliberately unmodified.

## Licence

Apache-2.0, which TinyTapeout's terms make mandatory for both the design and its
documentation. Copyright 2026 Jason Hickey.
