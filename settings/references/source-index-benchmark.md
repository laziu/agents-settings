# Source Index Benchmark

Evaluate whether a project source index improves agent navigation before changing the index format.

Do not load this guide during ordinary implementation. Use it only when running an explicit benchmark.

## Conditions

| Condition | Purpose |
| --- | --- |
| `NoIndex` | Baseline with no source index |
| `CurrentIndex` | Current project index as-is |
| `RewriteIndex` | Same project index format, rewritten from source |
| `ObjectiveIndex` | Target index format, rewritten from the same source |

Comparisons:

- `NoIndex` vs others: value of having any source index
- `CurrentIndex` vs `RewriteIndex`: current content quality
- `RewriteIndex` vs `ObjectiveIndex`: target format value
- `CurrentIndex` vs `ObjectiveIndex`: practical migration value

## Case Selection

Use past changes with known before and after commits.

```yaml
id: bridge-start-simulator-project-mode
base_commit: "<change-before>"
target_commit: "<change-after>"
prompt: >
  Bridge simulator launch flow must move to the project/run contract.
  Before editing, identify areas, files, guardrails, and verification as JSON.
```

Good cases:

- Target diff has a clear logical change
- Not only formatting, renaming, or generated files
- Multiple files or responsibility boundaries
- Source navigation, guardrails, or verification choice could benefit from an index
- Includes at least one contract boundary, migration trap, build/test choice, or stale term risk

Pilot set: 8 cases.

Suggested mix:

| Type | Examples |
| --- | --- |
| Single area | Bridge tools, Agents service, Client runtime |
| Cross area | contracts + Client, Bridge + Client, Agents + contracts |
| Workflow | project-mode run output, asset locking, simulator lifecycle |
| Migration trap | RunQueue, SimulationSetup, AppData fallback |
| Verification-heavy | git hooks, Unreal build, IPC smoke |
| Context-only | project rules or source index updates |

## Gold Data

Do not show `target_commit` to the trial agent.

Create gold data from the target diff plus relevant source, specs, and docs.

```yaml
gold:
  must_read:
    - Bridge/internal/process
    - contracts/specs/bridge-ipc.md
  touched_files:
    - Bridge/internal/process/manager.go
    - Bridge/internal/protocol/messages.go
  guardrails:
    - Bridge exposes local IPC only
    - simulator process uses -OdiroProject and -RunId
  verification:
    - cd Bridge; go test ./...
    - IPC smoke for startSimulator and getRunStatus
  stale_traps:
    - -Simulate
    - SimulationSetup
    - AppData fallback
```

Fields:

- `must_read`: files or directories a good agent should inspect before editing
- `touched_files`: actual diff files; use as a secondary recall metric
- `guardrails`: repo-local constraints that affect the change direction
- `verification`: minimum relevant checks
- `stale_traps`: legacy terms or paths that must not be treated as current truth

## Fixtures

Create four worktrees from the same `base_commit`.

```text
bench/<case-id>/no-index
bench/<case-id>/current-index
bench/<case-id>/rewrite-index
bench/<case-id>/objective-index
```

Condition setup:

| Condition | Setup |
| --- | --- |
| `NoIndex` | Remove `.agents/index` or forbid reading it in the prompt |
| `CurrentIndex` | Apply the project `.agents/index` exactly as it exists at evaluation time |
| `RewriteIndex` | Keep the current project index format, but rewrite entries from source |
| `ObjectiveIndex` | Apply the explicitly requested target format |

Keep source code, specs, tests, and docs identical across conditions.

Build `RewriteIndex` and `ObjectiveIndex` from the same source of truth.

Do not rewrite `CurrentIndex`.

The `ObjectiveIndex` target format must be stated in the experiment request. If omitted, use the default target format from the project-context-bootstrap source index reference.

## Trial Prompt

Run orientation only. Do not implement.

```text
Source index benchmark trial.

Condition: <NoIndex | CurrentIndex | RewriteIndex | ObjectiveIndex>
Task: <case prompt>

Rules:
- Do not edit files.
- Do not inspect the target commit or answer diff.
- Read source, docs, and the allowed index as needed.
- Return exactly one JSON object.

Output:
{
  "areas": [],
  "files_to_read": [],
  "read_order": [],
  "guardrails": [],
  "verification": [],
  "stale_or_legacy_risks": [],
  "unknowns": []
}
```

Condition additions:

```text
NoIndex:
Do not read `.agents/index` or any source-index fixture.

CurrentIndex:
Use the project `.agents/index` exactly as provided.

RewriteIndex:
Use only the rewritten source index fixture. It uses the same format as CurrentIndex.

ObjectiveIndex:
Use only the ObjectiveIndex fixture. Follow the target format stated in this benchmark request.
```

## Repetition

Pilot:

```text
8 cases * 4 conditions * 2 runs = 64 trials
```

Use a fresh thread or isolated agent session for each trial.

Do not run multiple conditions in the same conversational context.

## Recording

Save each trial result.

```text
bench/results/<case-id>/<condition>/run-01.json
bench/results/<case-id>/<condition>/run-02.json
```

Record session metadata when available.

```yaml
model: "<model>"
agent_version: "<tool/version>"
started_at: "<iso timestamp>"
base_commit: "<hash>"
condition: ObjectiveIndex
```

Also record:

- Files actually read
- Tool call count
- Elapsed time to orientation output
- Prompt violations or failures

## Metrics

| Metric | Calculation |
| --- | --- |
| `must_read_recall` | Gold `must_read` covered by `files_to_read` or `read_order` |
| `touched_file_recall` | Gold `touched_files` mentioned |
| `read_precision` | Mentioned read targets that are gold-relevant |
| `irrelevant_read_count` | Mentioned read targets unrelated to gold |
| `guardrail_recall` | Gold guardrails covered semantically |
| `verification_recall` | Gold verification covered semantically |
| `stale_trap_count` | Gold stale traps treated as current truth |
| `tool_calls` | Calls before orientation output |
| `elapsed_seconds` | Time to orientation output |

Automate path and keyword recall where practical.

Review guardrails, verification, and stale traps manually.

## Qualitative Score

Score each trial 0-2.

| Area | 0 | 1 | 2 |
| --- | --- | --- | --- |
| Area choice | misses core area | partial | appropriate |
| Read order | random or broad | usable | minimal path |
| Guardrails | misses risky rules | partial | core constraints |
| Verification | wrong or vague | partial | minimal sufficient |
| Stale handling | treats legacy as current | ambiguous | separates legacy |

## Implementation Trials

Run implementation only after orientation metrics show a meaningful difference.

Suggested scope:

```text
3 cases * 4 conditions * 1 run = 12 implementation trials
```

Additional metrics:

- Target intent satisfied
- Unnecessary file edits
- Test choice quality
- Stale contract reintroduced
- Source index update missed
- Review findings

Use implementation trials as supporting evidence. Base the decision on orientation metrics.

## Decision

Adopt `ObjectiveIndex` when:

- `must_read_recall` is at least as good as `CurrentIndex`
- `irrelevant_read_count`, `tool_calls`, or `elapsed_seconds` improve over `CurrentIndex`
- `guardrail_recall` and `verification_recall` improve over `NoIndex`
- `stale_trap_count` does not increase
- Navigation savings justify index maintenance cost

Interpretation:

- `RewriteIndex` close to `ObjectiveIndex`: rewrite quality matters more than target format
- `CurrentIndex` far from `RewriteIndex`: current content quality is the main issue
- All index conditions close to `NoIndex`: source index may not justify maintenance

## Request Templates

Case selection:

```text
Pick 8 past-change cases for a source index benchmark.
For each case, provide base_commit, target_commit, prompt, and draft gold data.
Do not create worktrees or edit files yet.
```

Fixture preparation:

```text
Prepare fixtures for selected source index benchmark cases.
Conditions: NoIndex, CurrentIndex, RewriteIndex, ObjectiveIndex.
Source code and docs must match base_commit across all conditions.
Build RewriteIndex and ObjectiveIndex from the same source of truth.
ObjectiveIndex target format: <project-specific target format or project-context-bootstrap default>.
```

Trial execution:

```text
Run a source index benchmark trial.
case: <case-id>
condition: <condition>
run: <run-number>
Do not implement. Save only the orientation JSON.
```

Result aggregation:

```text
Aggregate benchmark results.
Compare must_read_recall, read_precision, guardrail_recall, verification_recall, stale_trap_count, tool_calls, and elapsed_seconds by condition.
Recommend whether to adopt ObjectiveIndex.
```
