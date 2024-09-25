require 'rake'
require 'pathname'

task default: :install

DOTFILES_DIR = File.dirname(__FILE__)
ICLOUD_DRIVE = File.join(Dir.home, "Library/Mobile Documents/com~apple~CloudDocs")
LINK_WITHIN = %w[config]
EXCLUDE = %w[Rakefile README.md .gitmodules ssh Library iTerm babushka-deps].concat(LINK_WITHIN)
LINK_VISIBLY = %w[bin lib]
LINKABLES = (Dir.glob('*') - EXCLUDE).concat(
  LINK_WITHIN.flat_map {|dir| Dir.glob(dir + '/*') }
).sort

desc "Install dotfiles"
task :install do
  LINK_WITHIN.each do |dir|
    path = File.join(Dir.home, ".#{dir}")
    system "mkdir -p #{path}" unless File.exist?(path)
  end

  each_linkable { |source, link| make_link(source, link) }

  monotonic_clock = File.join(DOTFILES_DIR, "bin", "monotonic-clock")
  unless File.exist?(monotonic_clock)
    %x[gcc #{File.join(DOTFILES_DIR, "lib", "monotonic-clock.c")} -o #{monotonic_clock}]
  end
end

desc "Remove dotfiles"
task :remove do
  each_linkable { |source, link| remove_link(source, link) }
end

desc "Keep SSH_AUTH_SOCK for screen / tmux sessions"
task :ssh do
  linkables = Dir.glob('ssh/*').map { |l| File.basename(l) }
  linkables.each do |file|
    source = File.join(DOTFILES_DIR, "ssh", file)
    link = File.join(Dir.home, ".ssh", file)
    make_link(source, link)
  end
end

desc "Install custom macOS keybindings"
task :keybindings do
  file = "Library/KeyBindings/DefaultKeyBinding.dict"
  system "mkdir -p #{File.join(Dir.home, 'Library/KeyBindings')}"
  make_link(
    File.join(DOTFILES_DIR, file),
    File.join(Dir.home, file)
  )
end

desc "Compile terminals"
task :terminals do
  Dir.glob('terminals/*').map do |terminfo|
    %x[tic #{File.join(DOTFILES_DIR, terminfo)}]
  end
end

desc "Symlink iCloud Drive"
task :link_icloud_drive do
  make_link(
    File.join(Dir.home, ICLOUD_DRIVE),
    File.join(Dir.home, 'iCloud-Drive'),
  )
end

desc "Symlink lib"
task :link_lib do
  make_link(
    File.join(DOTFILES_DIR, 'lib'),
    File.join(Dir.home, 'lib'),
  )
end

desc "Symlink dev"
task :link_dev do
  make_link(
    File.join(ICLOUD_DRIVE, 'dev'),
    File.join(Dir.home, 'dev'),
  )
end

desc "Symlink journals"
task :link_journals do
  make_link(
    File.join(ICLOUD_DRIVE, 'journals'),
    File.join(Dir.home, 'journals'),
  )
end

desc "Symlink iA Writer documents"
task :link_ia_writer do
  make_link(
    File.join(Dir.home, 'Library/Mobile Documents/27N4MQEA55~pro~writer/Documents'),
    File.join(Dir.home, 'writer'),
  )
end

def make_link(source, link)
  unless File.exist?(link)
    File.symlink(source, link)
    puts [
      Pathname.new(source).relative_path_from(Dir.home),
      '->',
      Pathname.new(link).relative_path_from(Dir.home),
    ].join("\s")
  end
end

def linked?(source, link)
  File.symlink?(link) && File.readlink(link) == source
end

def remove_link(source, link)
  if linked?(source, link)
    puts "rm #{link}"
    File.delete(link)
  end
end

def each_linkable(&block)
  LINKABLES.each do |file|
    source = File.join(DOTFILES_DIR, file)
    link = File.join(Dir.home, LINK_VISIBLY.include?(file) ? file : ".#{file}")
    yield(source, link)
  end
end
