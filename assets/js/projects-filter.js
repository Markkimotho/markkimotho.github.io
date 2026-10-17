(() => {
  const filters = [...document.querySelectorAll("[data-project-filter]")];
  const groups = [...document.querySelectorAll("[data-project-category]")];
  if (!filters.length || !groups.length) return;

  const categories = new Set(groups.map((group) => group.dataset.projectCategory));
  const selectedCategory = () => {
    const hash = decodeURIComponent(window.location.hash.slice(1));
    return categories.has(hash) ? hash : "all";
  };

  function applyFilter() {
    const selected = selectedCategory();
    for (const group of groups) {
      group.hidden = selected !== "all" && group.dataset.projectCategory !== selected;
    }
    for (const filter of filters) {
      const active = filter.dataset.projectFilter === selected;
      filter.classList.toggle("is-active", active);
      if (active) filter.setAttribute("aria-current", "true");
      else filter.removeAttribute("aria-current");
    }
  }

  for (const filter of filters) {
    filter.addEventListener("click", (event) => {
      event.preventDefault();
      window.history.pushState(null, "", filter.href);
      applyFilter();
      document.getElementById(filter.dataset.projectFilter).scrollIntoView({
        behavior: "smooth",
        block: "start",
      });
    });
  }

  window.addEventListener("popstate", applyFilter);
  window.addEventListener("hashchange", applyFilter);
  applyFilter();
})();
