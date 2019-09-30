require 'rake'

task default: :install

DOTFILES_DIR = File.dirname(__FILE__)
EXCLUDE = %w[Rakefile README.md .gitmodules ssh Library]
LINK_VISIBLY = %w[bin lib]
LINKABLES = (Dir.glob('*') - EXCLUDE)

desc "Install dotfiles"
task :install do
  each_linkable { |source, target| make_link(source, target) }
end

desc "Remove dotfiles"
task :remove do
  each_link { |source, target| remove_link(source, target) }
end

desc "Keep SSH_AUTH_SOCK for screen / tmux sessions"
task :ssh do
  linkables = Dir.glob('ssh/*').map { |l| File.basename(l) }
  linkables.each do |file|
    source = File.join(DOTFILES_DIR, "ssh", file)
    target = File.join(Dir.home, ".ssh", file)
    make_link(source, target)
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

desc "Italic terminals"
task :italic_terminals do
  Dir.glob('terminals/*').map do |terminfo|
    %x[tic #{File.join(DOTFILES_DIR, terminfo)}]
  end
end

desc "Symlink iCloud Drive"
task :link_icloud_drive do
  make_link(
    File.join(Dir.home, 'Library/Mobile\ Documents/com~apple~CloudDocs'),
    File.join(Dir.home, 'iCloud-Drive'),
  )
end

desc "Symlink dev"
task :link_dev do
  make_link(
    File.join(Dir.home, 'Library/Mobile\ Documents/com~apple~CloudDocs/dev'),
    File.join(Dir.home, 'dev'),
  )
end

desc "Symlink iA Writer documents"
task :link_ia_writer do
  make_link(
    File.join(Dir.home, 'Library/Mobile\ Documents/27N4MQEA55~pro~writer/Documents'),
    File.join(Dir.home, 'writer'),
  )
end

def make_link(source, target)
  unless File.exist?(target)
    system %[ln -vsf #{source} #{target}]
  end
end

def linked?(source, target)
  File.symlink?(target) && File.readlink(target) == source
end

def remove_link(source, target)
  if linked?(source, target)
    puts "rm #{target}"
    File.delete(target)
  end
end

def each_linkable(&block)
  LINKABLES.each do |file|
    source = File.join(DOTFILES_DIR, file)
    target = File.join(Dir.home,
                       LINK_VISIBLY.include?(file) ? file : ".#{file}")
    yield(source, target)
  end
end

def each_link(&block)
  Dir.chdir(Dir.home) do
    Dir.children('.').select { |file|
      File.symlink?(file) && File.dirname(File.readlink(file)) == DOTFILES_DIR
    }.each { |link| yield(File.readlink(link), link) }
  end
end
