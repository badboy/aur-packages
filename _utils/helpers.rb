require 'json'
require 'cgi'
require 'open-uri'

PKG_RPC_URL = "https://aur.archlinux.org/rpc.php?type=info&arg=%s"
PKG_URL     = "https://aur.archlinux.org/packages.php?ID=%s"

PKGEXT = IO.read('/etc/makepkg.conf')[/^PKGEXT='(.+)'$/, 1]
SRCEXT = IO.read('/etc/makepkg.conf')[/^SRCEXT='(.+)'$/, 1]

def get_package_info(pkg)
  url = PKG_RPC_URL % CGI.escape(pkg)
  content = open(url).read
  data = JSON.parse(content)
  if data['type'] == 'error'
    false
  else
    data['results']
  end
end

def editor
  editor = ENV['VISUAL']
  editor ||= ENV['EDITOR']
  editor ||= "vim"
  editor
end

def source_file(pkgname)
  Dir["#{pkgname}-*#{SRCEXT}"].first
end

def package_dir(task_name, &block)
  deps = []
  if task_name.kind_of?(::Hash)
    deps = task_name.values.first
    task_name = task_name.keys.first
  end

  if deps.kind_of?(::Array)
    deps.unshift :pkgname
  else
    [:pkgname, deps]
  end

  task task_name => deps do
    Dir.chdir(@pkgname) do
      block.call
    end
  end
end

def echo(*args)
  puts args.join(" ")
end

def fatal(msg)
  abort "FATAL: #{msg}"
end


def get_yes_no msg="Ok?"
  print msg, " [Y/n] "
  yes_no = $stdin.gets

  if !yes_no.nil? && yes_no.chomp.downcase == "n"
    false
  else
    true
  end
end

def get_yes_no_abort msg="Ok?"
  if !get_yes_no(msg)
    puts "Aborting"
    exit
  end
  true
end
