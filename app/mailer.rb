require 'pry'

module JournaldWatcher
  class Mailer
    def initialize(from, to, subject)
      @from     = from
      @to       = to
      @subject  = subject
    end

    def mail_entry(entry)
      subject = entry.message

      if subject.length > 50
        subject = subject[0..50] + '...'
      end

      msg           = Mail.new
      msg.to        = @to
      msg.from      = @from
      msg.subject   = "#{@subject} #{subject}"
      msg.body      = entry.message
      msg.add_file filename: 'data.json', content: entry.to_h.to_json

      binding.pry

      # msg.deliver
    end
  end
end
