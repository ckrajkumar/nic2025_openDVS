# klayout -b -r tile_cmp.py -rd a=<gds with pixel_4tile> -rd b=<gds with pixel_4tile>
import pya
def load(p):
    ly=pya.Layout(); ly.read(p); return ly
A,B=load(a),load(b)
def sub(ly,top):
    c=ly.cell(top); ids=set([c.cell_index()]); c.called_cells() and ids.update(c.called_cells()); return {ly.cell(i).name:i for i in ids}
SA,SB=sub(A,top),sub(B,top)
print("cells A",len(SA),"B",len(SB),"onlyA",sorted(set(SA)-set(SB))[:10],"onlyB",sorted(set(SB)-set(SA))[:10])
def lm(ly): return {(ly.get_info(li).layer,ly.get_info(li).datatype):li for li in ly.layer_indexes()}
LA,LB=lm(A),lm(B)
ndiff=0
for n in sorted(set(SA)&set(SB)):
    ca,cb=A.cell(SA[n]),B.cell(SB[n])
    for ld in sorted(set(LA)|set(LB)):
        ra=pya.Region(ca.shapes(LA[ld])) if ld in LA else pya.Region()
        rb=pya.Region(cb.shapes(LB[ld])) if ld in LB else pya.Region()
        x=(ra^rb)
        if not x.is_empty():
            ndiff+=1; print("SHAPE DIFF",n,ld,x.count(),x.bbox())
        ta=pya.Texts(ca.shapes(LA[ld])) if ld in LA else pya.Texts()
        tb=pya.Texts(cb.shapes(LB[ld])) if ld in LB else pya.Texts()
        sa=sorted((t.string,t.x,t.y) for t in ta.each()); sb=sorted((t.string,t.x,t.y) for t in tb.each())
        if sa!=sb: ndiff+=1; print("TEXT DIFF",n,ld,len(sa),len(sb),[s for s in sa if s not in sb][:3],[s for s in sb if s not in sa][:3])
    ia=sorted((A.cell(i.cell_index).name,i.trans.to_s(),i.na,i.nb,i.a.to_s(),i.b.to_s()) for i in ca.each_inst())
    ib=sorted((B.cell(i.cell_index).name,i.trans.to_s(),i.na,i.nb,i.a.to_s(),i.b.to_s()) for i in cb.each_inst())
    if ia!=ib: ndiff+=1; print("INST DIFF",n,len(ia),len(ib))
print("TOTAL cell/layer differences:",ndiff)
