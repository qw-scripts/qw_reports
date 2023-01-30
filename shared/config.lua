Config = {}

-- Permissions

Config.AcePermName = 'command'

-- Commands

Config.CreateReportCommand = 'report'
Config.ViewReportsMenu = 'view-reports'

-- Report Types

Config.ReportTypes = { -- Fill out your own custom report types
    "Player Report",
    "Bug Report",
    "Staff Report",
    "Other"
}

-- Webhook Stuff

Config.Webhook = {
    enabled = false,
    webhookUrl = '', -- PUT YOUR WEBHOOK URL HERE
    webnhookImage = '' -- PUT YOUR WEBHOOK IMAGE HERE
}
