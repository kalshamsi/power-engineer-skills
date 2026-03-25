# Output Generation Steps

After selecting skills and filtering against already-installed ones, follow
these three steps to produce the final output.

---

## Step 1 — Build the install script

Read `references/INSTALL_SCRIPT_TEMPLATE.md` for the exact output format.
Write `install-skills.sh` to the current working directory following that
template. Sort global commands before local commands. Mark skipped skills
(already installed) as comments.

---

## Step 2 — Write PLUGIN_INSTALLS.md

Read `references/PLUGIN_INSTALLS_TEMPLATE.md` for the exact output format.
Write `PLUGIN_INSTALLS.md` to the current working directory. Highlight the
suites relevant to the user's answers at the top, and always include the
full catalog of all power suites at the bottom.

---

## Step 3 — Print summary

After writing both files, print this summary:

```
========================================
 Power Engineer Setup — Complete
========================================

Project:   [directory name]
Type:      [user's answers summary]
Stack:     [detected/chosen stack]

Skills selected:  [N] global + [N] local
Already present:  [N] skipped

Files written:
  install-skills.sh    -> review and run in terminal
  PLUGIN_INSTALLS.md   -> follow inside Claude Code

Quick start:
  chmod +x install-skills.sh && ./install-skills.sh

Then open Claude Code and follow PLUGIN_INSTALLS.md.
========================================
```
