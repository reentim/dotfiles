require 'rake'

task default: :install

HOME = Dir.home
DOTFILES_DIR = File.dirname(__FILE__)

def make_link(source, target)
  if File.exist?(target)
    puts "Skipping exiting file: #{target}"
  else
    system %[ln -vsf #{source} #{target}]
  end
end

desc "Install dotfiles."
task :install do
  exclude = %w{Rakefile README.md .gitmodules ssh Library}
  linkables = Dir.glob('*') - exclude
  link_as_visible = %w{bin}

  linkables.each do |file|
    source = File.join(DOTFILES_DIR, file)
    target = File.join(HOME, "#{'.' unless link_as_visible.include?(file)}#{file}")

    make_link(source, target)
  end
end

desc "Keep SSH_AUTH_SOCK for screen / tmux sessions."
task :ssh do
  linkables = Dir.glob('ssh/*').map { |l| File.basename(l) }

  linkables.each do |file|
    source = File.join(DOTFILES_DIR, "ssh", file)
    target = File.join(HOME, ".ssh", file)

    make_link(source, target)
  end
end

desc "Install macOS custom keybindings"
task :keybindings do
  file = "Library/KeyBindings/DefaultKeyBinding.dict"
  system "mkdir -p #{File.join(HOME, 'Library/KeyBindings')}"
  make_link(
    File.join(DOTFILES_DIR, file),
    File.join(HOME, file)
  )
end

desc "Italic terminal"
task :italic do
  %x[tic ./terminals/xterm-256color-italic.terminfo]
  %x[tic ./terminals/screen-256color-italic.terminfo]
  %x[tic ./terminals/tmux-256color.terminfo]
end
