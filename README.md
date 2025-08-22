# Vercel Purge

A command-line tool to clean up [Vercel](https://vercel.com/) deployments by removing all unused deployments from selected projects.

## Installation

```bash
./install.sh
```

This will install the `vercel_purge` command globally and ensure all dependencies (Python 3, Node.js, Vercel CLI) are available.

## Setup

Before using this tool, you must authenticate with Vercel:

```bash
vercel login
```

Follow the prompts to log in to your Vercel account. This only needs to be done once.

## Usage

### Basic Usage

```bash
# Interactive mode - pick a project from the list
vercel_purge

# Remove all deployments from a specific project
vercel_purge --project my-project

# Remove all deployments from ALL projects (with confirmation)
vercel_purge --project all

# Skip confirmation prompts
vercel_purge --project all --force
```

### Options

- `-p, --project PROJECT` - Specify target project name or "all" for all projects
- `-f, --force` - Skip confirmation prompts
- `-l, --list` - List all available projects and exit
- `-s, --status` - Show status of projects

### Examples

```bash
# List all your Vercel projects
vercel_purge --list

# Check status of all projects
vercel_purge --status

# Check status of specific project
vercel_purge --status --project my-app

# Clean up specific project without prompts
vercel_purge --project my-app --force

# Nuclear option - remove ALL deployments from ALL projects
vercel_purge --project all --force
```

## Requirements

- Python 3
- Node.js and npm
- Vercel CLI (`npm i -g vercel`)
- Active Vercel account with projects

## Uninstall

```bash
./uninstall.sh
```
