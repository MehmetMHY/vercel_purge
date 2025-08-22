# Vercel Purge

## About

A command-line tool to clean up [Vercel](https://vercel.com/) deployments by removing all deployments from selected projects.

Vercel's default behavior is to retain all deployments indefinitely, including preview deployments, to facilitate features like instant rollbacks and historical references. While this ensures accessibility, it can lead to deployment sprawl and potential security concerns with old versions remaining accessible.

Managing these accumulated deployments manually through the web interface is time-consuming and impractical for projects with many deployments. `vercel_purge` automates this cleanup process, providing a simple command-line interface to bulk-remove deployments from your Vercel projects.

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
# complete interactive mode (user controlled/input)
vercel_purge

# remove all deployments from a specific project
vercel_purge --project my-project

# remove all deployments from ALL projects (with confirmation)
vercel_purge --project all

# skip confirmation prompts
vercel_purge --project all --force
```

### Options

- `-p, --project PROJECT` - Specify target project name or "all" for all projects
- `-f, --force` - Skip confirmation prompts
- `-l, --list` - List all available projects and exit
- `-s, --status` - Show status of projects

### Examples

```bash
# list all your Vercel projects
vercel_purge --list

# check status of all projects
vercel_purge --status

# check status of specific project
vercel_purge --status --project my-app

# clean up specific project without prompts
vercel_purge --project my-app --force

# remove all deployments from all projects
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

## License

This project is licensed under the **GNU General Public License v3.0** and see the [LICENSE](LICENSE) file for details.
