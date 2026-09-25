# AGENTS.md — `~/code` workspace

`~/code` is the **workspace root**, not a git repository. Every project inside it is an
independent repo with its own history, remote, and CI. This file describes the layout and
the rules that apply across the whole workspace.

```
~/code
├── apps/    microservices, backend services, frontend apps, monorepos
├── libs/    shared libraries, component libraries, SDKs, shared tooling
├── ops/     IaC, GitOps, Helm charts, cluster/runbook config
├── docs/    HTML/PDF/notes — architecture docs, slide decks, site sources
└── ws/      workstation setup — dotfiles, OS install automation
```

---

## The one hard rule: local system changes go back into `ws/`

**If you install software, change a config, add a shell alias, install a plugin, enable a
service, or otherwise mutate this machine while working inside `~/code`, you must update the
matching repo in `~/code/ws` in the same task** (unless the user says otherwise). Machine
state that is not captured in `ws/` is state that disappears on the next reinstall and cannot
be reproduced on a second machine.

| What you changed | Where it belongs in `ws/` |
|---|---|
| Shell rc, prompt, aliases, ble.sh/fzf setup | `ws/dotfiles/bash/` |
| Any `~/.config/<tool>` file you edit or create | `ws/dotfiles/<tool>/` (mirror the real home path inside) |
| A tool you `pip`/`npm`/`cargo`/`pacman` installed system-wide | add to `ws/arch-install/distro/apps.csv` and/or `install-apps.sh` |
| Keyboard, WM, terminal, editor, tmux, git prompt, workmux config | the matching `ws/dotfiles/<tool>/` package |
| A new machine-setup step you scripted by hand | `ws/arch-install/<distro>/install-apps.sh` |
| A keybinding or shortcut you added outside the config file | `ws/arch-install/distro/shortcuts.adoc` |

Procedure for a `ws/` update:

1. **Edit the real source in `ws/`**, not the symlink target. `~/code/ws/dotfiles` is the
   source of truth; `~/.config/...` are stow symlinks pointing into it, so editing the live
   file usually writes through — verify which one you touched.
2. **Prefer `stow --adopt`** for a config that already exists on the machine and is not yet
   tracked; it pulls the live file into the repo. Then `git add -A`.
3. **Keep the stow layout intact**: every package dir mirrors the real home path inside it
   (`nvim/.config/nvim/init.lua` → `~/.config/nvim/init.lua`). Do not flatten a package.
4. **Keep the `PACKAGES` list in `ws/dotfiles/setup.sh` in sync** when you add a package dir.
5. **Update the `README.md` table** in `ws/dotfiles/` when you add or move a package.
6. **Update the rows in this file's table above** if a new category of change now exists.
7. Do **not** commit unless the user asks. Leave the change staged-ready and say what you touched.

Apps in `ws/arch-install` are tailored to one machine. When you add an entry, keep the CSV
format and keep the install scripts idempotent.

---

## `apps/` — deployable software

Services, APIs, frontends, and monorepos. Each entry is its own git repo.

- One repo per deployable unit, named after what it is (`registerwerk/`), not how it's built.
- Read that repo's own `AGENTS.md` / `CLAUDE.md` first — it is more specific than this file and
  wins on any conflict. This file only governs cross-workspace concerns.
- Local run artifacts (build output, `.env`, `node_modules`, `target/`) stay untracked in the
  repo's own `.gitignore`. Never commit secrets — `.env.example` only.
- If an app needs a new service it does not own (DB, queue, cache), do not add it to
  `docker-compose.yml` by hand without also wiring it in `ops/`.

## `libs/` — shared, published code

Libraries, component libraries, SDKs, shared build tooling. Consumed by more than one app,
or destined for publication.

- A thing belongs here only when at least two consumers exist, or it is intentionally public.
  App-private code stays in the app.
- Depend on libs from apps by **git submodule or package registry**, never by relative path
  into `../libs/`. The repos are independent and must stay clonable on their own.
- `ws/dotfiles/workmux` is the pattern to copy for cross-repo worktrees: a small config that
  opens each repo in its own tmux window.

## `ops/` — infrastructure and delivery

Terraform/OpenTofu, Ansible, Flux/ArgoCD GitOps, Helm charts, cluster config, runbooks.

- IaC is declarative and reviewed. Do not hand-edit live infrastructure — change the repo and
  apply.
- Secrets are referenced, never stored: use SOPS/age or an external secret store, and commit
  only `.sops.yaml` and encrypted files.
- Charts live at `ops/charts/<chart>/`; environments at `ops/environments/<env>/`. Helm values
  are environment overlays, not copies of a base file.
- A Helm chart or manifest change must come with the app version bump it targets.

## `docs/` — documents and artifacts

HTML, PDF, Markdown, slide decks, site sources.

- Prefer Markdown as the source; generate PDF/HTML from it. Do not hand-edit generated output.
- Site sources (e.g. Jekyll in `docs/ityreh.github.io/`) keep their own build config and
  `.gitignore` conventions.
- Slide decks go in `docs/slides/`, named `YYYY-MM-DD-topic`.
- Architecture docs for an app belong in that app's repo under its `docs/`, not here. This
  folder is for cross-project and personal material.

---

## Working agreements

- **Verify before writing.** Check whether a tool, library, or script already exists in the
  workspace before adding a second one.
- **Run the project's own checks.** Lint, typecheck, and tests come from the repo's
  `package.json` / `Makefile` / `pom.xml`. Never assume a command; read the config.
- **Don't commit, push, or create PRs** unless explicitly asked.
- **Don't reformat or "tidy"** code you weren't asked to touch.
- Say plainly what you changed in `ws/` whenever you touched the machine.
