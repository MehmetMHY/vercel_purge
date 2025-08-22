#!/usr/bin/env python3

import subprocess
import argparse
import shutil
import sys
import os
import re


def run(cmd):
    return subprocess.run(cmd, shell=True, capture_output=True, text=True).stdout


def clean_text(text):
    return re.sub(
        r"[\U0001f600-\U0001f64f\U0001f300-\U0001f5ff\U0001f680-\U0001f6ff\U0001f700-\U0001f77f\U0001f780-\U0001f7ff\U0001f800-\U0001f8ff\U0001f900-\U0001f9ff\U0001fa00-\U0001fa6f\U0001fa70-\U0001faff\U00002702-\U000027b0\U000024c2-\U0001f251]+",
        "",
        text,
    )


def get_projects():
    projects = []
    for line in run("vercel project 2>&1").split("\n"):
        if "http" in line:
            projects.append(line.strip().split()[0])
    return projects


def get_status(project=None):
    output = {}
    for line in run("vercel project 2>&1").split("\n"):
        if "http" in line:
            parts = line.strip().split()
            name, url = parts[0], parts[1]
            if project and name != project:
                continue
            output[name] = {}
            for l in run(f"vercel inspect {url} 2>&1").split("\n"):
                l = l.strip()
                if l.startswith("status"):
                    output[name]["status"] = clean_text(l.replace("status", "")).strip()
                elif l.startswith("url"):
                    output[name]["url"] = clean_text(l.replace("url", "")).strip()
                elif l.startswith("created"):
                    output[name]["created"] = clean_text(
                        l.replace("created", "")
                    ).strip()
                    break

    for i, (k, v) in enumerate(output.items()):
        print(f"{k}:")
        print(f"- Status: {v['status']}")
        print(f"- URL: {v['url']}")
        print(f"- Created: {v['created']}")
        if i < len(output) - 1:
            print()


def get_deployments(project):
    return [p.strip() for p in run(f"vercel ls {project}").split("\n")[1:] if p.strip()]


def safe_input(prompt):
    try:
        return input(prompt)
    except (KeyboardInterrupt, EOFError):
        print("\nOperation cancelled by user")
        sys.exit(1)


def pick_project(projects):
    while True:
        print("Pick A Project:")
        for i, name in enumerate(projects):
            print(f"{i}) {name}")
        print(f"{len(projects)}) ALL PROJECTS")

        try:
            choice = int(safe_input("Choice: "))
            if 0 <= choice <= len(projects):
                return choice
        except ValueError:
            pass
        print("Invalid input!")


def main():
    parser = argparse.ArgumentParser(description="Vercel deployment cleanup tool")
    parser.add_argument(
        "-f", "--force", action="store_true", help="Skip confirmation prompts"
    )
    parser.add_argument("-p", "--project", help="Specify target project name")
    parser.add_argument(
        "-l", "--list", action="store_true", help="List all available projects and exit"
    )
    parser.add_argument(
        "-s", "--status", action="store_true", help="Show status of projects"
    )
    args = parser.parse_args()

    if not shutil.which("vercel"):
        print("ERROR: Vercel CLI not found. Install from: https://vercel.com/docs/cli")
        sys.exit(1)

    projects = get_projects()
    if not projects:
        print("No projects found")
        sys.exit(0)

    if args.list:
        for p in projects:
            print(p)
        sys.exit(0)

    if args.status:
        get_status(args.project)
        sys.exit(0)

    if args.project:
        if args.project.upper() == "ALL":
            selected = projects
        elif args.project in projects:
            selected = [args.project]
        else:
            print(f"Error: Project '{args.project}' not found")
            sys.exit(1)
    else:
        choice = pick_project(projects)
        selected = projects if choice == len(projects) else [projects[choice]]

    cmds = []
    for project in selected:
        deployments = get_deployments(project)
        if not deployments:
            print(f"No deployments to remove for '{project}'")
            continue
        cmds.extend([f"vercel rm {d} -y" for d in deployments])

    if not cmds:
        print("No deployments to remove")
        sys.exit(0)

    print("Will Run Command(s):")
    for cmd in cmds:
        print(cmd)

    if not args.force:
        response = safe_input("Continue (y/n)? ").lower().strip()
        if response not in ["y", "yes"]:
            sys.exit(1)

    for cmd in cmds:
        os.system(cmd)


if __name__ == "__main__":
    try:
        main()
    except (KeyboardInterrupt, EOFError):
        print("\nOperation cancelled by user")
        sys.exit(1)
