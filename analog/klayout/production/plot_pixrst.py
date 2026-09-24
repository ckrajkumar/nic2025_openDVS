import numpy as np, analyze_raw as A
import matplotlib; matplotlib.use("Agg"); import matplotlib.pyplot as plt
runs=[("k (edit20260922k, TB as is)","outputs/biasdrift/nominal.raw","C0"),
      ("k, C(pixRst,vsf) scaled to the Quantus value (x0.43)","outputs/drift/pixrst_vsf043.raw","C1"),
      ("k, C(pixRst,vsf) = 0","outputs/drift/nopixrst_vsf.raw","C2"),
      ("k, all 24 nRst coupling cards = 0 (pixRst-vsf kept)","outputs/long_k/reset_rise_nocoupling.raw","C3"),
      ("production","outputs/long_prod/prod.raw","k")]
D=[(lab,A.read(p),c) for lab,p,c in runs]
fig,ax=plt.subplots(4,2,figsize=(15,12.5),sharex="col")
for lab,d,c in D:
    t=d["time"]*1e6
    for col,(lo,hi) in enumerate([(0,300),(-0.5,20)]):
        mm=(t>=lo)&(t<=hi)
        ax[0,col].plot(t[mm],d["v(vsfsense)"][mm],c,lw=1.2,label=lab)
        ax[1,col].plot(t[mm],d["v(vdiffsense)"][mm],c,lw=1.2)
        ax[1,col].plot(t[mm],d["v(vdsense)"][mm],c,lw=0.8,ls=":")
        ax[2,col].plot(t[mm],d["v(nrstsense)"][mm],c,lw=1.2)
        ax[3,col].plot(t[mm],d["v(onsense)"][mm],c,lw=1.2)
for col in (0,1):
    ax[0,col].axhline(1.1976,color="gray",ls="--",lw=0.8); ax[0,col].set_ylabel("vsf [V]")
    ax[1,col].axhline(0.77,color="gray",ls="--",lw=0.8); ax[1,col].set_ylabel("vdiff [V]  (dotted: vd)")
    ax[2,col].set_ylabel("nRst [V]"); ax[3,col].set_ylabel("ON [V]"); ax[3,col].set_xlabel("time after reset release [us]")
    ax[0,col].set_ylim(1.13,1.215); ax[1,col].set_ylim(0.3,1.0)
ax[0,0].set_title("0-300 us: vsf recovers only through the few-pA source follower (dashed = DC value 1.1976 V)")
ax[0,1].set_title("0-20 us zoom: reset kick, nRst ramp (4 nA, 7 us), change-amp response")
ax[1,0].set_title("vdiff = change-amp output slides as vsf recovers (dashed = ON threshold ~0.77 V at OnBn 100n)")
ax[2,0].set_title("nRst (Mrst gate): RefrBp 4 nA ramp into the refractory cap, 90 % at 7.3 us")
ax[3,0].set_title("ON comparator output")
ax[0,0].legend(loc="lower right",fontsize=9)
fig.suptitle("openDVS pixel 0, reset TB, IRefrBp 4 nA, tt 27 C: the slow post-reset slide is C(pixRst,vsf), not nRst",fontsize=13)
fig.tight_layout(); fig.savefig("outputs/drift/pixrst_vsf_effect.png",dpi=130); print("ok")
