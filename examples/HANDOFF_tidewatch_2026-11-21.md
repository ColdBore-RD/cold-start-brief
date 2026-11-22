<!--
SAMPLE, not complete enough to run as is. cold-start-brief 0.1.0 wrote it on Claude Sonnet 5.5 for the invented project in sample-project/, with no profile.
Two edits for publication: the scratch path became a placeholder, and the paragraphs quoted from the model guide became a link.
-->

<!--
Target: Claude Sonnet 5.5 (claude-sonnet-5-5), no subagents.
Suggested effort: medium (guide: medium for well-specified agentic coding tasks).
Guidance used, 2026-11-21: prompting-claude-sonnet-5-5 (fetched with WebFetch). NOT checked: the prompt-engineering overview page, and only the opening of the best-practices page was read.
Start: a new session in the project folder (below), local CLI, Windows 11, PowerShell. Nobody is available to answer questions.
Paste everything below the line.
-->

---

# Handoff: tidewatch should skip empty heights

## Mission

Make `tidewatch` skip CSV rows whose `height_m` is empty instead of crashing. The test for this already exists and fails. Make it pass, keep the other test passing, confirm the command-line behavior on the fixture, and report. Nobody can answer questions during this session, so this brief lists the assumptions to use.

<context>
- Project folder: `<path-to>/tidewatch`
- Windows 11, PowerShell primary. Whether `python` is on PATH was not checked; if `python` fails, try `py`.
- The folder is not a git repository. Don't run `git init` and don't commit.
- Standard library only (from `AGENTS.md`). Add no dependencies.
- There is no user profile file, so no personal conventions apply.
</context>

<scout_report>
Observed on 2026-11-21 (all files read directly):

- `tidewatch.py`: `THRESHOLD_M = 3.2`. `high_readings(rows, threshold=THRESHOLD_M)` returns `[row for row in rows if float(row["height_m"]) > threshold]`. `float("")` raises `ValueError`, which is the crash. The `__main__` block opens `sys.argv[1]` with `csv.DictReader` and prints `row["time"], row["height_m"]` for each result.
- `tests/test_tidewatch.py`: two tests. `test_keeps_readings_above_threshold` (rows 3.1 and 3.4, expects only 3.4) and `test_skips_empty_height` (`[{"height_m": ""}]` expects `[]`). Per `STATUS.md`, the second test fails today. I did not run the tests.
- `readings.csv`: header `time,height_m`, four rows. The 14:40 row has an empty height. This is a fixture: `AGENTS.md` forbids editing it to make tests pass.
- `AGENTS.md`: standard library only; test with `python -m unittest discover -s tests`; don't edit `readings.csv` to make tests pass.
- `STATUS.md` (updated 2026-11-15): Next is "skip rows with an empty height instead of crashing". The default threshold changed from 3.0 to 3.2 m on 2026-11-14 and the README was not updated.
- `README.md`: says the default threshold is 3.0 m. This is stale.

Conflict and trust order: the code says 3.2, the README says 3.0. Trust the code (live state), then `STATUS.md`, then the README.

Not checked: whether Python is installed, which Python version, and whether the tests currently fail as `STATUS.md` says.

Out of scope: threshold changes, the README threshold text, new features, a refactor of the command-line block, and edits to `readings.csv`.
</scout_report>

<assumptions>
Nobody can confirm these. Use them and list them again in the final report.

1. "Empty height" means an empty string or whitespace-only string in `height_m`. A missing value (`None`, which `csv.DictReader` produces for a short row) is also treated as empty, because it is the same failure from the user's view.
2. A non-empty value that is not a number (for example `abc`) is not an empty height. Let it keep raising `ValueError`. Hiding bad data is a separate decision that nobody has made.
3. Skipped rows produce no output and no warning. The request asks to skip them, and the test expects a plain empty result.
4. The fix goes inside `high_readings` so both the library function and the command line benefit.
5. The 3.2 m threshold in the code is correct. The README is stale, but fixing it was not requested, so report it rather than change it.
6. Updating `STATUS.md` is part of normal handoff upkeep and is allowed.
</assumptions>

## Work items

1. **Fix `high_readings`** in `tidewatch.py:8-9`. Skip a row when its `height_m` is `None` or blank after stripping; otherwise compare `float(...)` to the threshold as before. Why: this is the crash named in `STATUS.md`. Verify: `python -m unittest discover -s tests` passes both tests.
2. **Check the command line on the fixture.** Run `python tidewatch.py readings.csv`. Expected output, given a 3.2 threshold: `2026-11-14T08:25 3.4` and `2026-11-14T20:55 3.3`, with no traceback. Why: the unit test covers the function, not the `csv.DictReader` path.
3. **Cover the extra cases from the assumptions** only if a small change to the existing test file does it (whitespace-only and `None`). One or two short tests are enough. Why: assumption 1 goes beyond what the existing test checks. Verify: the full suite passes, and the existing two tests are unchanged.
4. **Update `STATUS.md`**: set `Updated:` to 2026-11-21, change `Next:` to say the empty-height work is done (or name the real next step), and remove the line saying the test fails. Leave the threshold/README note in place, since it is still true.

<approvals>
Can do without asking:
- Edit `tidewatch.py`, `tests/test_tidewatch.py` (adding tests only) and `STATUS.md`.
- Run the unit tests and run `python tidewatch.py readings.csv`.
- Write scratch files in the session scratchpad.

Ask first (nobody is here, so default to not doing it and list it in the final report):
- Changing the threshold or the README text.
- Treating non-numeric heights as skippable.
- Adding warnings, logging, or command-line options.
- Installing anything.

Hard limits:
- Don't edit `readings.csv`. `AGENTS.md` says it is a fixture, and editing it would hide a real failure.
- Don't weaken or delete the existing tests, because that would make a pass meaningless.
- Don't add third-party dependencies. The project is standard library only.
- Don't commit or run `git init`. The folder is not a repository and nobody asked for one.
- Don't open `.env` files or credential stores. None were seen in the project.
</approvals>

<sonnet_5_5_guidance>
[A real handoff carries the paragraphs fetched from the Sonnet 5.5 guide here, with their exact wording. This public sample leaves them out. Fetch them from:
https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-sonnet-5-5 ]
</sonnet_5_5_guidance>

<task>
Suggested order (change it if you have a reason): run the tests once to confirm the failure, make the fix (item 1), run the tests, run the command on the fixture (item 2), add the small extra tests if they fit (item 3), update `STATUS.md` (item 4), and run the full suite one last time.

Done means:
- `python -m unittest discover -s tests` passes, and you saw the output.
- `python tidewatch.py readings.csv` prints exactly the two expected lines and no traceback.
- `readings.csv` is unchanged, and the two original tests are unchanged.
- `STATUS.md` reflects the new state.
- No files were added other than this handoff, and no dependencies were added.

Final message must report:
- What changed, file by file.
- The test and command output you actually saw, or which check you could not run and why.
- The assumptions you used (list the six above, noting any you changed).
- Open approvals: the stale README threshold (3.0 vs 3.2), and whether non-numeric heights should be skipped.
</task>
