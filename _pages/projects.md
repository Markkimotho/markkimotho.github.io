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

<nav class="project-filters" id="all" aria-label="Filter projects">
  <a class="project-filter is-active" href="#all" data-project-filter="all" aria-current="true">All</a>
  <a class="project-filter" href="#work" data-project-filter="work">Work</a>
  <a class="project-filter" href="#open-source" data-project-filter="open-source">Open Source</a>
  <a class="project-filter" href="#fun" data-project-filter="fun">Fun</a>
</nav>

<div class="projects">
{% if site.enable_project_categories and page.display_categories %}
  <!-- Display categorized projects -->
  {% for category in page.display_categories %}
  {% assign categorized_projects = site.projects | where: "category", category %}
  {% assign sorted_projects = categorized_projects | sort: "importance" %}
  {% if sorted_projects.size > 0 %}
  {% if category == 'open-source' %}
    {% assign category_label = 'Open Source' %}
  {% else %}
    {% assign category_label = category | capitalize %}
  {% endif %}
  <section class="project-group" id="{{ category }}" data-project-category="{{ category }}" aria-labelledby="{{ category }}-heading">
  <div class="project-group-heading">
    <h2 id="{{ category }}-heading">{{ category_label }}</h2>
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
  </section>
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
<script src="{{ '/assets/js/projects-filter.js' | relative_url }}" defer></script>
