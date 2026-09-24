import json, statistics, sys
names={'tls':'base-native','tls:a':'base-baseline','tls:b':'fork-native','tls:c':'fork-baseline'}
for f in sys.argv[1:]:
    d=json.load(open(f))
    rows={}
    for r in d:
        mode=r['target']['mode']; v=r['target']['extra_config'].get('variant')
        key='tls' if not v else f'tls:{v}' 
        cyc=r['perf']['cycles']/r['extra']['backend_requests']
        ins=r['perf']['instructions']/r['extra']['backend_requests']
        rows.setdefault(key,[]).append((cyc,ins,r['valid'],r['target']['extra_config'].get('negotiated')))
    print(f)
    base=statistics.median(c for c,_,_,_ in rows['tls'])
    print(f"{'build':15} {'n':>2} {'median cyc/hs':>14} {'min':>9} {'max':>9} {'vs base-native':>15} {'median ins/hs':>14}  valid")
    for k in ['tls','tls:a','tls:b','tls:c']:
        cs=[c for c,_,_,_ in rows[k]]; ins=[i for _,i,_,_ in rows[k]]
        m=statistics.median(cs)
        print(f"{names[k]:15} {len(cs):>2} {m:>14,.0f} {min(cs):>9,.0f} {max(cs):>9,.0f} {100*(m/base-1):>+14.1f}% {statistics.median(ins):>14,.0f}  {all(v for _,_,v,_ in rows[k])} {rows[k][0][3]}")
