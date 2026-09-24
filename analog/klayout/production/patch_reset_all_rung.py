import sys, pathlib
p = pathlib.Path(sys.argv[1]); s = p.read_text()
start = s.index('        elif args.rung == "all":\n            results = []\n            nominal_results = _run_rows(')
end = s.index('        else:\n            results = _run_rows(\n                rows_for_campaign,')
new = '''        elif args.rung == "all":
            # edit20260922m patch: honour --paths/--shard for the pilot rows too
            # (the unpatched staging ran every path's nominal + extreme pilots in
            # every runner); the admission gates are diagnostic, non-fatal here.
            nominal_ids = {_row_id(r, r["condition"]) for r in nominal_rows}
            extreme_rows = select_pilot_rows(manifest, "extremes")
            extreme_ids = {_row_id(r, r["condition"]) for r in extreme_rows}
            selected = _selected_rows_filter(_pending_reset_rows(manifest))
            stages = (
                ("nominal", [r for r in selected if _row_id(r, r["condition"]) in nominal_ids]),
                ("extremes", [r for r in selected if _row_id(r, r["condition"]) in extreme_ids]),
                ("remaining", [r for r in selected if _row_id(r, r["condition"]) not in (nominal_ids | extreme_ids)]),
            )
            print(json.dumps({"status": "all_rung_selection_edit20260922m", "counts": {k: len(v) for k, v in stages}}), flush=True)
            results = []
            for stage, stage_rows in stages:
                stage_results = _run_rows(
                    stage_rows, sources, source_hashes, args.output, False, args.timeout_s
                )
                results.extend(stage_results)
                if stage_rows and not _results_are_valid(stage_results):
                    print(json.dumps({"status": f"{stage}_not_admitted_continuing_edit20260922m"}), flush=True)
            nominal_done = [r for r in results if r.get("row_id") in nominal_ids]
            if nominal_ids <= {r.get("row_id") for r in nominal_done} and _results_are_valid(nominal_done):
                _write_once_or_equal_json(
                    args.output / "nominal_admission.json",
                    _nominal_admission_value(manifest_hash, source_fingerprint, nominal_row_ids),
                )
'''
s = s[:start] + new + s[end:]
p.write_text(s); print("patched", p)
