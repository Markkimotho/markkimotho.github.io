---
layout: page
permalink: /repositories/
title: Repositories
description: Code, experiments, and work in progress.
nav: true
nav_order: 4
portfolio_section: repositories
---

The [Projects]({{ '/projects/' | relative_url }}) page holds individual project notes. These cards show details directly from GitHub for the repositories I've chosen to show here. Browse [all repositories](https://github.com/Markkimotho?tab=repositories) for the rest.

<section class="repository-group" aria-labelledby="github-overview">
  <div class="project-group-heading">
    <h2 id="github-overview">GitHub activity</h2>
  </div>
  <div class="github-overview">
  {% for user in site.data.repositories.github_users %}
    {% include repository/repo_user.liquid username=user %}
  {% endfor %}
  </div>
</section>

<section class="repository-group" aria-labelledby="selected-repositories">
  <div class="project-group-heading">
    <h2 id="selected-repositories">Selected repositories</h2>
    <span>{{ site.data.repositories.github_repos.size }} repositories</span>
  </div>
  <div class="github-repository-grid">
  {% for repo in site.data.repositories.github_repos %}
    {% include repository/repo.liquid repository=repo %}
  {% endfor %}
  </div>
</section>
