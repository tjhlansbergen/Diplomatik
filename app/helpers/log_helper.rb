# Helper voor het schrijven van logregels naar de database
module LogHelper

    # schrijft 1 logentry, met de opgegeven severity en message
    def log(severity, message)

        # maak en schrijf nieuwe log entry (datum wordt automatisch ingevoegd door overerven van ActiveRecord door LogEntry)
        entry = LogEntry.new(severity: severity, message: message)
        entry.save

        # om de database niet te overspoelen maken we 'rolling-log', verwijder de oudste entries als er meer zijn dan x
        if LogEntry.count > Rails.configuration.max_log_entries
            LogEntry.order(created_at: :asc).limit(LogEntry.count - Rails.configuration.max_log_entries).destroy_all
        end
    end
end
