module JournaldWatcher
  class Config
    def initialize
      @data = YAML.load_file(File.dirname(__FILE__) + '/../config/config.yml')
    end

    def flags
      return nil unless @data['flags']

      @data['flags'] = [@data['flags']] unless @data['flags'].is_a? Array

      flags_arr = @data['flags']

      flags  = 0
      flags |= Systemd::Journal::Flags::LOCAL_ONLY    if flags_arr.include? 'local'
      flags |= Systemd::Journal::Flags::RUNTIME_ONLY  if flags_arr.include? 'runtime'
      flags |= Systemd::Journal::Flags::SYSTEM_ONLY   if flags_arr.include? 'system'

      flags
    end

    def filter
      @data['filter'] or raise 'No filter given'
    end

    def mailer_from
      @data['mail'] && @data['mail']['from'] or raise 'No from address given'
    end

    def mailer_to
      @data['mail'] && @data['mail']['to'] or raise 'No to address(es) given'
    end

    def mailer_subject
      @data['mail'] && @data['mail']['subject'] || ''
    end

    def min_priority
      priority_str = @data['min_priority']

      case priority_str
        when 'emerg'
          Systemd::Journal::LOG_EMERG
        when 'alert'
          Systemd::Journal::LOG_ALERT
        when 'crit'
          Systemd::Journal::LOG_CRIT
        when 'err'
          Systemd::Journal::LOG_ERR
        when 'warning'
          Systemd::Journal::LOG_WARNING
        when 'notice'
          Systemd::Journal::LOG_NOTICE
        when 'info'
          Systemd::Journal::LOG_INFO
        when 'debug'
          Systemd::Journal::LOG_DEBUG
        else
          Systemd::Journal::LOG_DEBUG
      end
    end
  end
end
