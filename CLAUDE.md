# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A personal knowledge management vault (Obsidian + Git) for Markdown notes covering tech learning, reading, projects, and more. Content syncs to a [portfolio doc site](https://portfolio.coyotedemon.xyz/) on every push to master.

## Commands

- `yarn prettier` — format all `.md` and `.json` files with Prettier
- Pre-commit hook runs `yarn test` (git grep for "byted" — a leak check) and `npx lint-staged` (Prettier on staged `.md` files)
- Pushing to `master` triggers a GitHub Actions workflow that notifies an external repo to rebuild the portfolio site

## Repository Structure

Folders use a **numbered prefix** system:

- `01journal/` — personal journal (git-ignored)
- `02learning_notes/` — technical notes organized by topic (rust, cpp, python, front_end_notes, docker, git, etc.)
- `07work/` — work content (git-ignored)
- `08reading/literature_notes/` — reading notes, organized by `tech/{year}/quarter_N.md`
- `09other/tech_provoking/` — tech tips, mac config, tools exploration
- `10personal/` — personal content (git-ignored)
- `12project/` — side project documentation
- `auto_index/` — auto-generated index pages
- `task_board/` — agenda and project tracking (git-ignored)

## Conventions

- **Language**: Notes are written in a mix of Chinese and English. Follow whichever language the surrounding content uses.
- **File naming**: lowercase with underscores (e.g., `learn_python.md`, `env_config.md`). Folders also lowercase with underscores.
- **Index files**: Many topic folders have an `index.md` or `intro.md` as entry point.
- **Image assets**: Stored alongside notes in `_imgs/` folders or `*.assets/` directories.
- **Obsidian syntax**: Files may use wikilinks (`[[note]]`), callouts (`> [!tip]`), highlights (`==text==`), and frontmatter properties. When editing `.md` files, preserve these Obsidian-flavored elements.

## Git-Ignored Content

These folders exist locally but are not tracked: `01journal/`, `07work/`, `10personal/`, `task_board/`, `.obsidian/`, `obsidian/`. The `08reading/` folder is mostly ignored except `literature_notes/` and `_imgs/`.

## Reading Notes Workflow (`/read`)

Use the `/read` command to record reading notes. The workflow:

1. User provides URL and/or notes → Claude fetches content if URL given
2. Claude suggests classification → User confirms target file
3. Claude appends entry to the target file + updates `index.md`

### File Map

All reading note files live under `08reading/literature_notes/`:

| Category | File |
|----------|------|
| Tech articles | `tech/{year}/quarter_{1-4}.md` (quarter by month: 1-3→Q1, 4-6→Q2, 7-9→Q3, 10-12→Q4) |
| Personal growth / learning / philosophy / lifestyle | `being.md` |
| Career / entrepreneurship / company analysis | `career.md` |
| Art / design / typography / games | `art_&_design.md` |
| Finance / investing / economics | `wealth_management.md` |
| News / industry trends / product launches | `tide_&_information.md` |

### Entry Format

Every entry follows this format (all files, unified with timestamp):

```
{YYYY.MM.DD HH:MM:SS} +0800

[Article Title](url)

> Notes and summary in blockquote
```

### Index Update

After writing to the target file, also update `08reading/literature_notes/index.md`:
- Append a bullet point under the matching sub-category
- Tech entries use period labels like `2026Q1`
- For the full index structure with sub-categories (sections 一~八, 6.1~6.11), read the index.md file

## Portfolio Site Integration

Some content from this repo feeds into the doc site built with Nextra/Next.js (hosted in a separate repo). The site rebuild is triggered automatically via GitHub Actions dispatch on push to master. See `12project/doc_site_portfolio/` for design details.
