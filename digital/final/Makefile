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

CACHE_CONF  := local_cache.conf
LAYOUT_SCM  := layout_gen.scm

REF_RING     := 2
REF_INTERACT := 3

RECT_DIR := rect_gen

.PHONY: all ring layout clean

all: layout

# --- expression cache override, avoids the shared-cache collision (bugs.md Bug 1) ---
$(CACHE_CONF):
	printf 'begin synth\n    begin expropt\n        begin cache\n            string local "$(CURDIR)/.expr_cache"\n        end\n    end\nend\n' > $@

# --- CHP -> ring-synthesized PRS ---
ring: $(RING_OUT)

$(RING_OUT) $(EXPR_OUT) &: $(DECOMP_SRC) $(CACHE_CONF)
	synth2 -F ring -C bd -ref=$(REF_RING) -cnf=$(CACHE_CONF) \
		-p $(TOP_DECOMP) -o $(RING_OUT) -e $(EXPR_OUT) $(DECOMP_SRC)

# --- cell-map + transistor netlist + LEF + per-cell .rect layout ---
# (the standalone act2lef binary crashes in this environment - see bugs.md -
# so this goes through interact directly instead, via layout_gen.scm)
layout: $(RING_OUT) $(LAYOUT_SCM)
	rm -f out.lef *.rect
	interact -ref=$(REF_INTERACT) -T$(TECH) $(LAYOUT_SCM)
	mkdir -p $(RECT_DIR)
	mv -f *.rect $(RECT_DIR)/
	mv -f out.lef $(LEF_OUT)

clean:
	rm -f $(RING_OUT) $(EXPR_OUT) out.lef out.cell out.def $(LEF_OUT)
	rm -rf $(RECT_DIR)
