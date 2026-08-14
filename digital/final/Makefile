# Regenerates the synthesized/layout artifacts in this directory from
# async_readout.decomp.act onward (that file itself is treated as a source
# input, not regenerated here — see bugs.md).
#
# NOTE on -ref levels: every synth2/interact stage needs -ref one higher
# than the previous stage produced (see "Gotcha: -ref=N must be bumped by
# one at every stage" in bugs.md). If you regenerate async_readout.decomp.act
# with a different -ref, REF_RING below (and layout_gen.scm's own -ref=3,
# passed on interact's command line here) both need to shift to match.
#
# layout_gen.scm hardcodes the top process names / cell library path used
# for the cell-map + layout stage - see that file to change them.

TECH        := sky130l
TOP_DECOMP  := decomp_rawbits

DECOMP_SRC  := async_readout.decomp.act
RING_OUT    := async_readout_ring.decomp.act
EXPR_OUT    := expr.act
LEF_OUT     := output.lef
DEF_OUT     := output.def
GDS_OUT     := output.gds

CACHE_CONF   := local_cache.conf
LAYOUT_SCM   := layout_gen.scm
HYBRID_SCRIPT := build_hybrid_lef.py
GDS_SCRIPT    := build_gds.py

REF_RING     := 2
REF_INTERACT := 3

RECT_DIR := rect_gen

# Dali target placement density (0,1] - see HANDOFF.md's hybrid-placement
# section for how this was chosen/validated.
PLACE_DENSITY := 0.7

.PHONY: all ring layout place gds clean

all: gds

# --- expression cache override, avoids the shared-cache collision (bugs.md Bug 1) ---
$(CACHE_CONF):
	printf 'begin synth\n    begin expropt\n        begin cache\n            string local "$(CURDIR)/.expr_cache"\n        end\n    end\nend\n' > $@

# --- CHP -> ring-synthesized PRS ---
ring: $(RING_OUT)

$(RING_OUT) $(EXPR_OUT) &: $(DECOMP_SRC) $(CACHE_CONF)
	synth2 -F ring -C bd -Tsky130l -ref=$(REF_RING) -cnf=$(CACHE_CONF) \
		-p $(TOP_DECOMP) -o $(RING_OUT) -e $(EXPR_OUT) $(DECOMP_SRC)

# --- cell-map + transistor netlist + self-drawn LEF/DEF + per-cell .rect layout ---
# (the standalone act2lef binary crashes in this environment - see bugs.md -
# so this goes through interact directly instead, via layout_gen.scm)
# NOTE: custom.lef/custom.cell/seed.def here are the SELF-DRAWN geometry for
# every cell, real-sky130-mapped ones included - the "layout" target alone
# is not the final tapeout-ready output. See "place" below.
layout: $(RING_OUT) $(LAYOUT_SCM)
	rm -f custom.lef custom.cell seed.def *.rect
	interact -ref=$(REF_INTERACT) -T$(TECH) $(LAYOUT_SCM)
	mkdir -p $(RECT_DIR)
	mv -f *.rect $(RECT_DIR)/

# --- hybrid LEF (real sky130 macros swapped in for self-drawn ones) + Dali placement ---
# See HANDOFF.md's hybrid-placement section for why this exists: SkyWater's
# real, foundry-verified cells are used wherever this design has a real
# defcell counterpart (found dynamically in cells.act, not hardcoded);
# everything else (ring's own control fabric, custom compound gates) stays
# self-drawn. Dali (a real gridded placer, ~/actflow/Dali) legalizes the
# mix - verified empirically to produce zero overlaps despite the row-height
# mismatch between real sky130 cells and this project's self-drawn grid.
place: layout $(HYBRID_SCRIPT)
	python3 $(HYBRID_SCRIPT) --self-drawn custom.lef --out $(LEF_OUT)
	@# drop the self-drawn .rect for real-mapped cells - real.lef/gds covers
	@# them now, the self-drawn geometry is unused clutter (see HANDOFF.md 8d)
	for c in $$(grep -oE 'sky130_fd_sc_hd__[a-z0-9_]+' ~/.local/act/act/std/cells.act | sort -u); do \
		rm -f $(RECT_DIR)/_0_0std_0_0cells_0_0$$c.rect; \
	done
	rm -f placed.def placed_io.def placed_filling.def placed_comp.def phydb.def \
		dali*.log dali_out_router.cluster dali_outppnp.rect dali_outwell.rect
	dali -lef $(LEF_OUT) -def seed.def -cell custom.cell -o placed -d $(PLACE_DENSITY)
	mv -f placed.def $(DEF_OUT)

# --- final placed GDS: real sky130 silicon for real-mapped cells, self-drawn
# geometry (converted via rect2gds.py) for everything else, stitched together
# per output.def's placement. See HANDOFF.md's hybrid-placement section.
gds: place $(GDS_SCRIPT)
	python3 $(GDS_SCRIPT) --rect-dir $(RECT_DIR) --def-file $(DEF_OUT) --out $(GDS_OUT)

clean:
	rm -f $(RING_OUT) $(EXPR_OUT) $(LEF_OUT) $(DEF_OUT) $(GDS_OUT)
	rm -f custom.lef custom.cell seed.def
	rm -f placed.def placed_io.def placed_filling.def placed_comp.def phydb.def
	rm -f dali*.log dali_out_router.cluster dali_outppnp.rect dali_outwell.rect
	rm -rf $(RECT_DIR)
	@# .expr_cache/ holds cached ABC synthesis results, keyed only by each
	@# expression's own text + bit-widths - blind to synth.conf/expropt.conf
	@# changes (see HANDOFF.md's expropt section). Wiping it on every clean
	@# guarantees `make clean && make` always resynthesizes fresh rather
	@# than silently reusing a stale mapping from before a config edit.
	rm -rf .expr_cache $(CACHE_CONF)
