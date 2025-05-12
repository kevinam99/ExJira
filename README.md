# ExJira 🛠️

**ExJira** is a multitenant task management application built with [Elixir](https://elixir-lang.org/) and [Phoenix LiveView](https://hexdocs.pm/phoenix_live_view). Each user belongs to an organization, and permissions are controlled via role-based access control (RBAC). Inspired by Jira, designed for simplicity.

---

## ✨ Features

- 🔐 **Multitenant Authentication** using `phx.gen.auth`
- 🏢 **Organizations**: Users belong to a single organization
- 👥 **Role-Based Access Control**:
  - `admin`: full access
  - `manager`: can read, create, update
  - `employee`: read-only
- 📋 **Tasks**: Only visible and editable within the user’s organization
- ⚡ **LiveView UI** for seamless UX

---

## 🚀 Getting Started

### Prerequisites

- Elixir ~> 1.18.3-otp-27
- Erlang ~> 27.3.3
- Phoenix ~> 1.7
- PostgreSQL

### Setup

```bash
git clone https://github.com/kevinam99/ex_jira.git
cd ex_jira

# Install dependencies
mix deps.get

# Set up the database
mix ecto.setup
```

# Seeding the Database

Seeds include:
- 2 organizations: Acme Corp and Globex Inc
- Users for each org with admin, manager, and employee roles
- Example tasks scoped per organization


To seed, run:
```bash
mix run priv/repo/seeds.exs
```

# Running the App

```bash
mix phx.server
```

Visit http://localhost:4000
