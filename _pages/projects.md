---
layout: page
title: Projects
permalink: /projects/
description: A growing collection of my projects made for work and fun alike.
description_as_heading: true
nav: true
nav_order: 3
display_categories: [work, open-source, fun]
horizontal: true
portfolio_section: projects
---

The selected work on the [homepage]({{ '/' | relative_url }}) is a starting point. This archive includes applications, tools, and experiments. Each entry opens a project page with more detail; the [full repository list](https://github.com/Markkimotho?tab=repositories) is on GitHub.

<!-- pages/projects.md -->

<div class="projects">
{% if site.enable_project_categories and page.display_categories %}
  <!-- Display categorized projects -->
  {% for category in page.display_categories %}
  {% assign categorized_projects = site.projects | where: "category", category %}
  {% assign sorted_projects = categorized_projects | sort: "importance" %}
  {% if sorted_projects.size > 0 %}
  <div class="project-group-heading" id="{{ category }}">
    <h2>{{ category | replace: '-', ' ' }}</h2>
    <span>{{ sorted_projects.size }} projects</span>
  </div>
  <!-- Generate cards for each project -->
  {% if page.horizontal %}
  <div class="container">
    <div class="row row-cols-1">
    {% for project in sorted_projects %}
      {% include projects_horizontal.liquid %}
    {% endfor %}
    </div>
  </div>
  {% else %}
  <div class="row row-cols-1 row-cols-md-3">
    {% for project in sorted_projects %}
      {% include projects.liquid %}
    {% endfor %}
  </div>
  {% endif %}
  {% endif %}
  {% endfor %}

{% else %}

<!-- Display projects without categories -->

{% assign sorted_projects = site.projects | sort: "importance" %}

<!-- Generate cards for each project -->

{% if page.horizontal %}

<div class="container">
    <div class="row row-cols-1">
    {% for project in sorted_projects %}
      {% include projects_horizontal.liquid %}
    {% endfor %}
    </div>
  </div>
  {% else %}
  <div class="row row-cols-1 row-cols-md-3">
    {% for project in sorted_projects %}
      {% include projects.liquid %}
    {% endfor %}
  </div>
  {% endif %}
{% endif %}
</div>
