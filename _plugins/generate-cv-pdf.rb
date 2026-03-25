# _plugins/generate-cv-pdf.rb
#
# Jekyll hook that regenerates the CV PDF from _data/cv.yml
# before the site is built, ensuring the PDF is always up to date.

Jekyll::Hooks.register :site, :after_init do |site|
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
