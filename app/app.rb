module JournaldWatcher
  class App
    attr_reader :config

    def run
      load_config
      create_listener
      create_mailer
      listen
    end

    def load_config
      @config = Config.new
    end

    def create_listener
      @listener = Listener.new(
          Systemd::Journal.new(flags: @config.flags),
          @config.filter
      )
    end

    def create_mailer
      @mailer = Mailer.new(@config.mailer_from, @config.mailer_to, @config.mailer_subject)
    end

    def listen
      min_priority = @config.min_priority

      @listener.listen do |entry|
        @mailer.mail_entry(entry) if entry.priority.to_i <= min_priority # lower priorities have higher values
      end
    end
  end
end
