def template(from, to)
  if erb_path = template_file(from)
    erb = StringIO.new(ERB.new(File.read(erb_path)).result(binding))
    upload! erb, to
    info "copying: #{erb} to: #{to}"
  else
    error "error #{from} not found"
  end
end

def template_file(name)
  if File.exist?((file = "config/deploy/shared/#{name}"))
    return file
  end
  return nil
end
