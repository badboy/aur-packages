require File.join(File.dirname(__FILE__), '_utils/helpers')
Dir['_utils/*.rake'].each { |f| require f }

task :pkgname do
  @pkgname = ENV['PKG']
  if @pkgname.nil? || @pkgname.empty?
    Dir.chdir(Rake.original_dir) do
      if File.exists?('PKGBUILD')
        @pkgname = File.basename(Rake.original_dir)
      else
        fatal "need PKG"
      end
    end
  end
end

desc 'List project urls'
task :list do
  Dir["*"].sort.each do |dir|
    next unless File.directory?(dir)
    # ignore _utils dir and others
    next if dir[0] == '_'

    pkgbuild = File.join(dir, 'PKGBUILD')
    next unless File.exist?(pkgbuild)
    pkgbuild_content = IO.read(pkgbuild)

    pkg = pkgbuild_content[/pkgname=(.+)$/, 1]
    info = get_package_info(pkg)

    if info
      url = PKG_URL % info['ID']
      online_ver = info['Version']
      pkgver = pkgbuild_content[/pkgver=(.+)$/, 1]
      pkgrel = pkgbuild_content[/pkgrel=(.+)$/, 1]
      ver = "#{pkgver}-#{pkgrel}"
      ver << " \033[0;31m!\033[0m" if online_ver != ver
      ood = ''
      ood = " \033[0;31mOUT OF DATE!\033[0m" if info['OutOfDate'] != 0

      puts "%s (v%s)%s\n\t%s" % [pkg, ver, ood, url]
    else
      puts "%s\n\tnot found in AUR" % pkg
    end
  end
end

desc 'Create new package dir (PKG=<name>)'
task :new => :pkgname do
  if Dir.pwd != Rake.original_dir
    fatal 'must be executed from root dir!'
  end

  ver = ENV['VER'] || '0.0.1'

  if File.exist?(@pkgname)
    fatal "package '#{@pkgname}' exists!"
  end
  FileUtils.mkdir @pkgname
  pkgbuild = IO.read('PKGBUILD.proto')
  pkgbuild.gsub!(/^pkgname=NAME$/, "pkgname=#{@pkgname}")
  pkgbuild.gsub!(/^pkgver=VERSION$/,"pkgver=#{ver}")

  File.open(File.join(@pkgname, 'PKGBUILD'), 'w') do |f|
    f.write pkgbuild
  end
  puts "Created '#{@pkgname}' (v#{ver})"
end

namespace :new do
  desc 'Create new package and open PKGBUILD in editor'
  task :open => :new do
    file = File.join(@pkgname, 'PKGBUILD')

    puts "Open new PKGBUILD in '#{editor}'"
    sh editor, file
  end
end

desc 'Edit PKGBUILD in EDITOR'
package_dir :edit do
  file = 'PKGBUILD'

  puts "Open new PKGBUILD in '#{editor}'"
  sh editor, file
end

desc 'Use namcap to analyse package'
package_dir :namcap do
  Dir["{PKGBUILD,*#{PKGEXT}}"].each do |f|
    sh 'namcap', f
  end
end


desc 'Generate a source-only tarball without downloaded sources'
package_dir :source do
  force = !!ENV['FORCE'] || !!ENV['force']
  if force
    sh "makepkg", "--source", "--force"
  else
    sh "makepkg", "--source"
  end
end

desc 'Upload the source package to aur.archlinux.org'
package_dir :upload => :source do
  sf = source_file(@pkgname)
  fatal "source file not present" unless sf

  sh "aurploader", sf
end

desc 'Build package'
package_dir :build do
  args = []
  args << '--force' if !!ENV['FORCE'] || !!ENV['force']
  args << '--syncdeps' << '--rmdeps' if !!ENV['DEPS'] || !!ENV['deps']

  sh "makepkg", *args
end

desc 'Clean up package directory'
package_dir :clean do
  # ugly hack to extract source files
  ignore_files = `bash -c 'source PKGBUILD; for file in "${source[@]}"; do echo -n "$file|"; done;'`.split('|').reject{|f| f =~ %r{://}} +
    %w[PKGBUILD] +
    Dir['*.install'] +
    Dir['_*']

  rm_rf Dir["*"].reject { |f| ignore_files.include?(f) }
end

task :default => :list
