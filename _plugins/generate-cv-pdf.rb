# _plugins/generate-cv-pdf.rb
#
# Optional Jekyll hook for sites that generate a PDF from _data/cv.yml.
# This site's supplied PDF is authoritative when generate_cv_pdf is false.

Jekyll::Hooks.register :site, :after_init do |site|
  next if site.config['generate_cv_pdf'] == false

  cv_yml = File.join(site.source, "_data", "cv.yml")
  script = File.join(site.source, "_scripts", "generate_cv_pdf.py")

  unless File.exist?(script)
    Jekyll.logger.warn "CV PDF:", "Script not found at #{script}, skipping PDF generation."
    next
  end

  unless File.exist?(cv_yml)
    Jekyll.logger.warn "CV PDF:", "cv.yml not found, skipping PDF generation."
    next
  end

  Jekyll.logger.info "CV PDF:", "Generating resume PDF from cv.yml..."
  result = system("python3", script)

  if result
    Jekyll.logger.info "CV PDF:", "Resume PDF generated successfully."
  else
    Jekyll.logger.warn "CV PDF:", "PDF generation failed (exit #{$?.exitstatus}). Continuing with existing PDF."
  end
end
