<!-- INVENTED EXAMPLE. The skill never applies this file.
     Copy it to ~/.claude/cold-start-brief-profile.md, replace every value, and delete this comment.
     Keep secrets out: name where they live, never their values. -->

# cold-start-brief profile

## User
- Riley, the only maintainer at Juniper Lane Labs. Use "Riley" in handoffs.
- Ask decisions as two to four choices, recommended first.

## Machine and shell
- macOS with zsh. Python runs as `python3`.

## Workspace
- Every project is its own repo under `~/work/<project>`.
- Shared lessons are in `~/work/notes/lessons.md`.

## Git
- Commit with the identity already configured for the folder. Never change it.
- Work on a `change/<topic>` branch and open a pull request. Riley merges.

## Hosts
- `buildbox` runs the nightly builds. It is read-only for agents.

## Secrets
- Values live in the team's password manager. Never open `.env` files.

## Standing limits
- No force-push, because other checkouts track the same branches.
- Ask before adding a dependency, because Riley reviews each one's license.
- Subagents: one reviewer on a cheaper model.

## Delivery
- Save handoffs in the project root and don't commit them.
