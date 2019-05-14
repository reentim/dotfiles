require 'rake'

task default: :install

DOTFILES_DIR = File.dirname(__FILE__)

def make_link(source, target)
  require 'fileutils'

  if File.exist?(target)
    backup = File.join(Dir.home, '.dotfiles.old')
    FileUtils.mkdir_p(backup)
    FileUtils.mv(target, backup)
  else
    system %[ln -vsf #{source} #{target}]
  end
end

desc "Install dotfiles"
task :install do
  exclude = %w{Rakefile README.md .gitmodules ssh Library}
  linkables = Dir.glob('*') - exclude
  link_as_visible = %w{bin}

  linkables.each do |file|
    source = File.join(DOTFILES_DIR, file)
    target = File.join(Dir.home, "#{'.' unless link_as_visible.include?(file)}#{file}")

    make_link(source, target)
  end
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
task :italic do
  Dir.glob('terminals/*').map do |terminfo|
    %x[tic #{File.join(DOTFILES_DIR, 'terminals', terminfo)}]
  end
end

desc "Symlink iCloud Drive"
task :link_icloud_drive do
  make_link(
    File.join(Dir.home, 'Library/Mobile\ Documents/com~apple~CloudDocs'),
    File.join(Dir.home, 'iCloud-Drive'),
  )
end
