require 'rake'

HOME = Dir.home
DOTFILES_DIR = File.dirname(__FILE__)

desc "Install dotfiles"
task :install do

  def make_link(file, dotfile = true)
    if dotfile
      system %[ln -vsf #{File.join(DOTFILES_DIR, file)} #{File.join(HOME, ".#{file}")}]
      # puts "#{File.join(DOTFILES_DIR, file)} -> #{File.join(HOME, ".#{file}")}"
    else
      system %[ln -vsf #{File.join(DOTFILES_DIR, file)} #{File.join(HOME, file)}]
      # puts "#{File.join(DOTFILES_DIR, file)} -> #{File.join(HOME, file)}"
    end
  end

  all_dirs = Dir.glob('**/').map do |d|
    d.sub(/\/$/, '')
  end

  simple_link = Dir.glob('*')
  link_in_place = []

  all_dirs.each do |d|
    if File.exists?("#{HOME}/#{d}")
      files_in_dir = Dir.glob("#{d}/*")
      simple_link -= [d]
      link_in_place << files_in_dir
    end
  end

  simple_link.each do |l|
    make_link(l)
  end

  link_in_place.flatten.each do |l|
    make_link(l, false)
  end
end

