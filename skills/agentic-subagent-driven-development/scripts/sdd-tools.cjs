#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

function fail(message, code = 2) {
  process.stderr.write(`${message}\n`);
  process.exit(code);
}

function runGit(args, cwd = process.cwd()) {
  const result = spawnSync("git", args, {
    cwd,
    encoding: "utf8",
    windowsHide: true,
  });
  if (result.error) fail(`git failed: ${result.error.message}`);
  if (result.status !== 0) {
    fail((result.stderr || result.stdout || `git ${args.join(" ")} failed`).trim());
  }
  return result.stdout.trimEnd();
}

function resolvePlan(planArg) {
  if (!planArg) fail("missing PLAN_FILE");
  const plan = path.resolve(planArg);
  if (!fs.existsSync(plan) || !fs.statSync(plan).isFile()) {
    fail(`no such plan file: ${plan}`);
  }
  return plan;
}

function workspaceFor(plan) {
  const root = path.resolve(runGit(["rev-parse", "--show-toplevel"]));
  const raw = path.basename(plan, path.extname(plan));
  const slug = raw.replace(/[^A-Za-z0-9._-]+/g, "-").replace(/^-+|-+$/g, "");
  if (!slug || slug === "." || slug === "..") fail(`cannot derive plan name: ${plan}`);
  const base = path.join(root, ".agentic", "sdd");
  const workspace = path.join(base, slug);
  fs.mkdirSync(workspace, { recursive: true });
  fs.writeFileSync(path.join(base, ".gitignore"), "*\n", "utf8");
  return workspace;
}

function commandWorkspace(args) {
  const plan = resolvePlan(args[0]);
  process.stdout.write(`${workspaceFor(plan)}\n`);
}

function commandBrief(args) {
  const plan = resolvePlan(args[0]);
  const taskNumber = Number.parseInt(args[1], 10);
  if (!Number.isInteger(taskNumber) || taskNumber < 1) fail("TASK_NUMBER must be positive");

  const lines = fs.readFileSync(plan, "utf8").split(/\r?\n/);
  const selected = [];
  let active = false;
  let fence = null;

  for (const line of lines) {
    const fenceMatch = line.match(/^\s*(```+|~~~+)/);
    if (fenceMatch) {
      if (!fence) fence = fenceMatch[1][0];
      else if (fence === fenceMatch[1][0]) fence = null;
    }

    if (!fence) {
      const heading = line.match(/^#{1,6}\s+Task\s+(\d+)(?:\D|$)/i);
      if (heading) {
        const current = Number.parseInt(heading[1], 10);
        if (active && current !== taskNumber) break;
        active = current === taskNumber;
      }
    }

    if (active) selected.push(line);
  }

  const content = selected.join("\n").trim();
  if (!content) fail(`task ${taskNumber} not found in ${plan}`, 3);
  const output = args[2]
    ? path.resolve(args[2])
    : path.join(workspaceFor(plan), `task-${taskNumber}-brief.md`);
  fs.mkdirSync(path.dirname(output), { recursive: true });
  fs.writeFileSync(output, `${content}\n`, "utf8");
  process.stdout.write(`${output}\n`);
}

function commandReviewPackage(args) {
  const plan = resolvePlan(args[0]);
  const base = args[1];
  const head = args[2];
  if (!base || !head) fail("review-package requires BASE_SHA and HEAD_SHA");
  runGit(["rev-parse", "--verify", base]);
  runGit(["rev-parse", "--verify", head]);
  const shortBase = runGit(["rev-parse", "--short", base]);
  const shortHead = runGit(["rev-parse", "--short", head]);
  const output = args[3]
    ? path.resolve(args[3])
    : path.join(workspaceFor(plan), `review-${shortBase}..${shortHead}.diff`);
  fs.mkdirSync(path.dirname(output), { recursive: true });
  const sections = [
    `# Review package: ${base}..${head}`,
    "",
    "## Commits",
    runGit(["log", "--oneline", `${base}..${head}`]),
    "",
    "## Files changed",
    runGit(["diff", "--stat", `${base}..${head}`]),
    "",
    "## Diff",
    runGit(["diff", "-U10", `${base}..${head}`]),
    "",
  ];
  fs.writeFileSync(output, sections.join("\n"), "utf8");
  process.stdout.write(`${output}\n`);
}

const [command, ...args] = process.argv.slice(2);

switch (command) {
  case "workspace":
    commandWorkspace(args);
    break;
  case "brief":
    commandBrief(args);
    break;
  case "review-package":
    commandReviewPackage(args);
    break;
  default:
    fail(
      "usage: sdd-tools.cjs workspace PLAN_FILE | brief PLAN_FILE TASK_NUMBER [OUTFILE] | review-package PLAN_FILE BASE_SHA HEAD_SHA [OUTFILE]"
    );
}
