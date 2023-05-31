require 'securerandom'
require 'stringio'

def kitchen_template(src, dst, root = false)
  if src_path = kitchen_template_file(src)
    src_erb = StringIO.new(ERB.new(File.read(src_path)).result(binding))
    upload!(src_erb, dst) unless root
    sudo_upload!(src_erb, dst) if root

    info "Template: #{src} -> #{dst}"
  else
    error "Template file #{src} could not be found!"
  end
end

def kitchen_template_file(src)
  if File.exist?((file = "config/deploy/#{fetch(:stage)}/#{src}.erb"))
    return file
  elsif File.exist?((file = "config/deploy/shared/#{src}.erb"))
    return file
  elsif File.exist?((file = "config/deploy/templates/#{src}.erb"))
    return file
  elsif File.exist?((file = File.expand_path("../templates/#{src}.erb", __FILE__)))
    return file
  end

  nil
end

def sudo_upload!(local_path, remote_path, mode: '644', owner: 'root:root')
  tmp_path = "/tmp/#{SecureRandom.uuid}"

  upload!(local_path, tmp_path)

  execute :sudo, :mkdir, '-p', File.dirname(remote_path)
  execute :sudo, :mv, '-f', tmp_path, remote_path
  execute :sudo, :chmod, mode, remote_path
  execute :sudo, :chown, owner, remote_path
end