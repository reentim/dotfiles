class Vimlog
  class LogFile
    NAME_FORMAT = /vim-startup-(?<hostname>.*)-(?<revision>.*).log$/
    DECORATION = [
      'times in msec',
      ' clock   self+sourced   self:  sourced script',
      ' clock   elapsed:              other lines',
    ]

    def initialize(path, repo)
      matches = path.match(NAME_FORMAT)
      @lines = File.readlines(path)
      @hostname = matches[:hostname]
      @revision = matches[:revision]
      @filename = File.basename(path)
      @repo = repo
    end

    attr_reader :filename

    def entries
      lines
        .reject { |line| DECORATION.include?(line.chomp) }
        .join
        .split("\n\n\n")
        .reject(&:empty?)
        .map { |entry| LogEntry.new(entry, @revision, @hostname, @repo) }
        .compact
    end

    private

    attr_reader :lines
  end

  class LogEntry
    attr_reader :lines, :revision, :hostname

    def initialize(entry, revision, hostname, repo)
      @lines = entry.lines.map { |line| LogLine.for_line(line) }.compact
      @revision = revision
      @hostname = hostname
      @repo = repo
    end

    def commit_date
      @repo.find_date(revision)
    end

    def elapsed
      (@lines.last.clock - @lines.first.clock) / 1000.0
    end
  end

  class LogLine
    MSEC_FORMAT = /\d{3}\.\d{3}/
    FORMAT = /^(?<clock>#{MSEC_FORMAT})\s{2}(#{MSEC_FORMAT}\s{2})*(?<elapsed>#{MSEC_FORMAT}):\s(?<text>.*$)/

    def self.for_line(line)
      match = line.match(FORMAT)
      return unless match

      new(*match.captures)
    end

    def initialize(clock, elapsed, text)
      @clock = clock.delete('.').to_i
      @elapsed = elapsed.delete('.').to_i
      @text = text
    end

    attr_reader :clock, :elapased, :text
  end

  def self.in_dir(path)
    repo = Repo.new
    new(
      Dir.glob(
        File.join(path, "**/vim-startup-*.log"),
      ).map { |path| LogFile.new(path, repo) },
      repo
    )
  end

  def initialize(array, repo)
    @logs = array
  end

  attr_reader :logs

  def report
    logs
      .flat_map { |log| log.entries }
      .sort_by { |entry| entry.elapsed }
      .each do |entry|
        puts "#{entry.commit_date.rjust(25)}\t#{entry.revision}\t#{entry.elapsed}\t#{entry.hostname}"
      end
  end
end

class Repo
  def initialize
    @repo = {}
  end

  def find_date(revision)
    @repo.fetch(revision) do
      @repo[revision] = %x[git --git-dir #{ENV['HOME']}/.dotfiles/.git show -s --format=%ci #{revision} 2>/dev/null].chomp
    end
  end
end

Vimlog.in_dir("/Users/tim/cloud/log").report
