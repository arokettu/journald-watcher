module JournaldWatcher
  class Listener
    def initialize(journal, filter)
      @journal = journal
      @filter  = filter
    end

    def listen(&block)
      @journal.filter @filter
      @journal.seek :tail
      watch { |entry| block.call(entry) }
    end

    private

      # like Systemd::Journal.watch but don't wait forever
      def watch
        loop { (yield @journal.current_entry while @journal.move_next) if @journal.wait(100_000) }
      end
  end
end
